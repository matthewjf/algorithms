require_relative 'heap2'
require 'byebug'

class PriorityMap
  def initialize(&prc)
    @map = {}
    @queue = BinaryMinHeap.new do |key1, key2|
      prc.call(map[key1], map[key2])
    end
  end

  def [](key)
    @map[key]
  end

  def []=(key, value)
    has_key?(key) ? update(key, value) : insert(key, value)
  end

  def count
    @map.count
  end

  def empty?
    count <= 0
  end

  def extract
    key = @queue.extract
    result = [key, @map[key]]
    @map.delete(key)
    result
  end

  def has_key?(key)
    @map.has_key?(key)
  end

  protected
  attr_accessor :map, :queue

  def insert(key, value)
    @map[key] = value
    @queue.push(key)
  end

  def update(key, value)
    @map[key] = value
    @queue.reduce!(key)
  end
end
