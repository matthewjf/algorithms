**Do not share this repo or post it publicly. We will take violations
very seriously.**

# Virtual Shell

Given a hierarchical data set with arbitrary nesting, write a file
explorer that lets the user navigate the structure.

## Example file structure

```
root = {
  'folder0' => {
    'file0' => 'contents of file0',
    'folder0.1' => {
      'file1' => 'contents of file1'
    }
  },

  'folder1' => {
    'file2' => 'contents of file2'
  },

  'file3' => 'contents of file3'
}
```

You'll implement two classes for your solution: a VirtualFileSystem to
navigate the file structure and read files, and a VirtualShell to
provide the actual command prompt and user interaction. When your
virtual shell file is run, it should:

* Print the current path at every prompt (using ~ to represent the home,
  or root, directory).
* Expose commands for cd, ls, and less (which prints a file's contents)
* Show a command prompt with the string "#{current_path}$ "

## Example interaction

```
Welcome to Virtual Shell (population 1).
~$ ls
file3 folder0 folder1
~$ cd folder0
~/folder0$ ls
file0 folder0.1
~/folder0$ cd file0
error: cd: not a directory: file0
~/folder0$ less file0
contents of file0
~/folder0$ less folder0.1
error: folder0.1 is a directory
~/folder0$ cd folder0.1
~/folder0/folder0.1$ cd ../../folder1
~/folder1$ quit
Now leaving Virtual Shell (population 0).
```

## Tips

* The helper methods in `spec_helper.rb` are fairly complex. I don't
  recommend spending time trying to understand them. Focus on the specs
  and example interactions in `01_virutal_shell.rb`. If you can make
  your program match the example interactions character-for-character,
  then the specs should pass. :)
* The specs rely on a class that simulates shell input/output. While
  this simulator is running, any output generated with simple `puts`
  statements will be recorded for testing purposes, but not printed to
  the screen. If you need to print something to the screen for debugging
  purposes, you can do so by explicitly using the `STDOUT.puts` method,
  which *will* print to the screen and *will not* be captured for
  testing purposes.

## Polishing Up

You're not done yet! This is a coding challenge; Your code should be
neat and succinct. Use the full time available to you!

Here's some additional ideas for features:
* Add options and arguments to all of your commands
* Implement additional commands (pwd, mv, rm, grep, etc)
* Store your virtual file system in a separate file. This will allow you
  to persist changes to the file system between sessions!
* Implement the pipe (|) operator
* Add support for scripts/extensions, (possibly in a .virtualshellrc
  file)

**Copyright App Academy, please do not post online**
