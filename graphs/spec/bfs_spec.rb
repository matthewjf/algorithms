require 'rspec'
require 'bfs'

describe 'bfs' do
  let(:v1) { Vertex.new("A") }
  let(:v2) { Vertex.new("B") }
  let(:v3) { Vertex.new("C") }
  let(:v4) { Vertex.new("D") }

  before(:each) do
    v1.add_neighbor(v2)
    v1.add_neighbor(v3)
    v2.add_neighbor(v3)
    v2.add_neighbor(v4)
  end

  it 'should take in a vertex' do
    expect{ bfs(v1) }.to_not raise_error
  end

  it 'should sort the vertices correctly' do
    output = bfs(v1).map do |v, prev|
      [v.value, prev.value]
    end

    expect(output).to eq([["A", "A"], ["B", "A"], ["C", "B"], ["D", "B"]])
  end

end
