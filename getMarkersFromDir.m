function channelList = getMarkersFromDir(dirName,regExp, rootDir)

  channelList=[];
  dirData = dir(dirName);      %# Get the data for the current directory
  dirIndex = [dirData.isdir];  %# Find the index for directories
  fileList = {dirData(~dirIndex).name}';  %'# Get a list of the files
  if ~isempty(fileList)
    if(strcmpi(dirName(length(rootDir):length(rootDir)),filesep))
      subdir=regexprep(dirName,rootDir,'');
    else
      subdir=regexprep(dirName,[rootDir filesep],'');
    end
    fileList = cellfun(@(x) fullfile(subdir,x),...  %# Prepend path to files
                       fileList,'UniformOutput',false);
    
    for i=1:length(fileList)
      %Apply the regular expression to the file path minus the root directory  
      [~, ~, ~, ~, tokenStr, exprNames] = regexp(fileList{i},regExp);
      %Check if the regexp match and contain at least Channel (otherwise we can't find it)
      if (~isempty(tokenStr) && sum(cellfun(@isempty,tokenStr{1})==0) && isfield(exprNames,'Channel'))
        if(sum(ismember(channelList,exprNames.Channel))==0)%Check if the marker is not already referenced
          channelList{length(channelList)+1}=exprNames.Channel;
        end
      end
    end
  end
  if(~isempty(channelList))
    return;
  end
  subDirs = {dirData(dirIndex).name};  %# Get a list of the subdirectories
  validIndex = ~ismember(subDirs,{'.','..'});  %# Find index of subdirectories
                                               %#   that are not '.' or '..'
  for iDir = find(validIndex)                  %# Loop over valid subdirectories
    nextDir = fullfile(dirName,subDirs{iDir});    %# Get the subdirectory path
    channelList = getMarkersFromDir(nextDir,regExp,rootDir);  %# Recursively call getAllFiles
    if(~isempty(channelList))
      return;
    end
  end

end