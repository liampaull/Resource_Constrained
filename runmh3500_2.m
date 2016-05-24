clear;
clc;
close all;
J = load('data/manhattan3500_jac.txt');
I = jac_to_inf(J,16797,10500);
%I = load('data/manhattan20_inf.txt');
X_hat = load('data/manhattan3500_estimate.txt');

hold on;
node_dim = 3;
num_nodes = 3500
I_orig = I;
X_orig = X_hat;
i = 1;
total_Dkl_uniform=[];
for n = num_nodes - 1: -1:3450
    B = ones(1,n);
    B(1+floor(rand*n)) = 0
    [Dkl_min_card, I] = Evaluate_Node(B, I, X_hat, 1,1);
    inds = find(B==1);
    X_temp = X_hat;
    X_hat = [];
    for ind = 1:length(inds)
       for j = 1:node_dim
           X_hat = [X_hat X_temp((inds(ind) - 1)*node_dim + j)];
       end
    end
end

spy(I)