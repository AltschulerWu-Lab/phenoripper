function save_property_file(fileName,property)
% SAVE_PROPERTY_FILE - Save a property into a properties file.
% Parameters :
% FILENAME : the file which contains the properties. - String - Required
% PROPERTY : the property to save. - String - Required
% Output Parameters :
% PROPERTYLIST : a structure which contain the properties and their values.
% i.e. :
%       save_property_file('/tmp/test.properties','myRootDir=/tmp/')
%       write a file like :
%       ###############################
%       # PhenoRipper properties file #
%       ###############################
%
%       myRootDir=/tmp/
%       If the file contain already some properties, it will modify/add the
%       one given in parameters.
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


    if(exist(fileName,'file'))
      propertyList=read_property_file(fileName);
    end
    propertyName= regexp(property,'=','split');
    if(length(propertyName)~=2)
      return;
    end
    propertyList.(propertyName{1})=propertyName{2};
    saveProperties(propertyList,fileName);
    
    
  function saveProperties(propertiesStruct,fileName)
    fid = fopen(fileName, 'w');
    fieldNames=fieldnames(propertiesStruct);
    fprintf(fid, '%s\r\n', '###############################');
    fprintf(fid, '%s\r\n', '# PhenoRipper properties file #');
    fprintf(fid, '%s\r\n', '###############################');
    fprintf(fid, '%s\r\n', '');
    for i=1:length(fieldNames)
      propertyLine=[fieldNames{i} '=' propertiesStruct.(fieldNames{i})];
      fprintf(fid, '%s\r\n', propertyLine);
    end
    fclose(fid);
  end

end
