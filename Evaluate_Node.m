function [Dkl,I_s] = Evaluate_Node(B,I,X_hat,k_comp,k_bw)

node_dim = 3;

MBs = Get_Markov_Blankets(I,find(B==0));
[I_d_full, i_map] = Schur_Complement(I,B);
save I_d_full I_d_full
[I_d,X_hat_d] = Get_Markov_Blanket_Informations(I_d_full,X_hat,MBs,i_map);
H_s=Build_Jacobians_CLT(I_d,X_hat_d); % 
block_sizes = Get_Block_Sizes(I_d,H_s,k_comp,k_bw);
Dkl = 0;
I_s_full = I_d_full;
for i=1:length(MBs)
    [Dkli, I_si] = min_KLD(I_d{i},H_s{i},block_sizes{i});
    Dkl = Dkl + Dkli;
    inds = [];
    for j = 1:length(MBs{i})
        inds = [inds (i_map(MBs{i}(j))-1)*node_dim+1:i_map(MBs{i}(j))*node_dim];
    end
    I_s_full(inds,inds) = I_si;
end
%save I_d_full I_d_full
I_s = I_s_full;