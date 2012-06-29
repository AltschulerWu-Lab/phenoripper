function x = black_white_colormap(n,r)
% n->[0,1] controls the centering of the colormap, with 0.5 using the
% median
% r->[0,1] controls the sharpness of transition. r=0 gives a step function
% centered at n, while r=1 gives a perfect linear map 

% Code to demonstrate the effects of parameter change
% figure; 
% plot(sum(black_white_colormap(0.5,0.5),2)/3)
% hold on;
% plot(sum(black_white_colormap(0.5,0.2),2)/3,'r')
% plot(sum(black_white_colormap(0.3,0.2),2)/3,'g')
% plot(sum(black_white_colormap(0.5,0.8),2)/3,'k')
% hold off;
%
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

if ~exist('n','var')
    n = 0.5;
    r = 0.5;
end
if(r<0.99999999999999)
n1=128*n;
r1=r^0.1/(1-r^0.05);
y=tanh(((1:128)-n1)/r1)';

else
   y=(1:128)'; 
end
y=(y-min(y))/(max(y)-min(y));
x=repmat(y,1,3);


