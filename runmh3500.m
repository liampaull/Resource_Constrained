clear;
clc;
close all;
J = load('data/intel_jac.txt');
I = jac_to_inf(J,5514,2829);
%I = load('data/manhattan20_inf.txt');
X_hat = load('data/intel_estimate.txt');

hold on;
node_dim = 3;
num_nodes = 943
I_orig = I;
X_orig = X_hat;
i = 1;
total_Dkl_uniform=[];
for n = num_nodes - 1: -1:300
    [B, Dkl_star_i, I] = Resource_Contrained(I,X_hat,n,1,1);
    inds = find(B==1);
    X_temp = X_hat;
    X_hat = [];
    for ind = 1:length(inds)
       for j = 1:node_dim
           X_hat = [X_hat X_temp((inds(ind) - 1)*node_dim + j)];
       end
    end
    B_min_card = Minimum_Node_Cardinality_Set(I_orig,n);
    [Dkl_min_card, I_min_card] = Evaluate_Node(B_min_card, I_orig, X_orig, 1,1);
    B_max_card = Maximum_Node_Cardinality_Set(I_orig,n);
    [Dkl_max_card, I_max_card] = Evaluate_Node(B_max_card, I_orig, X_orig, 1,1);
    %avg_Dkl_star(i) = sum(real(Dkl_star))/i
    B_uniform = ones(num_nodes,1);
    if(floor(num_nodes/(num_nodes-n)) ~= floor(num_nodes/(num_nodes - n + 1)))
        floor(num_nodes/(num_nodes-n))
        floor(num_nodes/(num_nodes - n + 1))
        B_uniform(1:floor(num_nodes/(num_nodes-n)):num_nodes)=0;
        [Dkl_uniform, I_uniform] = Evaluate_Node(B_uniform, I_orig, X_orig, 1,1);
        total_Dkl_uniform(length(total_Dkl_uniform)+1) = Dkl_uniform;
        uniform_ind(length(total_Dkl_uniform)) = length(find(B_uniform==0));
    end
    B_rand = ones(num_nodes,1);
    r=0;
    while(r<num_nodes-n)
        r_num = 2+ floor((num_nodes-4)*rand);
        if (B_rand(r_num)==0)
            continue;
        end
        B_rand(r_num)=0;
        r=r+1;
    end
    [Dkl_rand, I_rand] = Evaluate_Node(B_rand, I_orig, X_orig, 1,1);
   node_removed(i) = find(B==0)
   for k=1:length(node_removed)
       node_removed_orig(k) = node_removed(k) + length(find(node_removed(1:k-1)<=node_removed(k)))
   end
   B_test = ones(length(X_orig)/node_dim,1);
   B_test(node_removed_orig) = 0;
   [Dkl_star, I_star] = Evaluate_Node(B_test, I_orig, X_orig, 1, 1);
    
    total_Dkl_star(i) = Dkl_star
    total_Dkl_min_card(i) = Dkl_min_card
    total_Dkl_max_card(i) = Dkl_max_card
    total_Dkl_rand(i) = Dkl_rand
    node_removed_min_card = find(B_min_card==0);
    i = i+1;
    plot(total_Dkl_min_card,'r');
    plot(total_Dkl_max_card, 'b');
    plot(uniform_ind,total_Dkl_uniform, 'g');
    plot(total_Dkl_rand,'c');
    plot(total_Dkl_star, 'm');
    drawnow;
end
