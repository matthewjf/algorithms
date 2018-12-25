=begin
This problem was asked by Airbnb.

Given a list of integers, write a function that returns the largest sum
of non-adjacent numbers. Numbers can be 0 or negative.

For example, [2, 4, 6, 2, 5] should return 13, since we pick 2, 6, and 5.
[5, 1, 1, 5] should return 10, since we pick 5 and 5.

Follow-up: Can you do this in O(N) time and constant space?
=end

def non_adjacent_sum(list)
  return list.max if list.length < 3

  t = list.shift(2)
  first_sum = t.first
  second_sum = t.max

  list.each do |el|
    current_sum = [first_sum + el, second_sum].max
    first_sum, second_sum = second_sum, current_sum
  end

  [first_sum, second_sum].max
end

require 'rspec'

RSpec.describe '#non_adjacent_sum' do
  it 'works in simple case' do
    expect(non_adjacent_sum([2, 4, 6, 2, 5])).to eq(13)
  end

  it 'will skip values' do
    expect(non_adjacent_sum([5, 1, 1, 5])).to eq(10)
  end
end
