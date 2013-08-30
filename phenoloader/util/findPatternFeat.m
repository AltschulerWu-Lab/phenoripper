function h = findPatternFeat(h,nameGroups) 
% FINDPATTERNFEAT finds common patterns in nameGroups using the template in
% handles h
%   FINDPATTERNFEAT(h,nameGroups) returns the features of a string based on
%   its folder location and specific string location within the folder.
%   These are then used with the function findPatternInSet.
%
%   FINDPATTERNFEAT arguments:
%   h - handles for the entire gui
%   nameGroups - a cell array containing strings of the filenames segmented
%   by some separator
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
     
    slashIdx = regexp(h.currName(2:end),'/');   % find location of folder separators

    h.foldStartIdx = find(h.selStart-1<=slashIdx,1,'first');    % determine which folder the beginning selection lies in
    h.foldEndIdx = find(h.selEnd-1<=slashIdx,1,'first');        % determine which folder the end selection lies in
    
    % set folder index to last folder if no folder index found
    if isempty(h.foldStartIdx)
        h.foldStartIdx = length(slashIdx)+1;
    end
    if isempty(h.foldEndIdx)
        h.foldEndIdx = length(slashIdx)+1;
    end
    
    h.patternError = 0;
    if h.foldStartIdx~=h.foldEndIdx
        warndlg('Select annotation only within a single folder!');
        h.patternError = 1;
    else
        h.foldIdx = h.foldStartIdx;
        if isempty(h.foldIdx)
            h.foldIdx = length(slashIdx)+1;
        end
    
        folderPattern = cell(size(nameGroups,1),1);
        for k = 1:size(nameGroups,1)
            temp = nameGroups{k};
            folderPattern(k) = cellstr(temp{h.foldIdx+1});
        end
        h.folderPattern = unique(folderPattern);

        slashIdx = [0 slashIdx length(h.currName)+1];
        
        % check if selection is an entire folder
        if any(((h.selStart-1)-slashIdx==1) | ((h.selStart-1)-slashIdx==0))  && any((slashIdx-(h.selEnd-1)==1) | (slashIdx-(h.selEnd-1)==0))
            h.entireFolder = 1;
            h.numSep = 0;
        else
            h.entireFolder = 0;
            
            % readjust selection index to selected start folder
            h.sStart = h.selStart - slashIdx(h.foldIdx) - 1;
            h.sEnd = h.selEnd - slashIdx(h.foldIdx) - 1;

            h.fileGroups = nameGroups{h.adjustedFileIdx};
            
            % split folder group into common separators
            fileSection = h.fileGroups{h.foldIdx+1};
            [h.sepIdx, splitstr] = regexp(fileSection,'[!-.:-@{-~\[\]-`]','start','split');

            
            h.numSep = length(h.sepIdx);
            h.sepIdx = [0 h.sepIdx length(fileSection)+1];

            h.subStartIdx = find(h.sStart<h.sepIdx,1,'first')-1;
            h.subEndIdx = find(h.sEnd>h.sepIdx,1,'last');

            begFeat = splitstr{h.subStartIdx};        
            begIdx = max(h.sStart - h.sepIdx(h.subStartIdx),1);
            if begIdx==1
                h.entireBeg = 1;
            else
                h.entireBeg = 0;
            end
            [begsplit begmatch] = regexp(begFeat,'\d+','split','match');
            begGroups = [begsplit; begmatch cellstr('')];
            begGroups = begGroups(:);
            begGroups = begGroups(~cellfun('isempty',begGroups));
            cnt = 1;
            for k = 1:length(begGroups)
                strLen = length(begGroups{k});
                begGroups(k) = cellstr([' ' num2str(cnt:cnt+strLen-1) ' ']);
                cnt = cnt + strLen;
            end
            
            endFeat = splitstr{h.subEndIdx};
            endIdx = min(h.sEnd - h.sepIdx(h.subEndIdx),length(endFeat));
            if endIdx==length(endFeat)
                h.entireEnd = 1;
            else
                h.entireEnd = 0;
            end
            [endsplit endmatch] = regexp(endFeat,'\d+','split','match');
            endGroups = [endsplit; endmatch cellstr('')];
            endGroups = endGroups(:);
            endGroups = endGroups(~cellfun('isempty',endGroups));
            cnt = 1;
            for k = 1:length(endGroups)
                strLen = length(endGroups{k});
                endGroups(k) = cellstr([' ' num2str(cnt:cnt+strLen-1) ' ']);
                cnt = cnt + strLen;
            end
            
            h.begIdx = find(~cellfun('isempty',regexp(begGroups,cellstr([' ' num2str(begIdx) ' ']))));
            h.endIdx = find(~cellfun('isempty',regexp(endGroups,cellstr([' ' num2str(endIdx) ' ']))));                       
        end
    end