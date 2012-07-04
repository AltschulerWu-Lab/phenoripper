function channelList = get_markers_from_dir(dirName,regExp, rootDir)
% GET_MARKERS_FROM_DIR  get marker names from file structure
%   CHANNELLIST = GET_MARKERS_FROM_DIR(DIRNAME,REGEXP, ROOTDIR) applies the
%   regular expression REGEXP(which can capture Channel name from filename)
%   to files in directory DIRNAME to extract names of channels and returns
%   them as a cell array CHANNELLIST. All paths are measures with respect
%   to root directory ROOTDIR.
%------------------------------------------------------------------------------
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
    channelList = get_markers_from_dir(nextDir,regExp,rootDir);  %# Recursively call get_all_files_in_dir
    if(~isempty(channelList))
      return;
    end
  end

end
