class Vertex
  attr_reader :value, :in_edges, :out_edges

  def initialize(value)
    @value = value
    @in_edges = []
    @out_edges = []
  end

  def delete_in_edge(edge)
    @in_edges.delete(edge)
  end

  def delete_out_edge(edge)
    @out_edges.delete(edge)
  end

  def destroy!
    (@in_edges + @out_edges).each {|e| e.destroy!}
  end
end

class Edge
  attr_reader :from_vertex, :to_vertex, :cost

  def initialize(from_vertex, to_vertex, cost = 1)
    @from_vertex = from_vertex
    @to_vertex = to_vertex
    @cost = cost
    set_edges!
  end

  def destroy!
    @from_vertex.delete_out_edge(self)
    @to_vertex.delete_in_edge(self)

    @from_vertex = nil
    @to_vertex = nil
    @cost = nil
  end

  private
  def set_edges!
    @from_vertex.out_edges.push(self)
    @to_vertex.in_edges.push(self)
  end
end
