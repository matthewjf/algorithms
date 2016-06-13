class Vertex
  attr_reader :value, :neighbors

  def initialize(value)
    @value, @neighbors = value, []
  end

  def add_neighbor(vertex)
    self.set_neighbor(vertex)
    vertex.set_neighbor(self)
  end

  def set_neighbor(vertex)
    return nil if @neighbors.include?(vertex)
    @neighbors.push(vertex)
  end
end
