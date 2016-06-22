def overlapping?(r1, r2)
  return false if r1.max < r2.min || r2.max < r2.min
  true
end

def merge_ranges(r1, r2)
  ([r1.min,r2.min].min..[r1.max,r2.max].max)
end

def sort(list_ranges)
  return list_ranges.sort_by{|r| r.min}
end


def insert_range(range, list)
  # insert the range into the list and sort by the minimum
  unioned = sort(list.push(range))

  # return if the only element in the list is the range to insert
  return unioned if unioned.length == 1

  result = []
  until unioned.empty?
    curr = unioned.shift
    if result.empty?
      result.push(curr)
    else
      if overlapping?(result.last, curr)
        # merge last range in result with next in unioned list
        merged = merge_ranges(result.pop, curr)
        result.push(merged)
      else
        result.push(curr)
      end
    end
  end
  result
end
