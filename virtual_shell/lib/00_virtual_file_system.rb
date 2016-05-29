class VirtualFileSystem
  attr_reader :root, :current
  def initialize(hash)
    @root = Folder.new('~')
    @current = @root
    process_hash(hash)
  end

  def process_hash(hash, parent = @current)
    hash.each do |k,v|
      if v.is_a?(Hash)
        folder = Folder.new(k, parent)
        parent.add_child(folder)
        process_hash(v, folder)
      else
        file = File.new(k, v, parent)
        parent.add_child(file)
      end
    end
  end

  def current_path
    @current.path
  end

  def ls(path = @current.path)
    @current.children.map(&:name)
  end

  def up!
    @current = @current.parent if @current.parent
  end

  def find(target)
    @current.children.find{|c| c.name == target}
  end

  def cd(target = '~')
    return @current = @root if target == '~'
    # return @current = @current.parent if target == '..'
    folders = target.split('/')

    until folders.empty?
      current_target = folders.shift
      found = find(current_target)

      if current_target == '..'
        up!
      elsif found && found.is_a?(Folder)
        @current = found
      else
        raise 'invalid path'
      end
    end
  end

  def less(file)
    found = find(file)
    if found
      return found.content
    else
      raise 'no such file'
    end
  end


  def pwd
    @current.path
  end
end

class Folder
  attr_reader :name, :children
  attr_accessor :parent

  def initialize(name, parent = nil)
    @name = name
    @parent = parent
    @children = []
  end

  def path
    path = self.name
    curr = self.parent

    until curr.nil?
      path = curr.name + "/" + path
      curr = curr.parent
    end
    path
  end

  def add_child(child)
    @children.push(child)
  end
end

class File
  attr_reader :name, :content
  attr_accessor :parent

  def initialize(name, content, parent = nil)
    @name = name
    @parent = parent
    @content = content
  end

  def path
    path = self.name
    curr = self.parent

    until curr.nil?
      path = curr.name + "/" + path
      curr = curr.parent
    end
    path
  end
end
