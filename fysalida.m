%
%------------------------------fysalida.m-----------------------------
% swap matrix's rows, because we sort column (col) by descending order 
% 
% input: A =  matrix
%        col = column we want to sort
% output:A = sorted matrix
%
% N.Cheilakos,2006
%----------------------------------------------------------------------
function A = fysalida(A,col)
[r c] = size(A);
%******************Error checking****************************************
if col < 1 | col > c | fix(col) ~= col
   uiwait(msgbox([' error input value second argumment takes only integer values between 1 & ' num2str(c)],'ERROR','error'));
   error;
end
%**************************************************************************
for i = 1 : r - 1
    d = r + 1 - i;
    for j = 1 : d - 1
        if A(j,col) < A(j + 1,col)
% row swap j <--> j + 1            
            A([j j + 1],:) = A([j + 1 j],:);
        end
    end
end