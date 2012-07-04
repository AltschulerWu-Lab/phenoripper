function [grouped_metadata,grouped_superblock_profiles,metadata_order,groups,...
    metadata_file_indices]=calculate_groups(group_index,metadata,...
    individual_superblock_profiles,individual_number_foreground_blocks,is_file_blacklisted)
%  CALCULATE_GROUPS calculate phenoripper profiles, metadata for specified groups of images
%    CALCULATE_GROUPS groups images with the same value of the 
%    GROUP_INDEXth field in METADATA (which contains metadata for each 
%    image) to produce averaged superblock profiles 
%    (GROUPED_SUPERBLOCK_PROFILES) and metadata (GROUPED_METADATA) for
%    each group of images. 
%    
%    calculate_groups arguments:
%    METADATA - an array of structs containing metadata for each image
%    GROUP_INDEX - an integer specifying which metadata field to use for grouping images
%    INDIVIDUAL_SUPERBLOCK_PROFILES - an array of superblock profiles calculated
%    by PhenoRipper for all the images (each row represents a different image)
%    INDIVIDUAL_NUMBER_FOREGROUND_BLOCKS - A vector containing the number of \
%    foreground blocks in each image. Profiles of images in the same group are
%    averaged with a weight proportional to the number of foreground blocks they
%    contain
%    IS_FILE_BLACKLISTED - a bool vector which is true for images that are
%    blacklisted and are not to be used for grouping calculation
%
%    calculate_groups output:
%    GROUPED_METADATA - an array (one lement per group) of structs containing 
%    %metadata for the different groups of images. If all images in the group
%    have the same value of a field in the original metadata, the grouped
%    metadata preserves this value. Otherwise it is replaced by a NaN.
%    GROUPED_SUPERBLOCK_PROFILES -  an array containing the (averaged)
%    superblock profiles for the different groups of images.
%    METADATA_ORDER - an array of integers have the same number of elements as
%    the original metadata. This specifies an ordering of the original metadata
%    where images in the same group are placed consecutively. Used primarily for
%    display of image grouping results.
%    GROUPS - an array of integers containing the group number of each image
%    (after they have been re-ordered using matadata_order). Primary use is for
%    display of image grouping results.
%    METADATA_FILE_INDICES - A cell array with as many elements as the number of
%    groups identified. Each element in the cell is a vector of integers
%    denoting the indexes of the images belonging to that group
% ------------------------------------------------------------------------------
% Copyright ??2012, The University of Texas Southwestern Medical Center 
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


  
number_of_files=length(metadata);
field_names=fieldnames(metadata{1});
file_class=cell(1,number_of_files);
for i=1:number_of_files
    file_class{i}=metadata{i}.(cell2mat(field_names(group_index+1)));
end
root_indices=find(ismember(file_class,''));
for i=1:length(root_indices)
    file_class{i}='root_directory'; %This is an ugly hack, fix it
end
blacklisted_files=find(is_file_blacklisted);
for i=1:length(blacklisted_files)
    file_class{blacklisted_files(i)}='';
end

[G,GN]=grp2idx(file_class);
number_of_groups=max(G);
grouped_metadata=cell(1,number_of_groups);
metadata_file_indices=cell(1,number_of_groups);
counter=1;
metadata_order=zeros(number_of_files,1);
groups=zeros(number_of_files,1);
grouped_superblock_profiles=zeros(number_of_groups,size(individual_superblock_profiles,2));
for group_number=1:number_of_groups
   %if(isempty(is_file_blacklisted)) 
    image_indices=find((G==group_number));
   %else
   % image_indices=find((G==group_number)&(~is_file_blacklisted));
   %end
   image_order=1:length(image_indices);
   %When this function is called from wizard_accept, superblock profiles
   %are not grouped
   if(~isempty(individual_superblock_profiles))
       grouped_superblock_profiles(group_number,:)=...
           nanmean(individual_superblock_profiles(image_indices,:)...
           .*repmat(individual_number_foreground_blocks(image_indices),...
           [1,size(individual_superblock_profiles,2)])...
           /(sum(individual_number_foreground_blocks(image_indices))/...
           nnz(individual_number_foreground_blocks(image_indices))),1);
       distmat=pdist2(grouped_superblock_profiles(group_number,:),...
           individual_superblock_profiles(image_indices,:));
       [~,image_order]=sort(distmat);
       
   end

   
   % Looping over the files in group to
   % 1) stores files belonging to group
   % 2) Reorders files by group so that files belonging to same group are
   % contiguous. Used only in the wizard_accept function for display purposes.
   % 3) groups: this contains the group number of each file. Used to
   % determine color in wizard_accept
   filenames=cell(length(image_indices),length(metadata{image_indices(1)}.FileNames));
   for i=1:length(image_indices)
       filenames(i,:)=metadata{image_indices(image_order(i))}.FileNames; %assigns files belonging to this group
       metadata_order(counter)=image_indices(image_order(i)); 
       groups(counter)=group_number;
       counter=counter+1;
   end
   metadata_file_indices{group_number}=image_indices(image_order);
   grouped_metadata{group_number}.files_in_group=filenames;
    
   for field_num=3:length(field_names)
       field_vals=cell(1,length(image_indices));
       for i=1:length(image_indices)
           field_vals{i}=metadata{image_indices(image_order(i))}.(cell2mat(field_names(field_num)));
       end
       [G1,GN1]=grp2idx(field_vals);
       if(max(G1)<=1)
           grouped_metadata{group_number}.(cell2mat(field_names(field_num)))=GN1(1);
       else
           grouped_metadata{group_number}.(cell2mat(field_names(field_num)))='';
       end
   end
   
   if(~isempty(individual_superblock_profiles))
        grouped_metadata{group_number}.Number_FG_Blocks=...
            mean(individual_number_foreground_blocks(image_indices));
   end
   
end







