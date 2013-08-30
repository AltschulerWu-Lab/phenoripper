function flag=isMultipleCall()
% ISMULTIPLECALL checks stack for multiple calls
%   FLAG = ISMULTIPLECALL() returns true or false depending if the stack
%   has more than one call
% ------------------------------------------------------------------------------
% Copyright ??2013, The University of Texas Southwestern Medical Center 
% Authors:
% Austin Ouyang for the Altschuler and Wu Lab
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
    flag = false; 
    % Get the stack
    s = dbstack();
    if numel(s)<=2
        % Stack too short for a multiple call
        return
    end

    % How many calls to the calling function are in the stack?
    names = {s(:).name};
    TF = strcmp(s(2).name,names);
    count = sum(TF);
    if count>1
        % More than 1
       flag = true; 
    end

