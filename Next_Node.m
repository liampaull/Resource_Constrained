function [B,i] = Next_Node(open_set, n)
% Description: pick a node in the open set to expand
% for now do something simple (stupid) and just pick the first one

i = length(open_set);
ix = open_set{i};
B = ones(n,1);
B(ix)=0;