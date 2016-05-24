function [D_kl_min, I_si] = min_KLD(I_di,H_s,block_sizesi)
% description - minimize the KLD between I_d and the (usually sparser) H'XH
% I_d - dense information matrix to be approximated
% H_S - Jacobian (should be invertible)
% block_sizes - array of block sizes for measurements

if(sum(block_sizesi) ~= length(I_di))
    block_sizesi
    I_di
    error('Sum of block measurement informations must equal size of I_di');
end

% do a test for invertible H_s
Sigma = inv(I_di);
T1 = H_s*Sigma*H_s'; % precalc this once 
r = 1;
D = zeros(length(I_di),length(I_di));
for i=1:length(block_sizesi)
    n = block_sizesi(i);
    D(r:r+n-1,r:r+n-1) = inv(T1(r:r+n-1,r:r+n-1));
    r = r + n;
end
I_si = H_s'*D*H_s; % precalc this once for use twice in next line
D_kl_min = trace(I_si*Sigma) + log(det(I_si));