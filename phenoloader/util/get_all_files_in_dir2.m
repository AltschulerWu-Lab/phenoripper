function [fileList, wbar, frac] = get_all_files_in_dir2(dirName,wbar,frac,top)
    % GET_ALL_FILES_IN_DIR recursively list all files in a directory
    %   FILELIST = GET_ALL_FILES_IN_DIR(DIRNAME) returns a cell array containing
    %   all the files contained in directory dirname and its sub-directories.
    % ------------------------------------------------------------------------------
    % Copyright ??2013, The University of Texas Southwestern Medical Center
    % Authors:
    % Austin Ouyang for the Altschuler and Wu Lab
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
    waitbar(frac,wbar,'Searching for all files and extensions in directory...');
    
    dirData = dir(dirName);      % Get the data for the current directory
    dirIndex = [dirData.isdir];  % Find the index for directories
    fileList = {dirData(~dirIndex).name}';  %' Get a list of the files
    if ~isempty(fileList)
        fileList = cellfun(@(x) fullfile(dirName,x),...  % Prepend path to files
            fileList,'UniformOutput',false);
    end
    subDirs = {dirData(dirIndex).name};  % Get a list of the subdirectories
    validIndex = ~ismember(subDirs,{'.','..'});  % Find index of subdirectories
    
    %   that are not '.' or '..'
    k=1;
    for iDir = find(validIndex)
        if top
            frac = (k-1)/sum(validIndex);
            k=k+1;
        end% Loop over valid subdirectories
        nextDir = fullfile(dirName,subDirs{iDir});    % Get the subdirectory path
        [f wbar frac]=get_all_files_in_dir2(nextDir,wbar,frac,0);
        fileList = [fileList; f];  % Recursively call getAllFiles
        
    end
    
end



% f0=java.io.File(dirName);
% list=cell(f0.list());
% %     isDir = cellfun('isempty',regexp(list,'\.'));
% isDir=f0.isDi
% fileList = list(~isDir);
% if ~isempty(fileList)
%     fileList = cellfun(@(x) fullfile(dirName,x),fileList,'UniformOutput',false);
% end
% subDirs = list(isDir);
% 
% 
% for k = 1:length(subDirs)
%     nextDir = fullfile(dirName,subDirs{k});
%     if top
%         frac = (k-1)/length(subDirs);
%     end
%     [f wbar frac] = get_all_files_in_dir2(nextDir,wbar,frac,0);
%     fileList = [fileList; f];
% end










