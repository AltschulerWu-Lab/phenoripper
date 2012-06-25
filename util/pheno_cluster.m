function positions=pheno_cluster(data,representatives,row_labels,row_bg_colors,...
    marker_scales,display_colors,sb_marker_profiles,block_size,sb_ordering_score,use_sb_dendrogram)
number_of_representatives=length(representatives);
number_of_data_points=size(data,1);


if(size(data,2)~=number_of_representatives)
   error('Incorrect Number Of Representatives'); 
end
figure_handle=figure('Name','PhenoRipper Clustergram');
%cmap1=colormap(figure_handle,'Bone');%Working only for Mtlab 2011
cmap1=black_white_colormap(0.3,0.35);
%cmap1=colormap('Bone');
cmap2=color_names_to_colormap(display_colors);
cmap=[cmap1;cmap2];
data(isnan(data))=0;
Y = pdist(data);
Z = linkage(Y,'average');
optimal_order1=optimalleaforder(Z,Y);
[~,~,perm1] = dendrogram(Z,0,'orientation','left','reorder',optimal_order1);
data1=data';
% for i=1:size(data1,1)
%    data1(i,:)=data1(i,:)/sum(data1(i,:)); 
% end


if(use_sb_dendrogram)
    Y1 = pdist(data1);
    Z1 = linkage(Y1,'average');
    if(isempty(sb_ordering_score))
        optimal_order2=optimalleaforder(Z1,Y1);
    else
        optimal_order2=dendrogram_reorder(Z1,sb_ordering_score);
    end
    [~,~,perm2] = dendrogram(Z1,0,'orientation','bottom','reorder',optimal_order2);
else
    [~,perm2]=sort(sb_ordering_score);
end
%perm3=fliplr(perm2);
temp1=data(perm1,:)';
temp2=flipud(temp1(perm2,:)');
%temp2=fliplr(flipud(temp1(perm2,:)'));
himg=gca;
imagesc(temp2);


axis off;
scale_factor=0.9;
if(number_of_representatives<10)
  scale_factor=0.2;
end
XLims=get(gca,'XLim');
YLims=get(gca,'YLim');
x_positions=linspace(1,number_of_representatives,number_of_representatives)-scale_factor/2;
y_positions=(number_of_data_points+0.5)*ones(number_of_representatives,1);
y_positions1=(number_of_data_points+0.5+(number_of_data_points)/number_of_representatives*scale_factor)*ones(number_of_representatives,1);
normalized_size=1/number_of_representatives;%(YLims(2)-YLims(1))/number_of_representatives;
%units=get(gca,'Units');
%set(gca,'Units','normalized');

h=gca;
f=gcf;
positions=zeros(number_of_representatives,4);
normed_size=number_of_data_points/number_of_representatives;
%perm2=fliplr(perm2);
perm1=fliplr(perm1);
for rep_num=1:number_of_representatives
   
%    axes('position', [0.1+0.8*(profile_mds(cluster,1)-min(profile_mds(:,1)))/(max(profile_mds(:,1))-min(profile_mds(:,1))),...
%        0.2+0.8*(profile_mds(cluster,2)-min(profile_mds(:,2)))/(max(profile_mds(:,2))-min(profile_mds(:,2))), ...
%        1*global_data.block_cluster_weights(cluster)+1e-5,...
%        1e-5+1*global_data.block_cluster_weights(cluster)]);
%    image(tanh(squeeze(global_data.representative_blocks(cluster,:,:,1:3,1))/700));
   
  % axes('position',[x_positions(rep_num),y_positions(rep_num),normalized_size,normalized_size]);
   %axes('position',[0.5,0.5,0.5,0.5]);
   
   units=get(gca,'Units');
  % set(gca,'Units','normalized');
   positions(rep_num,:)=dsxy2figxy(h,[x_positions(rep_num),y_positions(rep_num),scale_factor*1,scale_factor*number_of_data_points/number_of_representatives]);
   h1=axes('position', positions(rep_num,:),'parent',f);
   %perm2a=flipud(perm2);
   img=double(representatives{perm2(rep_num),1});
   max_col=max(img(:));
   display_image(img,h1,marker_scales,display_colors,[]);axis equal;axis off;
   line([2*block_size,5*block_size],[2*block_size,2*block_size],'Color','w');
   line([2*block_size,2*block_size],[5*block_size,2*block_size],'Color','w');
   line([2*block_size,5*block_size],[5*block_size,5*block_size],'Color','w');
   line([5*block_size,5*block_size],[5*block_size,2*block_size],'Color','w');

   
%% Display bar plots

   
   
   
   %image(img/max_col);axis equal;axis off;
   %image(representatives{perm2(rep_num)}./max(max(max(representatives{perm2(rep_num)}))));axis equal;axis off;
   %axis off;axis equal;
end
% Two different colormaps are needed for this figure: one for the main
% heatmap and the other for the bars. To do this we must concatenate the
% colormaps and rescale the heatmap colorspace as indicated by:
% http://www.mathworks.com/support/tech-notes/1200/1215.html
l1=length(cmap1);
l2=length(cmap2);
min_val=min(temp2(:));
max_val=max(temp2(:));
set(himg,'CLim', [min_val min_val+(l1+l2)*(max_val-min_val)/(l1-1)]);


for rep_num=1:number_of_representatives
    positions(rep_num,:)=dsxy2figxy(h,[x_positions(rep_num),y_positions1(rep_num),...
        scale_factor*1,0.7*scale_factor*(number_of_data_points+1)/number_of_representatives]);
    h1=axes('position', positions(rep_num,:),'parent',f);

    bhandle=bar(sb_marker_profiles(perm2(rep_num),:),'Parent',h1);
%    max_val= prctile(sb_marker_profiles(:),99);
    max_val=max(sb_marker_profiles(:));
    ch = get(bhandle,'Children');
    fvd = get(ch,'Faces');
    fvcd = get(ch,'FaceVertexCData');
    
    for i=1:length(display_colors)
        %set(h(i),'facecolor',myhandles.display_colors{i}(1));
        fvcd(fvd(i,:))=length(cmap1)+i;
    end
    %colormap(my_cmap);
    set(ch,'FaceVertexCData',fvcd);axis off;
    set(gca,'YLim',[0,1.5*max_val]);axis off;
    
end

%set(gca,'Units',units);

dpos=dsxy2figxy(h,[-number_of_representatives/10+0.5,0,number_of_representatives/10,number_of_data_points+1]);
axes('position', dpos,'parent',f);
[H,T] = dendrogram(Z,0,'orientation','left','reorder',optimal_order1);
axis off;


if(use_sb_dendrogram)
    dpos=dsxy2figxy(h,[0,-number_of_data_points/10+0.5,number_of_representatives+1,number_of_data_points/10]);
    axes('position', dpos,'parent',f);
    [H,T] = dendrogram(Z1,0,'orientation','bottom','reorder',optimal_order2);
    axis off;
end


for i=1:number_of_data_points
%     [tpos_x,tpos_y]=dsxy2figxy(h,number_of_representatives,i);
%     text(tpos_x,tpos_y,num2str(i),'parent',h);
      text(number_of_representatives+0.5,i+0.1,'  ','parent',h,'BackgroundColor',row_bg_colors(perm1(i),:));
      text(number_of_representatives+0.75,i+0.1,row_labels{perm1(i)},'parent',h);
end
min_label=[num2str(round(100*min(data(:)))) '%'];
max_label=[num2str(round(100*max(data(:)))) '%'];
mid_label=[num2str(round(100*(min(data(:))+max(data(:)))/2)) '%'];

%colorbar('YTickLabelMode','manual','YTickLabel',{min_label,mid_label,max_label},'YTickMode','manual');
%colorbar('YTick',[2,30,60], 'YTickLabelMode','manual','YTickLabel',{min_label,mid_label,max_label},'YTickMode','manual');
dpos=dsxy2figxy(h,[-2,0,0.5,number_of_data_points/4]);
axis_handle=axes('position', dpos,'parent',figure_handle);
min_val=min(temp2(:));
max_val=max(temp2(:));
bar_data=(max_val:(min_val-max_val)/10000:min_val)';
imagesc(bar_data); 
set(axis_handle,'CLim', [min_val min_val+(l1+l2)*(max_val-min_val)/(l1-1)]);
set(axis_handle,'XTick',[],'YTick',[1,10000],'YTickLabel',{max_label,min_label});
%colormap(figure_handle,cmap);%Working only for Mtlab 2011
colormap(cmap);
end
