# sort edges by ascending cost
# add edges in order to the MST unless it would create a cycle

# run time O(Elog(E))
  # build priority queue O(E)
  # delete min O(Elog(E))
  # union O(Vlog(V))
  # connected O(Elog(V))
