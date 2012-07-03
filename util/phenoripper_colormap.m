function colors=phenoripper_colormap(number_of_colors)
% PHENORIPPER_COLORMAP - colormap with qualitatively different levels 
%   COLORS=PHENORIPPER_COLORMAP(NUMBER_OF_COLORS) generates a colormap (array
%   of size:number_of_colors x 3) having number_of_colors qualitatively
%   different color levels. If number_of_colors exceeds 13 the colormap
%   defaults to the standard jet colormap used by matlab.  

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


if(number_of_colors<13 && number_of_colors>2)
    load('color_data.mat');
    colors=color_brewer{number_of_colors}./256;
else
   colors=jet(number_of_colors); 
end

end
