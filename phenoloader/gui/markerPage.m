function markerPage
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
    handles = getappdata(0,'handles');
    
    % Close any existing figures
    figsOpen = get(0,'children');
    figsOpen = figsOpen(figsOpen>101 & figsOpen<106);
    close(figsOpen);

    % Check that filenames have been found from Root Directory Step
    if isfield(handles,'origfileName')
        
        import java.awt.Color;
        import java.awt.Point;
        
        % Create Marker figure/panel
        handles.figMarker = figure(103); % Marker Figure
        set(handles.figMarker,'Position',[handles.px handles.py handles.wd handles.ht],'Visible','on',...
            'MenuBar','none','Resize','off','Name',handles.title,'NumberTitle','off',...
            'CloseRequestFcn',@figClose_CloseRequestFcn);        
        handles.pMarker1 = uipanel('Parent',handles.figMarker,'Visible','on',...
            'Position',[0 0 1 1],'BackgroundColor','black');        

        % Page Title
        uicontrol(handles.pMarker1,'Style','Text','FontSize',20,'String','Define and Name Biomarkers in Filename',...
                    'FontWeight','Bold','BackgroundColor','black','ForegroundColor','white',...
                    'Position',[handles.wd*0.1 handles.ht*0.89 handles.wd*0.8 40]);                

        % Create push button for File Attribute Example
        handles.showMarkerExample = uicontrol(handles.pMarker1,'Style','pushbutton',...
                    'FontSize',10,'String','Show/Hide Example',...
                    'callback',@showMarkerExample_callback,...
                    'Position',[10 450 150 40]);

        % Define File Select Text/Edit Box
        uicontrol(handles.pMarker1,'Style','Text','FontSize',12,'String',{'Use mouse to select portion of filename that identifies the biomarkers (e.g. -1,-2,-3 or Ch3,Ch5,Ph)'},'FontWeight','Bold',...
                    'BackgroundColor','black','ForegroundColor','white','HorizontalAlignment','left',...
                    'Position',[handles.wd*0.08 handles.ht*0.25 handles.wd*0.85 20]); 
        uicontrol(handles.pMarker1,'Style','Text','FontSize',12,'String','2)','FontWeight','Bold',...            
                    'BackgroundColor','black','ForegroundColor','white',...
                    'Position',[handles.wd*0.05 handles.ht*0.25 20 20]); 
        handles.SelectedFile = uicontrol(handles.pMarker1,'Style','edit','FontSize',12,...                    
                    'callback',@SelectedFile_callback,...
                    'Position',[handles.wd*0.08 handles.ht*0.16 handles.wd*0.85 44]); 
            
            drawnow;                            
            jb = java(findjobj(handles.SelectedFile));
            jbh = handle(jb,'CallbackProperties');
            set(jbh, 'MouseReleasedCallback',@SelectedFile_MouseReleasedCallback);

        % Define File Name Table Listbox      
        uicontrol(handles.pMarker1,'Style','Text','FontSize',12,'String',{'Select file from list'},'FontWeight','Bold',...
                    'BackgroundColor','black','ForegroundColor','white','HorizontalAlignment','left',...
                    'Position',[handles.wd*0.08 handles.ht*0.8 handles.wd*0.45 20]); 
        uicontrol(handles.pMarker1,'Style','Text','FontSize',12,'String','1)','FontWeight','Bold',...            
                    'BackgroundColor','black','ForegroundColor','white',...
                    'Position',[handles.wd*0.05 handles.ht*0.8 20 20]); 
        handles.FileNames = uicontrol(handles.pMarker1,'Style','listbox','FontSize',10,'Max',1,... 
                    'callback',@FileNames_callback,...
                    'Position',[handles.wd*0.08 handles.ht*0.35 handles.wd*0.45 handles.ht*0.45]); 

        % Define Marker Table
        uicontrol(handles.pMarker1,'Style','Text','FontSize',12,'String',{' Edit marker names (e.g. DAPI, Actin)'},'FontWeight','Bold',...
                    'BackgroundColor','black','ForegroundColor','white','HorizontalAlignment','left',...
                    'Position',[handles.wd*0.60 handles.ht*0.8 handles.wd*0.45 20]); 
        uicontrol(handles.pMarker1,'Style','Text','FontSize',12,'String','3)','FontWeight','Bold',...            
                    'BackgroundColor','black','ForegroundColor','white',...
                    'Position',[handles.wd*0.57 handles.ht*0.8 20 20]); 
        handles.markerTable = uitable(handles.pMarker1,'FontSize',10,'ColumnWidth',{100,150},...
                    'ColumnEditable', logical([1 0]),'ColumnFormat', {'char','char'},...
                    'ColumnName',{'Marker Name','Filename Convention',},...
                    'CellSelectionCallback',@markerTable_CellSelectionCallback,...                        
                    'CellEditCallback',@markerTable_CellEditCallback,...
                    'Position',[handles.wd*0.60 handles.ht*0.5 handles.wd*0.33 handles.ht*0.3]); 

        % Define Preview Grouping Button
        handles.PreviewGroup = uicontrol(handles.pMarker1,'FontSize',10,'String','Preview Image Grouping',...
                    'callback',@PreviewGroup_callback,...
                    'Position',[handles.wd*0.60 handles.ht*0.43 handles.wd*0.17 25]);

        % Create Marker Done Button
        uicontrol(handles.pMarker1,'String','Done','FontSize',12,'FontWeight','Bold',...
                    'callback',@markerDone_callback,...
                    'Position',[handles.wd*0.4 handles.ht*0.025 handles.wd*0.2 40]); 
        if(handles.multichannel) 
          turnOnBorder(handles.markerTable);      
          turnOffBorder(handles.FileNames);
        else
          turnOffBorder(handles.markerTable);      
          turnOnBorder(handles.FileNames);
        end
        
        handles.showEx = false;

        % Populate tables, filename list, and selected file with
        % current data
        
        set(handles.markerTable,'Data',handles.markerDB) 

        jTable = findjobj(handles.markerTable);
        jScroll = jTable.getComponent(0);
        jTable = jScroll.getComponent(0);

        jTable.setNonContiguousCellSelection(0);
        jTable.setColumnSelectionAllowed(1);
        jTable.setRowSelectionInterval(0,size(handles.markerDB,1)-1);
        jTable.setColumnSelectionInterval(0,0);       
        jTable.setSelectionBackground(Color(27/255,161/255,226/255));

        handles.currName = handles.origfileName{1};

        % highlight markers with updated marker list
        
        
        
        if isempty(handles.markerHighlight)
            set(handles.FileNames,'String',handles.useFileNames);
        else
            set(handles.FileNames,'String',handles.markerHighlight);
        end

        jList = findjobj(handles.FileNames);
        jList = jList.getComponent(0).getComponent(0);
        jList.setSelectionBackground(Color(0.94,0.94,0.94));
        jList.setSelectionForeground(Color(0,0,0));
        
        
    else
        warndlg('Define Root Directory and Image Extension!',handles.title)
    end
        
        
    function SelectedFile_callback(hObject,~,~)    
        % Triggeres with edit box is changed
        % resets contents in edit box to original filename string in case
        % of change
        set(hObject,'String',handles.currName);          
        setappdata(0,'handles',handles);       
    end

    function SelectedFile_MouseReleasedCallback(~,~,~)
        % Triggers on a mouse release in the Edit box
        % grabs the highlighted selected text
        try  
        drawnow;
        if ~handles.multichannel
            
            if isMultipleCall()
                return;
            end
            
            handles.fileIdx = get(handles.FileNames,'Value');

            jEdit = findjobj(handles.SelectedFile);
            handles.currPattern = char(jEdit.getSelectedText());

            handles.selStart = jEdit.getSelectionStart()+1;
            handles.selEnd = jEdit.getSelectionEnd();

            if handles.selStart<=handles.selEnd
                numFolders = length(handles.nameGroups{handles.fileIdx,:});
                numFolderArray = cellfun(@(x) length(x),handles.nameGroups);
                validFolderIdx = (numFolderArray==numFolders);
                filteredNameGroups = handles.nameGroups(validFolderIdx,:);
                useFileNames = handles.useFileNames(validFolderIdx);
                handles.adjustedFileIdx = find(find(validFolderIdx)==handles.fileIdx);                
                handles = findPatternFeat(handles,filteredNameGroups);                
                if ~handles.patternError                 

                    import java.awt.Color;
                    import java.awt.Point;
                                        
                    nameGroups = reshape([filteredNameGroups{:}],length(filteredNameGroups{1}),length(filteredNameGroups));
                    handles.fileGroups = nameGroups(handles.foldIdx+1,:)';
                    [handles.sepIdx handles.matchstr handles.splitstr] = regexp(handles.fileGroups,'[!-.:-@{-~\[\]-`]','start','match','split');
                    
                    sepNumArray = cellfun(@(x) length(x),handles.sepIdx);
%                     if handles.entireFolder
%                         validSep = true(size(sepNumArray));
%                     else
%                         validSep = sepNumArray==handles.numSep;
%                     end
%                     handles.filteredNameGroups = filteredNameGroups(validSep,:);
%                   handles.sepIdx = handles.sepIdx(validSep,:);
%                     handles.matchstr = handles.matchstr(validSep,:);
%                     handles.splitstr = handles.splitstr(validSep,:);
%                     handles.fileGroups = handles.fileGroups(validSep,:);
%                     handles.filteredFileName = useFileNames(validSep);
                    handles.filteredNameGroups = filteredNameGroups;
                    handles.filteredFileName = useFileNames();
                    handles = findPatternInSet(handles);                    
                    
%                     temp = handles.filenameHighlight;
%                     fileGroupHighlight = useFileNames;
%                     fileGroupHighlight(validSep) = temp;

                    fileGroupHighlight= handles.filenameHighlight;
                    
                    
                    handles.filenameHighlight = handles.useFileNames;
                    handles.filenameHighlight(validFolderIdx) = fileGroupHighlight;

                    set(handles.FileNames,'String',handles.filenameHighlight);

                    
                    handles.markerDB = cell(max(length(handles.filtName),1),2);
                    handles.markerDB(:) = cellstr('');
                    if isempty(handles.filtName)
                        temp = cellstr('');
                    else
                        temp = handles.filtName;
                    end
                        
                    handles.markerDB(:,1) = temp;
                    handles.markerDB(:,2) = temp;
                    handles.numMarkers = size(handles.markerDB,1);
                    set(handles.markerTable,'Data',handles.markerDB,'ColumnEdit',logical([1 0]));  
                   
                    jTable = findjobj(handles.markerTable);
                    jScroll = jTable.getComponent(0);
                    jTable = jScroll.getComponent(0);
                    
                    jTable.setNonContiguousCellSelection(0);
                    jTable.setColumnSelectionAllowed(1);                    
                    jTable.setRowSelectionInterval(0,max(size(handles.markerDB,1)-1,0));
                    jTable.setColumnSelectionInterval(0,0);       
                    jTable.setSelectionBackground(Color(27/255,161/255,226/255));

                    handles.markerKey = handles.patternsFound;
                    handles.markerHighlight = handles.filenameHighlight;
                    
                    handles.metaDB = [];
                    handles.currfeatDBdata = [];
                    handles.groupMetaDB = [];            
                    handles.groupNames = {};
                    set(handles.metadataButton,'Visible','off');
                    set(handles.metadataCheck,'visible','off')  

                    set(handles.metafileButton,'Visible','off');
                    set(handles.metafileCheck,'visible','off');
                    
                    turnOffBorder(handles.SelectedFile);
                    turnOnBorder(handles.markerTable);
                    close(handles.wbar);  
                end
            end            
        end
        setappdata(0,'handles',handles);
        catch err
                errordlg('Could not extract information from filenames. Try renaming files to use equal number of common separators such as .,-,_ and so on. Alternately, directly define a metadata file');
                rethrow(err);
        end
    end
   
    function markerTable_CellEditCallback(hObject, eventdata, ~)
        % Triggers when marker cell has been edited 
        drawnow;
        
        jTable = findjobj(hObject);
        jTable = jTable.getComponent(0).getComponent(0);
        jTable.setColumnSelectionAllowed(1);
        
        
        handles.markerRow = eventdata.Indices(1);
        handles.markerCol = eventdata.Indices(2);
        newValue = eventdata.EditData;
        handles.markerDB{handles.markerRow,handles.markerCol} = newValue;
                        
        % update number of markers
        set(handles.markerTable,'Data',handles.markerDB);
        setappdata(0,'handles',handles);
    end

    function markerTable_CellSelectionCallback(~, eventdata, ~)
        % Triggers when cell has been selected in marker table
        
        % grab current index for current cell selection
        if numel(eventdata.Indices)
            handles.markerIDRow = eventdata.Indices(1);
            handles.markerRow = eventdata.Indices(1);
            handles.markerCol = eventdata.Indices(2);
        end
        setappdata(0,'handles',handles);
    end

    function FileNames_callback(hObject, ~, ~)
        % Triggers when filename is selected from file list and updates
        % selected file edit box                
        handles.currName = handles.useFileNames{get(hObject,'Value'),1};        
        set(handles.SelectedFile,'String',handles.currName); 
        
        import java.awt.Color;
        jList = findjobj(handles.FileNames);
        jList = jList.getComponent(0).getComponent(0);
        jList.setSelectionBackground(Color(27/255,161/255,226/255));
        jList.setSelectionForeground(Color(1,1,1));
        
        turnOffBorder(handles.FileNames);
        turnOffBorder(handles.markerTable);
        turnOnBorder(handles.SelectedFile);
        
        setappdata(0,'handles',handles);      
    end

    function PreviewGroup_callback(~, ~, ~)
        % Triggers when Preview Group button is pressed
        
        % Create new figure/panel/table for preview display
        if ~handles.multichannel
            handles.figPreview = figure(108); % Marker Grouping Preview Figure
            set(handles.figPreview,'Position',[handles.px*1.25 handles.py*1.25 handles.wd*0.7 handles.ht*0.7],...
                'MenuBar','none','Resize','off','Name',handles.title,'NumberTitle','off');        

            pPreview = uipanel('Parent',handles.figPreview);
            tpos = [0 0 handles.wd*0.7 handles.ht*0.7];
            handles.groupTablePreview = uitable(pPreview,'FontSize',10,'Position',tpos); 

            % Groups images by marker annotations
            handles.groupedDB = cell(ceil(size(handles.filteredNameGroups,1)/handles.numMarkers),handles.numMarkers);        
            for k = 1:handles.numMarkers
                markedList = handles.filteredFileName(~cellfun('isempty',regexp(handles.markerKey,['^' handles.markerDB{k,2} '$'])));
                handles.groupedDB(1:length(markedList),k) = markedList;
            end
            validRows = any(~cellfun('isempty',handles.groupedDB),2);
            handles.groupedDB = handles.groupedDB(validRows,:);
            
            previewData = handles.groupedDB;
            badIdx = cellfun('isempty',previewData);
            previewData(badIdx) = cellstr('<html><font color="red">NO MATCH!');
            if sum(badIdx(:))>0
                warndlg({'Inconsistent groupings!','Images with missing biomarkers will be removed!'},handles.title)
            end
            
            
            set(handles.groupTablePreview,'Data',previewData);

            % Auto adjust column size to string size
            maxLen = zeros(1,size(handles.groupedDB,2));
            for k = 1:size(handles.groupedDB,2)
                maxLen(k) = max(cellfun('length',handles.groupedDB(:,k)))*7;
            end

            cwidth = num2cell(maxLen);
            cedit = false(1,handles.numMarkers);
            cfmt = cell(1,handles.numMarkers);
            cfmt(:) = {'char'};
            cname = cell(1,handles.numMarkers);
            cname(:) = handles.markerDB(1:handles.numMarkers,1);
            set(handles.groupTablePreview,'ColumnWidth',cwidth,'ColumnEdit',cedit,...
                'ColumnFormat',cfmt,'ColumnName',cname);
        end
        setappdata(0,'handles',handles);
    end  

    function markerDone_callback(~,~,~)
        % Triggers when done button is pressed
                
        % Close marker figure and all help figures
        close(handles.figMarker);
        
        if any(cellfun('isempty',handles.markerDB(:,1)))
            warndlg('Assuming only one marker',handles.title);
            handles.groupedDB = handles.useFileNames;
            handles.filteredNameGroups = regexp(handles.groupedDB(:,1),'/','split');
        else            
            if ~handles.multichannel
                % Groups images by marker annotation in case preview was not used
                handles.groupedDB = cell(ceil(size(handles.filteredNameGroups,1)/handles.numMarkers),handles.numMarkers);
                for k = 1:handles.numMarkers
                    markedList = handles.filteredFileName(~cellfun('isempty',regexp(handles.markerKey,['^' handles.markerDB{k,2} '$'])));
                    handles.groupedDB(1:length(markedList),k) = markedList;
                end               
            else
                handles.groupedDB = handles.useFileNames;                
            end
            
            handles.groupedDB = handles.groupedDB(all(~cellfun('isempty',handles.groupedDB),2),:);
            
            handles.filteredNameGroups = regexp(handles.groupedDB(:,1),'/','split');
        end
        setappdata(0,'handles',handles);
    end   
    
    function showMarkerExample_callback(~,~,~)
        % Triggers when show example checkbox value is changed
        
        handles.showMarkerEx = ~handles.showMarkerEx;
        
        if handles.showMarkerEx
            if ~isfield(handles,'figExample')
                handles.figExample = figure(106); % Main Example Figure
            else
                figure(handles.figExample)
            end
            set(handles.figExample,'MenuBar','none','Resize','off','Name','Example','NumberTitle','off');
            set(handles.figExample,'Position',[600 75 900 700]);
            set(handles.figExample,'Visible','on','CloseRequestFcn',@markerEx_CloseRequestFcn);
            pEx = uipanel('Parent',handles.figExample,'Position',[0 0 1 1],'BackgroundColor','black');
            set(pEx,'visible','on');
            
            axes('Parent',pEx,'Position',[0 0 1 1 ]);
            imshow(handles.imMarkerEx)

        else
            close(handles.figExample)
        end
        setappdata(0,'handles',handles);
    end
   
    function markerEx_CloseRequestFcn(~,~,~)
        delete(handles.figExample); 
        handles.showMarkerEx = 0;   
        setappdata(0,'handles',handles);    
    end
    
    function figClose_CloseRequestFcn(~,~,~)
     	
        if gcf==handles.figMain
            delete(handles.figMain)            
            rootDir = handles.rootDir;
            save('phenoLoaderProp.mat','rootDir');
        else
            figure(handles.figMain);
        end
        
        if ishandle(handles.figRoot)
            delete(handles.figRoot);
            if isfield(handles,'useFileNames')
                set(handles.markerButton,'Visible','on');
                set(handles.rootCheck,'visible','on')                
            else
                set(handles.rootCheck,'visible','off')  
                
                set(handles.markerButton,'Visible','off');
                set(handles.markerCheck,'visible','off');                
                                
                set(handles.metadataButton,'Visible','off');
                set(handles.metadataCheck,'visible','off')  
                
                set(handles.metafileButton,'Visible','off');
                set(handles.metafileCheck,'visible','off');
            end
        end
        
        if ishandle(handles.figMarker)
            if any(cellfun('isempty',handles.markerDB(1:end-1,1)))                
                handles.numMarkers = [];
                handles.markerDB = cell(1,2);
                handles.markerDB(:) = cellstr('');                
                handles.markerHighlight = {};
            end
            delete(handles.figMarker);
            handles.showMarkerEx = 0;
            if isfield(handles,'figPreview')
                if ishandle(handles.figPreview)
                    delete(handles.figPreview);
                end
            end
            
            if isfield(handles,'useFileNames') && ~isempty(handles.numMarkers)
                set(handles.metadataButton,'Visible','on');
                set(handles.markerCheck,'visible','on');
            else
                set(handles.markerCheck,'visible','off');
                
                set(handles.metadataButton,'Visible','off');
                set(handles.metadataCheck,'visible','off')  
                
                set(handles.metafileButton,'Visible','off');
                set(handles.metafileCheck,'visible','off');
            end
           
        end
        
        if ishandle(handles.figMeta)
            delete(handles.figMeta);
            handles.showMeta1Ex = 0;
            handles.showMeta2Ex = 0;
            if isfield(handles,'numMarkers') && isfield(handles,'groupedDB')
                set(handles.metafileButton,'Visible','on');
                set(handles.metadataCheck,'visible','on');
            else
                set(handles.metadataCheck,'visible','off');
                
                set(handles.metafileButton,'Visible','off');
                set(handles.metafileCheck,'visible','off');
            end
        end
        
        if ishandle(handles.figGenMeta)
            delete(handles.figGenMeta);
            if isfield(handles,'writeStatus')
                if handles.writeStatus
                    set(handles.metafileCheck,'visible','on');
                else
                    set(handles.metafileCheck,'visible','off');
                end
            else
                set(handles.metafileCheck,'visible','off');
            end
        end
        
        if isfield(handles,'figExample')
            if ishandle(handles.figExample)
                delete(handles.figExample);
            end
        end
        
        if isfield(handles,'figMeta1')
            if ishandle(handles.figMeta1)
                delete(handles.figMeta1);
            end
        end
        
        if isfield(handles,'figMeta2')
            if ishandle(handles.figMeta2)
                delete(handles.figMeta2);
            end
        end
        
        if isfield(handles,'figInput')
            if ishandle(handles.figInput)
                delete(handles.figInput);
            end
        end        
        
        setappdata(0,'handles',handles);
    end
   
    setappdata(0,'handles',handles);
end
