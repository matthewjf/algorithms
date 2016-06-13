require_relative 'undirected_graph'
require 'byebug'

def bfs(source, paths = {source => source})
  source.neighbors.each do |neighbor|
    next if paths.has_key?(neighbor)
    paths[neighbor] = source
    bfs(neighbor, paths)
  end

  return paths
end
