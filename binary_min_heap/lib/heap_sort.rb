require_relative "heap"

class Array
  def heap_sort!
    heap = BinaryMinHeap.new
    self.length.times { heap.push(self.pop) }

    until heap.count <= 0
      self.push(heap.extract)
    end

    self
  end
end
