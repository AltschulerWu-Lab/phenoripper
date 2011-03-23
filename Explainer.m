function varargout = Explainer(varargin)
% EXPLAINER M-file for Explainer.fig
%      EXPLAINER, by itself, creates a new EXPLAINER or raises the existing
%      singleton*.
%
%      H = EXPLAINER returns the handle to a new EXPLAINER or the handle to
%      the existing singleton*.
%
%      EXPLAINER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPLAINER.M with the given input arguments.
%
%      EXPLAINER('Property','Value',...) creates a new EXPLAINER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Explainer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Explainer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Explainer

% Last Modified by GUIDE v2.5 15-Mar-2011 14:58:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Explainer_OpeningFcn, ...
                   'gui_OutputFcn',  @Explainer_OutputFcn, ...
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


% --- Executes just before Explainer is made visible.
function Explainer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Explainer (see VARARGIN)

% Choose default command line output for Explainer
handles.output = hObject;
myhandles=getappdata(0,'myhandles');
set(handles.listbox1,'String',myhandles.grouping_fields);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Explainer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Explainer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
myhandles=getappdata(0,'myhandles');
contents = cellstr(get(hObject,'String'));     
grouping_field=contents{get(hObject,'Value')};
group_vals=cell(1,myhandles.number_of_conditions);
for condition=1:myhandles.number_of_conditions
   group_vals{condition}=cell2mat(myhandles.grouped_metadata{condition}.(grouping_field)); 
end
[group_numbers,field_names]=grp2idx(group_vals);
set(handles.popupmenu1,'String',field_names);
set(handles.popupmenu2,'String',field_names);

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


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


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)\
myhandles=getappdata(0,'myhandles');
contents = cellstr(get(handles.listbox1,'String'));     
grouping_field=contents{get(handles.listbox1,'Value')};
for condition=1:myhandles.number_of_conditions
   group_vals{condition}=cell2mat(myhandles.grouped_metadata{condition}.(grouping_field)); 
end
[group_numbers,field_names]=grp2idx(group_vals);
first_group=find(group_numbers==get(handles.popupmenu1,'Value'));
second_group=find(group_numbers==get(handles.popupmenu2,'Value'));

data=[myhandles.superblock_profiles(first_group,:);myhandles.superblock_profiles(second_group,:)];
categories=group_numbers([first_group;second_group]);

p_vals=zeros(1,myhandles.number_of_superblocks);
for i=1:myhandles.number_of_superblocks
    [h,p_vals(i)]=ttest2(myhandles.superblock_profiles(first_group,i),myhandles.superblock_profiles(second_group,i));
    %p_vals(i)=ranksum(myhandles.superblock_profiles(first_group,i),myhandles.superblock_profiles(second_group,i));
end
svm_struct=svmtrain(data,categories);%,'AutoScale',false);
svm_function(svm_struct,myhandles.superblock_profiles(7,:))


figure;

[sorted_p,p_indices]=sort(p_vals);
number_of_reps=min(nnz(p_vals<0.1),5);

for i=1:number_of_reps
   subplot(1,number_of_reps,i);
   img=double(myhandles.global_data.superblock_representatives{p_indices(i),1}(:,:,1:3));
   max_col=max(img(:));
   image(img/max_col);axis equal;axis off;
end
disp('meow');
% axis
% good_blocks=find(p_vals<0.005);
% subplot(length(good_blocks)+1,3,2);
% text('Class 1');
% subplot(length(good_blocks)+1,3,2);
% text('Class 2');
% svm_struct=svmtrain(data,categories,'AutoScale',false);





