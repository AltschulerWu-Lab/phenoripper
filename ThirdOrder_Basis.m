function data=ThirdOrder_Basis(filenames,global_data,number_of_superblocks,marker_scales,include_bg)
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
superblock_counter=0;
foreground_blocks_per_image=zeros(number_of_repeats,1);
foreground_blocks_temp=zeros(blocks_nx*blocks_ny*number_of_repeats,1);
image_number_of_block_temp=zeros(blocks_nx*blocks_ny*number_of_repeats,1);
position_of_block_temp=zeros(blocks_nx*blocks_ny*number_of_repeats,2);
neighbor_profiles_temp=zeros(blocks_nx*blocks_ny*number_of_repeats,number_of_block_clusters+1);

for image_counter=1:number_of_repeats
    %disp(['Reading Image ' num2str(image_counter) '....']);
    %img=zeros(xres,yres,number_of_channels);
    
       
    if(channels_per_file>1)
        img=Read_and_Scale_Image(filenames(image_counter),marker_scales); 
    else
        img=Read_and_Scale_Image(filenames(image_counter,:),marker_scales); 
    end
    
    %toc;
    
    cropped_image=img(x_offset:(x_offset+blocks_nx*block_size-1),...
        y_offset:(y_offset+blocks_ny*block_size-1),1:number_of_channels);
    
    %tic;
    intensity=sqrt(sum(double(cropped_image).^2,3)/number_of_channels);
    is.foreground=(intensity>cutoff_intensity);
    number_of_foreground_points=sum(sum(is.foreground));
    RGB_distmat=zeros(number_of_foreground_points,number_of_RGB_clusters);
    foreground_points=zeros(number_of_foreground_points,number_of_channels);
    for channel_counter=1:number_of_channels
        temp=squeeze(cropped_image(:,:,channel_counter));
        foreground_points(:,channel_counter)=temp(intensity>cutoff_intensity);
    end
    for rgb_cluster=1:number_of_RGB_clusters
        rgb_mat=ones(size(foreground_points,1),number_of_channels);
        for i=1:number_of_channels
            rgb_mat(:,i)=rgb_mat(:,i).*global_data.RGB_centroids(rgb_cluster,i);
        end
        RGB_distmat(:,rgb_cluster)=sum((foreground_points-rgb_mat).^2,2);
    end
    [~,foreground_pixel_states]=min(RGB_distmat,[],2);
    image_in_discrete_pixel_states=zeros(block_size*blocks_nx,block_size*blocks_ny);
    image_in_discrete_pixel_states(is.foreground)=foreground_pixel_states;
    %toc;
    
    %avg_block_intensities=A1*intensity*B1/(block_size^2);
    fraction_fg_pixels_in_block=A1*double(intensity>cutoff_intensity)*B1/(block_size^2);
    %foreground_blocks=find(avg_block_intensities>cutoff_intensity);
    foreground_blocks=find(fraction_fg_pixels_in_block>0.5);
    RGBprofiles_of_blocks=zeros(length(foreground_blocks),number_of_RGB_clusters+1);
    
    if(include_bg)
        start_cluster=0;
    else
        start_cluster=1;
    end
    %for rgb_cluster=0:number_of_RGB_clusters
    for rgb_cluster=start_cluster:number_of_RGB_clusters
        temp=A1*(double(image_in_discrete_pixel_states==rgb_cluster))*B1/(block_size^2);
        RGBprofiles_of_blocks(:,rgb_cluster+1)=temp(foreground_blocks);
    end
    rescale_factor=sum(RGBprofiles_of_blocks,2);
    for i=1:length(foreground_blocks)
       RGBprofiles_of_blocks(i,:)=RGBprofiles_of_blocks(i,:)/rescale_factor(i);
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
    h=[1 1 1;1 1 1; 1 1 1];
%filtered=imfilter(double(img),h);
    neighbor_profiles_in_image=zeros(length(foreground_blocks),number_of_block_clusters+1);
    
    for i=0:number_of_block_clusters
        temp=imfilter(double(image_in_discrete_block_states==i),h);
        neighbor_profiles_in_image(:,i+1)=temp(foreground_blocks)/9;
       
    end
    sb_image=false(blocks_nx,blocks_ny);
    sb_image(foreground_blocks)=true;
    sb_image(1,:)=false;sb_image(:,1)=false;
    sb_image(end,:)=false;sb_image(:,end)=false;
    is_foreground_sb=sb_image(foreground_blocks);
    if(~include_bg)
        is_foreground_sb=(is_foreground_sb&neighbor_profiles_in_image(:,1)==0);
    end
    foreground_superblocks=find(is_foreground_sb);
    
    
    data.image_in_discrete_block_states=image_in_discrete_block_states;
    
    
    foreground_blocks_per_image(image_counter)=length(foreground_superblocks);
    block_ids_temp(block_counter+1:block_counter+length(foreground_blocks))=block_ids_in_image;
    foreground_blocks_temp(block_counter+1:block_counter+length(foreground_blocks))=foreground_blocks;
    neighbor_profiles_temp(superblock_counter+1:superblock_counter+length(foreground_superblocks),:)=neighbor_profiles_in_image(foreground_superblocks,:);
    
    image_number_of_block_temp(superblock_counter+1:superblock_counter+length(foreground_superblocks))=image_counter;
    [x_pos,y_pos]=find(fraction_fg_pixels_in_block>0.5);%repeated operation,can be speeded up
    %[x_pos,y_pos]=find(avg_block_intensities>cutoff_intensity);%repeated operation,can be speeded up
    x_pos=x_pos(is_foreground_sb);
    y_pos=y_pos(is_foreground_sb);
    
    position_of_block_temp(superblock_counter+1:superblock_counter+length(foreground_superblocks),:)=...
        [(x_pos'-1)*block_size+x_offset;(y_pos'-1)*block_size+y_offset]';
    
    block_counter=block_counter+length(foreground_blocks);
    superblock_counter=superblock_counter+length(foreground_superblocks);
    %disp('done!');
end


block_ids=block_ids_temp(1:block_counter);
image_number_of_block=image_number_of_block_temp(1:superblock_counter);
position_of_block=position_of_block_temp(1:superblock_counter,:);

%neighbor_profiles=zeros(block_counter,number_of_block_clusters+1);
neighbor_profiles=neighbor_profiles_temp(1:superblock_counter,:);
%sb_without_bg=neighbor_profiles(:,1)==0;
%neighbor_profiles=neighbor_profiles(sb_without_bg,:);
mean_superblock_profile=mean(neighbor_profiles);
data.mean_superblock_profile=mean_superblock_profile;
%for i=1:block_counter
%        neighbor_profiles(i,:)=log(neighbor_profiles(i,:)./mean_superblock_profile);
%end
%for i=1:block_counter
%   neighbor_profiles(i,block_ids(i))=1000;
%end

[superblock_ids,data.superblock_centroids,~,superblock_distances]=kmeans(neighbor_profiles,number_of_superblocks...
    ,'emptyaction','singleton','start','cluster');
data.block_profile=zeros(number_of_block_clusters,1);
for block_cluster=1:number_of_block_clusters
   data.block_profile(block_cluster)=sum(block_ids==block_cluster)/length(block_ids);
end

superblock_profiles=zeros(number_of_repeats,number_of_superblocks);
for image_number=1:number_of_repeats
    ids_in_image=superblock_ids(image_number_of_block==image_number);
    for sb_num=1:number_of_superblocks
        superblock_profiles(image_number,sb_num)=nnz(ids_in_image==sb_num);
    end
    superblock_profiles(image_number,:)=superblock_profiles(image_number,:)/...
        sum(superblock_profiles(image_number,:));
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

% for i=1:number_of_superblocks
%   distance_cutoffs(i)=max(mink(superblock_distances(:,i),number_of_superblock_representatives));
%    
%    acceptable_blocks=find(superblock_distances(:,i)<=distance_cutoffs(i));
%    for j=1:length(acceptable_blocks)
%        block_num=acceptable_blocks(j);
%        FvB(image_number_of_block(block_num),i)=FvB(image_number_of_block(block_num),i)+1;
%        locations{image_number_of_block(block_num),i}=[locations{image_number_of_block(block_num),i};...
%            position_of_block(block_num,:)];
%    end
% end

position_in_blocks=position_of_block; %change units from pixels to blocks
position_in_blocks(:,1)=(position_in_blocks(:,1)-x_offset)/block_size+1;
position_in_blocks(:,2)=(position_in_blocks(:,1)-y_offset)/block_size+1;
is_not_edge=(position_in_blocks(:,1)>2)&(position_in_blocks(:,2)>2)...
        &(position_in_blocks(:,1)<blocks_nx-3)&(position_in_blocks(:,2)<blocks_ny-3);
for i=1:number_of_superblocks
    % blocks_of_type=find(superblock_ids==i);
    
    
    distance_cutoffs(i)=max(prctile(superblock_distances((superblock_ids==i)&is_not_edge,i),10),...
        max(mink(superblock_distances(is_not_edge,i),number_of_superblock_representatives)));
    acceptable_blocks=find((superblock_distances(:,i)<=distance_cutoffs(i))&(superblock_ids==i)&is_not_edge);
    
    [~,image_order]=sort(superblock_profiles(:,i),'descend');
    rep_count=0;
    image_count=1;
    while((rep_count<number_of_superblock_representatives)&&(image_counter<=number_of_repeats))
        image_number=image_order(image_count);
        selected_blocks=acceptable_blocks(image_number_of_block(acceptable_blocks)==image_number);
        needed_length=min(number_of_superblock_representatives-rep_count,length(selected_blocks));
        selected_blocks=selected_blocks(1:needed_length);
        for j=1:length(selected_blocks)
            block_num=selected_blocks(j);
            locations{image_number,i}=[locations{image_number,i};...
                position_of_block(block_num,:)];
            
        end
        rep_count=rep_count+length(selected_blocks);
        image_count=image_count+1;
    end
end

%included_files=find(bintprog(ones(number_of_repeats,1),-FvB',-number_of_superblock_representatives*ones(number_of_superblocks,1))>0.5);
included_files=1:number_of_repeats;
superblock_representatives=cell(number_of_superblocks,number_of_superblock_representatives);

supr_counter=zeros(number_of_superblocks,1);
for file_num=1:length(included_files)
    if(any(~cellfun('isempty',locations(file_num,:))))
        img=zeros(xres,yres,number_of_channels);
        
        
        if(channels_per_file>1)
            %img=double(imread(cell2mat(filenames(image_counter))));
            img=imread(cell2mat(filenames(included_files(file_num),1)));
        else
            for channel=1:number_of_channels
                %img(:,:,channel_counter)=imread(cell2mat(filenames(image_counter,channel_counter)));
                img(:,:,channel)=imread(cell2mat(filenames(included_files(file_num),channel)));
            end
        end
        
        %     for channel=1:number_of_channels
        %        img(:,:,channel)=imread(cell2mat(filenames(included_files(file_num),channel)));
        %
        %     end
        for i=1:number_of_superblocks
            number_of_matches=size(locations{included_files(file_num),i},1);
            if(number_of_matches>0)
                location_info=locations{included_files(file_num),i};
                for j=1:min(number_of_matches,number_of_superblock_representatives-supr_counter(i))
                    %rep_img=zeros(3*block_size,3*block_size,number_of_channels);
                    x1=max(location_info(j,1)-3*block_size,1);
                    x2=min(location_info(j,1)+4*block_size-1,xres);
                    y1=max(location_info(j,2)-3*block_size,1);
                    y2=min(location_info(j,2)+4*block_size-1,yres);
                    supr_counter(i)=supr_counter(i)+1;
                    superblock_representatives{i,supr_counter(i)}=img(x1:x2,y1:y2,:);
                    
                end
            end
            %disp('meow');
        end
    end
end

data.superblock_representatives=superblock_representatives;

end

