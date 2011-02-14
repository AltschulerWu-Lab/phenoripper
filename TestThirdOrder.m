block_size=15;
cutoff_intensity=20000;
number_of_RGB_clusters=10;
number_of_block_clusters=10;
number_of_blocks_per_training_image=1000;
rgb_samples_per_training_image=3000;
number_of_block_representatives=3;
number_of_superblock_representatives=3;
number_of_superblocks=20;
number_of_channels=4;

%imageDirectory='/home/srajaram/Work/Code/WMD/ForPaper/GUI/TestImages/Test1/';
%imageDirectory='/home/z/My Paper Stuff/Images/Test';
%imageDirectory='/home/project/2009_04_Cancer/plates/110113_HCEC_BIO500_8drugs_6hr_Plate_2011009001/bgs_images/';
imageDirectory='/home/project/2009_04_Cancer/plates/110125_HCEC_WNT_timecourse_0_6h_Plate_2011009004/bgs_images/';


%% Global Setup

if(strcmp(imageDirectory(length(imageDirectory):end),filesep))
    imageDirectory=imageDirectory(1:length(imageDirectory)-1);
end
dir_list=dir(imageDirectory);
subdirs={dir_list([(dir_list(:).isdir)]).name};
subdirs=subdirs(3:end);
global_filenames=cell(length(subdirs),number_of_channels);

for subdir_num=1:length(subdirs)
    dir_name=[imageDirectory filesep subdirs{subdir_num} filesep];
    
    dir_list=dir(dir_name);
    file_list={dir_list(~[(dir_list(:).isdir)]).name};
    imagenames=cell(0);
    
    for i=1:length(file_list)
        tokens=regexp(cell2mat(file_list(i)),'-','split');
        imagenames(i)=tokens(1);
    end
    imagenames=unique(imagenames);
    
    filenames=cell(length(imagenames),number_of_channels);
    for image_number=1:length(imagenames)
        for channel=1:number_of_channels
            filenames{image_number,channel}=...
                [dir_name imagenames{image_number} '-' num2str(channel) '.png'];
        end
    end
    
    file_num=randi(size(filenames,1));%Pick Random File
    for channel=1:number_of_channels
        global_filenames{subdir_num,channel}=filenames{file_num,channel}; %Change this to a randomly selected file
    end
  
    
end

global_data=wmd_read_data_simple(global_filenames,block_size,...
    cutoff_intensity,number_of_RGB_clusters,number_of_block_clusters,...
    number_of_blocks_per_training_image,...
    rgb_samples_per_training_image,number_of_block_representatives);


%% Third Order
third_order=ThirdOrder_Basis(global_filenames,global_data,number_of_superblocks);
global_data.superblock_centroids=third_order.superblock_centroids;
global_data.representative_neighborhoods=cell(number_of_block_clusters,number_of_superblock_representatives);


% figure;
% subplot(1,2,1);
% img=double(imread(filenames{image_number}));
% image(img./256);
% axis off;axis square;
% subplot(1,2,2);
% imagesc(results.image_in_discrete_block_states)
% axis off;axis square;
%img1=results.image_in_discrete_block_states;

figure;
counter=1;
lx=[1*block_size+1,2*block_size,2*block_size,2*block_size,2*block_size,1*block_size+1,1*block_size+1,1*block_size+1];
ly=[1*block_size+1,1*block_size+1,1*block_size+1,2*block_size,2*block_size,2*block_size,2*block_size,1*block_size+1];
max_val=2000;
for i=1:number_of_superblocks/2
    for j=1:number_of_superblock_representatives
        subplot(number_of_superblocks/2,number_of_superblock_representatives,counter);
        image(tanh(third_order.superblock_representatives{i,j}/max_val));
        line(lx,ly,'Color','y');
        axis off;axis equal;
        counter=counter+1;
    end
end
figure;
counter=1;
for i=number_of_superblocks/2+1:number_of_superblocks
    for j=1:number_of_superblock_representatives
        subplot(number_of_superblocks/2,number_of_superblock_representatives,counter);
        image(tanh(third_order.superblock_representatives{i,j}/max_val));
        line(lx,ly,'Color','y');
        axis off;axis equal;
        counter=counter+1;
    end
end

%Assuming number of blocks and superblocks are the same
% for i=1:number_of_superblocks
%     k=find(global_data.superblock_centroids(:,i)>0,1);
%     for j=1:number_of_superblock_representatives
%         global_data.representative_neighborhoods{i,j}=third_order.superblock_representatives{k,j};
%     end
% end
% figure;
% lx=[1*block_size+1,2*block_size,2*block_size,2*block_size,2*block_size,1*block_size+1,1*block_size+1,1*block_size+1];
% ly=[1*block_size+1,1*block_size+1,1*block_size+1,2*block_size,2*block_size,2*block_size,2*block_size,1*block_size+1];
% counter=1;
% for i=1:number_of_block_clusters
%     for j=1:number_of_block_representatives
%         subplot(number_of_block_clusters,number_of_superblock_representatives+number_of_block_representatives,counter);
%         image(squeeze(global_data.representative_blocks(i,:,:,:,j))/256);
%         axis off;axis equal;
%         counter=counter+1;
%     end
%     for j=1:number_of_superblock_representatives
%         subplot(number_of_block_clusters,number_of_superblock_representatives+number_of_block_representatives,counter);
%         image(global_data.representative_neighborhoods{i,j}/256);
%         line(lx,ly,'Color','y');
%         axis off;axis equal;
%         counter=counter+1;
%     end
% end



%% Second Order 
dir_list=dir(imageDirectory);
subdirs={dir_list([(dir_list(:).isdir)]).name};
subdirs=subdirs(3:end);
block_profiles=zeros(length(subdirs),number_of_block_clusters);
superblock_profiles=zeros(length(subdirs),number_of_superblocks);
for subdir_num=1:length(subdirs)
    dir_name=[imageDirectory filesep subdirs{subdir_num} filesep];
    
    dir_list=dir(dir_name);
    file_list={dir_list(~[(dir_list(:).isdir)]).name};
    imagenames=cell(0);
    
    for i=1:length(file_list)
        tokens=regexp(cell2mat(file_list(i)),'-','split');
        imagenames(i)=tokens(1);
    end
    imagenames=unique(imagenames);
    
    filenames=cell(length(imagenames),number_of_channels);
    for image_number=1:length(imagenames)
        for channel=1:number_of_channels
            filenames{image_number,channel}=...
                [dir_name imagenames{image_number} '-' num2str(channel) '.png'];
        end
    end
    
    results=SecondOrder_std(filenames,global_data);
    block_profiles(subdir_num,:)=results.block_profile;
    superblock_profiles(subdir_num,:)=results.superblock_profile;
end




