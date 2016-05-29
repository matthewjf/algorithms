require_relative "static_array"

class DynamicArray
  attr_reader :length

  def initialize
    self.length = 0
    self.capacity = 8
    self.store = StaticArray.new(self.capacity)
  end

  # O(1)
  def [](index)
    check_index(index)
    self.store[index]
  end

  # O(1)
  def []=(index, value)
    self.store[index] = value
  end

  # O(1)
  def pop
    check_index(0)
    self.store[self.length] = nil
    self.length -= 1
  end

  # O(1) ammortized; O(n) worst case. Variable because of the possible
  # resize.
  def push(val)
    resize!
    self.store[self.length] = val
    self.length += 1
  end

  # O(n): has to shift over all the elements.
  def shift
    check_index(0)
    index = 0

    until index == (self.length - 1)
      self[index] = self[index + 1]
      index += 1
    end

    self[index] = 0
    self.length -= 1
  end

  # O(n): has to shift over all the elements.
  def unshift(val)
    resize!
    index = self.length

    until index == 0
      self[index] = self[index - 1]
      index -= 1
    end

    self.store[index] = val
    self.length += 1
  end

  protected
  attr_accessor :capacity, :store
  attr_writer :length

  def check_index(index)
    raise "index out of bounds" if length == 0 || index >= length
  end

  # O(n): has to copy over all the elements to the new store.
  def resize!
    if self.length >= capacity
      tmp = self.store.dup
      self.store = StaticArray.new(self.capacity * 2)
      idx = 0
      until idx >= self.length
        self.store[idx] = tmp[idx]
        idx += 1
      end

      self.capacity *= 2
    end
  end
end
