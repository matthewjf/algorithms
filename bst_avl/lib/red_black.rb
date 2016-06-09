require 'byebug'
# color 0 => black
# color 1 => red
class BSTNode
  attr_accessor :left, :right, :color
  attr_reader :value

  def initialize(value)
    @value = value
    @color = 0
  end
end

# Left leaning
class RedBlackTree
  # Left rotation
  # Right rotation
  # Color flip: 2 red links
end
