class QuickSort
  # Quick sort has average case time complexity O(nlogn), but worst
  # case O(n**2).

  # Not in-place. Uses O(n) memory.
  def self.sort1(array)
    pivot = array[0]
    left = []
    right = []
    array.drop(1).each do |el|
      el < pivot ? left.push(el) : right.push(el)
    end

    return sort1(left) + [pivot] + sort1(right)
  end

  # In-place.
  def self.sort2!(array, start = 0, length = array.length, &prc)
    return array if length <= 1

    pivot_idx = partition(array, start, length, &prc)

    left = sort2!(array, start, pivot_idx - start, &prc)
    right = sort2!(array, pivot_idx, length - pivot_idx - 1, &prc)

    return array
  end

  def self.partition(array, start, length, &prc)
    prc ||= Proc.new {|el1, el2| el1 <=> el2 }

    pivot_idx = start 

    start.upto(start + length - 1) do |i|
      if pivot_idx != i && prc.call(array[pivot_idx], array[i]) > 0
        tmp = array[i]
        (i - 1).downto(pivot_idx) { |j| array[j + 1] = array[j] }
        array[pivot_idx] = tmp
        pivot_idx += 1
      end
    end

    pivot_idx
  end
end
