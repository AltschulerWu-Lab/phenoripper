function data=SecondOrder(filenames,global_data)
%% Preprocessing
block_size=global_data.block_size;
cutoff_intensity=global_data.cutoff_intensity;
number_of_RGB_clusters=global_data.number_of_RGB_clusters;
number_of_block_clusters=global_data.number_of_block_clusters;
number_of_superblocks=size(global_data.superblock_centroids,1);


[number_of_repeats,number_of_channels]=size(filenames);
%tic;
test=imfinfo(cell2mat(filenames(1,1)));
xres=test.Height;
yres=test.Width;
%channels_per_file=size(test,3);
if(strcmp(test.ColorType,'grayscale'))
    channels_per_file=1;
else
    channels_per_file=3;
end
number_of_channels=max(number_of_channels,channels_per_file);

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



%% Reading Images

block_ids_temp=zeros(blocks_nx*blocks_ny*number_of_repeats,1);
block_counter=0;
superblock_counter=0;
foreground_blocks_per_image=zeros(number_of_repeats,1);
foreground_blocks_temp=zeros(blocks_nx*blocks_ny*number_of_repeats,1);
neighbor_profiles_temp=zeros(blocks_nx*blocks_ny*number_of_repeats,number_of_block_clusters+1);

%if(exist('myhandles','var'));
myhandles=getappdata(0,'myhandles');
if(~isempty(myhandles))
        progress= get(myhandles.statusbarHandles.ProgressBar, 'Value');
end
tStart1=tic; 
%end
for image_counter=1:number_of_repeats
   % disp(['Reading Image ' num2str(image_counter) '....']);
    img=zeros(xres,yres,number_of_channels);
    
    if(channels_per_file>1)
        img=double(imread(cell2mat(filenames(image_counter))));
    else
        for channel_counter=1:number_of_channels
            img(:,:,channel_counter)=imread(cell2mat(filenames(image_counter,channel_counter)));
        end
    end
    %toc;
    
    cropped_image=img(x_offset:(x_offset+blocks_nx*block_size-1),...
        y_offset:(y_offset+blocks_ny*block_size-1),1:number_of_channels);
    
    %tic;
    intensity=sum(double(cropped_image).^2,3);
    is.foreground=(intensity>cutoff_intensity);
    number_of_foreground_points=sum(sum(is.foreground));
    RGB_distmat=zeros(number_of_foreground_points,number_of_RGB_clusters);
    foreground_points=zeros(number_of_foreground_points,number_of_channels);
    for channel_counter=1:number_of_channels
        temp=squeeze(cropped_image(:,:,channel_counter));
        foreground_points(:,channel_counter)=temp(intensity>cutoff_intensity);
    end
    RGB_centroids=global_data.RGB_centroids;
    for rgb_cluster=1:number_of_RGB_clusters
        rgb_mat=ones(size(foreground_points,1),number_of_channels);
        for i=1:number_of_channels
            rgb_mat(:,i)=rgb_mat(:,i).*RGB_centroids(rgb_cluster,i);
        end
        RGB_distmat(:,rgb_cluster)=sum((foreground_points-rgb_mat).^2,2);
    end
    [~,foreground_pixel_states]=min(RGB_distmat,[],2);
    %foreground_pixel_states=nearestNeighbor(global_data.detri,foreground_points(:,1),foreground_points(:,2),foreground_points(:,3));
    image_in_discrete_pixel_states=zeros(block_size*blocks_nx,block_size*blocks_ny);
    image_in_discrete_pixel_states(is.foreground)=foreground_pixel_states;
    %toc;
    
    avg_block_intensities=A1*intensity*B1/(block_size^2);
    foreground_blocks=find(avg_block_intensities>cutoff_intensity);
    RGBprofiles_of_blocks=zeros(length(foreground_blocks),number_of_RGB_clusters+1);
    
    
    
    for rgb_cluster=0:number_of_RGB_clusters
        temp=A1*(double(image_in_discrete_pixel_states==rgb_cluster))*B1/(block_size^2);
        
        RGBprofiles_of_blocks(:,rgb_cluster+1)=temp(foreground_blocks);
    end
    
    block_distmat=zeros(length(foreground_blocks),number_of_block_clusters);
    for block_cluster=1:number_of_block_clusters
        temp=repmat(global_data.block_centroids(block_cluster,:),length(foreground_blocks),1);
        block_distmat(:,block_cluster) =sum((RGBprofiles_of_blocks-temp).^2,2);
    end
    [~,block_ids_in_image]=min(block_distmat,[],2);
    image_in_discrete_block_states=zeros(blocks_nx,blocks_ny);
    image_in_discrete_block_states(foreground_blocks)=block_ids_in_image;
    
    
     h=[1 1 1;1 1 1; 1 1 1];
%filtered=imfilter(double(img),h);
    neighbor_profiles_in_image=zeros(length(foreground_blocks),number_of_block_clusters+1);
    
    for i=0:number_of_block_clusters
        temp=imfilter(double(image_in_discrete_block_states==i),h);
        neighbor_profiles_in_image(:,i+1)=temp(foreground_blocks)/9;
       
    end
    foreground_superblocks=find(neighbor_profiles_in_image(:,1)==0);
    neighbor_profiles_temp(superblock_counter+1:superblock_counter+length(foreground_superblocks),:)=neighbor_profiles_in_image(foreground_superblocks,:);
    
    
    
    data.image_in_discrete_block_states=image_in_discrete_block_states;
    
    
    foreground_blocks_per_image(image_counter)=length(foreground_superblocks);
    block_ids_temp(block_counter+1:block_counter+length(foreground_blocks))=block_ids_in_image;
    foreground_blocks_temp(block_counter+1:block_counter+length(foreground_blocks))=foreground_blocks;
    
    block_counter=block_counter+length(foreground_blocks);
    superblock_counter=superblock_counter+length(foreground_superblocks);
  
   
if(~isempty(myhandles))
%   if(exist('myhandles','var'))  
    progress=progress+1;
    tElapsed1=toc(tStart1); 
    tElapsed=myhandles.tElapsed+tElapsed1;
    %disp([num2str(myhandles.tElapsed),' ',num2str(tElapsed1),' ',num2str(tElapsed)]);
    
    files_analyzed=myhandles.files_analyzed+image_counter;
    %disp([num2str(myhandles.files_analyzed) ' ' num2str(image_counter),'
    %',num2str(myhandles.number_of_files)]);
    time_left=(myhandles.number_of_files-files_analyzed)*tElapsed/(files_analyzed);
    set(myhandles.statusbarHandles.ProgressBar,...
        'Value',progress,'StringPainted','on', 'string',FormatTime(time_left));
    %setappdata(0,'myhandles',myhandles);
    %disp('done!');
 %   end
end
end



block_ids=block_ids_temp(1:block_counter);

%neighbor_profiles=zeros(block_counter,2*number_of_block_clusters+1);
data.number_of_foreground_blocks=block_counter;
neighbor_profiles=neighbor_profiles_temp(1:superblock_counter,:);

%for i=1:block_counter
%        neighbor_profiles(i,:)=log(neighbor_profiles(i,:)./global_data.mean_superblock_profile);
%end

%for i=1:block_counter
%   neighbor_profiles(i,block_ids(i))=1;
%end

superblock_distmat=zeros(superblock_counter,number_of_superblocks);
    for superblock_cluster=1:number_of_superblocks
        temp=repmat(global_data.superblock_centroids(superblock_cluster,:),superblock_counter,1);
        superblock_distmat(:,superblock_cluster) =sum((neighbor_profiles-temp).^2,2);
    end
[distances,superblock_ids]=min(superblock_distmat,[],2);

image_superblock_states=zeros(blocks_nx,blocks_ny);
%image_superblock_states(foreground_superblocks)=superblock_ids;
data.image_superblock_states=image_superblock_states;
data.distance_to_superblock_centroid=zeros(blocks_nx,blocks_ny);
data.distance_to_superblock_centroid(foreground_superblocks)=distances;

data.block_profile=zeros(number_of_block_clusters,1);
for block_cluster=1:number_of_block_clusters
   data.block_profile(block_cluster)=sum(block_ids==block_cluster)/length(block_ids);
end

data.superblock_profile=zeros(number_of_superblocks,1);
for superblock_cluster=1:number_of_superblocks
   data.superblock_profile(superblock_cluster)=sum(superblock_ids==superblock_cluster)/length(superblock_ids);
end



end

