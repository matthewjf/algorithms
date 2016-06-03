require_relative 'graph'
require_relative 'priority_map'
require 'byebug'

# O(|V| + |E|*log(|V|)).
def dijkstra2(source)
  shortest_paths = {}
  
  possible_paths = PriorityMap.new do |data1, data2|
    data1[:cost] <=> data2[:cost]
  end

  possible_paths[source] = {cost: 0, last_edge: nil}

  until possible_paths.empty?
    vert, data = possible_paths.extract
    shortest_paths[vert] = data

    vert.out_edges.each do |e|
      next if shortest_paths.has_key?(e.to_vertex)
      next if possible_paths.has_key?(e.to_vertex) &&
              possible_paths[e.to_vertex][:cost] <= e.cost + data[:cost]

      possible_paths[e.to_vertex] = {cost: e.cost + data[:cost], last_edge: e}
    end
  end

  shortest_paths
end
