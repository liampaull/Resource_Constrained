%
%--------------------iscycle.m---------------------------
%
% input: korif = set of vertices in the graph
%       akmi = edge we insert in graph
% output: korif = The "new: set of vertices
%        c = 1 if we have circle, else c = 0
%
% N.Cheilakos,2006
%---------------------------------------------------------
function [korif,c]=iscircle(korif,akmi)
g=max(korif)+1;
c=0;
n=length(korif);
if korif(akmi(1))==0 & korif(akmi(2))==0
    korif(akmi(1))=g;
    korif(akmi(2))=g;
elseif korif(akmi(1))==0
    korif(akmi(1))=korif(akmi(2));
elseif korif(akmi(2))==0
    korif(akmi(2))=korif(akmi(1));
elseif korif(akmi(1))==korif(akmi(2))
    c=1;
    return
else
    m=max(korif(akmi(1)),korif(akmi(2)));
    for i=1:n
        if korif(i)==m
           korif(i)=min(korif(akmi(1)),korif(akmi(2)));
       end
   end
end
