function display_image_with_boundaries(img,axis_handle,color_scaling,colors,mask,boundary_mask)
% DISPLAY_IMAGE_WITH_BOUNDARIES display an image in specified axis with border
%   DISPLAY_IMAGE_WITH_BOUNDARIES(IMG,AXIS_HANDLE,COLOR_SCALING,COLORS,MASK,boundary_mask)
%   displays a matrix img in the axis specified by axis_handle. The matrix img is typically
%   3-dimensional, and each layer in the third dimension can be scaled linearly
%   using parameters in color_scaling and with specified color. Additionally, a
%   mask can be supplied to show highlighted regions and a border can be drawn
%   around the image.
%
%   display_image arguments:
%   IMG - A matrix representing image to be displayed (typically 3 dimensional)
%   AXIS_HANDLE - handle of the axis where image will be displayed
%   COLOR_SCALING - An array of size [number of channels x 2]. The first column is the min
%   value of each channel, and the second the max value
%   COLORS - a cell array containing color names, in human readable format,
%   that are used to display individual channels in the image
%   MASK - a 2D binary array having the same x,y dimensions as the image.
%   Portions of the mask that are marked true are highlighted in the displayed image
%   BOUNDARY_MASK -a 2D binary array having the same x,y dimensions as the image.
%   Portions of the mask that are marked true are set to white in the displayed image
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


img=double(img);
[xres,yres,nch]=size(img);
final_image=zeros(xres,yres,3);

for channel=1:nch
    img(:,:,channel)=max(min((img(:,:,channel)-color_scaling(channel,1))...
        /(color_scaling(channel,2)-color_scaling(channel,1)),1),0);
    switch colors{channel}
        case {'b','B','Blue'},    ch = 3;     wt = 1;
        case {'g','G','Green'},   ch = 2;     wt = 1;
        case {'r','R','Red'},     ch = 1;     wt = 1;
        case {'k','K','Gray'},    ch = 1:3;   wt = [1 1 1];
        case {'o','O','Orange'},  ch = 1:2;   wt = [1 .75];
        case {'y','Y','Yellow'},  ch = 1:2;   wt = [.5 .5];
        case {'c','C','Cyan'},    ch = 2:3;   wt = [1 1];
        case {'m','M','Magenta'}, ch = [1 3]; wt = [1 1];
        case {'','-' ,'None'},    ch=[];      wt=[];
    end
    for h=1:length(ch)
        if(isempty(mask))
            final_image(:,:,ch(h))=final_image(:,:,ch(h))+wt(h)*img(:,:,channel);
        else
           final_image(:,:,ch(h))=final_image(:,:,ch(h))+wt(h)*img(:,:,channel)+0.25*mask; 
        end
    end
    
end


final_image=min(max(final_image,0),1);
if(~isempty(boundary_mask))
    
    for i=1:3
    temp=final_image(:,:,i);
    temp(boundary_mask)=1;
    final_image(:,:,i)=temp;
    end
end
axes(axis_handle);
image(final_image);
%axis off;

end
