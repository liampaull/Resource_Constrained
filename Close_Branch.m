function [open_set, closed_branches] = Close_Branch(i, open_set, closed_branches)

closed_branches{length(closed_branches)+1} = open_set{i};
open_set(i) = [];