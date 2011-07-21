function [grouped_metadata,grouped_superblock_profiles,metadata_order,groups,...
    metadata_file_indices]=CalculateGroups(group_index,metadata,...
    individual_superblock_profiles,individual_number_foreground_blocks,is_file_blacklisted)

  
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
           grouped_metadata{group_number}.(cell2mat(field_names(field_num)))=NaN;
       end
   end
   
   if(~isempty(individual_superblock_profiles))
        grouped_metadata{group_number}.Number_FG_Blocks=...
            mean(individual_number_foreground_blocks(image_indices));
   end
   
end







