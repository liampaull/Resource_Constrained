function [I_d,i_map] = Schur_Complement(I,b)

% input:
%   I is the input information matrix
%   b is a vector of 1's and 0's corresponding to the nodes to be removed

node_dim=3;

B_R = zeros(sum(b)*node_dim  ,length(b)*node_dim);
B_M = zeros(sum(1-b)*node_dim,length(b)*node_dim);
r_R = 1;
r_M = 1;
%disp('in SC 1')
%clock
for i=1:length(b)
    if(b(i) == 1)
        for j =1:node_dim
            B_R(node_dim*(r_R-1) + j,node_dim*(i-1) + j) = 1;
        end
        i_map(i)=r_R;
        r_R = r_R+1;
    else
        for j =1:node_dim
            B_M(node_dim*(r_M-1) + j,node_dim*(i-1) + j) = 1;
        end
        i_map(i)=-1;
        r_M = r_M+1;
    end
end
% 
% disp('in SC 2')
% clock
% I_RR = B_R*I*B_R';
% I_MM = B_M*I*B_M';
% I_MR = B_M*I*B_R';

R = find(b==1);
M = find(b==0);

RR = [];
MM = [];
for i=1:length(R)
    for j=1:node_dim
    RR = [RR ; (R(i)-1)*node_dim + j];
    end
end
for i=1:length(M)
    for j=1:node_dim
    MM = [MM ; (M(i)-1)*node_dim + j];
    end
end

I_RR = I(RR,RR);
I_MM = I(MM,MM);
I_MR = I(MM,RR);

%save SC

%disp('in SC 3')
%clock
I_d = I_RR - I_MR'*I_MM^(-1)*I_MR;
save I_d_full I_d