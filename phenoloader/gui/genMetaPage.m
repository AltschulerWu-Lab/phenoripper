function genMetaPage
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

    % Close other existing figures
    figsOpen = get(0,'children');
    figsOpen = figsOpen(figsOpen>101 & figsOpen<106);
    close(figsOpen);

    % Check that markers have been defined and grouping of images was
    % successful
    if isfield(handles,'numMarkers') && isfield(handles,'groupedDB')            

        % Creat genMeta figure/panel
        handles.figGenMeta = figure(105); % Generate Metafile Figure
        set(handles.figGenMeta,'Position',[handles.px handles.py handles.wd handles.ht],'Visible','on',...
            'MenuBar','none','Resize','off','Name',handles.title,'NumberTitle','off',...
            'CloseRequestFcn',@figClose_CloseRequestFcn);
        handles.pGenMeta = uipanel('Parent',handles.figGenMeta,'Visible','on',...
            'Position',[0 0 1 1],'BackgroundColor','black');

        % Page Title
        uicontrol(handles.pGenMeta,'Style','Text','FontSize',20,'String','Preview and Save Metadata File',...
                    'FontWeight','Bold','BackgroundColor','black','ForegroundColor','white',...
                    'Position',[handles.wd*0.1 handles.ht*0.89 handles.wd*0.8 40]);

        % Metafile name Text/Edit box
        uicontrol(handles.pGenMeta,'Style','Text','FontSize',12,'String','Metafile Directory and Name:',...
                    'FontWeight','Bold','BackgroundColor','black','ForegroundColor','white',...
                    'Position',[handles.wd*0.025 handles.ht*0.85 handles.wd*0.24 22]);
        handles.metaFilecomp = uicontrol(handles.pGenMeta,'Style','Edit','FontSize',10,'String',[handles.rootDir '/metafile.csv'],...
                    'callback',@metaFilename_callback,...
                    'Position',[handles.wd*0.025 handles.ht*0.8 handles.wd*0.75 22]);

        % Create File Directory Control
        uicontrol(handles.pGenMeta,'String','Select Directory','FontSize',12,...
                    'callback',@metaFileDir_callback,...
                    'Position',[handles.wd*0.78 handles.ht*0.78 150 40]); 

        % Define Current Feature Table
        handles.currFeatTable_tpos = [handles.wd*0.025 handles.ht*0.08 handles.wd*0.75 handles.ht*0.7];
        handles.metaTable = uitable(handles.pGenMeta,'FontSize',10,'Position',handles.currFeatTable_tpos); 


        % Create Write Metadata Control
        uicontrol(handles.pGenMeta,'String','Create Metafile','FontSize',12,'FontWeight','Bold',...
                    'callback',@CreateMetafile_callback,...
                    'Position',[handles.wd*0.8 handles.ht*0.4 150 100]);    
                  
        % Create Write Metadata Control
        uicontrol(handles.pGenMeta,'String','Next','FontSize',12,'FontWeight','Bold',...
                    'callback',@saveParams,...
                    'Position',[handles.wd*0.8 handles.ht*0.1 150 100]);

        handles.metaFilename = [handles.rootDir '/metafile.csv'];
    
        % Generate column names for metafile (filename,drug,etc.)               
        numMeta = 0;
        cname = handles.groupMetaDB(:,1)';
        for x = 1:size(handles.groupMetaDB,1)
            numMeta = numMeta + length(handles.groupMetaDB{x,2});
            cname = [cname handles.groupMetaDB{x,2}];
        end

        if ~handles.multichannel
            markerNames = handles.markerDB(:,1)';
            for x = 1:length(markerNames)
                markerNames{x} = ['Image:' markerNames{x}];
            end
            cname = [cname markerNames];
        else
            cname = [cname cell(1)];
        end

        % split first groupedDB list by folder separators
        handles.groupedDBtrun = cell(size(handles.groupedDB));
        for x = 1:size(handles.groupedDB,2)
            handles.groupedDBtrun(:,x) = cellfun(@(f) f(:,2:end),handles.groupedDB(:,x),'UniformOutput',false);             
        end
        
        groupList = handles.groupedDBtrun(:,1);            
        [groupList] = regexp(groupList,'/','split');

        % Generate final table with metadata
        handles.finalList = [handles.groupedDBtrun cell(size(handles.groupedDBtrun,1),numMeta)];
        if ~handles.multichannel
            sidx = handles.numMarkers+1;
        else
            sidx = 2;
        end
        handles.defMetadata = cell(size(handles.finalList,1),size(handles.groupMetaDB,1));
        handles.defMetadata(:) = cellstr('');
        
        frac = 0;
%        h.wbar = waitbar(frac,'Generating preview...');          
        for x = 1:size(handles.groupMetaDB,1)
            currLabel = handles.groupMetaDB{x,1};
            metaLabel = handles.groupMetaDB{x,2};
            patternKey = handles.groupMetaDB{x,3};
            handles.defMetadata(:,x) = patternKey;

            idx = ~cellfun('isempty',regexp(handles.metaDB(:,2),['^' currLabel '$']));

            pattern = handles.metaDB(idx,1);
            foldIdx = handles.metaDB(idx,3);

            metadata = handles.metaDB(idx,4:4+length(metaLabel)-1);
            eidx = sidx+length(metaLabel)-1;
            
            for m = 1:length(pattern)
                folderList = cell(size(groupList,1),1);                
                for n = 1:size(groupList,1)
                    temp = groupList{n};
                    folderList{n} = temp{foldIdx{m}};
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                frac = 1/size(handles.metaDB,1) + frac;
%                waitbar(frac,h.wbar,'Generating preview...');                 

                idx = ~cellfun('isempty',regexp(folderList,pattern{m}));
                handles.finalList(idx,sidx:eidx) = repmat(metadata(m,:),sum(idx),1); 
            end
            sidx = eidx+1;  
        end
         
        
        
        if ~handles.multichannel
            handles.dispList = [handles.defMetadata handles.finalList(:,handles.numMarkers+1:end) handles.finalList(:,1:handles.numMarkers)];
            handles.finalList = [handles.finalList(:,1:handles.numMarkers) handles.defMetadata handles.finalList(:,handles.numMarkers+1:end)];                
        else
            handles.dispList = [handles.defMetadata handles.finalList(:,2:end) handles.finalList(:,1)];
            handles.finalList = [handles.finalList(:,1) handles.defMetadata handles.finalList(:,2:end)];                
        end;

        validMetaIdx = any(~cellfun('isempty',handles.finalList),1);
        handles.finalList = handles.finalList(:,validMetaIdx);

        validMetaIdx = any(~cellfun('isempty',handles.dispList),1);
        handles.dispList = handles.dispList(:,validMetaIdx);

        handles.cname = cname(validMetaIdx);
        cname = cell(1,length(handles.cname));
        for x = 1:length(handles.cname)
            cname(x) = cellstr(['<html><font size=+1><b>' handles.cname{x}]);
        end

        % Space tabs of final table to autofit
        maxLen = cell(1,size(handles.dispList,2));
        for x = 1:size(handles.dispList,2)
            numChar = max(cellfun('length',handles.dispList(:,x)));
            if numChar>10
                maxLen{x} = numChar*7;
            else
                maxLen{x} = 'auto';
            end
        end

        % Populate final table for confirmation
        cwidth = maxLen;
        set(handles.metaTable,'Data',handles.dispList,'ColumnName',cname,'ColumnWidth',cwidth); 
        close(h.wbar);
    else
        warndlg('Define Markers!',handles.title)
        setappdata(0,'handles',handles);
    end


    function metaFilename_callback(hObject,~,~)
        % Triggers when Edit box of filename is changed
        handles.metaFilename = get(hObject,'String');
        setappdata(0,'handles',handles);
    end

    function metaFileDir_callback(~,~,~)
        % Triggers when Select Directory button is pressed
        % updates output metafile name
        handles.metaRootDir = uigetdir;        

        if ~handles.metaRootDir
            handles.metaFilename = get(handles.metaFilecomp,'String');
        else
            handles.metaRootDir(handles.metaRootDir=='\') = '/';
            splitstr = regexp(handles.metaFilename,'/','split');
            filename = splitstr{end};
            handles.metaFilename = [handles.metaRootDir '/' filename];
        end

        set(handles.metaFilecomp,'String',handles.metaFilename);
        setappdata(0,'handles',handles);
    end

    function saveParams(~, ~, ~)
      myhandles=getappdata(0,'myhandles');
      %fileConcat = cell(size(handles.finalList,1),1);
      myhandles.file_matrix=handles.finalList(:,1:3);
      myhandles.markers = cell(1,handles.numMarkers);
      
      
      for k = 1:handles.numMarkers
          myhandles.markers{1,k}=struct;
          myhandles.markers{1,k}.isUse=1;
          myhandles.markers{1,k}.marker=handles.markerDB{k,2};
          myhandles.markers{1,k}.name=handles.markerDB{k,1};
          myhandles.markers{1,k}.regExp=[];
      end
      
      if ~handles.multichannel
        cname = handles.cname(1:end-handles.numMarkers);
        myhandles.files_per_image=handles.numMarkers;
      else
        cname = handles.cname(1:end-1);
        myhandles.files_per_image=1;
      end
      
      myhandles.metadata = cell(1,size(handles.finalList,1));
      for f=1:size(handles.finalList,1)
        myhandles.metadata{1,f}.FileNames=cell(1,handles.numMarkers,2);
        for k=1:handles.numMarkers
          myhandles.metadata{1,f}.FileNames{1,k,1}=handles.finalList{f,k};
          myhandles.metadata{1,f}.FileNames{1,k,2}={1,0};
        end
        myhandles.metadata{1,f}.None=handles.finalList{f,1};
        for mm=1:size(cname,2)
          myhandles.metadata{1,f}.(cname{1,mm})=handles.finalList{f,handles.numMarkers+mm};
        end
      end
      myhandles.use_metadata=1;
      myhandles.number_of_channels=handles.numMarkers;
      myhandles.wizardData.markers=myhandles.markers;
      myhandles.rootDir=[handles.rootDir '/'];
      %myhandles.wizard_handle=gcf;
      setappdata(0,'myhandles',myhandles);
      close(handles.figGenMeta);
      figure(handles.figMain);
      close(handles.figMain);
      wizard_sampling;
      
    end

    function CreateMetafile_callback(~, ~, ~)
        % Triggers when Create Metafile button is clicked        
        fileConcat = cell(size(handles.finalList,1),1);
        if ~handles.multichannel
            % Concatenates images into a single column

            for k = 1:handles.numMarkers
                fileConcat = strcat(fileConcat,handles.finalList(:,k));
                if k~=handles.numMarkers
                    fileConcat = strcat(fileConcat,cellstr(repmat(';',size(fileConcat,1),1)));    
                end
            end


            cname = handles.cname(1:end-handles.numMarkers);
        else
            cname = handles.cname(1:end-1);
        end
        % Appends additional meta information
        label = horzcat('FileNames', cname);
        if ~handles.multichannel
            fileConcat = horzcat(fileConcat,handles.finalList(:,handles.numMarkers+1:end));
        else
            fileConcat = handles.finalList;
        end
        fileConcat = [label; fileConcat];
        fileConcat = fileConcat(~any(cellfun('isempty',fileConcat),2),:);
        if ~handles.multichannel
            [overwrite handles.writeStatus] = cell2csv([handles.rootDir '/'],1,handles.markerDB(:,1),handles.metaFilename, fileConcat);
        else
            [overwrite handles.writeStatus]= cell2csv([handles.rootDir '/'],handles.nbImages,handles.markerDB(:,1),handles.metaFilename, fileConcat);
        end
        if overwrite && handles.writeStatus
          message = sprintf(['Metadata file ' handles.metaFilename ' saved!']);
          uiwait(msgbox(message));
        end

%         if overwrite && handles.writeStatus
%             close(handles.figGenMeta);
%             figure(handles.figMain);
%         end
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
end