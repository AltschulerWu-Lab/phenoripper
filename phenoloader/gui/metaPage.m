function metaPage
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

    % Check that the Directory and Markers Steps have been completed
    if isfield(handles,'useFileNames') && ~isempty(handles.numMarkers)
        
        import java.awt.Color;
        
        % Create Meta figure/panels
        handles.figMeta = figure(104); % Meta Figure
        set(handles.figMeta,'Position',[handles.px handles.py handles.wd handles.ht],'Visible','on',...
            'MenuBar','none','Resize','off','Name',handles.title,'NumberTitle','off',...
            'CloseRequestFcn',@figClose_CloseRequestFcn);
        handles.pMeta1 = uipanel('Parent',handles.figMeta,'Visible','on',...
            'Position',[0 0 1 1],'BackgroundColor','black');
        handles.pMeta2 = uipanel('Parent',handles.figMeta,'Visible','off',...
            'Position',[0 0 1 1],'BackgroundColor','black');        

    % Meta1 Panel
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Page Title
        uicontrol(handles.pMeta1,'Style','Text','FontSize',20,'String','Extract Groups From Filename',...
                    'FontWeight','Bold','BackgroundColor','black','ForegroundColor','white',...
                    'Position',[handles.wd*0.2 handles.ht*0.89 handles.wd*0.6 40]);

        % Create push button for File Attribute Example
        handles.showMeta1Example = uicontrol(handles.pMeta1,'Style','pushbutton','FontSize',10,...
                    'String','Show/Hide Example',...                        
                    'callback',@showMeta1Example_callback,...
                    'Position',[10 450 150 40]);

        % Define File Name Table Text/Listbox
        uicontrol(handles.pMeta1,'Style','Text','FontSize',12,'FontWeight','Bold','String','1)',...            
                    'BackgroundColor','black','ForegroundColor','white','HorizontalAlignment','left',...
                    'Position',[handles.wd*0.03 handles.ht*0.80 20 20]); 
        uicontrol(handles.pMeta1,'Style','Text','FontSize',12,'FontWeight','Bold','String','Select file from list',...            
                    'BackgroundColor','black','ForegroundColor','white','HorizontalAlignment','left',...
                    'Position',[handles.wd*0.06 handles.ht*0.80 325 20]);        
        handles.FileNames2 = uicontrol(handles.pMeta1,'Style','listbox','FontSize',10,... 
                    'callback',@FileNames2_callback,...
                    'Position',[handles.wd*0.06 handles.ht*0.35 handles.wd*0.4 handles.ht*0.45]); 

        % Define File Select Text/Edit Box
        uicontrol(handles.pMeta1,'Style','Text','FontSize',12,'FontWeight','bold','String','2)',...
                    'BackgroundColor','black','ForegroundColor','white',...
                    'Position',[handles.wd*0.03 handles.ht*0.25 15 20]);
        uicontrol(handles.pMeta1,'Style','Text','FontSize',12,'FontWeight','Bold','String','Use mouse to select group in filename (e.g. B16, Tile01, r3, etc.)',...
                    'BackgroundColor','black','ForegroundColor','white','HorizontalAlignment','left',...
                    'Position',[handles.wd*0.06 handles.ht*0.25 handles.wd*0.89 20]);

        handles.SelectedFile2 = uicontrol(handles.pMeta1,'Style','edit','FontSize',12,...                      
                    'callback',@SelectedFile2_callback,...
                    'Position',[handles.wd*0.06 handles.ht*0.15 handles.wd*0.89 44]);      

            % handles used to retrieve indices of selection in Edit box
            drawnow;
            jb = java(findjobj(handles.SelectedFile2));
            jbh = handle(jb,'CallbackProperties');
            set(jbh, 'MouseReleasedCallback',@SelectedFile2_MouseReleasedCallback);                              

        uicontrol(handles.pMeta1,'Style','Text','FontSize',12,'FontWeight','Bold','String','Groups',...
                    'BackgroundColor','black','ForegroundColor','white',...
                    'Position',[handles.wd*0.6 handles.ht*0.80 handles.wd*0.2 handles.ht*0.05]);     

        if ~isempty(handles.currfeatDBdata)
            dropString = handles.groupNames;
        else
            dropString = ' ';
        end
        handles.currFeatDropdown = uicontrol(handles.pMeta1,'Style','popup','String',dropString,'FontSize',10,'Position',[handles.wd*0.6 handles.ht*0.75 handles.wd*0.2 handles.ht*0.05],...
                    'callback',@currFeatDropdown_callback);
        handles.currFeatList = uicontrol(handles.pMeta1,'Style','Listbox','FontSize',10,'Position',[handles.wd*0.6 handles.ht*0.34 handles.wd*0.20 handles.ht*0.4],'Enable','inactive');
        uicontrol(handles.pMeta1,'String','rename/delete','FontSize',10,'Position',[handles.wd*0.81 handles.ht*0.75 handles.wd*0.1 handles.ht*0.05],...
                    'callback',@groupRenameDelete_callback);

        % Create Meta Done button
        uicontrol(handles.pMeta1,'String','Done','FontSize',12,'FontWeight','Bold',...
                    'callback',@metaDone_callback,...
                    'Position',[handles.wd*0.4 handles.ht*0.025 handles.wd*0.2 40]);     

        % Create Next button for meta1->meta2
        handles.nextMeta12 = uicontrol(handles.pMeta1,'String','Add additional information','FontSize',12,'FontWeight','Bold',...
                    'callback',@nextMeta12_callback,...
                    'Position',[handles.wd*0.825 handles.ht*0.025 150 40]);     
        str = '<html>Continue if you wish to add more<br>metadata with your groups';
        set(handles.nextMeta12,'tooltipString',str);

    % Meta2 Panel
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Page Title
        uicontrol(handles.pMeta2,'Style','Text','FontSize',20,'String','Add Additional Metadata',...
                    'FontWeight','Bold','BackgroundColor','black','ForegroundColor','white',...
                    'Position',[handles.wd*0.2 handles.ht*0.89 handles.wd*0.6 40]);

        % Create push button for File Attribute Example
        handles.showMeta2Example = uicontrol(handles.pMeta2,'Style','pushbutton','FontSize',10,...
                    'String','Show/Hide Example',...
                    'callback',@showMeta2Example_callback,...
                    'Position',[10 450 150 40]);

        % Define Group Text/Table            
        uicontrol(handles.pMeta2,'Style','Text','FontSize',12,'FontWeight','Bold','String','Group',...
                    'BackgroundColor','black','ForegroundColor','white','HorizontalAlign','Left',...
                    'Position', [handles.wd*0.1 handles.ht*0.8 handles.wd*0.2 handles.ht*0.05]);
        if ~isempty(handles.currfeatDBdata)
            dropString = handles.groupNames;
        else
            dropString = ' ';
        end
        handles.GroupList = uicontrol(handles.pMeta2,'Style','popup','String',dropString,'FontSize',10,'Position',[handles.wd*0.1 handles.ht*0.75 handles.wd*0.2 handles.ht*0.05],...
                    'callback',@GroupList_callback);

        % Define Pattern Meta Text/Table
        handles.PatternMetaTable_tpos = [handles.wd*0.1 handles.ht*0.15 handles.wd*0.8 handles.ht*0.55];
        handles.PatternMetaTable = uitable(handles.pMeta2,'FontSize',10,'Position',handles.PatternMetaTable_tpos,...
                'KeyPressFcn',@PatternMetaTable_KeyPressFcn,...
                'CellEditCallback',@PatternMetaTable_CellEditCallback);

            jPatternTable = findjobj(handles.PatternMetaTable);            
            jTable2 = jPatternTable.getComponent(3).getComponent(0);      
            hjtable = handle(jTable2,'CallbackProperties');
            set(hjtable,'MouseReleasedCallback',@PatternMetaTable_MouseReleasedCallback);


        % Define Add Column Button                   
        uicontrol(handles.pMeta2,'String','Add Metadata Group','FontSize',10,...
                    'callback',@AddColumn_callback,...
                    'Position',[handles.wd*0.35 handles.ht*0.75 handles.wd*0.15 handles.ht*0.05]); 

        % Create Back Button for meta2->meta1
        uicontrol(handles.pMeta2,'String','<<<Back','FontSize',12,'FontWeight','Bold',...
                    'callback',@backMeta21_callback,...
                    'Position',[handles.wd*0.01 handles.ht*0.025 100 40]);          

        % Create Meta Done button
        uicontrol(handles.pMeta2,'String','Done','FontSize',12,'FontWeight','Bold',...
                    'callback',@metaDone_callback,...
                    'Position',[handles.wd*0.4 handles.ht*0.025 handles.wd*0.2 40]);          
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        handles.showEx1 = false;
        handles.showEx2 = false;

        % Populate filename list with images containing only the 1st marker
        set(handles.FileNames2,'Value',length(handles.FileNames2));
        set(handles.FileNames2,'str',handles.groupedDB(:,1));     

        cname = cell(1,length(handles.groupNames));
        for x = 1:length(handles.groupNames)
            cname(x) = cellstr(['<html><font size=+1><b>' handles.groupNames{x}]);
        end

        % Populate annotation table with current data
        if ~isempty(handles.currfeatDBdata)
            val = get(handles.currFeatDropdown,'Value');
            temp = handles.currfeatDBdata(:,val);
            temp = temp(~cellfun('isempty',temp));
            set(handles.currFeatList,'String',temp)
        end
        
        jList = findjobj(handles.FileNames2);
        jList = jList.getComponent(0).getComponent(0);
        jList.setSelectionBackground(Color(0.94,0.94,0.94));
        jList.setSelectionForeground(Color(0,0,0));
        
        turnOffBorder(handles.SelectedFile2);
        turnOnBorder(handles.FileNames2);
        
    else
        warndlg('Define Markers!',handles.title)
    end
        
        
        
    % handles.pMeta1 panel    
    function FileNames2_callback(hObject, ~, ~)     
        % Triggers on selection of filename from list
        handles.currName = handles.groupedDB{get(hObject,'Value'),1};        
        set(handles.SelectedFile2,'String',handles.currName);
        
        import java.awt.Color;
        jList = findjobj(handles.FileNames2);
        jList = jList.getComponent(0).getComponent(0);
        jList.setSelectionBackground(Color(27/255,161/255,226/255));
        jList.setSelectionForeground(Color(1,1,1));
        
        turnOnBorder(handles.SelectedFile2);
        turnOffBorder(handles.FileNames2);
        
        setappdata(0,'handles',handles);
    end

    function SelectedFile2_callback(hObject,~,~)   
        % Triggers when Edit box for selected file is change
        % reverts change of text to original string
        set(hObject,'String',handles.currName);
        setappdata(0,'handles',handles);
    end

    function SelectedFile2_MouseReleasedCallback(~,~,~)  
        % Triggers on a mouse release of the edit box
        % Grabs the index of selection in edit box
        drawnow;
        
        if isMultipleCall()
            return;
        end
        
        if isfield(handles,'figInput')
            if ishandle(handles.figInput)
                figure(handles.figInput)
                return;
            end
        end
        
        handles.fileIdx = get(handles.FileNames2,'Value');
        handles.adjustedFileIdx = handles.fileIdx;

        jEdit = findjobj(handles.SelectedFile2);
        handles.currPattern = char(jEdit.getSelectedText());

        handles.selStart = jEdit.getSelectionStart()+1;
        handles.selEnd = jEdit.getSelectionEnd();        

        if handles.selStart<=handles.selEnd
            handles = findPatternFeat(handles,handles.filteredNameGroups); 
            if ~handles.patternError
                nameGroups = reshape([handles.filteredNameGroups{:}],length(handles.filteredNameGroups{1}),length(handles.filteredNameGroups));
                handles.fileGroups = nameGroups(handles.foldIdx+1,:)';
                [handles.sepIdx handles.matchstr handles.splitstr] = regexp(handles.fileGroups,'[!-.:-@{-~\[\]-`]','start','match','split');
                handles = findPatternInSet(handles);

                set(handles.FileNames2,'String',handles.filenameHighlight);

                handles.currfeatDBtemp = handles.filtName;                 
                
                handles.addingNewGroup = 1;

                if isfield(handles,'figInput')
                    if ~ishandle(handles.figInput)
                        handles.figInput = figure(109); % Dialog input
                    end
                else
                    handles.figInput = figure(109);
                end
                handles.colSel = 0;
                set(handles.figInput,'Position',[800-200/2 450-100/2 200 100],'MenuBar','none','Resize','off','Name',handles.title,'NumberTitle','off',...
                    'Color',[0 0 0]);
                uicontrol('Parent',handles.figInput,'Style','Text','String','Enter Group Name:','FontSize',11,...
                    'BackgroundColor','black','ForegroundColor','white','Position',[10 80 180 20])
                uicontrol('Parent',handles.figInput,'String','OK','Position',[10 10 30 30],'callback',@ok1Button_callback);
                uicontrol('Parent',handles.figInput,'String','Cancel','Position',[50 10 50 30],'callback',@cancelButton_callback);                
                handles.groupLabelEdit = uicontrol('Parent',handles.figInput,'Style','Edit','BackgroundColor','white','Position',[10 50 180 30],...
                    'KeyPressFcn',@groupLabelEdit_KeyPressFcn);
                drawnow
                jEdit = findjobj(handles.groupLabelEdit);
                jEdit.grabFocus();
                close(handles.wbar)
            end
        end
        setappdata(0,'handles',handles);
    end

    function currFeatDropdown_callback(hObject,~,~)
        val = get(hObject,'Value');
        temp = handles.currfeatDBdata(:,val);
        temp = temp(~cellfun('isempty',temp));
        set(handles.currFeatList,'String',temp)
        setappdata(0,'handles',handles);
    end

    function groupRenameDelete_callback(~,~,~)
        if isfield(handles,'figInput')
            if ~ishandle(handles.figInput)
                handles.figInput = figure(109); % Dialog Input
            end
        else
            handles.figInput = figure(109);
        end


        set(handles.figInput,'Position',[800-200/2 450-100/2 200 100],'MenuBar','none','Resize','off','Name',handles.title,'NumberTitle','off',...
            'Color',[0 0 0]);
        uicontrol('Parent',handles.figInput,'Style','Text','String','Enter Group Name:','FontSize',11,...
            'BackgroundColor','black','ForegroundColor','white','Position',[10 80 180 20])
        handles.groupLabelEdit = uicontrol('Parent',handles.figInput,'Style','Edit','BackgroundColor','white','Position',[10 50 180 30],...
            'KeyPressFcn',@groupLabelEdit_KeyPressFcn);
        uicontrol('Parent',handles.figInput,'String','OK','Position',[10 10 30 30],'callback',@ok1Button_callback);
        uicontrol('Parent',handles.figInput,'String','Cancel','Position',[50 10 50 30],'callback',@cancelButton_callback);
        uicontrol('Parent',handles.figInput,'String','Delete Column','Position',[110 10 80 30],'callback',@del1Button_callback);                      
        jEdit = findjobj(handles.groupLabelEdit);        
        if length(jEdit)==1
            jEdit.grabFocus();
        end
        setappdata(0,'handles',handles);
    end

    function groupLabelEdit_KeyPressFcn(~,eventdata,~)
        if regexp(eventdata.Key,'^return$')
            drawnow;
            ok1Button_callback;
        end
    end

    function ok1Button_callback(~,~,~)

        labelName = get(handles.groupLabelEdit,'String');
        if ~isempty(labelName) 
            if handles.addingNewGroup

                % only add patterns in group that are not already in metaDB
                currfeatidx = zeros(size(handles.currfeatDBtemp,1),1);
                if ~isempty(handles.metaDB)
                    for k = 1:size(handles.currfeatDBtemp,1)
                        match = regexp(handles.metaDB(:,1),['^' handles.currfeatDBtemp{k,1} '$'],'match');
                        currfeatidx(k) = all(cellfun('isempty',match));
                    end            
                    handles.currfeatDBtemp = handles.currfeatDBtemp(logical(currfeatidx),:);
                end


                % add new group name
                if isempty(handles.groupNames)
                    handles.groupNames = cellstr(labelName);
                else
                    handles.groupNames = [cellstr(labelName); handles.groupNames];
                end


                handles.currfeatDBtemp = [handles.currfeatDBtemp; cellstr('')];
                if isempty(handles.currfeatDBdata)
                    handles.currfeatDBdata = handles.currfeatDBtemp;
                else
                    currFeatNum = size(handles.currfeatDBdata,1);
                    if length(handles.currfeatDBtemp)<currFeatNum
                        handles.currfeatDBtemp = [handles.currfeatDBtemp; repmat(cellstr(''),currFeatNum-length(handles.currfeatDBtemp),1)];
                        handles.currfeatDBdata = [handles.currfeatDBtemp handles.currfeatDBdata];
                    else
                        handles.currfeatDBdata = [handles.currfeatDBdata; repmat(cellstr(''),length(handles.currfeatDBtemp)-currFeatNum,size(handles.currfeatDBdata,2))];
                        handles.currfeatDBdata = [handles.currfeatDBtemp handles.currfeatDBdata];                    
                    end
                end

                set(handles.currFeatDropdown,'String',handles.groupNames,'Value',1)
                temp = handles.currfeatDBdata(:,1);
                temp = temp(~cellfun('isempty',temp));
                set(handles.currFeatList,'String',temp)                    
            end

            val = get(handles.currFeatDropdown,'Value');
            handles.prevName = handles.groupNames{val};
            handles.groupNames{val} = labelName;

            set(handles.currFeatDropdown,'String',handles.groupNames,'Value',val);
            handles.labelstr = labelName;


            % update metaDB with new metagroup
            handles.currfeatDBtemp = handles.currfeatDBtemp(~cellfun('isempty',handles.currfeatDBtemp));

            if isempty(handles.metaDB)
                numMatch = size(handles.currfeatDBtemp,1);
                temp = [handles.currfeatDBtemp repmat(cellstr(handles.labelstr),numMatch,1) repmat({handles.foldIdx},numMatch,1)];
                handles.metaDB = temp;
            else
                idx = ~cellfun('isempty',regexp(handles.metaDB(:,2),['^' handles.prevName '$']));                        
                if all(~idx)
                    numMatch = size(handles.currfeatDBtemp,1);
                    temp = [handles.currfeatDBtemp repmat(cellstr(handles.labelstr),numMatch,1) repmat({handles.foldIdx},numMatch,1) repmat(cellstr(''),numMatch,size(handles.metaDB,2)-3)];
                    handles.metaDB = [handles.metaDB; temp];
                else                                
                    numMatch = sum(idx);
                    handles.metaDB(idx,2) = repmat(cellstr(handles.labelstr),numMatch,1);
                end
            end 

            % Expands groupMetaDB with new groupNames and associating metadata
            temp = [handles.groupNames cell(size(handles.groupNames,1),2)];
            if handles.addingNewGroup
                temp(val,3) = {handles.patternsFound};
                if isempty(handles.groupMetaDB)
                    handles.groupMetaDB = temp;
                else
                    for k = 1:size(temp,1)
                        idx = ~cellfun('isempty',regexp(handles.groupMetaDB(:,1),['^' temp{k,1} '$']));
                        if any(idx)
                            temp(k,2:end) = handles.groupMetaDB(idx,2:end);                    
                        end
                    end
                    handles.groupMetaDB = temp;
                end
                handles.addingNewGroup = 0;
            else
                handles.groupMetaDB(val,1) = handles.groupNames(val);
            end
                
            

            close(handles.figInput);        
            figure(handles.figMeta);

        else
            warndlg('Enter a Group Name!');
        end
        setappdata(0,'handles',handles);
    end

    function cancelButton_callback(~,~,~)
        close(handles.figInput);    
        figure(handles.figMeta);
        setappdata(0,'handles',handles);
    end

    function del1Button_callback(~,~,~)
        if ~handles.addingNewGroup
            val = get(handles.currFeatDropdown,'Value');

            groupToDel = handles.groupNames{val};
            keepIdx = true(1,length(handles.groupNames));
            keepIdx(val) = false;
            handles.groupNames = handles.groupNames(keepIdx);
            handles.currfeatDBdata = handles.currfeatDBdata(:,keepIdx);
            cutIdx = find(all(cellfun('isempty',handles.currfeatDBdata)==1,2),1);
            handles.currfeatDBdata = handles.currfeatDBdata(1:cutIdx,:);

            handles.metaDB = handles.metaDB(cellfun('isempty',regexp(handles.metaDB(:,2),['^' groupToDel '$'])),:);
            handles.groupMetaDB = handles.groupMetaDB(cellfun('isempty',regexp(handles.groupMetaDB(:,1),['^' groupToDel '$'])),:);

            if val>length(handles.groupNames)
                val = length(handles.groupNames);
            end
            
            if isempty(handles.currfeatDBdata)
                tempList = ' ';  
                tempGroupNames = ' ';
                val = 1;
            else
                tempList = handles.currfeatDBdata(:,val);
                tempList = tempList(~cellfun('isempty',tempList));
                tempGroupNames = handles.groupNames;
            end
            
            set(handles.currFeatDropdown,'String',tempGroupNames,'Value',val)
            set(handles.currFeatList,'String',tempList);
        else
            handles.addingNewGroup = 0;
        end

        close(handles.figInput);            
        figure(handles.figMeta);
        setappdata(0,'handles',handles);
    end

    function nextMeta12_callback(~, ~, ~)
        % Triggers on next button press

        set(handles.pMeta1,'visible','off');        
        set(handles.pMeta2,'visible','on');

        import java.awt.Color;

        % update groupTable and PatternMetaTable with defined annotation
        % groups
        if isempty(handles.currfeatDBdata)
            set(handles.GroupList,'String',' ');
        else
            set(handles.GroupList,'String',handles.groupNames,'Value',1);
        end

        if ~isempty(handles.metaDB)
            handles.row = 1;
            handles.idx = ~cellfun('isempty',regexp(handles.metaDB(:,2),['^' handles.groupNames{handles.row} '$']));
            handles.patternmetaDB = handles.metaDB(handles.idx,1);

            handles.metaList = handles.groupMetaDB{handles.row,2};
            if ~isempty(handles.metaList)
                handles.patternmetaDB = [handles.patternmetaDB handles.metaDB(handles.idx,4:4+length(handles.metaList)-1)];
                set(handles.PatternMetaTable,'ColumnName', horzcat('Pattern',handles.metaList),'ColumnEdit',logical([0 ones(1,length(handles.metaList))]));
            else
                set(handles.PatternMetaTable,'ColumnName', {'Pattern'},'ColumnEdit',false);
            end

            set(handles.PatternMetaTable,'Data',handles.patternmetaDB);
        else
            set(handles.PatternMetaTable,'Data',{});
        end
        
        setappdata(0,'handles',handles);
    end

    function showMeta1Example_callback(~,~,~)
        % Triggers when show example checkbox is changed

        handles.showMeta1Ex = ~handles.showMeta1Ex;

        if handles.showMeta1Ex
            if ~isfield(handles,'figExample')
                handles.figExample = figure(106); % Main Example Figure
            else
                figure(handles.figExample)
            end
            set(handles.figExample,'MenuBar','none','Resize','off','Name','Example','NumberTitle','off');
            set(handles.figExample,'Position',[600 75 900 700]);
            set(handles.figExample,'Visible','on','CloseRequestFcn',@meta1Ex_CloseRequestFcn);
            pEx = uipanel('Parent',handles.figExample,'Position',[0 0 1 1],'BackgroundColor','black');
            set(pEx,'visible','on');

            axes('Parent',pEx,'Position',[0 0 1 1]);
            imshow(handles.imMeta1Ex)

        else
            close(handles.figExample)
        end
        setappdata(0,'handles',handles);
    end

    function meta1Ex_CloseRequestFcn(~,~,~)
           delete(handles.figExample);
           handles.showMeta1Ex = 0;
           handles.showMeta2Ex = 0;
           setappdata(0,'handles',handles);
        end

    % handles.pMeta2 panel
    function PatternMetaTable_KeyPressFcn(~, eventdata, ~)
        % Triggers when an annotation table cell is selected
        % updates metaDB with change of data

        returnHit = ~isempty(regexp(eventdata.Key,'^delete$', 'once'));
        if returnHit
            
            jPattern = findjobj(handles.PatternMetaTable);
            jTable23 = jPattern.getComponent(0).getComponent(0);
            prows = jTable23.getSelectedRows()+1;
            pcols = jTable23.getSelectedColumns()+1;
            
            pcols = pcols(pcols~=1);
            if isempty(pcols)
                return;
            end
            
            drawnow;
            tempTbl = get(handles.PatternMetaTable,'Data');
            tempTbl(prows,pcols) = cellstr('');
            handles.patternmetaDB = tempTbl;
            
            metaDBidx = find(handles.idx);
            handles.metaDB(metaDBidx(prows),pcols+2) = cellstr('');

            maxLen = zeros(1,size(handles.patternmetaDB,2));       
            for k = 1:size(handles.patternmetaDB,2)
                maxLen(k) = max(max(cellfun('length',handles.patternmetaDB(:,k)))*7,100);
            end

            cwidth = num2cell(maxLen);

            set(handles.PatternMetaTable,'Data',handles.patternmetaDB,'ColumnWidth',cwidth);

        end
        setappdata(0,'handles',handles);
    end

    function PatternMetaTable_CellEditCallback(~, eventdata, ~)
        % Triggers when an annotation table cell is selected
        % updates metaDB with change of data      
        
        if isMultipleCall()
            return;
        end
        
        jPattern = findjobj(handles.PatternMetaTable);
        jTable23 = jPattern.getComponent(0).getComponent(0);
        
        prow = jTable23.getSelectedRows()+1;
        pcol = eventdata.Indices(2);
        metaDBidx = find(handles.idx);
        handles.metaDB(metaDBidx(prow),pcol+2) = cellstr(eventdata.EditData);
        handles.patternmetaDB(prow,pcol) = cellstr(eventdata.EditData);

        maxLen = zeros(1,size(handles.patternmetaDB,2));       
        for k = 1:size(handles.patternmetaDB,2)
            maxLen(k) = max(max(cellfun('length',handles.patternmetaDB(:,k)))*7,100);
        end

        cwidth = num2cell(maxLen);

        set(handles.PatternMetaTable,'Data',handles.patternmetaDB,'ColumnWidth',cwidth);        
        setappdata(0,'handles',handles);
    end

    function PatternMetaTable_MouseReleasedCallback(~,~,~)

        if isMultipleCall()
            return;
        end
        
        if isfield(handles,'figInput')
            if ishandle(handles.figInput)
                figure(handles.figInput)
                return;
            end
        end

        import java.awt.Color;
        import java.awt.Point;

        jTableHead = findjobj(handles.PatternMetaTable);
        jTableHead = jTableHead.getComponent(3).getComponent(0);

        jTable = findjobj(handles.PatternMetaTable);
        jScroll = jTable.getComponent(0);
        jTable = jScroll.getComponent(0);

        screenPos = get(0,'PointerLocation');
        figPos = get(handles.figMeta,'Position');
        tpos = handles.PatternMetaTable_tpos;
        mousePos = screenPos-figPos(1:2)-[tpos(1) tpos(2)]-[jScroll.getX()+1 tpos(4)-jScroll.getY()+1];
        handles.colSel = jTableHead.columnAtPoint(Point(mousePos(1),mousePos(2)));

        if handles.colSel>0
            jTable.setNonContiguousCellSelection(0);
            jTable.setColumnSelectionAllowed(1);
            jTable.setRowSelectionInterval(0,size(handles.patternmetaDB,1)-1);
            jTable.setColumnSelectionInterval(handles.colSel,handles.colSel);       
            jTable.setSelectionBackground(Color(27/255,161/255,226/255));

            if isfield(handles,'figInput')
                if ~ishandle(handles.figInput)
                    handles.figInput = figure(109); % Dialog Input Figure
                end
            else
                handles.figInput = figure(109);
            end

            handles.labelAdd = 0;
            
            set(handles.figInput,'Position',[800-200/2 450-100/2 200 100],'MenuBar','none','Resize','off','Name',handles.title,'NumberTitle','off',...
                'Color',[0 0 0]);
            uicontrol('Parent',handles.figInput,'Style','Text','String','Enter Group Name:','FontSize',11,...
                'BackgroundColor','black','ForegroundColor','white','Position',[10 80 180 20])
            handles.groupLabelEdit = uicontrol('Parent',handles.figInput,'Style','Edit','BackgroundColor','white','Position',[10 50 180 30],...
                'KeyPressFcn',@groupLabelEdit2_KeyPressFcn);
            uicontrol('Parent',handles.figInput,'String','OK','Position',[10 10 30 30],'callback',@ok2Button_callback);
            uicontrol('Parent',handles.figInput,'String','Cancel','Position',[50 10 50 30],'callback',@cancelButton_callback);
            uicontrol('Parent',handles.figInput,'String','Delete Column','Position',[110 10 80 30],'callback',@del2Button_callback);                      
            jEdit = findjobj(handles.groupLabelEdit);            
            if length(jEdit)==1
                jEdit.grabFocus();
            end            
        end
        setappdata(0,'handles',handles);
    end

    function groupLabelEdit2_KeyPressFcn(~,eventdata,~)
        if regexp(eventdata.Key,'^return$')
            drawnow;
            ok2Button_callback;
        end
    end

    function ok2Button_callback(~,~,~)
        labelName = get(handles.groupLabelEdit,'String');
        if ~isempty(labelName)   
            handles.labelstr = labelName;            
            newColumnName = regexprep(handles.labelstr,' ','_');
            metagroup = cellstr(['^' newColumnName '$']);
            if isempty(handles.metaList)
                handles.metaList = {newColumnName};
                handles.patternmetaDB = [handles.patternmetaDB cell(size(handles.patternmetaDB,1),1)];
                handles.patternmetaDB(:,end) = repmat({''},size(handles.patternmetaDB,1),1);
                set(handles.PatternMetaTable,'ColumnName',horzcat('Pattern',handles.metaList),...
                    'ColumnEdit',logical([0 ones(1,length(handles.metaList))]),'Data',handles.patternmetaDB);            
            elseif all(cellfun('isempty',regexp(handles.metaList,metagroup))); 
                if handles.labelAdd
                    handles.metaList = [handles.metaList cellstr(newColumnName)];        
                    handles.patternmetaDB = [handles.patternmetaDB cell(size(handles.patternmetaDB,1),1)];
                    handles.patternmetaDB(:,end) = repmat({''},size(handles.patternmetaDB,1),1);                    
                else
                    handles.metaList(handles.colSel) = cellstr(newColumnName);        
                end

                set(handles.PatternMetaTable,'ColumnName',horzcat('Pattern',handles.metaList),...
                    'ColumnEdit',logical([0 ones(1,length(handles.metaList))]),'Data',handles.patternmetaDB);

            end

            handles.groupMetaDB(handles.row,2) = {handles.metaList};

            if ~isempty(handles.metaDB)
                lenMetalist = zeros(size(handles.groupMetaDB,1),1);
                for k = 1:size(handles.groupMetaDB,1)
                    lenMetalist(k) = length(handles.groupMetaDB{k,2});
                end
                maxMetalist = max(lenMetalist);
                if size(handles.metaDB,2)<(maxMetalist+3)
                    handles.metaDB = [handles.metaDB cell(size(handles.metaDB,1),1)];        
                end

                handles.metaDB(handles.idx,4:4+length(handles.metaList)-1) = handles.patternmetaDB(:,2:end);
            end
        end 

        close(handles.figInput);
        figure(handles.figMeta);
        setappdata(0,'handles',handles);
    end

    function del2Button_callback(~,~,~)
        % Triggers when remove delete button is clicked
        % Searches for column with specified name and deletes the column

        idx = true(1,length(handles.metaList));
        idx(handles.colSel) = false;
        handles.metaList = handles.metaList(idx);
        handles.patternmetaDB = handles.patternmetaDB(:,[true idx]);
        set(handles.PatternMetaTable,'ColumnName',horzcat('Pattern',handles.metaList),...
                'ColumnEdit',logical([0 ones(1,length(handles.metaList))]),...
                'Data',handles.patternmetaDB);

        handles.groupMetaDB(handles.row,2) = {handles.metaList};

        handles.metaDB(handles.idx,4:4+length(handles.metaList)-1) = handles.patternmetaDB(:,2:end);            

        % re-adjust metaDB to fit maximum meta label length
        if ~isempty(handles.metaDB)
            lenMetalist = zeros(size(handles.groupMetaDB,1),1);
            for k = 1:size(handles.groupMetaDB,1)
                lenMetalist(k) = length(handles.groupMetaDB{k,2});
            end
            maxMetalist = max(lenMetalist);
            handles.metaDB(handles.idx,4:4+sum(idx)-1) = handles.metaDB(handles.idx,[false(1,3) idx]);
            if size(handles.metaDB,2)>(maxMetalist+3)
                handles.metaDB = handles.metaDB(:,1:maxMetalist+3);
            end

        end            
        close(handles.figInput);
        figure(handles.figMeta);
        setappdata(0,'handles',handles);
    end

    function GroupList_callback(hObject,~,~)
        if ~isempty(handles.metaDB)
            handles.row = get(hObject,'Value');
            handles.idx = ~cellfun('isempty',regexp(handles.metaDB(:,2),['^' handles.groupNames{handles.row} '$']));
            handles.patternmetaDB = handles.metaDB(handles.idx,1);

            handles.metaList = handles.groupMetaDB{handles.row,2};
            if ~isempty(handles.metaList)
                handles.patternmetaDB = [handles.patternmetaDB handles.metaDB(handles.idx,4:4+length(handles.metaList)-1)];
                set(handles.PatternMetaTable,'ColumnName', horzcat('Pattern',handles.metaList),'ColumnEdit',logical([0 ones(1,length(handles.metaList))]));
            else
                set(handles.PatternMetaTable,'ColumnName', {'Pattern'},'ColumnEdit',false);
            end

            set(handles.PatternMetaTable,'Data',handles.patternmetaDB);       
        end
        setappdata(0,'handles',handles);
    end

    function AddColumn_callback(~,~,~)
        % Triggers when Add Column button is clicked
        
        if isfield(handles,'figInput')
            if ishandle(handles.figInput)
                figure(handles.figInput);
                return;
            end
        end
        
        handles.labelAdd = 1;

        if isfield(handles,'figInput')
            if ~ishandle(handles.figInput)
                handles.figInput = figure(109); % Dialog Input Figure
            end
        else
            handles.figInput = figure(109);
        end

        set(handles.figInput,'Position',[800-200/2 450-100/2 200 100],'MenuBar','none','Resize','off','Name',handles.title,'NumberTitle','off',...
            'Color',[0 0 0]);
        uicontrol('Parent',handles.figInput,'Style','Text','String','Enter Group Name:','FontSize',11,...
            'BackgroundColor','black','ForegroundColor','white','Position',[10 80 180 20])
        handles.groupLabelEdit = uicontrol('Parent',handles.figInput,'Style','Edit','BackgroundColor','white','Position',[10 50 180 30],...
            'KeyPressFcn',@groupLabelEdit2_KeyPressFcn);
        uicontrol('Parent',handles.figInput,'String','OK','Position',[10 10 30 30],'callback',@ok2Button_callback);
        uicontrol('Parent',handles.figInput,'String','Cancel','Position',[50 10 50 30],'callback',@cancelButton_callback);    
        jEdit = findjobj(handles.groupLabelEdit);
        jEdit.grabFocus();
        setappdata(0,'handles',handles);
    end   

    function backMeta21_callback(~, ~, ~)
        % Triggers when back button is pressed
        set(handles.pMeta2,'visible','off');

        set(handles.pMeta1,'visible','on');
        setappdata(0,'handles',handles);
    end

    function metaDone_callback(~, ~, ~)
        % Triggers when done button is clicked
        % Closes meta figure and all examples
        close(handles.figMeta);
        setappdata(0,'handles',handles);
    end

    function showMeta2Example_callback(~,~,~)
        % Triggers when checkbox is changed
        handles.showMeta2Ex = ~handles.showMeta2Ex;

        if handles.showMeta2Ex
            if ~isfield(handles,'figMeta2')
                handles.figMeta2 = figure(106); % Main Example Figure
            else
                figure(handles.figMeta2)
            end
            set(handles.figMeta2,'Position',[600 75 900 700],'MenuBar','none','Resize','off','Name','Example','NumberTitle','off',...
                'CloseRequestFcn',@meta2Ex_CloseRequestFcn);
            p = uipanel('Parent',handles.figMeta2,'Position',[0 0 1 1],'BackgroundColor','black');                
            axes('Parent',p,'Position',[0 0 1 1]);
            imshow(handles.imMeta2Ex)
        else                        
            close(handles.figMeta2);
        end
        setappdata(0,'handles',handles);
    end

    function meta2Ex_CloseRequestFcn(~,~,~)
        delete(handles.figMeta2); 
        handles.showMeta1Ex = 0;
        handles.showMeta2Ex = 0;
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
