function save_last_path(path,type)
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


try
  if ispc
    userdir= getenv('USERPROFILE'); 
  else
    userdir= getenv('HOME');
  end


  switch type
    case 'wizard'
      save_property_file([userdir filesep 'lastPath.properties'],['wizardPath=' path]);
    case 'metadata'
      save_property_file([userdir filesep 'lastPath.properties'],['metadataPath=' path]);
    case 'save'
      save_property_file([userdir filesep 'lastPath.properties'],['savePath=' path]);
    case 'result'
      save_property_file([userdir filesep 'lastPath.properties'],['resultPath=' path]);
    case 'importtemplate'
      save_property_file([userdir filesep 'lastPath.properties'],['importtemplatePath=' path]);
    otherwise
      ;
  end
catch
  ;
end

%   fid = fopen('.lastPath.txt','w');
%   fprintf(fid, '%s', path);
%   fclose(fid);
