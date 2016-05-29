class Fixnum
  # Fixnum#hash already implemented for you
end

class Array
  def hash
    self.each_with_index.map do |el, i|
      if el.is_a?(Array)
        (i.hash ^ el.hash).hash
      else
        (i.hash ^ el.to_s.ord.hash).hash
      end
    end.inject(:^).hash
  end
end

class String
  def hash
    self.chars.map(&:ord).map(&:hash).hash
  end
end

class Hash
  # This returns 0 because rspec will break if it returns nil
  # Make sure to implement an actual Hash#hash method
  def hash
    result = 0.hash
    self.to_a.each do |pair|
      result = result ^ pair.hash
    end
    result
  end
end
