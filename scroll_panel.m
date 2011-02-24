function varargout = scroll_panel(varargin)
myhandles=getappdata(0,'myhandles');
myhandles.files_per_image=1;
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
        'Callback', {@multichannel_checkbox_callback,handles},'parent',handles.fig); %Single or multichannel files?
handles.subdirs_checkbox=uicontrol('Style', 'checkbox','BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color,...
        'Units','normalized','String','Analyze SubDirectories?',...
        'position', [0.25,0.9,0.3,0.03],...
        'Callback', {@rootdirectory_pushbutton_callback,handles},'parent',handles.fig); %Analyze Subdirectories?

% Dealing with Multichannel files
handles.numberofchannels_text=uicontrol('Style','Text','String','Number of Channels:',...
'Units','normalized','position',[0.05,0.85,0.15,0.03],'parent',handles.fig,...
'BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color,...
'HorizontalAlignment','left','Visible','off'); %Root directory static text
handles.numberofchannels_popupmenu=uicontrol('Style','popupmenu','String',{'1','2','3','4','5'},...
'Units','normalized','position',[0.2,0.85,0.05,0.03],'parent',handles.fig,...
'BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color,...
'HorizontalAlignment','left','Visible','off'); %Root directory static text


    
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
handles.metadatafile_button=uicontrol('Style', 'pushbutton',...
        'Units','normalized','String','MetaData From File',...
        'position', [handles.right_edge_of_panel+0.2,0.9,0.15,0.075],...
        'Callback', @metadatafile_callback,'parent',handles.fig,...
        'BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color); % Button to Accept Results and Exit


    
    
   
setappdata(0,'myhandles',myhandles);  
myhandles.marker_handles(myhandles.files_per_image)=add_marker(handles.marker_start_pos...
-150*myhandles.files_per_image,handles.main_panel,handles);
uistack(handles.main_panel,'bottom');


setappdata(0,'handles',handles);        
setappdata(0,'myhandles',myhandles);    

function accept_callback(hObject,eventdata,handles)
handles=getappdata(0,'handles');
myhandles=getappdata(0,'myhandles');
setappdata(0,'myhandles',myhandles);
if(get(handles.multichannel_checkbox,'Value'))
       myhandles.number_of_channels=get(handles.numberofchannels_popupmenu,'Value'); 
else
        myhandles.number_of_channels=myhandles.files_per_image;
end
setappdata(0,'myhandles',myhandles);
delete(handles.fig);


function scroll_callback(hObject,eventdata,handles)
handles=getappdata(0,'handles');
set(handles.main_panel,'position',[0.05,handles.top_of_panel-handles.main_panel_height+(1-get(hObject,'Value'))*(handles.main_panel_height-handles.height_of_panel),0.6,0.9]);
setappdata(0,'handles',handles);   

function addmarker_callback(hObject,eventdata,handles)
myhandles=getappdata(0,'myhandles');  
handles=getappdata(0,'handles');
myhandles.files_per_image=myhandles.files_per_image+1;
setappdata(0,'myhandles',myhandles);
myhandles.marker_handles(myhandles.files_per_image)=add_marker(handles.marker_start_pos-150*myhandles.files_per_image,handles.main_panel,handles);
myhandles.regular_expressions{myhandles.files_per_image}='';
setappdata(0,'handles',handles);   
setappdata(0,'myhandles',myhandles);

function deletemarker_callback(hObject,eventdata,handles)
myhandles=getappdata(0,'myhandles');  
handles=getappdata(0,'handles'); 
setappdata(0,'myhandles',myhandles);
%delete(handles.marker_handles(myhandles.files_per_image));
delete(myhandles.marker_handles(myhandles.files_per_image).marker_panel);
myhandles.regular_expressions(files_per_image)=[];
myhandles.files_per_image=myhandles.files_per_image-1;
setappdata(0,'handles',handles);   
setappdata(0,'myhandles',myhandles);


function rootdirectory_pushbutton_callback(hObject,eventdata,handles)
handles=getappdata(0,'handles'); 
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

function multichannel_checkbox_callback(hObject,eventdata,handles)
handles=getappdata(0,'handles');
if(get(hObject,'Value'))
set(handles.numberofchannels_popupmenu,'Visible','on');
set(handles.numberofchannels_text,'Visible','on');
else
set(handles.numberofchannels_popupmenu,'Visible','off');
set(handles.numberofchannels_text,'Visible','off');
end
setappdata(0,'handles',handles);

function metadatafile_callback(hObject,eventdata)
[filename,pathname]=uigetfile('*.txt');
[filenames,metadata]=ReadData([pathname filesep filename],',');
myhandles=getappdata(0,'myhandles');
file_matrix=cell(length(filenames),length(filenames{1}));
for i=1:length(filenames)
    for j=1:length(filenames{1})
        file_matrix{i,j}=filenames{i}{j};
        if(~exist(file_matrix{i,j},'file'))
            errordlg('File Missing');
            return;
        end
    end
end
[myhandles.metadata,matched_files]=extract_regexp_metadata(file_matrix,myhandles.regular_expressions);
matched_files=find(matched_files);
fnames=fieldnames(metadata);
for i=1:length(matched_files)
    for j=1:length(fnames)    
        myhandles.metadata{i}.(fnames{j})=metadata(matched_files(i)).(fnames{j});
    end
end
myhandles.files_per_image=length(filenames{1});
handles=getappdata(0,'handles');
fnames=fieldnames(myhandles.metadata{1});
set(handles.groupby_listbox,'String',fnames(2:end));
setappdata(0,'handles',handles);
setappdata(0,'myhandles',myhandles); %Should probably throw in some checks to
                                     % make sure that myhandles.files_per_image is not being reset
                                     


function marker_handles=add_marker(height,parent_handle,handles)
%panel_dims = get(parent_handle,'position')              % Get the axis limits [xlim ylim (zlim)]
panel_width=handles.width_of_panel*handles.gui_width;
panel_height=handles.height_of_panel*handles.gui_height;
myhandles=getappdata(0,'myhandles');

row=linspace(0.8,0.05,4);

marker_handles.marker_panel=uipanel('Title',['Marker Number ' num2str(myhandles.files_per_image)],'BackgroundColor',handles.background_color,...
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
'HorizontalAlignment','left','Callback',{@marker_ending_edit_callback});
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
'position',[0.1,row(4),0.5,0.15],'parent',marker_handles.marker_panel,...
'BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color,...
'HorizontalAlignment','left','Callback',{@marker_regexp_edit_callback,marker_handles,myhandles.files_per_image},'Visible','off');
marker_handles.marker_regexp_wizard=uicontrol('Style','pushbutton','Units','normalized',...
'position',[0.6,row(4),0.3,0.15],'String','Launch Wizard','parent',marker_handles.marker_panel,...
'BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color,...
'HorizontalAlignment','left','Callback',{@marker_regexp_wizard_callback,marker_handles,myhandles.files_per_image},'Visible','off');

marker_handles.marker_metadata_checkbox=uicontrol('Style','checkbox','Units','normalized',...
'position',[0.5,row(2),0.5,0.15],'parent',marker_handles.marker_panel,'String','Extract Metadata?',...
'BackgroundColor',handles.background_color,'ForegroundColor',handles.foreground_color,...
'HorizontalAlignment','left','Callback',{@marker_metadata_checkbox_callback,marker_handles});
%setappdata(0,'handles',handles); 


function marker_regexp_wizard_callback(hObject,eventdata,marker_handles,channel_number)
handles=getappdata(0,'handles');
file_names=get(handles.file_table,'Data');
myhandles=getappdata(0,'myhandles');
myhandles.wizard_files=file_names(:,channel_number);
myhandles.regexp_text=get(marker_handles.marker_regexp_edit,'String');
setappdata(0,'myhandles',myhandles); 
RegExp_Wizard();
uiwait;
myhandles=getappdata(0,'myhandles');
regular_expression=myhandles.regexp_text;
set(marker_handles.marker_regexp_edit,'String',regular_expression);
myhandles.regular_expressions{channel_number}=myhandles.regexp_text;
[myhandles.metadata,~]=extract_regexp_metadata(myhandles.file_table,myhandles.regular_expressions);
temp=fieldnames(myhandles.metadata{1});
handles=getappdata(0,'handles');
set(handles.groupby_listbox,'String',temp(2:end));
setappdata(0,'myhandles',myhandles);
setappdata(0,'handles',handles);



function marker_name_edit_callback(hObject,eventdata,marker_handles)
set(marker_handles.marker_panel,'Title',get(hObject,'String'));
%setappdata(0,'handles',handles);   

function marker_ending_edit_callback(hObject,eventdata)
myhandles=getappdata(0,'myhandles');
handles=getappdata(0,'handles');
myhandles.file_table=contruct_filetable();
set(handles.file_table,'Data',myhandles.file_table);
setappdata(0,'handles',handles);   
setappdata(0,'myhandles',myhandles);   

function marker_regexp_edit_callback(hObject,eventdata,marker_handles,channel_number)
myhandles=getappdata(0,'myhandles');
myhandles.regular_expressions{channel_number}=get(hObject,'String');
[myhandles.metadata,~]=extract_regexp_metadata(myhandles.file_table,myhandles.regular_expressions);
temp=fieldnames(myhandles.metadata{1});
handles=getappdata(0,'handles');
set(handles.groupby_listbox,'String',temp(2:end));
setappdata(0,'myhandles',myhandles);
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

function groupby_callback(hObject,eventdata,handles)
myhandles=getappdata(0,'myhandles');
number_of_files=length(myhandles.metadata);
field_index=get(hObject,'Value');
fnames=fieldnames(myhandles.metadata{1});
file_class=cell(1,number_of_files);
for i=1:number_of_files
    file_class{i}=myhandles.metadata{i}.(cell2mat(fnames(field_index+1)));
end
root_indices=find(ismember(file_class,''));
for i=1:length(root_indices)
    file_class{i}='root_directory'; %This is an ugly hack, fix it
end
[G,GN]=grp2idx(file_class);
number_of_groups=max(G);
grouped_metadata=cell(1,number_of_groups);
counter=1;
order=zeros(number_of_files,1);
groups=zeros(number_of_files,1);
for group_number=1:number_of_groups
   group_indices=find(G==group_number);

   filenames=cell(length(group_indices),myhandles.files_per_image);
   for i=1:length(group_indices)
       filenames(i,:)=myhandles.metadata{group_indices(i)}.FileNames;
       order(counter)=group_indices(i);
       groups(counter)=group_number;
       counter=counter+1;
   end
   grouped_metadata{group_number}.files_in_group=filenames;
    
   for field_num=3:length(fnames)
       field_vals=cell(1,length(group_indices));
       for i=1:length(group_indices)
           field_vals{i}=myhandles.metadata{group_indices(i)}.(cell2mat(fnames(field_num)));
       end
       [G1,GN1]=grp2idx(field_vals);
       if(max(G1)<=1)
           grouped_metadata{group_number}.(cell2mat(fnames(field_num)))=GN1(1);
       else
           grouped_metadata{group_number}.(cell2mat(fnames(field_num)))=NaN;
       end
   end
end
myhandles.grouped_metadata=grouped_metadata;

ordered_data=myhandles.metadata(order);
[raw_table_data,colnames]=convert_struct_to_table(ordered_data);
handles=getappdata(0,'handles');
temp=color_table(raw_table_data,groups);
set(handles.file_table,'Data',temp,'ColumnName',colnames);
myhandles.grouping_fields=colnames(2:end);
setappdata(0,'myhandles',myhandles);




function file_matrix=contruct_filetable()
myhandles=getappdata(0,'myhandles');
handles=getappdata(0,'handles');
number_of_cols=myhandles.files_per_image;
channel_wise_matches=cell(1,myhandles.files_per_image);
rexp=cell(1,myhandles.files_per_image);
for channel=1:myhandles.files_per_image
    rexp{channel}=get(myhandles.marker_handles(channel).marker_ending_edit,'String');
    matches=myhandles.all_files(~cellfun('isempty',regexp(myhandles.all_files,[rexp{channel} '$'],'match')));
    temp=regexp(matches,[rexp{channel} '$'] ,'split');
    channel_wise_matches{channel}=cellfun(@(x) x(1),temp);
end
common_files=channel_wise_matches{1};

for channel=2:myhandles.files_per_image
    common_files=intersect(common_files,channel_wise_matches{channel});
end

if(isempty(common_files))
   file_matrix={'No Files In Common'}; 
else
    file_matrix=cell(length(common_files),myhandles.files_per_image);
    for match_num=1:length(common_files)
        temp=common_files{match_num}(length(get(handles.rootdirectory_edit,'String'))+2:end);
        for channel=1:myhandles.files_per_image
            file_matrix{match_num,channel}=[temp rexp{channel}];
        end
    end
  myhandles.common_files=file_matrix;
  setappdata(0,'myhandles',myhandles);
end

function [metadata,files_with_matches]=extract_regexp_metadata(file_matrix,regular_expressions)
[number_of_files,files_per_image]=size(file_matrix);
metadata=cell(1,number_of_files);

%Put directory selector here
 
dir_start=regexp(file_matrix(:,1),filesep);
handles=getappdata(0,'handles');
root_directory=get(handles.rootdirectory_edit,'String');
for i=1:number_of_files
   temp=file_matrix(i,:);
  % handles=getappdata(0,'handles');
   for j=1:files_per_image
        if(isempty(regexpi(temp{j},['^' root_directory],'match')))
                metadata{i}.FileNames{j}=[root_directory filesep temp{j}];
        else
                metadata{i}.FileNames{j}=temp{j};
        end
   end
   metadata{i}.None=file_matrix{i,1}; 
   if(~isempty(dir_start{i}))
       metadata{i}.Directory=file_matrix{i,1}(1:dir_start{i}(end));
   else
       metadata{i}.Directory='';
   end
end

files_with_matches=false(number_of_files,files_per_image);

for channel=1:files_per_image
    
        if(~isempty(regular_expressions{channel}))        
                file_names=file_matrix(:,channel);
                pattern=regular_expressions{channel};
                [idx edx ext mat tok nam] = regexp(file_names,pattern,...
                    'start','end','tokenExtents','match','tokens','names');
               
                matched_bool=~cellfun('isempty',mat);
                files_with_matches(:,channel)=matched_bool;
                matched=find(matched_bool);
            
                if(~isempty(matched))
                    fnames=fieldnames(nam{matched(1)});
                else
                    error('No matches');
                end
                
                
                for i=1:number_of_files
                    if(matched_bool(i))
                       for j=1:length(fnames)
                            temp=nam{i}.(fnames{j});
                            if(strcmp(temp,''))
                                metadata{i}.(fnames{j})=[];
                            else
                                metadata{i}.(fnames{j})=temp;                            
                            end
                          
                        end
                        
                    else
                        for j=1:length(fnames)
                            metadata{i}.(fnames{j})=[];
                        end
                    end
                end
        end
end
files_with_matches=any(files_with_matches,2);
metadata=metadata(files_with_matches);


function [table_data,field_names]=convert_struct_to_table(data)
number_of_groups=length(data);
fnames=fieldnames(data{1});
table_data=cell(number_of_groups,length(fnames)-1);

for i=1:number_of_groups
    for j=1:length(fnames)-1
       table_data{i,j}=data{i}.(fnames{j+1}); 
    end
end
field_names=fnames(2:end);
field_names{1}='File Name';

function formatted_data=color_table(raw_data,groups)
bg_colors=cell(size(raw_data));
fg_colors=cell(size(raw_data));
colors={'#A6CEE3', '#1F78B4','#B2DF8A','#33A02C','#FB9A99','#3E31A1C',...
    '#FDBF6F','#FF7F00','#CAB2D6','#6A3D9A'};
for i=1:size(raw_data,1)
   for j=1:size(raw_data,2)
       fg_colors{i,j}=colors{rem(groups(i)-1,10)+1};
   end
end
formatted_data=create_formatted_table(raw_data,fg_colors,bg_colors);



