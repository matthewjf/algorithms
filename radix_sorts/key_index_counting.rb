# non-comparative sort
# keys are small integers from 0 to max - 1

# linear time sort for array of small integers
# useful when there is associative data with each integer

def key_indexed_counting(arr, max)
  count = Array.new(max + 1, 0)

  arr.each { |num| count[num + 1] += 1 }
  idx = 0
  while idx < max
    count[idx + 1] += count[idx]
    idx += 1
  end

  aux = []
  arr.each do |num|
    aux[count[num]] = num
    count[num] += 1
  end

  arr.each_index do |idx|
    arr[idx] = aux[idx]
  end

  arr
end
