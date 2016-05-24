function block_sizes = Get_Block_Sizes(I_d,H_s,k_comp,k_bw)
% I_d: list of dense information matrices - one for each MB
% H_s: list of Sparse jacobians
% k_comp: the computational constraint
% k_bw:   the bandwidth constraint
node_dim = 3;

for i=1:length(I_d) % each MB
    block_sizes{i} = node_dim*ones(length(I_d{i})/node_dim,1);
end

%TODO start to add edges until the constraints are met?