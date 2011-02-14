data=rand(10);
labels=struct;
colors=jet(10);

row_labels=cell(0);
for i=1:10
    labels(i).Labels=num2str(i);
    row_labels{i}=num2str(i);
    labels(i).Colors=colors(i,:);
end

c=clustergram(data,'ColumnLabelsColor',labels);

c=clustergram(data,'ColumnLabels',row_labels,'ColumnLabelsColor',labels);