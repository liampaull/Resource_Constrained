function H_s = Build_Jacobians_CLT(I_d,X_hat_d)
% inputs:
% I_d: A set of dense information matrices. One for each separate Markov
%      Blanket
% X_hat_d: A set of MAP estimates corresponding to the nodes in each
% separate Markov Blanket
% outputs:
% H_s: The meausurement Jacobians according to relative measurements in
%      SE(n) and a Chow-Liu Tree connectivity structure.


node_dim = 3; % dimension of a node. Should be 2 or 3 SE(n) relative constraint

for i = 1:length(I_d)
    if (length(I_d{i})==node_dim) % at some point might want to explicitly not allow MBs of size one. Means we are marginalizing out a node with a global factor which you might not want to do.
        H_s{i}=eye(node_dim);% unary factor
        continue;
    end
    PV=[];
    r=1;
    % populate the mutual inf matrix?
    for j = 1:length(I_d{i})/node_dim
        for k = 1:length(I_d{i})/node_dim
            if (j==k) 
                continue;
            end
            I_jj = I_d{i}((j-1)*node_dim+1:j*node_dim,(j-1)*node_dim+1:j*node_dim);
            I_jk = I_d{i}((j-1)*node_dim+1:j*node_dim,(k-1)*node_dim+1:k*node_dim);
            I_kk = I_d{i}((k-1)*node_dim+1:k*node_dim,(k-1)*node_dim+1:k*node_dim);
            PV(r,1)=j;
            PV(r,2)=k;
            PV(r,3) = -0.5*log(det(I_jj - I_jk*inv(I_kk)*I_jk')/det(I_jj));
            r = r+1;
        end
    end
    [w,T]=kruskal(PV); % T contains adjacency matrix - w is the weights on the spanning tree.
    H_s{i} = zeros(size(I_d{i}));%square jacobian - enforces invertibility
    H_s{i}(1:node_dim,1:node_dim) = eye(node_dim); % global measurement on first node
    T = triu(T,1);
    [row,col] = find(T==1);
    
    %TODO set the jacobian to real values based on analytical expressions
    %for relative measuremens in SE(n) and MAP values X_hat
    for l=2:length(row)+1
        x_2 = X_hat_d{i}((row(l-1)-1)*node_dim+1:row(l-1)*node_dim);
        x_1 = X_hat_d{i}((col(l-1)-1)*node_dim+1:col(l-1)*node_dim);
        z_hat = ominus(x_2,x_1);
        c = cos(x_1(3));
        s = sin(x_1(3));
        J1 = [-c, -s, z_hat(2); s, c, -z_hat(1); 0, 0, -1];
        J2 = [c, s, 0; -s, c, 0; 0, 0, 1];
        H_s{i}((l-1)*node_dim+1:l*node_dim,(row(l-1)-1)*node_dim+1:row(l-1)*node_dim) = J1;
        H_s{i}((l-1)*node_dim+1:l*node_dim,(col(l-1)-1)*node_dim+1:col(l-1)*node_dim) = J2;
    end
end

function z = ominus(x_2,x_1)
c = cos(x_1(3));
s = sin(x_1(3));
dx = x_2(1) - x_1(1);
dy = x_2(2) - x_1(2);
z(1) = c*dx + s*dy;
z(2) = -s*dx + c*dy;
z(3) = x_2(3) - x_1(3);
