function MBs = Get_Markov_Blankets(I,nodes_removed)
% Input: I - information matrix (used to infer connectivity of graph)
% Input: nodes_removed - the list of nodes to be removed.
% Output: MBs - the list of nodes in the distinct Markov Blankets
% Description: the tricky part is how to merge MBs that overlap and
% find the distinct set

node_dim=3;

to_remove = [];
for b=1:length(nodes_removed)
    to_add = [];
    r = 1;
    MBs{b}=[];
    id = nodes_removed(b);
    for i=1:length(I)/node_dim
        if (i == id) 
            continue;
        end
        if (I((id-1)*node_dim+1,(i-1)*node_dim+1) ~= 0)
            if(length(intersect(i,nodes_removed(1:b)))==1)
                k = find(nodes_removed==i,1);
                to_add(length(to_add)+1) = k;
                to_remove(length(to_remove)+1) = k;
                r = length(MBs{b})+1;
            elseif (isempty(intersect(i,nodes_removed)))
                MBs{b}(r)=i;
                r = r+1;
            end
        end
    end
    for i=1:length(to_add)
        MBs{b} = union(MBs{b},MBs{i});
    end
    MBs{b} = unique(MBs{b});
end
%for i=1:length(MBs)
%    if (isempty(MBs{i}))
%        to_remove(length(to_remove)+1) = i;
%    end
%end
MBs(to_remove) = [];


% known bug: If the nodes that remain cut the original graph then it is
% possible to get two identical markov blankets in the list. For example
% consider the graph:
%               2
%           1 < 3 > 4
% where 1 and 4 are removed they both have the same MB {2,3}