=begin
Social network connectivity
Given a social network containing N members and a log file containing M
timestamps at which times pairs of members formed friendships, design an
algorithm to determine the earliest time at which all members are connected
(i.e., every member is a friend of a friend of a friend ... of a friend).
Assume that the log file is sorted by timestamp and that friendship is an
equivalence relation. The running time of your algorithm should be MlogN or
better and use extra space proportional to N.
=end

# assumptions
# n is the number of members
# friendships is a list of relationships [i,j] where i and j are friends

require_relative 'quick_union'

def connected_time(members, friendships)
  list = UnionFind.new
  members.each {|mem| list.add(mem)}
  friendships.each do |mem1, mem2, time|
    list.union(mem1, mem2)
    return time if list.count_isolated_components == 1
  end
end
