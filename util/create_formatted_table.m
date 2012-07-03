function formatted_table=create_formatted_table(data_table,fg_table,bg_table)
% CREATE_FORMATTED_TABLE construct a GUI embeddable table with specified colors
%   FORMATTED_TABLE=CREATE_FORMATTED_TABLE(DATA_TABLE,FG_TABLE,BG_TABLE) takes
%   a cell array, data_table, and foreground (fg_table) and background
%   (bg_table) color specification of each cell in the table, and constructs a
%   GUI embeddable table with the specified colors. The color specification
%   tables have the same size as the data, and colors are specified using HTML
%   color codes
%
%
% ------------------------------------------------------------------------------
% Copyright ©2012, The University of Texas Southwestern Medical Center 
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
