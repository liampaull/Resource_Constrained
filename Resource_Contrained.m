function [B_star, Dkl_star,I_s] = Resource_Contrained(I,X_hat,k_mem,k_comp,k_bw)
% Top level function
% Inputs: I - information matrix output by SLAM solver
%         X_hat  - the MAP estimates of the states
%         k_mem  - memory constraint: number of nodes we will reduce to
%         k_comp - computation constraint: edge density
%         k_bw   - bandwidth constraint: edge number


% open_set: the set of candidate nodes to be evaluated. Each element in the
% set is an array of indices corresponding the nodes that have been REMOVED
% e.g. 8 node graph where node 2 has been removed is encoded by {2}
% closed_branches: indices of zeros that correspond to a closed branch

format shortg
global node_dim;
node_dim=3; % 3 - SE(2); 6 - SE(3)


B_star = Minimum_Node_Cardinality_Set(I,k_mem);
[Dkl_star,I_s] = Evaluate_Node(B_star,I,X_hat,k_comp,k_bw);

B = ones(length(I)/node_dim,1);
open_set = [];
closed_branches = [];
open_set{length(open_set)+1} = []; % empty since no zeros (nodes removed)
open_set = Expand_Node(1, open_set, closed_branches,length(I)/node_dim,k_mem);
while (~isempty(open_set))
    [B_test,i] = Next_Node(open_set,length(I)/node_dim);
    %disp('start evaluate node')
    [Dkl_test, I_s_test] = Evaluate_Node(B_test,I,X_hat,k_comp,k_bw);
    sum_B = sum(B_test);
    %disp('end evaluate node')
    if (Dkl_test > Dkl_star) % KL divergence is already bigger and we haven't hit the node removal requirement yet. Kill the whole branch
        [open_set, closed_branches] = Close_Branch(i, open_set, closed_branches);
    else
        open_set = Expand_Node(i, open_set, closed_branches, length(I)/node_dim, k_mem);
    end
    if (sum(B_test) == k_mem && Dkl_test < Dkl_star)
 %       disp('New best');
        Dkl_star = Dkl_test;
        B_star = B_test;
        I_s = I_s_test;
    end
end

B_star=B_star;
Dkl_star=Dkl_star;
I_s = I_s;