function bd= bit_depth(max_value,standard_levels)
% BIT_DEPTH estimate bit depth (of an image)
%   BD= BIT_DEPTH(MAX_VALUE,STANDARD_LEVELS) returns the optimal bit depth BD from 
%   among the possible values STANDARD_LEVELS for an image with maximum pixel 
%   intensity value MAX_VALUE, 
%   
%   Usage:
%    img= imread('cameraman.tif');
%    bd= bit_depth(max(img(:)),[8,12,14,16,32]);
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


level=log2(double(max_value));

if(level>=max(standard_levels))
    bd=ceil(level);
    return;
else
    standard_levels=sort(standard_levels);
    i=1;
    while(level>standard_levels(i))
        i=i+1;
    end
    bd=standard_levels(i);
end
end
