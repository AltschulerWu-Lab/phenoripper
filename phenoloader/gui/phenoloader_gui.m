function phenoloader_gui(varargin)
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
                   
handles.wd = 950;
handles.ht = 500;
handles.px = (1600-handles.wd)/2;
handles.py = 50;

handles.wdM = 500;
handles.htM = 400;
handles.pxM = (1600-handles.wdM)/2;
handles.pyM = (900-handles.htM)/2-100;

%close all;

handles.title = ['PhenoLoader ' num2str(dlmread('version.txt'))];

handles.imFileEx1 = imread('fileEx1.png');
handles.imMarkerEx = imread('markerEx.png');
handles.imMeta1Ex = imread('meta1Ex.png');
handles.imMeta2Ex = imread('meta2Ex.png');
handles.greencheck = imread('checkOk.png');


handles.figMain = figure(101); % Main Figure
set(handles.figMain,'MenuBar','none','Resize','off','Name',handles.title,'NumberTitle','off');
set(handles.figMain,'Position',[handles.pxM handles.pyM handles.wdM handles.htM]);
set(handles.figMain,'Visible','on','CloseRequestFcn',@figClose_CloseRequestFcn);
pMain = uipanel('Parent',handles.figMain,'Position',[0 0 1 1],'BackgroundColor','black');
set(pMain,'Unit','pixels');
set(pMain,'visible','on');
        
handles.metaDB = [];                % [B16 Well 3 Apicidin Histone deacetylase; etc...]
handles.currfeatDBdata = [];        % [B16 B 16; C20 C 20; etc...]
handles.groupMetaDB = [];           % [{'Well'} {Drug} {240x1}; {'Row'} {DrugClass} {240x1}; etc...]
handles.markerHighlight = {};       % ['/B16/HeLa9566-<Highlight>1<Highlight>.tif'; etc...]
handles.labelAdd = 0;

handles.rootDir=load_last_path('phenoloaderroot');
if(isempty(handles.rootDir))
  handles.rootDir = [];
end

% if exist('phenoLoaderProp.mat','file')
%     r = load('phenoLoaderProp.mat');
%     handles.rootDir = r.rootDir;
% else
%     handles.rootDir = [];
% end

handles.markerDB = cell(1,2);
handles.markerDB(:) = cellstr('');  % [marker name, marker filename annotation]
handles.extTypes = {};              % [.tiff; .png; etc...]
handles.extVal = 1;
handles.showMarkerEx = 0;
handles.showMeta1Ex = 0;
handles.showMeta2Ex = 0;

handles.figRoot = [];
handles.figMarker = [];
handles.figMeta = [];
handles.figGenMeta = [];


% pMain panel
% Page Title
uipanel('Parent',pMain,'Visible','on','Position',[0 0.8 1 0.2],'BackgroundColor','red');
uicontrol(pMain,'Style','Text','FontSize',24,'String',handles.title,...
            'FontWeight','Bold','BackgroundColor','red','ForegroundColor','black',...
            'Position',[handles.wdM*0.25 handles.htM*0.85 handles.wdM*0.5 40]);

% Create Root Directory button
uicontrol(pMain,'String','Define Root Directory','FontSize',12,'FontWeight','Bold',...
            'callback',@rootPanel_callback,...
            'Position',[handles.wdM*0.25 handles.htM*0.6 handles.wdM*0.5 40]);    

        axes('Parent',pMain,'Position',[0.775 0.62 0.075 0.075]);
            handles.rootCheck = imshow(handles.greencheck);
            set(handles.rootCheck,'visible','off')
        

% Create Marker button
handles.markerButton = uicontrol(pMain,'String','Define Markers','FontSize',12,'FontWeight','Bold',...
            'callback',@markerPanel_callback,'Visible','off',...
            'Position',[handles.wdM*0.25 handles.htM*0.45 handles.wdM*0.5 40]);  
        
        axes('Parent',pMain,'Position',[0.775 0.47 0.075 0.075]);
            handles.markerCheck = imshow(handles.greencheck);
            set(handles.markerCheck,'visible','off')
        
% Create Metadata button
handles.metadataButton = uicontrol(pMain,'String','Define Metadata','FontSize',12,'FontWeight','Bold',...
            'callback',@metaPanel_callback,'Visible','off',...
            'Position',[handles.wdM*0.25 handles.htM*0.30 handles.wdM*0.5 40]);  
        
        axes('Parent',pMain,'Position',[0.775 0.32 0.075 0.075]);
            handles.metadataCheck = imshow(handles.greencheck);
            set(handles.metadataCheck,'visible','off');
            
% Create Create Metafile button
handles.metafileButton = uicontrol(pMain,'String','Create Metadatafile','FontSize',12,'FontWeight','Bold',...
            'callback',@genMetaPanel_callback,'Visible','off',...
            'Position',[handles.wdM*0.25 handles.htM*0.15 handles.wdM*0.5 40]);                  
        
        axes('Parent',pMain,'Position',[0.775 0.17 0.075 0.075]);
            handles.metafileCheck = imshow(handles.greencheck);
            set(handles.metafileCheck,'visible','off');
     
setappdata(0,'handles',handles);            
            
% OPEN MAIN PANELS       
    function rootPanel_callback(~,~,~)        
        rootPage;
    end
                
    function markerPanel_callback(~,~,~)
        markerPage;
    end

    function metaPanel_callback(~,~,~)
        metaPage;
    end

    function genMetaPanel_callback(~,~,~)
        genMetaPage;        
    end

    function figClose_CloseRequestFcn(~,~,~)
     	handles = getappdata(0,'handles');
        if gcf==handles.figMain
            delete(handles.figMain)    
            try
              %save('data/phenoLoaderProp.mat','rootDir');
              save_last_path(rootDir,'phenoloaderroot');              
            catch
            end
        else
            figure(handles.figMain);
        end
        if ishandle(handles.figRoot)
            delete(handles.figRoot);
            if isfield(handles,'origfileName')
                handles_visibility(handles.markerButton,1);
                handles_visibility(handles.rootCheck,1);          
            else
                handles_visibility(handles.rootCheck,0);
                handles_visibility(handles.markerButton,0);
                handles_visibility(handles.markerCheck,0);
                handles_visibility(handles.metadataButton,0);
                handles_visibility(handles.metadataCheck,0);
                handles_visibility(handles.metafileButton,0);
                handles_visibility(handles.metafileCheck,0);                
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
                handles_visibility(handles.markerCheck,1);
                handles_visibility(handles.metadataButton,1);                
            else                
                handles_visibility(handles.markerCheck,0);
                handles_visibility(handles.metadataButton,0);
                handles_visibility(handles.metadataCheck,0);
                handles_visibility(handles.metafileButton,0);
                handles_visibility(handles.metafileCheck,0);                
            end
           
        end
        
        if ishandle(handles.figMeta)
            delete(handles.figMeta);
            handles.showMeta1Ex = 0;
            handles.showMeta2Ex = 0;
            if isfield(handles,'numMarkers') && isfield(handles,'groupedDB')
                handles_visibility(handles.metadataCheck,1);
                handles_visibility(handles.metafileButton,1);                
            else                                
                handles_visibility(handles.metadataCheck,0);
                handles_visibility(handles.metafileButton,0);
                handles_visibility(handles.metafileCheck,0);  
            end
        end
        
        if ishandle(handles.figGenMeta)
            delete(handles.figGenMeta);
            if isfield(handles,'writeStatus')
                if handles.writeStatus                    
                    handles_visibility(handles.metafileCheck,1); 
                else
                    handles_visibility(handles.metafileCheck,0); 
                end
            else
                if ishandle(handles.metafileCheck)
                    handles_visibility(handles.metafileCheck,0);                     
                end
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
