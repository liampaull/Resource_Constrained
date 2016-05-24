%
%---------------------kruskal.m---------------------   
%
% Kruskal algorithm for finding maximum spanning tree
%
% Input:  PV = nx3 martix. 1st and 2nd row's define the edge (2 vertices) and
% the 3rd is the edge's weight
% Output: w = Minimum spanning tree's weight
%         T = Minimum spanning tree's adjacency matrix
% 
% N.Cheilakos,2006
%----------------------------------------------------
function [w,T] = kruskal(PV)
row = size(PV,1);
X = [];
% create graph's adjacency matrix
for i = 1 : row
    X(PV(i,1),PV(i,2)) = 1;
    X(PV(i,2),PV(i,1)) = 1;
end
n = size(X,1);
% Check if graph is connected
con = connected(X);
if con == 1
   error('Graph is not connected');
end
% sort PV by ascending weights order. (we use bubble sort)
PV = fysalida(PV,3);
korif = zeros(1,n);
T = zeros(n);
for i = 1 : row
% control if we insert edge[i,j] in the graphic. Then the graphic has
% circle
    akmi = PV(i,[1 2]);
    [korif,c] = iscycle(korif,akmi);
    if c == 1
       PV(i,:) = [0 0 0];
   end
end
% Calculate Minimum spanning tree's weight
w = sum(PV(:,3)');
% Create minimum spanning tree's adjacency matrix
for i = 1 : row
    if PV(i,[1 2]) ~= [0 0]
        T(PV(i,1),PV(i,2)) = 1;
        T(PV(i,2),PV(i,1)) = 1;
    end
end