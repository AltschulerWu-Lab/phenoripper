function data=wmd_read_data_simple(filenames,block_size,cutoff_intensity, number_of_RGB_clusters,number_of_block_clusters,...
    number_of_blocks_per_image,rgb_samples_per_image,number_of_representative_blocks,marker_scales,include_bg)

data.block_size=block_size;
data.cutoff_intensity=cutoff_intensity;
data.number_of_RGB_clusters=number_of_RGB_clusters;
data.number_of_block_clusters=number_of_block_clusters;


[number_of_repeats,number_of_channels]=size(filenames);

test=imread(cell2mat(filenames(1,1)));
xres=size(test,1);
yres=size(test,2);
channels_per_file=size(test,3);
number_of_channels=max(number_of_channels,channels_per_file);
%% Set up the matrices for averaging



blocks_nx=floor(xres/block_size);
x_offset=floor(rem(xres,block_size)/2)+1;
blocks_ny=floor(yres/block_size);
y_offset=floor(rem(yres,block_size)/2)+1;

B=repmat(((1:block_size*blocks_ny)<=block_size)',1,blocks_ny);
for i=1:blocks_ny
        B(:,i)=circshift(B(:,i),(i-1)*block_size);
end

A=repmat(((1:block_size*blocks_nx)<=block_size),blocks_nx,1);
for i=1:blocks_nx
    A(i,:)=circshift(A(i,:)',(i-1)*block_size)';
end
A1=sparse(A);
B1=sparse(B);


%% Read and Process Images


block_data_temp=zeros(block_size,block_size,number_of_channels,number_of_blocks_per_image*number_of_repeats); %Temporarary variable to store all the blocks (needed because we dont know number of valid blocks before hand
rgb_data_temp=zeros(rgb_samples_per_image*number_of_repeats,number_of_channels);
block_counter=0;
rgb_counter=0;

for image_counter=1:number_of_repeats
    
    
    if(channels_per_file>1)
        img=Read_and_Scale_Image(filenames(image_counter),marker_scales); 
    else
        img=Read_and_Scale_Image(filenames(image_counter,:),marker_scales); 
    end
    
    intensity=sqrt(sum(img.^2,3)/number_of_channels);
    foreground_points=zeros(sum(sum(intensity>cutoff_intensity)),number_of_channels);
    for channel_counter=1:number_of_channels
        temp=squeeze(img(:,:,channel_counter));
        foreground_points(:,channel_counter)=temp(intensity>cutoff_intensity);
    end
    
    rgb_sample_size=min(size(foreground_points,1),rgb_samples_per_image);
    rgb_data_temp(rgb_counter+1:rgb_counter+rgb_sample_size,:)=...
        foreground_points(randsample(1:size(foreground_points,1),rgb_sample_size),:);
    raw_data=zeros(block_size*blocks_nx,block_size*blocks_ny,number_of_channels);
    
    
    for channel_counter=1:number_of_channels
        raw_data(:,:,channel_counter)=img(x_offset:(x_offset+blocks_nx*block_size-1),...
            y_offset:(y_offset+blocks_ny*block_size-1),channel_counter);
    end
    
        
    temp=intensity(x_offset:(x_offset+blocks_nx*block_size-1),...
        y_offset:(y_offset+blocks_ny*block_size-1));
    %avg_intensity=A1*temp*B1/(block_size^2);
    
    fraction_fg_pixels_in_block=A1*double(temp>cutoff_intensity)*B1/(block_size^2);
    foreground_blocks=find(fraction_fg_pixels_in_block>0.5);
    %foreground_blocks=find(avg_intensity>cutoff_intensity);
    sample_size=min(number_of_blocks_per_image,length(foreground_blocks));
    if(sample_size>0)
        good_blocks=randsample(foreground_blocks,sample_size);
        bx=zeros(sample_size,1);
        by=zeros(sample_size,1);
        
        for k=1:sample_size
            [bx(k) by(k)]=ind2sub([blocks_nx,blocks_ny],good_blocks(k));
            block_data_temp(:,:,:,block_counter+k)=raw_data((bx(k)-1)*block_size+1:bx(k)*block_size,...
                (by(k)-1)*block_size+1:by(k)*block_size,:) ;
           
        end
    end
    
    rgb_counter=rgb_counter+rgb_sample_size;
    block_counter=block_counter+sample_size;
    
end

block_data=block_data_temp(:,:,:,1:block_counter);
rgb_data=rgb_data_temp(1:rgb_counter,:);
[ids0,data.RGB_centroids]=kmeans(rgb_data,...
    number_of_RGB_clusters,'emptyaction','singleton','start','cluster');
data.RGB=mean(rgb_data);
data.RGB_dist=rgb_data;
data.RGB_weights=zeros(number_of_RGB_clusters,1);
for k=1:number_of_RGB_clusters
   data.RGB_weights(k)=sum(ids0==k)./length(ids0);
end

% Calculate fractions of various colors (RGB clusters) in the different
% blocks

data.block_weights=zeros(block_counter,number_of_RGB_clusters+1);
%centroids_temp=reshape(x,[number_of_RGB_clusters,1,number_of_channels]);
centroids_temp=zeros(block_size,block_size,number_of_channels,number_of_RGB_clusters);
for i=1:number_of_RGB_clusters
    centroids_temp(:,:,:,i)=repmat(reshape(data.RGB_centroids(i,:),1,1,number_of_channels),block_size,block_size);
end
for k=1:block_counter
    %data.block_weights(k,:)=...
     %   block_weights(block_data(:,:,:,k),data.RGB_centroids);
     data.block_weights(k,:)=...
        block_weights2(block_data(:,:,:,k),centroids_temp,cutoff_intensity,include_bg);

end


[ids1,data.block_centroids,~,distmat]=kmeans(data.block_weights,...
    number_of_block_clusters,'emptyaction','singleton','start','cluster');

data.representative_blocks=zeros(number_of_block_clusters,block_size,block_size,number_of_channels,number_of_representative_blocks);
for cluster_counter=1:number_of_block_clusters
   [~,ids]=sort(distmat(:,cluster_counter));
   data.representative_blocks(cluster_counter,:,:,:,:)=block_data(:,:,:,ids(1:number_of_representative_blocks));
end



data.block_cluster_weights=zeros(number_of_block_clusters,1);
for k=1:number_of_block_clusters
    data.block_cluster_weights(k)=sum(ids1==k)/block_counter;
end


end
