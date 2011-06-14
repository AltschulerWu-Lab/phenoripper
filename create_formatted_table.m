function formatted_table=create_formatted_table(data_table,fg_table,bg_table)
[number_of_rows,number_of_cols]=size(data_table);
formatted_table=cell(data_table);
for row=1:number_of_rows
   for col=1:number_of_cols
       if(~isempty(fg_table{row,col}))
           if(isempty(bg_table{row,col}))
           formatted_table{row,col}=...
               ['<HTML><font color="' fg_table{row,col} '">' data_table{row,col} '</font></HTML>'];
           else
                 formatted_table{row,col}=...
               ['<HTML><tr bgcolor="' bg_table{row,col} '">' ' <font color="' fg_table{row,col} '">' data_table{row,col} '</font></tr></HTML>'];
           end
       else
           if(isempty(bg_table{row,col}))
               formatted_table{row,col}=data_table{row,col};
           else
                formatted_table{row,col}=...
               ['<HTML><tr bgcolor="' bg_table{row,col} '">' data_table{row,col} '</tr></HTML>'];
           end
       end
   end
end

end