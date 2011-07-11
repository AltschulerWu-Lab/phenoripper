function varargout = wizard_accept(varargin)
% WIZARD_ACCEPT M-file for wizard_accept.fig
%      WIZARD_ACCEPT, by itself, creates a new WIZARD_ACCEPT or raises the existing
%      singleton*.
%
%      H = WIZARD_ACCEPT returns the handle to a new WIZARD_ACCEPT or the handle to
%      the existing singleton*.
%
%      WIZARD_ACCEPT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WIZARD_ACCEPT.M with the given input arguments.
%
%      WIZARD_ACCEPT('Property','Value',...) creates a new WIZARD_ACCEPT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before wizard_accept_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to wizard_accept_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wizard_accept

% Last Modified by GUIDE v2.5 24-May-2011 12:52:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @wizard_accept_OpeningFcn, ...
                   'gui_OutputFcn',  @wizard_accept_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before wizard_accept is made visible.
function wizard_accept_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to wizard_accept (see VARARGIN)

% Choose default command line output for wizard_accept
handles.output = hObject;
myhandles=getappdata(0,'myhandles');
[table_data,field_names]=convert_struct_to_table(myhandles.metadata);
set(handles.popupmenu1,'String',field_names);
set(handles.accepted_table,'Data',table_data);
set(handles.rejected_table,'Data',myhandles.all_files(~myhandles.matched_files));
popupmenu1_Callback(hObject, eventdata, handles)
% Update handles structure
guidata(hObject, handles);


% UIWAIT makes wizard_accept wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = wizard_accept_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        popupmenu1
myhandles=getappdata(0,'myhandles');
number_of_files=length(myhandles.metadata);
try
    group_index=get(hObject,'Value');
catch
    
    group_index=1;
end
   
myhandles.chosen_grouping_field=group_index;

%fnames=fieldnames(myhandles.metadata{1});
%file_class=cell(1,number_of_files);
%for i=1:number_of_files
%    file_class{i}=myhandles.metadata{i}.(cell2mat(fnames(group_index+1)));
%end
%root_indices=find(ismember(file_class,''));
%for i=1:length(root_indices)
%    file_class{i}='root_directory'; %This is an ugly hack, fix it
%end
%[G,GN]=grp2idx(file_class);
%number_of_groups=max(G);
%grouped_metadata=cell(1,number_of_groups);
%counter=1;
%order=zeros(number_of_files,1);
%groups=zeros(number_of_files,1);
%for group_number=1:number_of_groups
%   group_indices=find(G==group_number);
%
%   filenames=cell(length(group_indices),myhandles.files_per_image);
%   for i=1:length(group_indices)
%       filenames(i,:)=myhandles.metadata{group_indices(i)}.FileNames;
%       order(counter)=group_indices(i);
%       groups(counter)=group_number;
%       counter=counter+1;
%   end
%   grouped_metadata{group_number}.files_in_group=filenames;
%    
%   for field_num=3:length(fnames)
%       field_vals=cell(1,length(group_indices));
%       for i=1:length(group_indices)
%           field_vals{i}=myhandles.metadata{group_indices(i)}.(cell2mat(fnames(field_num)));
%       end
%       [G1,GN1]=grp2idx(field_vals);
%       if(max(G1)<=1)
%           grouped_metadata{group_number}.(cell2mat(fnames(field_num)))=GN1(1);
%       else
%           grouped_metadata{group_number}.(cell2mat(fnames(field_num)))=NaN;
%       end
%   end
%end
%myhandles.grouped_metadata=grouped_metadata;
%
[myhandles.grouped_metadata,~,order,groups,~]=...
CalculateGroups(group_index,myhandles.metadata,[],[]);
ordered_data=myhandles.metadata(order);
[raw_table_data,colnames]=convert_struct_to_table(ordered_data);
temp=color_table(raw_table_data,groups);
set(handles.accepted_table,'Data',temp,'ColumnName',colnames);
myhandles.grouping_fields=colnames(2:end);
setappdata(0,'myhandles',myhandles);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in accept_button.
function accept_button_Callback(hObject, eventdata, handles)
% hObject    handle to accept_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
delete(myhandles.wizard_handle);
delete(gcf);



% --- Executes on button press in back_button.
function back_button_Callback(hObject, eventdata, handles)
% hObject    handle to back_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(gcf);


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


% --- Executes on button press in metadata_button.
function metadata_button_Callback(hObject, eventdata, handles)
% hObject    handle to metadata_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
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
                                    
