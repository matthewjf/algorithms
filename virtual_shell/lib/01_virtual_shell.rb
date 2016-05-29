require_relative "00_virtual_file_system"
require 'byebug'
class VirtualShell
  def initialize(file_system)
    @fs = file_system
  end

  def run
    puts "Welcome to Virtual Shell (population 1)."

    loop do
      print "#{@fs.current_path}$ "
      input = gets.chomp
      parse_input(input)
    end
  end

  def start_with?(cmd)
    ->(input) {input.start_with?(cmd)}
  end

  def parse_input(input)
    args = input.split(' ').drop(1)
    begin
      case input
      when start_with?('pwd') then puts @fs.current_path
      when start_with?('ls') then puts @fs.ls
      when start_with?('cd') then @fs.cd(args.first)
      when start_with?('less') then puts @fs.less(args.first)
      else 'unknown'
      end
    rescue Exception => e
      puts 'error'
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  # some code to get you started

  root = {
    "folder0" => {
      "file0" => "contents of file0",
      "folder0.1" => {
        "file1" => "contents of file1"
      }
    },

    "folder1" => {
      "file2" => "contents of file2"
    },

    "file3" => "contents of file3"
  }

  vfs = VirtualFileSystem.new(root)
  shell = VirtualShell.new(vfs)
  shell.run
end
