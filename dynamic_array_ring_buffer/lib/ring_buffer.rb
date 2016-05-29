require_relative "static_array"
require 'byebug'

class RingBuffer
  attr_reader :length

  def initialize
    self.start_idx = 0
    self.length = 0
    self.capacity = 8
    self.store = StaticArray.new(self.capacity)
  end

  # O(1)
  def [](index)
    check_index(index)
    self.store[(start_idx + index) % capacity]
  end

  # O(1)
  def []=(index, val)
    check_index(index)
    self.store[(start_idx + index) % capacity] = val
  end

  # O(1)
  def pop
    raise "index out of bounds" if length == 0
    val = self[length - 1]
    self.length -= 1
    val
  end

  # O(1) ammortized
  def push(val)
    resize! if length == capacity
    self.length += 1
    self[self.length - 1] = val
    nil
  end

  # O(1)
  def shift
    val = self[0]
    self.start_idx = (self.start_idx + 1) % capacity
    self.length -= 1

    val
  end

  # O(1) ammortized
  def unshift(val)
    resize! if length == capacity

    self.start_idx = (self.start_idx - 1) % capacity
    self.length += 1

    self[0] = val
  end

  protected
  attr_accessor :capacity, :start_idx, :store
  attr_writer :length

  def check_index(index)
    raise "index out of bounds" unless (index >= 0) && (index < length)
  end

  def resize!
    new_capacity = capacity * 2
    new_store = StaticArray.new(new_capacity)
    length.times { |i| new_store[i] = self[i] }

    self.capacity = new_capacity
    self.store = new_store
    self.start_idx = 0
  end
end
