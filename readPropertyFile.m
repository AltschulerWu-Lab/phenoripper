function propertyList = readPropertyFile(fileName)
% Read a property file and return a struture containing the property list with their values.
% Parameters :
% @fileName : the file which contains the properties. - String - Required
% Output Parameters :
% @propertyList : a structure which contain the properties and their values.
% i.e. :
%       readPropertyFile(W:\Common\toolbox_v2.0\project.properties)
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
%  Copyright (C) B. Pavie and S. Rajaram for Altschuler and Wu Lab, 2011
% ----------------------------------------------------------------------
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
