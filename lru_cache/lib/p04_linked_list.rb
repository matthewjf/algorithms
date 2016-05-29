class Link
  attr_accessor :key, :val, :next, :prev

  def initialize(key = nil, val = nil)
    @key = key
    @val = val
    @next = nil
    @prev = nil
  end

  def to_s
    "#{@key}: #{@val}"
  end
end
require 'byebug'
class LinkedList
  include Enumerable

  def initialize
    @head = nil
    @tail = nil
  end

  def [](i)
    each_with_index { |link, j| return link if i == j }
    nil
  end

  def first
    @head
  end

  def last
    @tail
  end

  def empty?
    @head == nil
  end

  def get(key)
    return nil if empty?

    each do |link|
      if link.key == key
        return link.val
      end
    end
  end

  def include?(key)
    each do |link|
      return true if link.key == key
    end
    false
  end

  def insert(key, val)
    new_link = Link.new(key, val)
    if empty?
      @head = new_link
    else
      new_link.prev = last
      last.next = new_link
    end
    @tail = new_link
    new_link
  end

  def remove(key)
    each do |link|
      if link.key == key
        link.next.prev = link.prev unless link == last
        link.prev.next = link.next unless link == @head
        @head = link.next if link == @head
        @tail = link.prev if link == @tail
        link = nil
      end
    end
  end

  def each
    if block_given?
      return nil if empty?
      current = @head

      until current == nil
        yield current
        current = current.next
      end
    end
  end

  # uncomment when you have `each` working and `Enumerable` included
  def to_s
    inject([]) { |acc, link| acc << "[#{link.key}, #{link.val}]" }.join(", ")
  end
end
