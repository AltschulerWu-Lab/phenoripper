function formatted_data=color_table(raw_data,groups)
% COLOR_TABLE construct a colored table
%   FORMATTED_DATA=COLOR_TABLE(RAW_DATA,GROUPS) accepts as input raw_data formatted
%   as a cell array, and a vector groups specifying the group number of each
%   row. The output of color_table is cell array with the same dimensions as
%   raw_data, but formated so that when displayed as a table in a MATLAB gui,
%   rows corresponding to the different groups are colored differently.
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
