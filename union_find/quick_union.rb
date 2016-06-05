class UnionFind
  def initialize
    @connected_count = 0
    @parent = {}
    @tree_size = {}
  end

  # O(1)
  def add(el)
    @connected_count += 1
    @parent[el] = el
  end

  # O(log(n))
  def union(el1, el2)
    root_1 = find_root(el1)
    root_2 = find_root(el2)

    return nil if root_1 == root_2

    if @tree_size[root_1] < @tree_size[root_2]
      @parent[root_1] = root_2
      root = root_2
      @tree_size[root_2] += @tree_size[root_1]
    else
      @parent[root_2] = root_1
      root = root_1
      @tree_size[root_1] += @tree_size[root_2]
    end

    @connected_count -= 1
    root
  end

  # O(log(n))
  def connected?(el1, el2)
    find_root(el1) == find_root(el2)
  end

  # O(1)
  def count_isolated_components
    @connected_count
  end

  # O(log(n))
  def find_root(el)
    root = el
    until @parent[root] == root
      @parent[root] = @parent[@parent[root]]
      root = @parent[root]
    end
    root
  end
end
