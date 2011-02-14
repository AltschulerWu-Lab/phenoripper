function varargout = scroll_panel(varargin)

myhandles.number_of_channels=1;
setappdata(0,'myhandles',myhandles);
handles.background_color='black';
handles.foreground_color='white';

handles.gui_width=1000;
handles.gui_height=700;


handles.main_panel_height=1;
handles.marker_start_pos=handles.gui_height*(handles.main_panel_height-0.05);

handles.left_edge_of_panel=0.05;
handles.width_of_panel=0.4;
handles.right_edge_of_panel=handles.left_edge_of_panel+handles.width_of_panel;
handles.bottom_of_panel=0.25;
handles.height_of_panel=0.55;
handles.top_of_panel=handles.bottom_of_panel+handles.height_of_panel;

handles.marker_panel_height=0.2; %As fraction of gui height

handles.fig=figure('position',[0,0,handles.gui_width,handles.gui_height],'Color',handles.background_color,...
'MenuBar','none');


% Panel where channel file info is provided. Scroll bar makes it move up and
% down
handles.main_panel=uipanel('BackgroundColor',handles.background_color,...
'position',[handles.left_edge_of_panel,handles.top_of_panel-handles.main_panel_height,handles.width_of_panel,handles.main_panel_height],...
'ForegroundColor',handles.foreground_color,'parent',handles.fig,'BorderType','none');
uistack(handles.main_panel,'bottom');


%The two frames that give the appearance of scrolling
handles.top_blocking_frame=uicontrol('Style','frame','Units','normalized','BackgroundColor',handles.background_color,...
'position',[handles.left_edge_of_panel,handles.top_of_panel,handles.width_of_panel,1-handles.top_of_panel],'ForegroundColor',...
handles.background_color,'parent',handles.fig);
uistack(handles.top_blocking_frame,'top');
handles.bottom_blocking_frame=uicontrol('Style','frame','Units','normalized','BackgroundColor',handles.background_color,...
'position',[handles.left_edge_of_panel,0.0,handles.width_of_panel,handles.bottom_of_panel],'ForegroundColor',...
handles.background_color,'parent',handles.fig);
uistack(handles.bottom_blocking_frame,'top');

% Channel Filename Scrollbar
handles.scroll_bar=uicontrol('Style', 'slider',...
        'Min',0,'Max',1,'Value',1,'Units','normalized',...
        'position', [handles.right_edge_of_panel+0.01,handles.bottom_of_panel,0.015,handles.height_of_panel],...
        'Callback', {@scroll_callback,handles},'parent',handles.fig);


    

%Add/Delete Channel Buttons
handles.add_marker=uicontrol('Style', 'pushbutton',...
        'Units','normalized','String','Add marker',...
        'position', [handles.left_edge_of_panel+0.05,handles.bottom_of_panel-0.15,0.1,0.05],...
        'Callback', {@addmarker_callback,handles},'parent',handles.fig,...
        'BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color); %Add Channel
handles.delete_marker=uicontrol('Style', 'pushbutton',...
        'Units','normalized','String','Delete marker',...
        'position', [handles.left_edge_of_panel+0.2,handles.bottom_of_panel-0.15,0.1,0.05],...
        'Callback', {@deletemarker_callback,handles},'parent',handles.fig,...
        'BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color); %Delete Channel

%table to display matched files
handles.file_table=uitable('Units','normalized','position',...
    [handles.right_edge_of_panel+0.05,0.15,0.925-handles.right_edge_of_panel,0.4]...
    );
    
%Root Directory
handles.rootdirectory_text=uicontrol('Style','Text','String','Root Directory:',...
'Units','normalized','position',[0.05,0.95,0.1,0.03],'parent',handles.fig,...
'BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color,...
'HorizontalAlignment','left'); %Root directory static text
handles.rootdirectory_edit=uicontrol('Style','edit',...
'Units','normalized','position',[0.15,0.95,0.2,0.03],'parent',handles.fig,...
'BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color,...
'HorizontalAlignment','left'); % Root Directory as editable text box
handles.rootdirectory_pushbotton=uicontrol('Style', 'pushbutton',...
        'Units','normalized','String','Browse','BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color,...
        'position', [0.35,0.95,0.1,0.03],...
        'Callback', {@rootdirectory_pushbutton_callback,handles},'parent',handles.fig); %Button to launch uigetdir to pick root directory

%Directory Checks
handles.multichannel_checkbox=uicontrol('Style', 'checkbox',...
        'Units','normalized','String','Multichannel Files?','BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color,...
        'position', [0.05,0.9,0.3,0.03],...
        'Callback', {@rootdirectory_pushbutton_callback,handles},'parent',handles.fig); %Single or multichannel files?
handles.subdirs_checkbox=uicontrol('Style', 'checkbox','BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color,...
        'Units','normalized','String','Analyze SubDirectories?',...
        'position', [0.25,0.9,0.3,0.03],...
        'Callback', {@rootdirectory_pushbutton_callback,handles},'parent',handles.fig); %Analyze Subdirectories?

    
% Accept Results
handles.accept_button=uicontrol('Style', 'pushbutton',...
        'Units','normalized','String','Accept',...
        'position', [handles.right_edge_of_panel+0.2,0.05,0.15,0.075],...
        'Callback', {@accept_callback,handles},'parent',handles.fig,...
        'BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color); % Button to Accept Results and Exit

% Metadata Stuff
handles.groupby_listbox=uicontrol('Style', 'listbox',...
        'Units','normalized','String',{'Directory','Other Crap'},...
        'position', [handles.right_edge_of_panel+0.2,0.6,0.3,0.3],...
        'Callback', {@groupby_callback,handles},'parent',handles.fig,...
        'BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color); % Button to Accept Results and Exit

    
    
   
setappdata(0,'myhandles',myhandles);  
myhandles.marker_handles(myhandles.number_of_channels)=add_marker(handles.marker_start_pos...
-150*myhandles.number_of_channels,handles.main_panel,handles);
uistack(handles.main_panel,'bottom');


setappdata(0,'handles',handles);        
setappdata(0,'myhandles',myhandles);    

function accept_callback(hObject,eventdata,handles)
handles=getappdata(0,'handles');
myhandles=getappdata(0,'myhandles');
setappdata(0,'myhandles',myhandles);


delete(handles.fig);


function scroll_callback(hObject,eventdata,handles)
set(handles.main_panel,'position',[0.05,handles.top_of_panel-handles.main_panel_height+(1-get(hObject,'Value'))*(handles.main_panel_height-handles.height_of_panel),0.6,0.9]);
setappdata(0,'handles',handles);   

function addmarker_callback(hObject,eventdata,handles)
myhandles=getappdata(0,'myhandles');  
handles=getappdata(0,'handles');
myhandles.number_of_channels=myhandles.number_of_channels+1;
setappdata(0,'myhandles',myhandles);
myhandles.marker_handles(myhandles.number_of_channels)=add_marker(handles.marker_start_pos-150*myhandles.number_of_channels,handles.main_panel,handles);
setappdata(0,'handles',handles);   
setappdata(0,'myhandles',myhandles);

function deletemarker_callback(hObject,eventdata,handles)
myhandles=getappdata(0,'myhandles');  
setappdata(0,'myhandles',myhandles);
%delete(handles.marker_handles(myhandles.number_of_channels));
delete(myhandles.marker_handles(myhandles.number_of_channels).marker_panel);
myhandles.number_of_channels=myhandles.number_of_channels-1;
setappdata(0,'handles',handles);   
setappdata(0,'myhandles',myhandles);


function rootdirectory_pushbutton_callback(hObject,eventdata,handles)
dir_name=uigetdir();
myhandles=getappdata(0,'myhandles'); 
if(~exist(char(dir_name),'dir'))
        dir_name='';
        warndlg('Invalid Root Directory');
else
        myhandles.all_files=files_in_dir(dir_name);
        temp=regexp(myhandles.all_files,[dir_name filesep],'split');
        set(handles.file_table,'Data',cellfun(@(x) x(end),temp));
end
set(handles.rootdirectory_edit,'String',dir_name);
setappdata(0,'myhandles',myhandles);   
setappdata(0,'handles',handles);   

function marker_handles=add_marker(height,parent_handle,handles)
%panel_dims = get(parent_handle,'position')              % Get the axis limits [xlim ylim (zlim)]
panel_width=handles.width_of_panel*handles.gui_width;
panel_height=handles.height_of_panel*handles.gui_height;
myhandles=getappdata(0,'myhandles');

row=linspace(0.8,0.05,4);

marker_handles.marker_panel=uipanel('Title',['Marker Number ' num2str(myhandles.number_of_channels)],'BackgroundColor',handles.background_color,...
'ForegroundColor',handles.foreground_color,'Units','pixels','position',[0.05*panel_width,height,0.95*panel_width,0.2*handles.gui_height],...
'parent',parent_handle);
uistack(marker_handles.marker_panel,'bottom');
marker_handles.marker_ending_text=uicontrol('Style','Text','String','File ends in',...
'Units','normalized','position',[0.05,row(1),0.2,0.15],'parent',marker_handles.marker_panel,...
'BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color,...
'HorizontalAlignment','left');
marker_handles.marker_ending_edit=uicontrol('Style','edit','Units','normalized',...
'position',[0.25,row(1),0.4,0.15],'parent',marker_handles.marker_panel,...
'BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color,...
'HorizontalAlignment','left','Callback',{@marker_ending_edit_callback,handles});
marker_handles.marker_color_text=uicontrol('Style','Text','String','Color:',...
'Units','normalized','position',[0.675,row(1),0.1,0.15],'parent',marker_handles.marker_panel,...
'BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color,...
'HorizontalAlignment','left');
marker_handles.marker_color_popup=uicontrol('Style','popupmenu','Units','normalized',...
'position',[0.775,row(1),0.2,0.15],'parent',marker_handles.marker_panel,'String',{'-','Red','Green','Blue'},...
'BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color,...
'HorizontalAlignment','center');
marker_handles.marker_name_text=uicontrol('Style','Text','String','Name:',...
'Units','normalized','position',[0.05,row(2),0.2,0.15],'parent',marker_handles.marker_panel,...
'BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color,...
'HorizontalAlignment','left');
marker_handles.marker_name_edit=uicontrol('Style','edit','Units','normalized',...
'position',[0.15,row(2),0.3,0.15],'parent',marker_handles.marker_panel,...
'BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color,...
'HorizontalAlignment','left','Callback',{@marker_name_edit_callback,marker_handles});
marker_handles.marker_metadata_popupmenu=uicontrol('Style','popupmenu','Units','normalized',...
'position',[0.25,row(3),0.3,0.15],'parent',marker_handles.marker_panel,'String',{'File Name','Full Path'},...
'BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color,...
'HorizontalAlignment','left','Callback',{@marker_metadata_checkbox_callback,marker_handles},'Visible','off');
marker_handles.marker_metadata_text=uicontrol('Style','Text','String','Metadata from:',...
'Units','normalized','position',[0.05,row(3),0.2,0.15],'parent',marker_handles.marker_panel,...
'BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color,...
'HorizontalAlignment','left','Visible','off');
marker_handles.marker_regexp_text=uicontrol('Style','Text','String','Reg Exp:',...
'Units','normalized','position',[0.6,row(3),0.2,0.15],'parent',marker_handles.marker_panel,...
'BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color,...
'HorizontalAlignment','left','Visible','off');
marker_handles.marker_regexp_edit=uicontrol('Style','edit','Units','normalized',...
'position',[0.15,row(4),0.5,0.15],'parent',marker_handles.marker_panel,...
'BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color,...
'HorizontalAlignment','left','Callback',{@marker_name_edit_callback,marker_handles},'Visible','off');
marker_handles.marker_regexp_wizard=uicontrol('Style','pushbutton','Units','normalized',...
'position',[0.6,row(4),0.3,0.15],'String','Launch Wizard','parent',marker_handles.marker_panel,...
'BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color,...
'HorizontalAlignment','left','Callback',{@marker_regexp_wizard_callback,marker_handles,myhandles.number_of_channels},'Visible','off');

marker_handles.marker_metadata_checkbox=uicontrol('Style','checkbox','Units','normalized',...
'position',[0.5,row(2),0.5,0.15],'parent',marker_handles.marker_panel,'String','Extract Metadata?',...
'BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color,...
'HorizontalAlignment','left','Callback',{@marker_metadata_checkbox_callback,marker_handles});
setappdata(0,'handles',handles); 


function marker_regexp_wizard_callback(hObject,eventdata,marker_handles,channel_number)
handles=getappdata(0,'handles');
file_names=get(handles.file_table,'Data');
myhandles=getappdata(0,'myhandles');
myhandles.wizard_files=file_names(:,channel_number);
setappdata(0,'myhandles',myhandles); 
RegExp_Wizard();


function marker_name_edit_callback(hObject,eventdata,marker_handles)
set(marker_handles.marker_panel,'Title',get(hObject,'String'));
%setappdata(0,'handles',handles);   

function marker_ending_edit_callback(hObject,eventdata,handles)
set(handles.file_table,'Data',contruct_filetable());
setappdata(0,'handles',handles);   

    

function marker_metadata_checkbox_callback(hObject,eventdata,marker_handles)
if(get(hObject,'Value'))
on_off='on';
else
on_off='off';
end
set(marker_handles.marker_metadata_popupmenu,'Visible',on_off);
set(marker_handles.marker_metadata_text,'Visible',on_off);
set(marker_handles.marker_regexp_text,'Visible',on_off);
set(marker_handles.marker_regexp_edit,'Visible',on_off);
set(marker_handles.marker_regexp_wizard,'Visible',on_off);

function file_matrix=contruct_filetable()
myhandles=getappdata(0,'myhandles');
handles=getappdata(0,'handles');
number_of_cols=myhandles.number_of_channels;
channel_wise_matches=cell(1,myhandles.number_of_channels);
rexp=cell(1,myhandles.number_of_channels);
for channel=1:myhandles.number_of_channels
    rexp{channel}=get(myhandles.marker_handles(channel).marker_ending_edit,'String');
    matches=myhandles.all_files(~cellfun('isempty',regexp(myhandles.all_files,[rexp{channel} '$'],'match')));
    temp=regexp(matches,[rexp{channel} '$'] ,'split');
    channel_wise_matches{channel}=cellfun(@(x) x(1),temp);
end
common_files=channel_wise_matches{1};

for channel=2:myhandles.number_of_channels
    common_files=intersect(common_files,channel_wise_matches{channel});
end

if(isempty(common_files))
   file_matrix={'No Files In Common'}; 
else
    file_matrix=cell(length(common_files),myhandles.number_of_channels);
    for match_num=1:length(common_files)
        temp=common_files{match_num}(length(get(handles.rootdirectory_edit,'String'))+2:end);
        for channel=1:myhandles.number_of_channels
            file_matrix{match_num,channel}=[temp rexp{channel}];
        end
    end
  myhandles.common_files=file_matrix;
  setappdata(0,'myhandles',myhandles);
end
