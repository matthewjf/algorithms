require_relative 'graph'

# O(|V|**2 + |E|).
def dijkstra1(source)
  shortest_paths = {}
  possible_paths = {source => {cost: 0, last_edge: nil}}

  until possible_paths.empty?
    vert, data = possible_paths.min_by {|k,data| data[:cost]}
    shortest_paths[vert] = possible_paths[vert]
    possible_paths.delete(vert)

    vert.out_edges.each do |e|
      unless shortest_paths.include?(e.to_vertex)
        possible_paths[e.to_vertex] = {cost: data[:cost] + e.cost, last_edge: e}
      end
    end
  end

  shortest_paths
end
