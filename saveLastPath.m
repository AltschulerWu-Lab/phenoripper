function saveLastPath(path,type)

switch type
  case 'wizard'
    savePropertyFile('lastPath.properties',['wizardPath=' path]);
  case 'metadata'
    savePropertyFile('lastPath.properties',['metadataPath=' path]);
  case 'save'
    savePropertyFile('lastPath.properties',['savePath=' path]);
  otherwise
    ;
end

%   fid = fopen('.lastPath.txt','w');
%   fprintf(fid, '%s', path);
%   fclose(fid);