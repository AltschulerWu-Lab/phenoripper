function path=load_last_path(type)
% LOAD_LAST_PATH load the path of the last used directory
%   PATH=LOAD_LAST_PATH(TYPE) returns a string, PATH, pointing to the last
%   directory used in the context type. TYPE may be one of 'metadata',
%   'wizard','save','result','importtemplate' and the returned path will be 
%   the last directory used for that type of operation.
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



try
  if ispc
    userdir= getenv('USERPROFILE'); 
  else
    userdir= getenv('HOME');
  end
  
switch type
  case 'wizard'
    read_property_file([userdir filesep 'lastPath.properties']);
    path=getPath('wizardPath');
  case 'metadata'
    path=getPath('metadataPath');
  case 'save'
    path=getPath('savePath');
  case 'result'
    path=getPath('resultPath');
  case 'importtemplate'
    path=getPath('importtemplatePath');
  case 'phenoloaderroot'
    path=getPath('phenoloaderrootPath');
  otherwise
    path='';
end
  
catch

% path=[];
% if(exist('.lastPath.txt','file'))
%   fid = fopen('.lastPath.txt', 'r');
%   path = fgetl(fid);
%   fclose(fid);
end

function path=getPath(type)
try
  
  if ispc
    userdir= getenv('USERPROFILE'); 
  else
    userdir= getenv('HOME');
  end
  propertyList = read_property_file([userdir filesep 'lastPath.properties']);
  if (~isempty(propertyList) && isfield(propertyList,type))
    path=propertyList.(type);
  else
    path='';
  end
catch
  ;
end
