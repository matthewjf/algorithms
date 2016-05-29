VIRTUAL_SHELL_PROGRAM = File.expand_path('../../lib/01_virtual_shell.rb', __FILE__)

# loads 01_virtual_shell.rb, simulates entering commands, and returns a string
# of everything that the program prints to the console
def record_shell_interaction(commands)
 ShellSimulator.new(commands).capture_output do
    load VIRTUAL_SHELL_PROGRAM
  end
end

class ShellSimulator
  # We will reset global variables that the student created.
  # This is a list of system-generated variables that we *don't* want to reset.
  IGNORED_GLOBAL_VARS = [
    :$ERROR_INFO, :$ERROR_POSITION, :$FS, :$FIELD_SEPARATOR, :$OFS,
    :$OUTPUT_FIELD_SEPARATOR, :$RS, :$INPUT_RECORD_SEPARATOR, :$ORS,
    :$OUTPUT_RECORD_SEPARATOR, :$INPUT_LINE_NUMBER, :$NR, :$LAST_READ_LINE,
    :$DEFAULT_OUTPUT, :$DEFAULT_INPUT, :$PID, :$PROCESS_ID, :$CHILD_STATUS,
    :$LAST_MATCH_INFO, :$IGNORECASE, :$ARGV, :$MATCH, :$PREMATCH,
    :$POSTMATCH, :$LAST_PAREN_MATCH, :$binding
  ]

  module ::Kernel
    # See ShellSimulator#done? for context.
    # Thread status is 'sleep' while 'require'd libraries are being loaded.
    # But, we don't want to kill a thread until it has loaded its required
    # libraries and had a chance to run to completion.
    # Therefore, we'll keep track of the number of pending_requires, so that we
    # can check that we don't kill the thread while it's requiring files.
    alias_method :original_require, :require

    def require(file)
      @@pending_requires ||= 0
      @@pending_requires += 1

      original_require(file)

      @@pending_requires -= 1
    end
  end

  class InputSimulator < StringIO
    def gets
      # sleep indefinitely after we run out specified simulated inputs
      eof? ? sleep : super
    end
  end

  def initialize(commands)
    @commands = commands
  end

  def capture_output(&prc)
    prepare_simulation
    run_in_thread(prc)

    output_capturer.string[0..10_000] # truncate very long outputs
  ensure
    restore_original_state
  end

  def done?(thread)
    pending_requires = Kernel.class_variable_get :@@pending_requires
    thread.status != 'run' && pending_requires == 0
  end

  def input_simulator(commands)
    commands_string = commands.map { |command| "#{command}\n" }.join
    InputSimulator.new(commands_string)
  end

  def nillify_new_global_vars
    new_global_variables = global_variables - @@original_global_variables
    new_global_variables.each do |var|
      # is there a way to do this without `eval`?
      eval "#{var} = nil" unless IGNORED_GLOBAL_VARS.include?(var)
    end
  end

  def output_capturer
    @output ||= StringIO.new
  end

  def prepare_simulation
    save_original_state

    ARGV.clear # otherwise `gets` tries to read from command line arguments
    $stdin = input_simulator(@commands)
    $stdout = output_capturer
    $stderr = output_capturer

    $PROGRAM_NAME = VIRTUAL_SHELL_PROGRAM
  end

  def restore_original_state
    $stdin = @original_stdin
    $stdout = @original_stdout
    $stderr = @original_stderr

    $PROGRAM_NAME = @original_program_name

    undefine_new_constants
    nillify_new_global_vars
  end

  def run_in_thread(prc)
    start = Time.now
    thread = Thread.new { prc.call }

    loop do
      sleep 0.05
      if done?(thread) || (Time.now - start) > 1
        thread.kill
        break
      end
    end
  end

  def save_original_state
    @original_stdin = $stdin
    @original_stdout = $stdout
    @original_stderr = $stderr

    @original_program_name = $PROGRAM_NAME

    # Class variable will be defined when the first ShellSimulator is created.
    # When other shell simulators are created, any student-created global vars
    # would already be defined and considered 'original', which we don't want.
    @@original_global_variables ||= global_variables
    @original_constants = Object.constants
  end

  def undefine_new_constants
    new_constants = Object.constants - @original_constants
    new_constants.each do |constant|
      Object.send(:remove_const, constant) unless constant == :Byebug
    end
  end
end

def words_of(line)
  line.split(/\s+/)
end

# The previous command's output/response (this does not refer to the
# directory and  command prompt) ends with a newline, so start the regex
# there (or the beginning of the string, corresponding to program
# startup). Keep matching all characters, except for newlines (which
# aren't matched by the . matcher), stopping at either the last command
# prompt in the program, or the last command promp before a command
# response is printed (which contains a newline, and therefore cannot be
# matched by the regex). Split on these matches. This leaves the outputs.
def last_output(lines)
  lines.split(/(?:^|\n).*\$/).map(&:strip).reject(&:empty?).last
end

# This regex has 3 parts (in parentheses)
# 1. positive look-behind:
#    beginning of string (program just started)
#    OR $: (end of last command prompt)
#    OR newline (end of last command's output)
# 2. any characters not matching '$:' or a newline -- the matched group
# 3. positive lookahead to the command prompt, '$:'
def last_dir(lines)
  temp = lines.scan(/(?<=^|\$|\n[^\$])([^(\$|\n)]+)(?=\$)/)
  temp.last.last.strip
end
