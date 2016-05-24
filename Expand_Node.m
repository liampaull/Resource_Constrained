function open_set = Expand_Node(i, open_set, closed_branches, n, k_mem)

node_spacing=1;

a=2:node_spacing:n-2;
if(n - length(open_set{i}) > k_mem) % sum(B) gives number of 1's in B which the num of nodes still in the graph. 
    b = setdiff(a,open_set{i}); % all possible branches to explore
    for ix=1:length(b)
        candidate_node = [open_set{i} b(ix)];
        if (~is_closed(candidate_node,closed_branches))
            open_set{length(open_set)+1} = candidate_node;
        end
    end
end

open_set(i) = []; % remove from open set.

function isclosed = is_closed(node,closed_branches)

isclosed=0;
for i = 1:length(closed_branches)
    if (all(ismember(closed_branches{i}, node))) % if there a closed branch which is a subset of the node that we just generated. if yes then the node is in the closed branch
        isclosed=1;
    end
end
