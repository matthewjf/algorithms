=begin

This problem was asked by Google.

A unival tree (which stands for "universal value") is a tree where all
nodes under it have the same value. Given the root to a binary tree, count
the number of unival subtrees.

For example, the following tree has 5 unival subtrees:

   0
  / \
 1   0
    / \
   1   0
  / \
 1   1
=end

class Node
  attr_accessor :left, :right, :value

  def initialize(value, left: nil, right: nil)
    @left = left
    @right = right
    @value = value
  end

  def is_unival?
    return true if left.nil? && right.nil?
    return false if left.nil? || right.nil?

    left.value == right.value && left.is_unival? && right.is_unival?
  end
end

def count_unival(root)
  return 0 if root.nil?
  return 1 if root.left.nil? && root.right.nil?

  res = count_unival(root.left) + count_unival(root.right)
  res += 1 if root.value == root.left.value && root.value == root.right.value
  res
end

require 'rspec'

RSpec.describe '#non_adjacent_sum' do
  it 'returns 1 for nodes without children' do
    expect(count_unival(Node.new(10))).to eq(1)
  end

  it 'works in simple case' do
    root = Node.new(0)
    root.left = Node.new(1)
    root.right = Node.new(0, left: Node.new(1, left: Node.new(1), right: Node.new(1)), right: Node.new(0))

    expect(count_unival(root)).to eq(5)
  end
end
