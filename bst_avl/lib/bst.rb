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

    if value == node.value
      return nil if node.children.nil?
      return node.children.first if node.children.length == 1
    end

    if value < node.value
      node.left = self.delete!(node.left, value)
    else
      node.right = self.delete!(node.right, value)
    end

    return node
  end
end
