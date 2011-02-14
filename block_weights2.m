function [weights block_ids] =block_weights2(block,centroids,intensity_cutoff)

number_of_clusters=size(centroids,4);
[xsize,ysize,~]=size(block);
distmat=zeros(xsize,ysize,number_of_clusters);
bg=sum(block.^2,3)<intensity_cutoff;

for cluster=1:number_of_clusters
    
    distmat(:,:,cluster)=sum((block-centroids(:,:,:,cluster)).^2,3);
end
[~,block_ids]=min(distmat,[],3);
block_ids(bg(:))=0;
weights=zeros(number_of_clusters+1,1);
for cluster=0:number_of_clusters
    weights(cluster+1)=sum(block_ids(:)==cluster)/(xsize*ysize);
end

end