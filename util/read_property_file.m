function propertyList = read_property_file(fileName)
% READ_PROPERTY_FILE - read a project properties file
% Read a property file and return a structure containing the property list with their values.
% Parameters :
% FILENAME : the file which contains the properties. - String - Required
% Output Parameters :
% PROPERTYLIST : a structure which contain the properties and their values.
% i.e. :
%       read_property_file(W:\Common\toolbox_v2.0\project.properties)
%       return a struct like :
%       propertyList = 
%           pcRootDir: 'W:/'
%           unixRootDir: '/home/project/'
% i.e. of a .properties file structure :
% ###########################
% # Project properties file #
% ###########################
%
% #Windows Root directory which contain all the projects
% pcRootDir=W:/
% #Unix Root directory which contain all the projects
% unixRootDir=/home/project/
%
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

  if(~exist(fileName,'file'))
    propertyList=[];
    return;
  end
  fid = fopen(fileName, 'rt');
  propertyList = [];
  while feof(fid) == 0
    tline = fgetl(fid);
     %Do the job only for the line does'nt contain comments which start
     %with the caracter #
    if( ~isempty(tline) && ~strcmp(tline(1),'#'))
        %tmp = split_string(tline,'=');
        tmp = regexp(tline,'=','split');
        if(length(tmp)==2)
          propertyList.(tmp{1})=tmp{2};
        end
    end
  end
  fclose(fid);
end
