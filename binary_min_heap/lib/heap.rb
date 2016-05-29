require 'byebug'

class BinaryMinHeap
  def initialize(&prc)
    @store = []
    @prc = prc
  end

  def count
    @store.length
  end

  def extract
    @store[0], @store[-1] = @store[-1], @store[0]
    result = @store.pop
    BinaryMinHeap.heapify_down(@store, 0, count, &@prc)
    return result
  end

  def peek
    @store.first
  end

  def push(val)
    @store.push(val)
    BinaryMinHeap.heapify_up(@store, count - 1, count, &@prc)
  end

  # protected
  attr_accessor :prc, :store

  public
  def self.child_indices(len, parent_index)
    indices = []

    first = 2 * parent_index + 1
    second = 2 * parent_index + 2

    indices.push(first) if first > 0 && first < len
    indices.push(second) if second > 0 && second < len

    indices
  end

  def self.parent_index(child_index)
    raise "root has no parent" if child_index == 0
    (child_index - 1) / 2
  end

  def self.heapify_down(array, parent_idx, len = array.length, &prc)
    childs = child_indices(len, parent_idx)
    return array if childs.empty?

    prc ||= Proc.new { |el1, el2| el1 <=> el2 }
    if childs.length == 1
      child_idx = childs[0]
    else
      child_idx = prc.call(array[childs[0]], array[childs[1]]) <= 0 ? childs[0] : childs[1]
    end

    if prc.call(array[child_idx], array[parent_idx]) <= 0
      array[parent_idx], array[child_idx] = array[child_idx], array[parent_idx]
      heapify_down(array, child_idx, len, &prc)
    else
      return array
    end
  end

  def self.heapify_up(array, child_idx, len = array.length, &prc)
    return array if child_idx == 0

    prc ||= Proc.new { |par, chd| par <=> chd }

    parent_idx = parent_index(child_idx)
    return array if prc.call(array[parent_idx], array[child_idx]) <= 0

    array[parent_idx], array[child_idx] = array[child_idx], array[parent_idx]
    heapify_up(array, parent_index(child_idx),len, &prc)
  end
end

=begin
[0, 1, 2, 3, 4, 5, 6, 7, 8]
=end
