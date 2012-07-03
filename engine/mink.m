function mink_vals = mink(x,k)
% MINK_VALS find the k smallest values in an array
%   MINK_VALS = MINK(X,K) returns the K smallest values (in order) in the
%   array X.
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


if(length(x)<k); k=length(x); mink_vals=zeros(k,1); end
for i=1:k
    [mink_vals(i) min_index]= min(x);
    x(min_index) = +inf;
end
