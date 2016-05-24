function I = jac_to_inf(J,n,m)

jac = zeros(n,m);

for i = 1:length(J)
    jac(J(i,1)+1,J(i,2)+1) = J(i,3);
end

I = jac'*jac;