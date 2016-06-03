# O(V^2 + E)
def dijkstra_hash(src, target = nil)
  frontier = Hash.new(Float::INFINITY)
  shortest_paths = {src => 0}
  frontier[src] = 0

  until frontier.empty?
    v, c = frontier.min_by(&:last)
    frontier.delete(v)

    return c if target == v
    shortest_paths[v] = c

    v.outer_edges.each do |e|
      v2, c2 = e.to, e.cost
      next if shortest_paths[v2]

      frontier[v2] = [frontier[v2], c + c2].min
    end
  end

  shortest_paths
end

# priority queue
# O((V + E)*log(V))
def dijkstra(src, target = nil)
  frontier = PriorityQueue.new
  shortest_paths = {src => 0}
  frontier[src] = 0

  until frontier.empty?
    v, c = frontier.pop_min # much faster

    return c if target == v
    shortest_paths[v] = c

    v.outer_edges.each do |e|
      v2, c2 = e.to, e.cost
      next if shortest_paths[v2]

      frontier.insert([v2, c + c2]) # faster
    end
  end

  shortest_paths
end

# Fibonacci heap is even faster (hard to implement)
# O(V*log(V) + E)
