=begin
Asked by Stripe.

Given an array of integers, find the first missing positive integer
in LINEAR time and CONSTANT space. The array can contain duplicates and
negative numbers
=end

def find_missing(list)
  minimum = list.min

  list.each do |val|
    idx = val.abs - minimum
    list[idx] = -list[idx] unless list[idx].nil? || list[idx].negative?
  end

  list.each.with_index do |v, i|
    return i + minimum if v > 0
  end
end

require 'rspec'

RSpec.describe 'find_missing' do
  it 'finds missing integer' do
    list = [5,6,7,9,10].shuffle
    result = find_missing(list)
    expect(result).to eq(8)
  end

  it 'handle duplicates' do
    list = [1,1,2,3,5]
    expect(find_missing(list)).to eq(4)
  end

  it 'handles the missing end element' do
    list = [1,1,2,3]
    expect(find_missing(list)).to eq(4)
  end
end
