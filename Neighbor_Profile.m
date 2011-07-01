function neighbor_profile=Neighbor_Profile(img_states,number_of_states)

reduced_size=(size(img_states,1)-1)*(size(img_states,2)-1);

remapped_img=imfilter(img_states,[0 0;0 1]);
remapped_img=remapped_img(1:end-2,1:end-2);

%profile_matrix=sparse(reduced_size,(number_of_states+1)^2);
profile_matrix=zeros(reduced_size,(number_of_states+1)^2);


index_matrix=zeros(reduced_size,2);
index_matrix(:,1)=1:reduced_size;

h1=[number_of_states,1;0 0];
h2=[number_of_states,0;1 0];
h3=[number_of_states,0;0 1];

A1=imfilter(img_states,h1);
A1r=A1(1:end-1,1:end-1);
index_matrix(:,2)=A1r(:)+1;
indices=sub2ind(size(profile_matrix),index_matrix(:,1),index_matrix(:,2));
profile_matrix(indices)=profile_matrix(indices)+1;

A1=imfilter(img_states,h2);
A1r=A1(1:end-1,1:end-1);
index_matrix(:,2)=A1r(:)+1;
indices=sub2ind(size(profile_matrix),index_matrix(:,1),index_matrix(:,2));
profile_matrix(indices)=profile_matrix(indices)+1;

A1=imfilter(img_states,h3);
A1r=A1(1:end-1,1:end-1);
index_matrix(:,2)=A1r(:)+1;
indices=sub2ind(size(profile_matrix),index_matrix(:,1),index_matrix(:,2));
profile_matrix(indices)=profile_matrix(indices)+1;

h1=[1,number_of_states;0 0];
h2=[1,0;number_of_states 0];
h3=[1,0;0 number_of_states];

A1=imfilter(img_states,h1);
A1r=A1(1:end-1,1:end-1);
index_matrix(:,2)=A1r(:)+1;
indices=sub2ind(size(profile_matrix),index_matrix(:,1),index_matrix(:,2));
profile_matrix(indices)=profile_matrix(indices)+1;

A1=imfilter(img_states,h2);
A1r=A1(1:end-1,1:end-1);
index_matrix(:,2)=A1r(:)+1;
indices=sub2ind(size(profile_matrix),index_matrix(:,1),index_matrix(:,2));
profile_matrix(indices)=profile_matrix(indices)+1;

A1=imfilter(img_states,h3);
A1r=A1(1:end-1,1:end-1);
index_matrix(:,2)=A1r(:)+1;
indices=sub2ind(size(profile_matrix),index_matrix(:,1),index_matrix(:,2));
profile_matrix(indices)=profile_matrix(indices)+1;

neighbor_profile=reshape(profile_matrix,size(img_states,1)-1,size(img_states,2)-1,(number_of_states+1)^2);
neighbor_profile=imfilter(neighbor_profile,[1 1;1 1]);
foreground_blocks=remapped_img(:)>0;
neighbor_profile=reshape(neighbor_profile(1:end-1,1:end-1,:),(size(img_states,1)-2)*(size(img_states,2)-2),(number_of_states+1)^2);
neighbor_profile=neighbor_profile(foreground_blocks,:);
% A2=imfilter(img_states,h2);
% A3=imfilter(img_states,h3);
end