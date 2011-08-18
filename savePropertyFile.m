function savePropertyFile(fileName,property)
% Save a property into a properties file.
% Parameters :
% @fileName : the file which contains the properties. - String - Required
% @property : the property to save. - String - Required
% Output Parameters :
% @propertyList : a structure which contain the properties and their values.
% i.e. :
%       savePropertyFile('/tmp/test.properties','myRootDir=/tmp/')
%       write a file like :
%       ###############################
%       # PhenoRipper properties file #
%       ###############################
%
%       myRootDir=/tmp/
%       If the file contain already some properties, it will modify/add the
%       one given in parameters.
%  Copyright (C) B. Pavie and S. Rajaram for Altschuler and Wu Lab, 2011
% ----------------------------------------------------------------------

    if(exist(fileName,'file'))
      propertyList=readPropertyFile(fileName);
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
