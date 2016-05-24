function B = Maximum_Node_Cardinality_Set(I,k_mem)

node_dim=3;
node_spacing=3;

A=1*ones(1,length(I)/node_dim);

for i=2:node_spacing:length(I)/node_dim-2
    A(i) = nnz(I(i*node_dim-2,1:3:length(I)));
end
[C,ind] = sort(A,'descend');
B=ones(1,length(I)/node_dim);
B(ind(1:length(I)/node_dim - k_mem))=0;