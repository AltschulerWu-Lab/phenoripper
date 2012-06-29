function phenoripper
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



current_dir=pwd;
addpath(genpath([current_dir filesep 'engine']));
addpath(genpath([current_dir filesep 'gui']));
addpath(genpath([current_dir filesep 'util']));
addpath(genpath([current_dir filesep 'data']));
addpath(genpath([current_dir filesep 'img']));
version=fileread('version.txt');
disp(['PhenoRipper version ' version]);
phenoripper_gui;
