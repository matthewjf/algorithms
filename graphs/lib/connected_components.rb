require_relative 'bfs'
require_relative 'undirected_graph'

# constant time lookup for connected components

class ConnectedComponents
  attr_reader :store, :count

  def initialize(vertices)
    @store = self.class.connected_components(vertices)
    @count = @store.values.uniq.length
  end

  def self.connected_components(vertices)
    components = {}
    component_idx = 0
    vertices.each do |vert|
      next if components[vert]
      bfs(vert).keys.each {|v| components[v] = component_idx}
      component_idx += 1
    end

    components
  end

  def connected?(v1, v2)
    @store[v1] == @store[v2]
  end
end
