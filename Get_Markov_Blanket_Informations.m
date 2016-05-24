function [I_d,X_hat_d] = Get_Markov_Blanket_Informations(I_d_full,X_hat,MBs,i_map)
% Description: Get the block information matrices corresponding to the 
%              Markov Blankets

node_dim=3;

for i=1:length(MBs)
    inds = [];
    for j = 1:length(MBs{i})
        inds = [inds (i_map(MBs{i}(j))-1)*node_dim+1:i_map(MBs{i}(j))*node_dim];
    end
    I_d{i}=I_d_full(inds,inds);
    X_hat_d{i} = X_hat(inds);
end
