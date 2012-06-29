function [weights block_ids] =calculate_qcolor_fractions_in_block(block,centroids,intensity_cutoff,include_bg)
%
% ------------------------------------------------------------------------------
% Copyright ©2012, The University of Texas Southwestern Medical Center 
% Authors:
% Satwik Rajaram and Benjamin Pavie for the Altschuler and Wu Lab
% For latest updates, check: < http://www.PhenoRipper.org >.
%
% All rights reserved.
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, version 3 of the License.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details:
% < http://www.gnu.org/licenses/ >.
%
% ------------------------------------------------------------------------------
%%

number_of_clusters=size(centroids,4);
number_of_channels=size(centroids,3);
[xsize,ysize,~]=size(block);
distmat=zeros(xsize,ysize,number_of_clusters);
bg=sqrt(sum(block.^2,3)/number_of_channels)<intensity_cutoff;

for cluster=1:number_of_clusters
    distmat(:,:,cluster)=sum((block-centroids(:,:,:,cluster)).^2,3);
end
[~,block_ids]=min(distmat,[],3);

% All background blocks are set to have id=0
block_ids(bg(:))=0;

weights=zeros(number_of_clusters+1,1);
% If backround is not used, then the weight of the background (first) component is
% always zero
if(include_bg)
    start_cluster=0;
else
    start_cluster=1;
end
%for cluster=0:number_of_clusters
for cluster=start_cluster:number_of_clusters
    %weights(cluster+1)=sum(block_ids(:)==cluster)/(xsize*ysize);
    weights(cluster+1)=sum(block_ids(:)==cluster)/(nnz(block_ids>=start_cluster));
end

end
