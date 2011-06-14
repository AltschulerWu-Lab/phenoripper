function positions=CoolClustergram(data,representatives,row_labels,row_bg_colors)
number_of_representatives=length(representatives);
number_of_data_points=size(data,1);
if(size(data,2)~=number_of_representatives)
   error('Incorrect Number Of Representatives'); 
end
figure('Name','PhenoRipper Clustergram');
Y = pdist(data);
Z = linkage(Y,'average');
optimal_order1=optimalleaforder(Z,Y);
[~,~,perm1] = dendrogram(Z,0,'orientation','left','reorder',optimal_order1);
Y1 = pdist(data');
Z1 = linkage(Y1,'average');
optimal_order2=optimalleaforder(Z1,Y1);
[~,~,perm2] = dendrogram(Z1,0,'orientation','bottom','reorder',optimal_order2);

temp1=data(perm1,:)';
temp2=flipud(temp1(perm2,:)');
%temp2=fliplr(flipud(temp1(perm2,:)'));

imagesc(temp2);


axis off;
scale_factor=0.9;
XLims=get(gca,'XLim');
YLims=get(gca,'YLim');
x_positions=linspace(1,number_of_representatives,number_of_representatives)-scale_factor/2;
y_positions=(number_of_data_points+0.5)*ones(number_of_representatives,1);
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
   axes('position', positions(rep_num,:),'parent',f);
   img=double(representatives{perm2(rep_num),1}(:,:,1:3));
   max_col=max(img(:));
   image(img/max_col);axis equal;axis off;
   %image(representatives{perm2(rep_num)}./max(max(max(representatives{perm2(rep_num)}))));axis equal;axis off;
   %axis off;axis equal;
end
colormap('Bone');

%set(gca,'Units',units);

dpos=dsxy2figxy(h,[-number_of_representatives/10+0.5,0,number_of_representatives/10,number_of_data_points+1]);
axes('position', dpos,'parent',f);
[H,T] = dendrogram(Z,0,'orientation','left','reorder',optimal_order1);
axis off;


dpos=dsxy2figxy(h,[0,-number_of_data_points/10+0.5,number_of_representatives+1,number_of_data_points/10]);
axes('position', dpos,'parent',f);
[H,T] = dendrogram(Z1,0,'orientation','bottom','reorder',optimal_order2);
axis off;


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
axes('position', dpos,'parent',f);
imagesc((10000:-1:1)'); 
set(gca,'XTick',[],'YTick',[1,10000],'YTickLabel',{max_label,min_label});

end
