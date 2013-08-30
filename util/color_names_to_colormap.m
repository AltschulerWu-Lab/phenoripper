function cmap=color_names_to_colormap(display_colors)
% COLOR_NAMES_TO_COLORMAP construct colormap from human readable list of colors
%   CMAP=COLOR_NAMES_TO_COLORMAP(DISPLAY_COLORS) takes as input, 
%   DISPLAY_COLORS,a list of human-readable colors, specified as strings in 
%   a cell array. It produces a colormap array containing the R,G and B 
%   values for these specified colors.
%
%   Usage:
%   cmap=color_names_to_colormap({'Red','Gray','Yellow'});
% ------------------------------------------------------------------------------
% Copyright ??2012, The University of Texas Southwestern Medical Center 
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
  j=0;
  for (i=1:length(display_colors))
    if (~strcmpi(display_colors(i),''))
      j=j+1;
    end
  end 
  cmap=zeros(j,3);
  j=1;
  for i=1:length(display_colors)
     switch display_colors{i}
      case {'b','B','Blue'},    cmap(j,:)= [0 0.51 0.84];%[0.2148    0.4922    0.7188];
      case {'g','G','Green'},   cmap(j,:)= [0.21 0.71 0.09];%[0.3008    0.6836    0.2891];
      case {'r','R','Red'},     cmap(j,:)=[1 0.2 0];%[0.8906    0.1016    0.1094];
      case {'k','K','Gray'},    cmap(j,:)=[0.5 0.5 0.5];
      case {'o','O','Orange'},  cmap(j,:)=[1 0.4 0];
      case {'y','Y','Yellow'},  cmap(j,:)=[1 1 0];
      case {'c','C','Cyan'},    cmap(j,:)=[0 1 1];
      case {'m','M','Magenta'}, cmap(j,:)=[1 0 1];
      case {'','-' ,'None'},
        j=j-1;
        %cmap(i,:)=[0 0 0];
     end
     j=j+1;
  end
    

end
