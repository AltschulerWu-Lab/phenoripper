function data=wmd_read_data_simple(filenames,block_size,cutoff_intensity, number_of_RGB_clusters,number_of_block_clusters,...
    number_of_blocks_per_image,rgb_samples_per_image,number_of_representative_blocks,marker_scales,include_bg)
% This is the function to train PhenoRipper to fix the reduced colorset and
% block types
% filenames is a cell array with rows corresponding to different images; the
% columns correspond to different channels
% marker_scales ([number of channels x 2]): The first column is the min
% value of each channel, and the second the max value
%include_bg: a bool which determines if background pixels are used
% all other parameters are integers, with (hopefully) self-descriptive name

% Setting up variables
data.block_size=block_size;
data.cutoff_intensity=cutoff_intensity;
data.number_of_RGB_clusters=number_of_RGB_clusters;
data.number_of_block_clusters=number_of_block_clusters;
[number_of_training_images,number_of_channels]=size(filenames);

% Montage Variable
split_image_res=1000;

%Setting image parameters
test=imread2(cell2mat(filenames(1,1)));
xres_full=size(test,1);
yres_full=size(test,2);

if((xres_full/split_image_res)>=2)
    xres_crop=split_image_res;
else
    xres_crop=xres_full;
end
if((yres_full/split_image_res)>=2)
   yres_crop=split_image_res;
else
    yres_crop=yres_full;
end
data.xres_full=xres_full;data.xres_crop=xres_crop;
data.yres_full=yres_full;data.yres_crop=yres_crop;


blocks_nx=floor(xres_crop/block_size);
x_offset=floor(rem(xres_crop,block_size)/2)+1;%because the image may not contain an integer number of blocks
blocks_ny=floor(yres_crop/block_size);
y_offset=floor(rem(yres_crop,block_size)/2)+1;%because the image may not contain an integer number of blocks
%Testing for multi-channel (as opposed to gray=scale) images
channels_per_file=size(test,3);
data.channels_per_file=channels_per_file;
number_of_channels=max(number_of_channels,channels_per_file);

%% Set up the matrices for averaging
% A1 and B1 are matrices used to find average values within blocks in images
% For a matrix M [200x100],if block size is 10, then A1 has dim (20x200), B1 has dim (100x10), 
% then A1*M*B1/(block_size^2) [20x10] is a matrix where each element contains the
% mean value of M in the corresponding block in M.
% A1 and B1 are of block diagonal type matrices containing 0s and 1s



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
data.A1=A1;
data.B1=B1;

if((xres_full~=xres_crop)||(yres_full~=yres_crop))
    blocks_nx_full=floor(xres_full/block_size);
    blocks_ny_full=floor(yres_full/block_size);
    B_full=repmat(((1:block_size*blocks_ny_full)<=block_size)',1,blocks_ny_full);
    for i=1:blocks_ny_full
        B_full(:,i)=circshift(B_full(:,i),(i-1)*block_size);
    end
    
    A_full=repmat(((1:block_size*blocks_nx_full)<=block_size),blocks_nx_full,1);
    for i=1:blocks_nx_full
        A_full(i,:)=circshift(A_full(i,:)',(i-1)*block_size)';
    end
    data.A2=sparse(A_full);
    data.B2=sparse(B_full);
    
else
    data.A2=A1;
    data.B2=B1;
end



%% Read and Process Images

%Temporarary variable to store all the training blocks
%(needed because we dont know number of valid blocks before hand)
block_data_temp=zeros(block_size,block_size,number_of_channels,...
    number_of_blocks_per_image*number_of_training_images); 
%Temporary variable to store all the foreground pixels used to train color
%reduction. Since we are not sure how many foreground pixels are present,
%we pre-allocate max possible number for speed
rgb_data_temp=zeros(rgb_samples_per_image*number_of_training_images,number_of_channels);
block_counter=0; %Number of foreground blocks used
rgb_counter=0; % Number of foreground pixels used
for image_counter=1:number_of_training_images
    %Read and Scale Images 
    if(channels_per_file>1)
        img=read_and_scale_image(filenames(image_counter),marker_scales,xres_full,yres_full,channels_per_file,xres_crop,yres_crop); 
    else
        img=read_and_scale_image(filenames(image_counter,:),marker_scales,xres_full,yres_full,channels_per_file,xres_crop,yres_crop); 
    end
    
    %Identify foreground pixels and store their RBG (i.e., multi-channel intensity) values
    intensity=sqrt(sum(img.^2,3)/number_of_channels);
    foreground_points=zeros(sum(sum(intensity>cutoff_intensity)),number_of_channels);
    for channel_counter=1:number_of_channels
        temp=squeeze(img(:,:,channel_counter));
        foreground_points(:,channel_counter)=temp(intensity>cutoff_intensity);
    end
    number_of_pixels_used=min(size(foreground_points,1),rgb_samples_per_image);
    rgb_data_temp(rgb_counter+1:rgb_counter+number_of_pixels_used,:)=...
        foreground_points(randsample(1:size(foreground_points,1),number_of_pixels_used),:);
    
    %Crop image so that it contains integer number of blocks in both
    %directions
    raw_data=zeros(block_size*blocks_nx,block_size*blocks_ny,number_of_channels);
    for channel_counter=1:number_of_channels
        raw_data(:,:,channel_counter)=img(x_offset:(x_offset+blocks_nx*block_size-1),...
            y_offset:(y_offset+blocks_ny*block_size-1),channel_counter);
    end
    
    %Identify foreground blocks (on cropped intensity)    
    cropped_intensity=intensity(x_offset:(x_offset+blocks_nx*block_size-1),...
        y_offset:(y_offset+blocks_ny*block_size-1));
    %avg_intensity=A1*cropped_intensity*B1/(block_size^2);
    fraction_fg_pixels_in_block=A1*double(cropped_intensity>cutoff_intensity)*B1/(block_size^2);
    % Blocks that are more than 50% foreground are considered foreground blocks
    foreground_blocks=find(fraction_fg_pixels_in_block>0.5);
    %foreground_blocks=find(avg_intensity>cutoff_intensity);
    
    % Save foreground block data
    number_of_blocks_used=min(number_of_blocks_per_image,length(foreground_blocks));
    if(number_of_blocks_used>0)
        selected_blocks=randsample(foreground_blocks,number_of_blocks_used);
        bx=zeros(number_of_blocks_used,1);%x-positions of blocks in cropped image
        by=zeros(number_of_blocks_used,1);%y-positions of blocks in cropped image
        for k=1:number_of_blocks_used
            [bx(k) by(k)]=ind2sub([blocks_nx,blocks_ny],selected_blocks(k));
            block_data_temp(:,:,:,block_counter+k)=...
                raw_data((bx(k)-1)*block_size+1:bx(k)*block_size,...
                (by(k)-1)*block_size+1:by(k)*block_size,:) ;
        end
    end
    
    %Update the block and pixel counts
    rgb_counter=rgb_counter+number_of_pixels_used;
    block_counter=block_counter+number_of_blocks_used;
end

% Use only the filled part of block and RGB data (since they were
% pre-allocated to max possible size)
block_data=block_data_temp(:,:,:,1:block_counter);
rgb_data=rgb_data_temp(1:rgb_counter,:);

%Perform k-means on the RGB data to identify reduced color set
[ids0,data.RGB_centroids]=kmeans(rgb_data,...
    number_of_RGB_clusters,'emptyaction','singleton','start','cluster');

% Used for 0th and First Order only
% data.RGB=mean(rgb_data);
% data.RGB_dist=rgb_data;
% data.RGB_weights=zeros(number_of_RGB_clusters,1);
% for k=1:number_of_RGB_clusters
%    data.RGB_weights(k)=sum(ids0==k)./length(ids0);
% end

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
        calculate_qcolor_fractions_in_block(block_data(:,:,:,k),centroids_temp,cutoff_intensity,include_bg);
end

%Perform k-means on the block profiles to identify block types
[ids1,data.block_centroids,~,distmat]=kmeans(data.block_weights,...
    number_of_block_clusters,'emptyaction','singleton','start','cluster');


% Pick out the blocks closest to centroids and store them as
% representatives
data.representative_blocks=zeros(number_of_block_clusters,block_size,block_size,number_of_channels,number_of_representative_blocks);
for cluster_counter=1:number_of_block_clusters
   [~,ids]=sort(distmat(:,cluster_counter));
   data.representative_blocks(cluster_counter,:,:,:,:)=block_data(:,:,:,ids(1:number_of_representative_blocks));
end


% Calculate frequencies of different block types in training data
% May be used for over-expression
% data.block_cluster_weights=zeros(number_of_block_clusters,1);
% for k=1:number_of_block_clusters
%     data.block_cluster_weights(k)=sum(ids1==k)/block_counter;
% end


end
