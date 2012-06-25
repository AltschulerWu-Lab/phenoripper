function formatted_data=color_table(raw_data,groups)
bg_colors=cell(size(raw_data));
fg_colors=cell(size(raw_data));
colors={'#A6CEE3', '#1F78B4','#B2DF8A','#33A02C','#FB9A99','#3E31A1C',...
    '#FDBF6F','#FF7F00','#CAB2D6','#6A3D9A'};
for i=1:size(raw_data,1)
   for j=1:size(raw_data,2)
       fg_colors{i,j}=colors{rem(groups(i)-1,10)+1};
      
   end
end
formatted_data=create_formatted_table(raw_data,fg_colors,bg_colors);
