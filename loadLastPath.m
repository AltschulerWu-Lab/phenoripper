function path=loadLastPath(type)

try
  if ispc
    userdir= getenv('USERPROFILE'); 
  else
    userdir= getenv('HOME');
  end
  
switch type
  case 'wizard'
    readPropertyFile([userdir filesep 'lastPath.properties']);
    path=getPath('wizardPath');
  case 'metadata'
    path=getPath('metadataPath');
  case 'save'
    path=getPath('savePath');
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
  propertyList = readPropertyFile([userdir filesep 'lastPath.properties']);
  if (~isempty(propertyList) && isfield(propertyList,type))
    path=propertyList.(type);
  else
    path='';
  end
catch
  ;
end