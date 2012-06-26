function saveLastPath(path,type)

try
  if ispc
    userdir= getenv('USERPROFILE'); 
  else
    userdir= getenv('HOME');
  end


  switch type
    case 'wizard'
      savePropertyFile([userdir filesep 'lastPath.properties'],['wizardPath=' path]);
    case 'metadata'
      savePropertyFile([userdir filesep 'lastPath.properties'],['metadataPath=' path]);
    case 'save'
      savePropertyFile([userdir filesep 'lastPath.properties'],['savePath=' path]);
    case 'result'
      savePropertyFile([userdir filesep 'lastPath.properties'],['resultPath=' path]);
    case 'importtemplate'
      savePropertyFile([userdir filesep 'lastPath.properties'],['importtemplatePath=' path]);
    otherwise
      ;
  end
catch
  ;
end

%   fid = fopen('.lastPath.txt','w');
%   fprintf(fid, '%s', path);
%   fclose(fid);
