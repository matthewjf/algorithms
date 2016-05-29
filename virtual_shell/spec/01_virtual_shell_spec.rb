require "rspec"
require_relative "spec_helper"

describe "VirtualShell" do
  # ~$
  it "starts in the root directory" do
    commands = []
    console_output = record_shell_interaction(commands)
    expect(last_dir(console_output)).to eq("~")
  end

  describe "basic commands" do
    # ~$ ls
    # file3 folder0 folder1
    # ~$
    it "lists the contents of the current directory" do
      commands = ["ls"]
      console_output = record_shell_interaction(commands)
      expect(words_of(last_output(console_output)))
        .to match_array(["folder0", "folder1", "file3"])
    end

    # ~$ cd folder0
    # ~/folder0$
    it "navigates to another directory" do
      commands = ["cd folder0"]
      console_output = record_shell_interaction(commands)
      expect(last_dir(console_output)).to eq("~/folder0")
    end

    # ~$ less file3
    # contents of file3
    # ~$
    it "prints the contents of a file" do
      commands = ["less file3"]
      console_output = record_shell_interaction(commands)
      expect(last_output(console_output)).to eq("contents of file3")
    end
  end

  # ~$ less folder0
  # error
  # ~$
  describe "error handling" do
    it "prints an error when `less`ing a directory" do
      commands = ["less folder0"]
      console_output = record_shell_interaction(commands)
      expect(last_output(console_output)).to match("error")
    end

    # ~$ cd file3
    # error
    # ~$
    it "prints an error when `cd`ing a file" do
      commands = ["cd file3"]
      console_output = record_shell_interaction(commands)
      expect(last_output(console_output)).to match("error")
    end

    # ~$ cd folder0/folder0.1/folder0
    # error
    # ~$
    it "prints an error when `cd`ing an invalid relative path" do
      commands = ["cd folder0/folder0.1/folder0"]
      console_output = record_shell_interaction(commands)
      expect(last_output(console_output)).to match("error")
    end
  end

  context "after `cd`ing" do
    # ~$ cd folder0
    # ~/folder0$ ls
    # file0 folder0.1
    # ~/folder0$
    it "can still `ls`" do
      commands = ["cd folder0", "ls"]
      console_output = record_shell_interaction(commands)
      expect(words_of(last_output(console_output)))
        .to match_array(["file0", "folder0.1"])
    end

    # ~$ cd folder0
    # ~/folder0$ less file0
    # contents of file0
    # ~/folder0$
    it "can still `less`" do
      commands = ["cd folder0", "less file0"]
      console_output = record_shell_interaction(commands)
      expect(last_output(console_output)).to eq("contents of file0")
    end

    # ~$ cd folder0
    # ~/folder0$ cd folder0.1
    # ~/folder0/folder0.1$
    it "can still `cd` down" do
      commands = ["cd folder0", "cd folder0.1"]
      console_output = record_shell_interaction(commands)
      expect(last_dir(console_output)).to eq("~/folder0/folder0.1")
    end

    # ~$ cd folder0
    # ~/folder0$ cd ..
    # ~$
    it "can `cd` back up" do
      commands = ["cd folder0", "cd .."]
      console_output = record_shell_interaction(commands)
      expect(last_dir(console_output)).to eq("~")
    end
  end

  context "after `cd`ing multiple levels at once" do
    # ~$ cd folder0/folder0.1
    # ~/folder0/folder0.1$
    it "is in the correct place" do
      commands = ["cd folder0/folder0.1"]
      console_output = record_shell_interaction(commands)
      expect(last_dir(console_output)).to eq("~/folder0/folder0.1")
    end

    # ~$ cd folder0/folder0.1
    # ~/folder0/folder0.1$ ls
    # file1
    # ~/folder0/folder0.1$
    it "can `ls`" do
      commands = ["cd folder0/folder0.1", "ls"]
      console_output = record_shell_interaction(commands)
      expect(last_output(console_output)).to eq("file1")
    end

    # ~$ cd folder0/folder0.1
    # ~/folder0/folder0.1$ less file1
    # contents of file1
    # ~/folder0/folder0.1$ cd ../..
    # ~$
    it "can `less` then `cd` up multiple levels" do
      commands = ["cd folder0/folder0.1", "less file1", "cd ../.."]
      console_output = record_shell_interaction(commands)
      expect(last_dir(console_output)).to eq("~")
    end

    # ~$ cd folder0/folder0.1
    # ~/folder0/folder0.1$ cd ../folder0.1/../../folder1
    # ~/folder1$ ls
    # file2
    # ~/folder1$
    it "can handle arbitrary complexity" do
      commands = ["cd folder0/folder0.1", "cd ../folder0.1/../../folder1", "ls"]
      console_output = record_shell_interaction(commands)
      expect(last_output(console_output)).to eq("file2")
    end
  end
end
