require 'byebug'
class BSTNode
  attr_accessor :left, :right
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def children
    if left && right
      return [left, right]
    elsif left
      return [left]
    elsif right
      return [right]
    else
      return nil
    end
  end
end

class BinarySearchTree
  attr_reader :root
  def initialize
    @root = nil
  end

  def insert(value)
    @root = self.class.insert!(@root, value)
  end

  def find(value)
    self.class.find!(@root, value)
  end

  def inorder
    self.class.inorder!(@root)
  end

  def postorder
    self.class.postorder!(@root)
  end

  def preorder
    self.class.preorder!(@root)
  end

  def height
    self.class.height!(@root)
  end

  def min
    self.class.min(@root)
  end

  def max
    self.class.max(@root)
  end

  def delete(value)
    self.class.delete!(@root, value)
  end

  def display
    self.class.display(@root)
  end

  def self.insert!(node, value)
    return BSTNode.new(value) if node.nil?

    if value <= node.value
      node.left = self.insert!(node.left, value)
    else
      node.right = self.insert!(node.right, value)
    end

    node
  end

  def self.find!(node, value)
    return nil if node.nil?
    return node if node.value == value

    if value < node.value
      self.find!(node.left, value)
    else
      self.find!(node.right, value)
    end
  end

  def self.preorder!(node)
    return [] if node.nil?
    return [node.value] + self.preorder!(node.left) + self.preorder!(node.right)
  end

  def self.inorder!(node)
    return [] if node.nil?
    return self.inorder!(node.left) + [node.value] + self.inorder!(node.right)
  end

  def self.postorder!(node)
    return [] if node.nil?
    return self.postorder!(node.left) + self.postorder!(node.right) + [node.value]
  end

  def self.height!(node)
    return -1 if node.nil?
    1 + [self.height!(node.left), self.height!(node.right)].max
  end

  def self.max(node)
    curr = node
    until curr.right == nil
      curr = curr.right
    end
    curr
  end

  def self.min(node)
    curr = node
    until curr.left == nil
      curr = curr.left
    end
    curr
  end

  def self.delete_min!(node)
    if node.nil?
      return nil
    elsif node.left
      node.left = self.delete_min!(node.left) if node.left
    elsif node.right
      node = node.right
    else
      node = nil
    end

    return node
  end

  def self.delete!(node, value)
    return nil if node.nil?
    if value < node.value
      node.left = self.delete!(node.left, value)
    elsif value > node.value
      node.right = self.delete!(node.right, value)
    else
      return nil if node.children.nil?
      return node.children.first if node.children.length == 1
      
      # hibbard deletion: replace with successor and delete that node
      t = node
      node = self.min(t.right)
      node.right = self.delete_min!(t.right)
      node.left = t.left
    end

    node
  end

  def self.display(node)
    h = self.height!(node)
    char_count = (2 ** (h + 1) - 1)

    # display first level
    s = " " * char_count
    s[s.length / 2] = node.value.to_s
    puts s

    # display following levels
    depth = 1
    parents = [node]

    until depth > h
      level = []
      spaces = " " * (char_count / (2 ** (depth + 1)))
      parents.each do |node|
        if node
          left = display_node(node.left)
          right = display_node(node.right)
        else
          left = " "
          right = " "
        end

        level.push(spaces + left + spaces)
        level.push(spaces + right + spaces)
      end

      puts level.join(" ")

      parents = parents.map do |node|
        if node
          [node.left, node.right]
        else
          [nil, nil]
        end
      end.flatten

      depth += 1
    end
  end

  def self.display_node(node)
    return " " unless node
    node.value.to_s
  end
end
