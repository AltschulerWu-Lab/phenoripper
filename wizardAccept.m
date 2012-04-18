function varargout = wizardAccept(varargin)
% WIZARDACCEPT MATLAB code for wizardAccept.fig
%      WIZARDACCEPT, by itself, creates a new WIZARDACCEPT or raises the existing
%      singleton*.
%
%      H = WIZARDACCEPT returns the handle to a new WIZARDACCEPT or the handle to
%      the existing singleton*.
%
%      WIZARDACCEPT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WIZARDACCEPT.M with the given input arguments.
%
%      WIZARDACCEPT('Property','Value',...) creates a new WIZARDACCEPT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before wizardAccept_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to wizardAccept_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wizardAccept

% Last Modified by GUIDE v2.5 28-Feb-2012 15:20:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @wizardAccept_OpeningFcn, ...
                   'gui_OutputFcn',  @wizardAccept_OutputFcn, ...
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


% --- Executes just before wizardAccept is made visible.
function wizardAccept_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to wizardAccept (see VARARGIN)

% Choose default command line output for wizardAccept
parsingMsgDlg = msgbox('Extracting Metadata information, Please wait...');
%Trick to show off the OK button
hc=get(parsingMsgDlg,'Children'); 
set(hc(2),'Visible','off');
drawnow;
pause(0.01);

wizardAcceptHandles.acceptedFiles=[];
wizardAcceptHandles.rejectedFiles=[];
setappdata(0,'wizardAcceptHandles',wizardAcceptHandles);
try
  handles.output = hObject;
  % Update handles structure
  guidata(hObject, handles);  
  axis(handles.header);
  setappdata(0,'handles',handles);
  img=imread('wizard.png');
  image(img,'parent',handles.header);
  axis(handles.header,'off');
  
  myhandles=getappdata(0,'myhandles');
  [table_data,field_names]=convert_struct_to_table(myhandles.metadata);
  groupNameList=field_names;
  groupNameList{1}=['Random (don''','t know)'];
  set(handles.grouppopupmenu1,'String',groupNameList);
  
  
  wizardAcceptHandles=getappdata(0,'wizardAcceptHandles');  
  wizardAcceptHandles.acceptedFiles=table_data;
  %set(handles.accepted_table,'Data',table_data);
  if(~myhandles.use_metadata)
    wizardAcceptHandles.rejectedFiles=myhandles.all_files(~myhandles.matched_files);
    %set(handles.rejected_table,'Data',myhandles.all_files(~myhandles.matched_files));
  end  
  setappdata(0,'wizardAcceptHandles',wizardAcceptHandles);
  grouppopupmenu1_Callback(hObject, eventdata, handles)
  
  
  description=['Choose a strategy for sampling a representative subset '... 
    'of your data.%sIf you expect groups of images to be similar '...
    '(e.g. images from same wells, replicate experiments, similar perturbations),'...
    ' please select this group. Otherwise PhenoRipper will sample randomly.'];
  description=strrep(description, '%s', char(10));
  %description=strrep(description, '%x', num2str(length(groupNameList)));
  set(handles.description,'String',description);
  
  
  
 % Update handles structure
  guidata(hObject, handles);
  close(parsingMsgDlg);
catch
  close(parsingMsgDlg);
end





% --- Outputs from this function are returned to the command line.
function varargout = wizardAccept_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in grouppopupmenu1.
function grouppopupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to grouppopupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns grouppopupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from grouppopupmenu1
myhandles=getappdata(0,'myhandles');
number_of_files=length(myhandles.metadata);
try
    group_index=get(hObject,'Value');
catch    
    group_index=1;
end
   
myhandles.chosen_grouping_field=group_index;
[myhandles.grouped_metadata,~,order,groups,~]=...
    CalculateGroups(group_index,myhandles.metadata,[],[],[]);
ordered_data=myhandles.metadata(order);
[raw_table_data,colnames]=convert_struct_to_table(ordered_data);
temp=color_table(raw_table_data,groups);
wizardAcceptHandles=getappdata(0,'wizardAcceptHandles');
wizardAcceptHandles.acceptedFiles=temp;
wizardAcceptHandles.colNames=colnames;
setappdata(0,'wizardAcceptHandles',wizardAcceptHandles);
% set(handles.accepted_table,'Data',temp,'ColumnName',colnames);
myhandles.grouping_fields=colnames(2:end);
setappdata(0,'myhandles',myhandles);


% --- Executes during object creation, after setting all properties.
function grouppopupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to grouppopupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in inspectGroupingButton.
function inspectGroupingButton_Callback(hObject, eventdata, handles)
% hObject    handle to inspectGroupingButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wizardAcceptHandles=getappdata(0,'wizardAcceptHandles');
wizardAcceptView(wizardAcceptHandles.acceptedFiles,...
  wizardAcceptHandles.rejectedFiles,wizardAcceptHandles.colNames);

% --- Executes on button press in okButton.
function okButton_Callback(hObject, eventdata, handles)
% hObject    handle to okButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
if isfield(myhandles,'wizard_handle')
  delete(myhandles.wizard_handle);
end
if isfield(myhandles,'wizardMetaData_handle')
  delete(myhandles.wizardMetaData_handle);
end
delete(gcf);

