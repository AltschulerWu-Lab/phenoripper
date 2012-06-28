function perm = dendrogram_reorder(Z,score)
% -------------------------------------------------------------------------
% The code in this directory was used in the cancer heterogeneity project, 
% focusing on the information content of phenotypic heterogeneity in
% cellular populations and its relevance to their functional responses.
%
% These prototype scripts are not guaranteed to run in all environments,
% nor are they supported by the authors.
%
% Developed on Matlab version: R2007a
% Last updated: 9/9/09 
%
% Copyright 2009 -- Chin-Jen Ku, Lani Wu, and Steven Altschuler
% All rights reserved. Do not redistribute without express written consent
% of the authors.
% -------------------------------------------------------------------------

% INPUT
%   Z     - input linkage object
%   score - score for leaf nodes (in numerical order of leaf id)
% OUTPUT
%   perm  - permutation of leaf nodes that sorts tree from low to high scores

%1. create tree structure from matlab linkage structure
%       assume that nodes are labeled from 1..length(score)
Tree = [];
sz = size(Z);
N = length(score); %nodes 1..N
parent = N+1;
for r = 1:sz(1)
   Tree = [Tree; Z(r,1) parent];
   Tree = [Tree; Z(r,2) parent];
   parent = parent + 1;
end
parent = parent - 1; % last parent id

%2. create score S for each parent node
%   columns: sum of children scores, num children, ave children scores

% leaf nodes first
S(1:N,1) = score;
S(1:N,2) = 1;
S(1:N,3) = score;

% parents next
for  i = N+1:parent
    children = Tree(Tree(:, 2) == i, 1);
    S(i,:) = sum(S(children, :));
    S(i,3) = S(i,1)/S(i,2);
end

%3. order child pairs low (Left) to high (Right) by score in LR array
for  i = N+1:parent
    children = Tree(Tree(:, 2) == i, 1);
    [s, I] = sort(S(children, 3)); 
    LR(i, :) = children(I);
end

% 4. rebuild array by substitution, starting from top parent
final = LR(end, :);
for i = parent-1:-1:N+1
    replace = find(final ==i);
    
    if replace >1
        newFinal = [final(1:replace-1)];
    else 
        newFinal = [];
    end
    newFinal = [newFinal LR(i, :)];
    if replace < length(final)
        newFinal = [newFinal final( replace+1:end)];
    end
    final = newFinal;
end
perm = final;
    
    

