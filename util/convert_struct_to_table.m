function [table_data,field_names]=convert_struct_to_table(data)
number_of_groups=length(data);
fnames=fieldnames(data{1});
table_data=cell(number_of_groups,length(fnames)-1);

for i=1:number_of_groups
    for j=1:length(fnames)-1
        table_data{i,j}=data{i}.(fnames{j+1});
    end
end
field_names=fnames(2:end);
field_names{1}='File Name';


