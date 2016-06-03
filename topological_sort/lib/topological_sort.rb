require_relative 'graph'

# Implementing topological sort using both Khan's and Tarian's algorithms

def topological_sort(vertices)
  in_degree = vertices.inject({}) do |acc, v|
    acc[v] = v.in_edges.length
    acc
  end

  sorted = []
  queue = in_degree.select {|k,v| v == 0 }.keys

  until queue.empty?
    curr = queue.shift
    sorted.push(curr)

    in_degree[curr] = nil

    curr.out_edges.map(&:to_vertex).each do |v|
      in_degree[v] -= 1
      queue.push v if in_degree[v] == 0
    end
  end

  sorted
end
