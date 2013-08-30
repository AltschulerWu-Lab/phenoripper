function h = findPatternInSet(h)    
% findPatternInSet uses features from findPatternFeat to search for common
% patterns in h.filteredNameGroups
%   findPatternInSet(h) returns the found patterns with higlights
%   into h.filenameHighlight and the unique groups within it into
%   h.filtName
%
%   findPatternInSet arguments:
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

    % search for pattern in entire set        
    if ~h.entireFolder
        strLen = cellfun('length',h.fileGroups);
        h.sepIdx = reshape([h.sepIdx{:}],length(h.sepIdx{1}),length(h.filteredNameGroups));
        h.sepIdx = [zeros(1,length(h.filteredNameGroups)); h.sepIdx; strLen'];
    end
    
    h.patternsFound = cell(length(h.filteredNameGroups),1);
    h.filenameHighlight = cell(length(h.filteredNameGroups),1);
    
    h.invalidSel = 0;   
    h.wbar = waitbar(0,'Searching for patterns...');     
    for k = 1:length(h.filteredNameGroups)
        if h.entireFolder
            temp = h.fileGroups{k};
            subfolderStr = cellstr(['<FONT style="BACKGROUND-COLOR: yellow" color="black">' temp '</FONT>']);
        else                    
            sstr = h.splitstr{k};
            mstr = [h.matchstr{k} cellstr('')];            
            
            begFeat = sstr{h.subStartIdx};                    
            endFeat = sstr{h.subEndIdx}; 
            
             
            
            if h.entireBeg && h.entireEnd
                begTemp = [];
                endTemp = [];
            elseif h.entireBeg                
                begTemp = [];
                
                [endsplit endmatch] = regexp(endFeat,'\d+','split','match');
                endGroups = [endsplit; endmatch cellstr('')];
                endGroups = endGroups(:);
                endGroups = endGroups(~cellfun('isempty',endGroups));
                if h.endIdx>length(endGroups)
                    h.invalidSel = 1;                    
                    begTemp = sstr{h.subEndIdx};
                    sstr{h.subEndIdx} = '';
                    endTemp = [];
                else
                    sstr{h.subEndIdx} = [endGroups{1:h.endIdx}];
                    endTemp = [endGroups{h.endIdx+1:end}];
                end
                
            elseif h.entireEnd                
                [begsplit begmatch] = regexp(begFeat,'\d+','split','match');
                begGroups = [begsplit; begmatch cellstr('')];
                begGroups = begGroups(:);
                begGroups = begGroups(~cellfun('isempty',begGroups));
                if h.begIdx>length(begGroups)
                    h.invalidSel = 1;
                    begTemp = sstr{h.subStartIdx};
                    sstr{h.subStartIdx} = '';
                    endTemp = [];                    
                else
                    sstr{h.subStartIdx} = [begGroups{h.begIdx:end}];
                    begTemp = [begGroups{1:h.begIdx-1}];                
                    endTemp = [];
                end
            else                
                [begsplit begmatch] = regexp(begFeat,'\d+','split','match');
                begGroups = [begsplit; begmatch cellstr('')];
                begGroups = begGroups(:);
                begGroups = begGroups(~cellfun('isempty',begGroups));

                [endsplit endmatch] = regexp(endFeat,'\d+','split','match');
                endGroups = [endsplit; endmatch cellstr('')];
                endGroups = endGroups(:);
                endGroups = endGroups(~cellfun('isempty',endGroups));

                if h.subStartIdx~=h.subEndIdx
                    sstr{h.subStartIdx} = [begGroups{h.begIdx:end}];
                    sstr{h.subEndIdx} = [endGroups{1:h.endIdx}];
                    begTemp = [begGroups{1:h.begIdx-1}];
                    endTemp = [endGroups{h.endIdx+1:end}];
                else
                    if h.endIdx>length(endGroups)
                        h.invalidSel = 1;                    
                        begTemp = sstr{h.subEndIdx};
                        sstr{h.subEndIdx} = '';
                        endTemp = [];
                    else
                        sstr{h.subStartIdx} = [begGroups{h.begIdx:h.endIdx}];
                        begTemp = [begGroups{1:h.begIdx-1}];
                        endTemp = [endGroups{h.endIdx+1:end}];
                    end
                end

            end
            
            temp = [sstr(h.subStartIdx:h.subEndIdx); mstr(h.subStartIdx:h.subEndIdx-1) cellstr('')];
            temp = [temp{:}];

            frontStr = [sstr(1:h.subStartIdx-1); mstr(1:h.subStartIdx-1)];
            frontStr = [frontStr{:}];

            endStr = [mstr(h.subEndIdx:end-1); sstr(h.subEndIdx+1:end)];
            endStr = [endStr{:}];

            subfolderStr = cellstr([frontStr begTemp '<FONT style="BACKGROUND-COLOR: yellow" color="black">' temp '</FONT>' endTemp endStr]);
            
        end       
        
        nameGroupTemp = h.filteredNameGroups{k};
        nameGroupTemp(h.foldIdx+1) = subfolderStr;
        tempFilenameHighlight = [nameGroupTemp; repmat(cellstr('/'),1,length(nameGroupTemp)-1) cellstr('')];
        tempFilenameHighlight = ['<HTML><BODY>' tempFilenameHighlight{:} '</BODY></HTML>'];
        h.filenameHighlight(k) = cellstr(tempFilenameHighlight);
        
        h.patternsFound(k) = cellstr(temp);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        frac = k/length(h.filteredNameGroups);
        waitbar(frac,h.wbar,'Searching for patterns...');        
        
    end    
    
    if h.invalidSel
        h.filenameHighlight = regexprep(h.filenameHighlight,'<HTML><BODY>','');
        h.filenameHighlight = regexprep(h.filenameHighlight,'</BODY></HTML>','');
        h.filenameHighlight = regexprep(h.filenameHighlight,'<FONT style="BACKGROUND-COLOR: yellow" color="black">','');
        h.filenameHighlight = regexprep(h.filenameHighlight,'</FONT>','');
                
        h.filtName = cell(1);
        warndlg('Invalid Selection!');
    else
        h.filtName = unique(h.patternsFound);
    end
        
      

    

    
    