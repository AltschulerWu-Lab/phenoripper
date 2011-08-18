function path=loadLastPath(type)

switch type
  case 'wizard'
    readPropertyFile('lastPath.properties');
    path=getPath('wizardPath');
  case 'metadata'
    path=getPath('metadataPath');
  case 'save'
    path=getPath('savePath');
  otherwise
    path='';
end

  function path=getPath(type)
    propertyList = readPropertyFile('lastPath.properties');
    if (~isempty(propertyList) && isfield(propertyList,type))
      path=propertyList.(type);
    else
      path='';
    end
  end

% path=[];
% if(exist('.lastPath.txt','file'))
%   fid = fopen('.lastPath.txt', 'r');
%   path = fgetl(fid);
%   fclose(fid);
end