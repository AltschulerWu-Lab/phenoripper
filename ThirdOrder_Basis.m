function data=ThirdOrder_Basis(filenames,global_data,number_of_superblocks)
%% Preprocessing
block_size=global_data.block_size;
cutoff_intensity=global_data.cutoff_intensity;
number_of_RGB_clusters=global_data.number_of_RGB_clusters;
number_of_block_clusters=global_data.number_of_block_clusters;

number_of_superblock_representatives=3;

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
foreground_blocks_per_image=zeros(number_of_repeats,1);
foreground_blocks_temp=zeros(blocks_nx*blocks_ny*number_of_repeats,1);
image_number_of_block_temp=zeros(blocks_nx*blocks_ny*number_of_repeats,1);
position_of_block_temp=zeros(blocks_nx*blocks_ny*number_of_repeats,2);
neighbor_profiles_temp=zeros(blocks_nx*blocks_ny*number_of_repeats,number_of_block_clusters+1);

for image_counter=1:number_of_repeats
    %disp(['Reading Image ' num2str(image_counter) '....']);
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
    for rgb_cluster=1:number_of_RGB_clusters
        rgb_mat=ones(length(foreground_points),number_of_channels);
        for i=1:number_of_channels
            rgb_mat(:,i)=rgb_mat(:,i).*global_data.RGB_centroids(rgb_cluster,i);
        end
        RGB_distmat(:,rgb_cluster)=sum((foreground_points-rgb_mat).^2,2);
    end
    [~,foreground_pixel_states]=min(RGB_distmat,[],2);
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
    
    %h=fspecial('gaussian',2,1);
    h=[1 1 1;1 0 1; 1 1 1];
%filtered=imfilter(double(img),h);
    neighbor_profiles_in_image=zeros(length(foreground_blocks),number_of_block_clusters+1);
    
    for i=0:number_of_block_clusters
        temp=imfilter(double(image_in_discrete_block_states==i),h);
        neighbor_profiles_in_image(:,i+1)=temp(foreground_blocks)/8;
       
    end
    
    
    data.image_in_discrete_block_states=image_in_discrete_block_states;
    
    
    foreground_blocks_per_image(image_counter)=length(foreground_blocks);
    block_ids_temp(block_counter+1:block_counter+length(foreground_blocks))=block_ids_in_image;
    foreground_blocks_temp(block_counter+1:block_counter+length(foreground_blocks))=foreground_blocks;
    neighbor_profiles_temp(block_counter+1:block_counter+length(foreground_blocks),:)=neighbor_profiles_in_image;
    image_number_of_block_temp(block_counter+1:block_counter+length(foreground_blocks))=image_counter;
    [x_pos,y_pos]=find(avg_block_intensities>cutoff_intensity);%repeated operation,can be speeded up
    position_of_block_temp(block_counter+1:block_counter+length(foreground_blocks),:)=...
        [(x_pos'-1)*block_size+x_offset;(y_pos'-1)*block_size+y_offset]';
    
    block_counter=block_counter+length(foreground_blocks);
    %disp('done!');
end


block_ids=block_ids_temp(1:block_counter);
image_number_of_block=image_number_of_block_temp(1:block_counter);
position_of_block=position_of_block_temp(1:block_counter,:);

neighbor_profiles=zeros(block_counter,2*number_of_block_clusters+1);
neighbor_profiles(:,number_of_block_clusters+1:end)=neighbor_profiles_temp(1:block_counter,:);
for i=1:block_counter
   neighbor_profiles(i,block_ids(i))=1000;
end

[~,data.superblock_centroids,~,superblock_distances]=kmeans(neighbor_profiles,number_of_superblocks...
    ,'emptyaction','singleton','start','cluster');
data.block_profile=zeros(number_of_block_clusters,1);
for block_cluster=1:number_of_block_clusters
   data.block_profile(block_cluster)=sum(block_ids==block_cluster)/length(block_ids);
end



%Picking representatives
% 1) For each block store filenumber and (x,y) location (remember cropping)
% 

% Optimal File Opening Steps:
% 1) Identify blocks within acceptable range of top and determine image and location
% 2) Create a FileVsBlockType matrix containing number of acceptable representatives for each superblock per file
% 3) If i is the indicator function to include a file, then minimize sum(i) such that i.*f(:,j)>number_of_reps for each j
% 4) Since all files will need to be opened, just go in order and load up all possible reps per file
distance_cutoffs=zeros(number_of_superblocks,1);
FvB=zeros(number_of_repeats,number_of_superblocks);
locations=cell(number_of_repeats,number_of_superblocks);

for i=1:number_of_superblocks
  distance_cutoffs(i)=max(mink(superblock_distances(:,i),number_of_superblock_representatives));
   
   acceptable_blocks=find(superblock_distances(:,i)<=distance_cutoffs(i));
   for j=1:length(acceptable_blocks)
       block_num=acceptable_blocks(j);
       FvB(image_number_of_block(block_num),i)=FvB(image_number_of_block(block_num),i)+1;
       locations{image_number_of_block(block_num),i}=[locations{image_number_of_block(block_num),i};...
           position_of_block(block_num,:)];
   end
end

included_files=find(bintprog(ones(number_of_repeats,1),-FvB',-number_of_superblock_representatives*ones(number_of_superblocks,1))>0.5);
%included_files=1:number_of_repeats;
superblock_representatives=cell(number_of_superblocks,number_of_superblock_representatives);

supr_counter=zeros(number_of_superblocks,1);
for file_num=1:length(included_files)
    img=zeros(xres,yres,number_of_channels);
    for channel=1:number_of_channels
       img(:,:,channel)=imread(cell2mat(filenames(included_files(file_num),channel)));
       
    end
    for i=1:number_of_superblocks
        number_of_matches=size(locations{included_files(file_num),i},1);
        if(number_of_matches>0)
            location_info=locations{included_files(file_num),i};
            for j=1:min(number_of_matches,number_of_superblock_representatives-supr_counter(i))
                %rep_img=zeros(3*block_size,3*block_size,number_of_channels);
                x1=max(location_info(j,1)-block_size,1);
                x2=min(location_info(j,1)+2*block_size-1,xres);
                y1=max(location_info(j,2)-block_size,1);
                y2=min(location_info(j,2)+2*block_size-1,yres);
                supr_counter(i)=supr_counter(i)+1;
                superblock_representatives{i,supr_counter(i)}=img(x1:x2,y1:y2,:);
                
            end
        end
     %disp('meow');       
              
    end
end

data.superblock_representatives=superblock_representatives;

end

