%
%------------------------connected.m------------------------
% Find if a undirected graph with adjacency matrix X is connected
%
% input: X = Adjacency matrix
% returns 0 if graph is connected
%
% N.Cheilakos,2006
% ---------------------------------------------------------
function c = connected(X)
c = 0;
i = 1;
j = 2;
a = size(X);
while(j > i)
    if X(i,j) == 0
        j = j + 1;
    else
        X(i,:) = X(i,:) | X(j,:);
        X(:,i) = X(:,i) | X(:,j);
        X(j,:) = [];
        X(:,j) = [];
        a(1) = a(1) - 1;
    end
    if (j > a(1)) & (i < a(1))
        j = i + 2;
        i = i + 1;
        c = 1;
        break
    else
        if i >= a(1)
            i = j;
        end
    end
end