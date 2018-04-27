# DisjointIntervalST
## interval search tree that can merge and delete disjoint intervals

The simpler solution to the disjoint interval problem would involve one pass through 
the interval data while checking for intersections and outputting to the txt file accordingly.
If the time complexity of printing/outputting to the txt file were considered in the problem
this would also be the optimal solution (linear). If printing is not taken into account and 
you consider the situation where the state of the data is tracked but not printed, O(log(n)) 
solutions are possible. I used a modified interval search tree to handle insertion, merging, 
and deletion in log(n). It should also be noted that this is only the optimal solution if 
the majority of merges and deletions do not intersect with a large percentage of the intervals.
