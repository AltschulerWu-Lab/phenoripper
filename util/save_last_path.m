function save_last_path(path,type)

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
