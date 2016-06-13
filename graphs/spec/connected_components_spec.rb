require 'rspec'
require 'connected_components'

describe ConnectedComponents do
  let(:v0) { Vertex.new(0) }
  let(:v1) { Vertex.new(1) }
  let(:v2) { Vertex.new(2) }
  let(:v3) { Vertex.new(3) }
  let(:v4) { Vertex.new(4) }
  let(:v5) { Vertex.new(5) }
  let(:v6) { Vertex.new(6) }
  let(:v7) { Vertex.new(7) }
  let(:v8) { Vertex.new(8) }
  let(:v9) { Vertex.new(9) }
  let(:v10) { Vertex.new(10) }
  let(:v11) { Vertex.new(11) }
  let(:v12) { Vertex.new(12) }
  let(:vertices) {[v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12]}
  let(:cc) { ConnectedComponents.new(vertices) }

  before(:each) do
    v0.add_neighbor(v1)
    v0.add_neighbor(v2)
    v0.add_neighbor(v6)
    v0.add_neighbor(v5)
    v3.add_neighbor(v4)
    v3.add_neighbor(v5)
    v4.add_neighbor(v5)
    v4.add_neighbor(v6)

    v7.add_neighbor(v8)

    v9.add_neighbor(v10)
    v9.add_neighbor(v11)
    v9.add_neighbor(v12)
    v11.add_neighbor(v12)
  end

  describe 'initialize' do
    it 'should take in a list if vertices' do
      expect{ ConnectedComponents.new(vertices) }.to_not raise_error
    end

    it 'stores a hash of components' do
      expect(cc.send(:store)).to be_a Hash
    end
  end

  describe '#count' do
    it 'should count then number of connected components' do
      expect(cc.count).to eq 3
    end
  end

  describe '#connected?' do
    it 'should tell if vertices are connected' do
      expect(cc.connected?(v0, v4)).to eq true
    end

    it 'should identify disconnected vertices' do
      expect(cc.connected?(v0, v11)).to eq false
    end
  end
end
