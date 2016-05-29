require "rspec"
require "00_virtual_file_system"

describe VirtualFileSystem do
  let(:root) do
    {
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
  end

  subject(:shell) { VirtualFileSystem.new(root) }

  describe "#initialize" do
    it "accepts a hash representing a file structure" do
      expect { shell }.not_to raise_error
    end
  end

  describe "#pwd" do
    context "when in the home directory" do
      it "returns '~'" do
        expect(shell.pwd).to eq("~")
      end
    end
  end

  describe "#cd" do
    context "when passed '~' or nothing" do
      it "navigates to the home directory" do
        shell.cd("folder0")

        shell.cd
        expect(shell.pwd).to eq("~")

        shell.cd("folder0")

        shell.cd("~")
        expect(shell.pwd).to eq("~")
      end
    end

    context "when passed the name of a folder in the current directory" do
      it "navigates to the folder" do
        shell.cd("folder0")

        expect(shell.pwd).to eq("~/folder0")
      end
    end

    context "when passed a path to a folder in working_dir" do
      it "navigates to the folder" do
        shell.cd("folder0/folder0.1")

        expect(shell.pwd).to eq("~/folder0/folder0.1")
      end
    end

    context "when passed '..'" do
      it "navigates to the parent directory" do
        shell.cd("folder0")

        expect(shell.pwd).to eq("~/folder0")

        shell.cd("..")

        expect(shell.pwd).to eq("~")
      end
    end

    context "when passed an invalid path" do
      it "raises an error" do
        expect { shell.cd("asdf") }.to raise_error
      end
    end
  end

  describe "#ls" do
    it "returns the names of files and folders in the current directory" do
      expect(shell.ls).to eq(["folder0", "folder1", "file3"])

      shell.cd("folder0")

      expect(shell.ls).to eq(["file0", "folder0.1"])
    end
  end

  describe "#less" do
    context "when passed a valid filename" do
      it "returns the contents of the file" do
        expect(shell.less("file3")).to eq("contents of file3")

        shell.cd("folder1")

        expect(shell.less("file2")).to eq("contents of file2")
      end
    end

    context "when passed an invalid filename" do
      it "raises an error" do
        expect { shell.less("file5") }.to raise_error
      end
    end
  end
end
