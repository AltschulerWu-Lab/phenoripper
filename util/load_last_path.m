function path=load_last_path(type)

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
