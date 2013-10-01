function h = findExt(h)
% FINDEXT finds all possible extensions within a directory
%   FINDEXT(h) returns the found extensions within a directory and creates
%   a list that has the entire file path for each file, but filtered by the
%   selected extension
%
%   findExt arguments:
%   h - handles for the entire gui
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
    try
        h.wbar = waitbar(0,'Finding all extensions in directory.');        
        [h.list, h.wbar, frac] = get_all_files_in_dir2(h.rootDir,h.wbar,0,1);
        close(h.wbar);
    catch err
        h.list=err.message;
    end
    
    h.rootDir=regexprep(h.rootDir,'\','/');
    h.list=regexprep(h.list,'\','/');
    
    h.origfileName = regexp(h.list,h.rootDir,'split');
    h.origfileName = cellfun(@(x) x{end},h.origfileName,'UniformOutput',false);    
    
    
    ext = regexp(h.origfileName,'\.','split');
    number_without_extension=0;
    for k = 1:length(ext)
        temp = ext{k};
        ext(k) = cellstr(['.' temp{end}]);
        if(length(temp)==1)
             number_without_extension= number_without_extension+1;
             ext(k)={'.<empty>'};
        end
    end
    
    h.fileExt=ext;
    h.extTypes = unique(ext);
    extHistogram = zeros(length(h.extTypes),1);

    for k = 1:length(h.extTypes)
        extHistogram(k) = sum(~cellfun('isempty',regexp(ext,h.extTypes{k},'match')));
    end

    [~, i] = sort(extHistogram,'descend');
    h.extTypes = h.extTypes(i);

    h.imageExt = h.extTypes{1};
    h.imageExt = h.imageExt(2:end);

    popupStr = [];
    for k = 1:length(h.extTypes)
        popupStr = [popupStr h.extTypes{k} '|'];
    end
    popupStr = popupStr(1:end-1);

    set(h.ImageExtension,'String',popupStr,'Value',1);

%     idx = ~cellfun('isempty',regexp(h.origfileName,h.imageExt,'match'));
    idx=strcmp(h.fileExt,['.' h.imageExt]);
    h.origfileName = h.origfileName(idx);
    h.origfileName = sort(h.origfileName);
    h.nameGroups = regexp(h.origfileName,'/','split');
    
    if(number_without_extension>0)
       warndlg(['We detected ' num2str(number_without_extension) ' files without extension. If your images do in fact not have any extension select .<empty> in the dropdown menu']); 
    end
   