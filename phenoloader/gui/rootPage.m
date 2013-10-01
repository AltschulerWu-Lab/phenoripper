function rootPage
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

    % Create Main Root Directory Figure/Panel
    handles.figRoot = figure(102); % Root Figure
    set(handles.figRoot,'Position',[handles.px handles.py handles.wd handles.ht],'Visible','on',...
        'MenuBar','none','Resize','off','Name',handles.title,'NumberTitle','off',...
        'CloseRequestFcn',@figClose_CloseRequestFcn);

    handles.pRoot = uipanel('Parent',handles.figRoot,'Visible','on',...
        'Position',[0 0 1 1],'BackgroundColor','black');        

    % Page Title
    uicontrol(handles.pRoot,'Style','Text','FontSize',20,'String','Choose Root Directory and Extension',...
                'FontWeight','Bold','BackgroundColor','black','ForegroundColor','white',...
                'Position',[handles.wd*0.20 handles.ht*0.89 handles.wd*0.60 40]);

    % Create push button for File Attribute Example
    handles.showRootExample = uicontrol(handles.pRoot,'Style','pushbutton',...
                'FontSize',10,'String','Show/Hide Example',...
                'callback',@showRootExample_callback,...
                'Position',[10 450 150 40]);

    % Define Root Directory Text/Button/Edit Box
    uicontrol(handles.pRoot,'Style','Text','FontSize',12,'FontWeight','bold','String','1)',...
                'BackgroundColor','black','ForegroundColor','white',...
                'Position',[handles.wd*0.09 handles.ht*0.63 15 20]);
    uicontrol(handles.pRoot,'FontSize',12,'String','Browse for Directory',...
                'callback',@selectRootDirectory_callback,...
                'Position',[handles.wd*0.12 handles.ht*0.60 165 44]);
    handles.RootDirectory = uicontrol(handles.pRoot,'Style','edit','FontSize',10,...
                'callback',@RootDirectory_callback,...
                'Position',[handles.wd*0.3 handles.ht*0.60 handles.wd*0.6 44]);

    % Define Image Extension Text/Popupmenu
    uicontrol(handles.pRoot,'Style','Text','FontSize',12,'FontWeight','bold','String','2)',...
                'BackgroundColor','black','ForegroundColor','white',...
                'Position',[handles.wd*0.133 handles.ht*0.53 15 20]);
    uicontrol(handles.pRoot,'Style','Text','FontSize',12,'FontWeight','Bold','String','Image Extension',...
                'BackgroundColor','black','ForegroundColor','white',...
                'Position',[handles.wd*0.155 handles.ht*0.53 140 20]);        

    handles.ImageExtension = uicontrol(handles.pRoot,'Style','popupmenu','String',{''},...
                'FontSize',12,...
                'callback',@ImageExtension_callback,...
                'Position',[handles.wd*0.3 handles.ht*0.46 handles.wd*0.1 60]);             

    % Create Root Done Button
    uicontrol(handles.pRoot,'String','Done','FontSize',12,'FontWeight','Bold',...
                'callback',@rootDone_callback,...
                'Position',[handles.wd*0.4 handles.ht*0.3 handles.wd*0.2 40]);  

    handles.showEx = false;
        

    % handles.pRoot panel       
    function selectRootDirectory_callback(~, ~, ~)
        % Triggered on Button Press
        
        handles.currDir = pwd;
        lastPath=load_last_path('wizard');
        if(~exist(char(lastPath),'dir'))
          rootDir=uigetdir();
        else
          rootDir=uigetdir(lastPath);
        end      
        
%         if ~isempty(handles.rootDir)
%             rootDir = uigetdir(handles.rootDir);
%         else
%             rootDir = uigetdir(handles.currDir);
%         end
        
        if rootDir~=0
            handles.rootDir = rootDir;        
            if(~isunix)
                handles.rootDrive = handles.rootDir(1:2);
            else
                handles.rootDrive='';
            end

            set(handles.RootDirectory,'String', handles.rootDir);

            % Find extension possibilities and set popup to most prevalent extension
            handles = findExt(handles);

            % Clear all data
            handles.useFileNames = {};
            handles.remFileNames = {};
            handles.metaDB = [];
            handles.currfeatDBdata = [];
            handles.groupMetaDB = [];
            handles.numMarkers = [];
            handles.markerDB = cell(1,2);
            handles.markerDB(:) = cellstr('');
            handles.groupNames = {};
            handles.markerHighlight = {};
            
            set(handles.markerCheck,'visible','off');                

            set(handles.metadataButton,'Visible','off');
            set(handles.metadataCheck,'visible','off')  

            set(handles.metafileButton,'Visible','off');
            set(handles.metafileCheck,'visible','off');
            save_last_path(rootDir,'wizard');
        end
        setappdata(0,'handles',handles);
    end

    function RootDirectory_callback(hObject, ~, ~)
        % Triggered on Edit Box change
        
        handles.rootDir = get(hObject,'String');
        
        if ~isempty(handles.rootDir)
            % Find extension possibilities and set popup to most prevalent extension
            handles = findExt(handles);

            % Clear all data
            handles.useFileNames = {};
            handles.remFileNames = {};
            handles.metaDB = [];
            handles.currfeatDBdata = [];
            handles.groupMetaDB = [];
            handles.numMarkers = [];
            handles.markerDB = cell(1,2);
            handles.markerDB(:) = cellstr('');
            handles.groupNames = {};
            handles.markerHighlight = {};
                        
            set(handles.markerCheck,'visible','off');                

            set(handles.metadataButton,'Visible','off');
            set(handles.metadataCheck,'visible','off')  

            set(handles.metafileButton,'Visible','off');
            set(handles.metafileCheck,'visible','off');
        end
        setappdata(0,'handles',handles);
    end

    function ImageExtension_callback(hObject, ~, ~)
        % Triggered on popupmenu change
        
        handles.extVal = get(hObject,'Value');
        
        if ~isempty(handles.extTypes)
            handles.imageExt = handles.extTypes{handles.extVal};
            handles.imageExt = handles.imageExt(2:end);

            handles.origfileName = cellfun(@(x) x(:,2),regexp(handles.list,handles.rootDir,'split'));
            handles.origfileName = handles.origfileName(strcmp(handles.fileExt,['.' handles.imageExt]));
            %handles.origfileName = handles.origfileName(~cellfun('isempty',regexp(handles.origfileName,handles.imageExt)));
       
            handles.origfileName = sort(handles.origfileName);
            
            % nameGroups is a cell array containing all the
            % folders/filename without the file separator
            handles.nameGroups = regexp(handles.origfileName,'/','split');               

            % Clear all data
            handles.useFileNames = {};
            handles.remFileNames = {};
            handles.numMarkers = [];
            handles.markerDB = cell(1,2);
            handles.markerDB(:) = cellstr('');
            handles.markerHighlight = {};
            handles.metaDB = [];
            handles.currfeatDBdata = [];
            handles.groupMetaDB = [];            
            handles.groupNames = {};
            
            
            set(handles.markerCheck,'visible','off');                

            set(handles.metadataButton,'Visible','off');
            set(handles.metadataCheck,'visible','off')  

            set(handles.metafileButton,'Visible','off');
            set(handles.metafileCheck,'visible','off');
        end
        setappdata(0,'handles',handles);
    end

    function rootDone_callback(~, ~, ~)
        % Triggers on clicking the done button 

        choice = questdlg('By default all files with selected extension will be analyzed. Specify a subset for analysis?',handles.title,'yes','no','no');
        
        switch choice
            case 'yes'
                handles.figFilterFiles = figure(107);
                pos = [handles.px/2 handles.py handles.wd*1.25 handles.ht*1.25];        
                w = pos(3);
                h = pos(4);
                set(handles.figFilterFiles,'Position',pos,'Visible','on',...
                'MenuBar','none','Resize','off','Name',handles.title,'NumberTitle','off');

                handles.pFilterFiles = uipanel('Parent',handles.figFilterFiles,'Visible','on',...
                'Position',[0 0 1 1],'BackgroundColor','black');

                % Page Title
                uicontrol(handles.pFilterFiles,'Style','Text','FontSize',20,'String','Choose Files to Use',...
                            'FontWeight','Bold','BackgroundColor','black','ForegroundColor','white',...
                            'Position',[w*0.20 h*0.89 w*0.60 40]);


                uicontrol(handles.pFilterFiles,'Style','Text','String','Files to Use','FontSize',12,'FontWeight','bold',...
                        'BackgroundColor','black','ForegroundColor','white',...
                        'Position',[w*0.05 h*0.8 w*0.35 h*0.04]);            
                handles.useList = uicontrol(handles.pFilterFiles,'Style','listbox','FontSize',10,...
                    'Position',[w*0.05 h*0.1 w*0.35 h*0.7],...
                    'callback',@useList_callback);

                uicontrol(handles.pFilterFiles,'Style','Text','String','Unused Files','FontSize',12,'FontWeight','bold',...
                        'BackgroundColor','black','ForegroundColor','white',...
                        'Position',[w*0.60 h*0.8 w*0.35 h*0.04]);
                handles.remList = uicontrol(handles.pFilterFiles,'Style','listbox','FontSize',10,...
                    'Position',[w*0.60 h*0.1 w*0.35 h*0.7],...
                    'callback',@remList_callback);

                if isempty(handles.useFileNames)
                    handles.useFileNames = handles.origfileName;            
                end       

                if isempty(handles.remFileNames)
                    handles.remFileNames = {''};
                end
                set(handles.useList,'String',handles.useFileNames,'Max',size(handles.useFileNames,1))
                set(handles.remList,'String',handles.remFileNames,'Max',size(handles.remFileNames,1))
                handles.useFilterExpression=0;

                % Create filter expression edit box
                uicontrol(handles.pFilterFiles,'Style','Text','String','Filter Pattern','FontSize',12,'FontWeight','bold',...
                        'BackgroundColor','black','ForegroundColor','white',...
                        'Position',[w*0.425 h*0.75 w*0.15 h*0.04]);
                uicontrol(handles.pFilterFiles,'Style','edit','String','','FontSize',12,...
                        'callback',@filterExpression_callback,...
                        'Position',[w*0.425 h*0.7 w*0.15,...
                        h*0.05],'TooltipString','Enter sequence of letters common to the filenames to be discarded');

                % Create FileFilter transfer right Button
                uicontrol(handles.pFilterFiles,'String','>>>','FontSize',20,'FontWeight','Bold',...
                        'callback',@rem_callback,...
                        'Position',[w*0.5-h*0.05 h*0.50 h*0.1 h*0.1]);  

                % Create FileFilter transfer left Button
                uicontrol(handles.pFilterFiles,'String','<<<','FontSize',20,'FontWeight','Bold',...
                        'callback',@use_callback,...
                        'Position',[w*0.5-h*0.05 h*0.35 h*0.1 h*0.1]);  

                % Create FileFilter Done Button
                uicontrol(handles.pFilterFiles,'String','Done','FontSize',12,'FontWeight','Bold',...
                        'callback',@fileFilterDone_callback,...
                        'Position',[w*0.425 h*0.1 w*0.15 40]);     
            case 'no'
                handles.useFileNames = handles.origfileName;
                first_filename=[handles.rootDir handles.useFileNames{1}];
                nc=Number_Of_Channels_In_File(first_filename);
                handles.multichannel = nc>1;
                handles.numMarkers = nc;
                if(nc>1)
                  handles.markerDB = cell(handles.numMarkers,2);
                  handles.markerDB(:) = cellstr('');
                  handles.markerDB(:,2) = cellstr([repmat('marker',handles.numMarkers,1) num2str((1:handles.numMarkers)')]);
                  handles.markerDB(:,1) = handles.markerDB(:,2);
                end
               
                close(handles.figRoot);   
        end
        setappdata(0,'handles',handles);
    end
   
    function filterExpression_callback(hObject,~,~)
        filtExp = get(hObject,'String');
        [matchstr,splitstr] = regexp(filtExp,'[!-.:-@{-~\[\]-`]','match','split');
        for k = 1:length(matchstr)
            matchstr(k) = cellstr(['\' matchstr{k}]);
        end
        filtExp = [splitstr; [matchstr {''}]];
        filtExp = [filtExp{:}];
        handles.useidx = cellfun('isempty',regexp(handles.useFileNames,filtExp));        
        handles.remidx = cellfun('isempty',regexp(handles.remFileNames,filtExp));
        handles.useFilterExpression = 1;
        
        jListUse = findjobj(handles.useList);
        jListUse = jListUse.getComponent(0).getComponent(0);          
        if ~isempty(find(~handles.useidx,1))            
            handles.useFileNames = [handles.useFileNames(~handles.useidx); handles.useFileNames(handles.useidx)];                        
            if isempty(handles.useFileNames)
                handles.useFileNames = cellstr('');
            end
            set(handles.useList,'String',handles.useFileNames,'Max',size(handles.useFileNames,1),'Value',1)                  
            jListUse.setSelectionInterval(0,sum(~handles.useidx)-1);
        else
            jListUse.setSelectionInterval(0,0);
        end
        jListUse.grabFocus;
        
        jListRem = findjobj(handles.remList);
        jListRem = jListRem.getComponent(0).getComponent(0);
        if ~isempty(find(~handles.remidx,1))
            handles.remFileNames = [handles.remFileNames(~handles.remidx); handles.remFileNames(handles.remidx)];
            if isempty(handles.remFileNames)
                handles.remFileNames = cellstr('');
            end
            set(handles.remList,'String',handles.remFileNames,'Max',size(handles.remFileNames,1),'Value',1)
            jListRem.setSelectionInterval(0,sum(~handles.remidx)-1);
        else
            jListRem.setSelectionInterval(0,0);
        end
        jListRem.grabFocus;
        setappdata(0,'handles',handles);
    end
    
    function useList_callback(~,~,~)
        handles.useFilterExpression = 0;
        setappdata(0,'handles',handles);
    end

    function remList_callback(~,~,~)
        handles.useFilterExpression = 0;
        setappdata(0,'handles',handles);
    end

    function rem_callback(~,~,~)
        if isMultipleCall()
            return;
        end
        
        if handles.useFilterExpression
            idx = true(length(handles.useFileNames),1);
            idx(1:sum(~handles.useidx)) = false;
            handles.useFilterExpression = 0;
        else
            jList = findjobj(handles.useList);
            jList = jList.getComponent(0).getComponent(0);
            remIdx = jList.getSelectedIndices()+1;
            idx = true(length(handles.useFileNames),1);
            idx(remIdx) = false;
        end
        
        if isempty(handles.remFileNames{1})
            handles.remFileNames = handles.useFileNames(~idx);
        else
            temp = handles.useFileNames(~idx);
            if ~isempty(temp)
                if ~isempty(temp{1})
                   handles.remFileNames = [handles.remFileNames; temp];
                end
            end
        end

        if sum(~idx) == length(handles.useFileNames)
            handles.useFileNames = cellstr('');
        else
            handles.useFileNames = handles.useFileNames(idx);
        end

        handles.useFileNames = sort(handles.useFileNames);
        handles.remFileNames = sort(handles.remFileNames);

        set(handles.useList,'String',handles.useFileNames,'Max',size(handles.useFileNames,1),'Value',1)
        set(handles.remList,'String',handles.remFileNames,'Max',size(handles.remFileNames,1),'Value',1)
        
        setappdata(0,'handles',handles);
    end

    function use_callback(~,~,~)
        if isMultipleCall()
            return;
        end
        
        if handles.useFilterExpression
            idx = true(length(handles.remFileNames),1);
            idx(1:sum(~handles.remidx)) = false;
            handles.useFilterExpression = 0;
        else
            jList = findjobj(handles.remList);
            jList = jList.getComponent(0).getComponent(0);
            useIdx = jList.getSelectedIndices()+1;
            idx = true(length(handles.remFileNames),1);
            idx(useIdx) = false;        
        end
        
        if isempty(handles.useFileNames{1})
            handles.useFileNames = handles.remFileNames(~idx);
        else
            temp = handles.remFileNames(~idx);
            if ~isempty(temp)
                if ~isempty(temp{1})
                    handles.useFileNames = [handles.useFileNames; temp];
                end
            end
        end        
        
        if sum(~idx) == length(handles.remFileNames)
            handles.remFileNames = cellstr('');
        else
            handles.remFileNames = handles.remFileNames(idx);
        end
        
        handles.useFileNames = sort(handles.useFileNames);
        handles.remFileNames = sort(handles.remFileNames);
        
        set(handles.useList,'String',handles.useFileNames,'Max',size(handles.useFileNames,1),'Value',1)
        set(handles.remList,'String',handles.remFileNames,'Max',size(handles.remFileNames,1),'Value',1)
        setappdata(0,'handles',handles);
    end

    function fileFilterDone_callback(~,~,~)
        
        if isempty(handles.useFileNames{1})
            handles.useFileNames(1) = handles.remFileNames(1);
            handles.remFileNames = handles.remFileNames(2:end);
        end
        
        wbar = waitbar(0.25,'Checking for multiple channels...');
        first_filename=[handles.rootDir handles.useFileNames{1}];
        nc=Number_Of_Channels_In_File(first_filename);
        handles.multichannel = nc>1;
        handles.numMarkers = nc;
        if(nc>1)
          handles.markerDB = cell(handles.numMarkers,2);
          handles.markerDB(:) = cellstr('');
          handles.markerDB(:,2) = cellstr([repmat('marker',handles.numMarkers,1) num2str((1:handles.numMarkers)')]);
          handles.markerDB(:,1) = handles.markerDB(:,2);
        end
        handles.nameGroups = regexp(handles.useFileNames,'/','split');
        close(wbar);
        close(handles.figRoot);        
        close(handles.figFilterFiles);
        
        setappdata(0,'handles',handles);
    end

    function showRootExample_callback(~,~,~)
        % Triggers on checking/unchecking the show example box
        
        handles.showEx = ~handles.showEx;
        
        % Display example corresponding to root directory
        if handles.showEx
            if ~isfield(handles,'figExample')
                handles.figExample = figure(106); % Main Example Figure
            else
                figure(handles.figExample);
            end
            set(handles.figExample,'MenuBar','none','Resize','off','Name','Example','NumberTitle','off');
            set(handles.figExample,'Position',[(1600-700)/2 handles.pyM+handles.htM+30 700 200]);
            set(handles.figExample,'Visible','on','CloseRequestFcn',@rootEx_CloseRequestFcn);
            pEx = uipanel('Parent',handles.figExample,'Position',[0 0 1 1],'BackgroundColor','black');
            set(pEx,'visible','on');
            axes('Parent',pEx,'Position',[-0.1 0 9/7 1]);
            imshow(handles.imFileEx1);
        else
            close(handles.figExample);
        end
        setappdata(0,'handles',handles);
    end

    function rootEx_CloseRequestFcn(~,~,~)
       delete(handles.figExample); 
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
            if isfield(handles,'origfileName')
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
            
            if isfield(handles,'origfileName') && ~isempty(handles.numMarkers)
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

function number_of_channels=Number_Of_Channels_In_File(first_filename)
        img=imread2(first_filename,true);
        number_of_channels=size(img,3);
end
