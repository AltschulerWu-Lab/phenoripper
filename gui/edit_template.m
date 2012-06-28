function varargout = edit_template(varargin)
% EDIT_TEMPLATE MATLAB code for edit_template.fig
%      EDIT_TEMPLATE, by itself, creates a new EDIT_TEMPLATE or raises the existing
%      singleton*.
%
%      H = EDIT_TEMPLATE returns the handle to a new EDIT_TEMPLATE or the handle to
%      the existing singleton*.
%
%      EDIT_TEMPLATE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EDIT_TEMPLATE.M with the given input arguments.
%
%      EDIT_TEMPLATE('Property','Value',...) creates a new EDIT_TEMPLATE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before edit_template_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to edit_template_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help edit_template

% Last Modified by GUIDE v2.5 25-Jun-2012 12:52:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @edit_template_OpeningFcn, ...
                   'gui_OutputFcn',  @edit_template_OutputFcn, ...
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


% --- Executes just before edit_template is made visible.
function edit_template_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to edit_template (see VARARGIN)

% Choose default command line output for edit_template
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
wizardhandles=getappdata(0,'wizardhandles');
template=wizardhandles.templates{wizardhandles.selectedTemplateID};
example=template.Example;
regExp=template.Pattern;
set(handles.multiChannelCB,'Value',template.isMultiChannel)
%regExp=template.getRegularExpression(wizardhandles.fileExtension,wizardhandles.channelSeparator);

set(handles.exampleTF,'String',example);
set(handles.regularExpressionTF,'String',regExp);
set(handles.descriptionTF,'String',wizardhandles.templates{wizardhandles.selectedTemplateID}.Description);
set(handles.groupByL,'String',template.getGroupbyList());

% UIWAIT makes edit_template wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = edit_template_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function nameTF_Callback(hObject, eventdata, handles)
% hObject    handle to nameTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nameTF as text
%        str2double(get(hObject,'String')) returns contents of nameTF as a double


% --- Executes during object creation, after setting all properties.
function nameTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nameTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function exampleTF_Callback(hObject, eventdata, handles)
% hObject    handle to exampleTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of exampleTF as text
%        str2double(get(hObject,'String')) returns contents of exampleTF as a double


% --- Executes during object creation, after setting all properties.
function exampleTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exampleTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function regularExpressionTF_Callback(hObject, eventdata, handles)
% hObject    handle to regularExpressionTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of regularExpressionTF as text
%        str2double(get(hObject,'String')) returns contents of regularExpressionTF as a double
wizardhandles=getappdata(0,'wizardhandles');
example=get(handles.exampleTF,'String');

pattern=get(handles.regularExpressionTF,'String');

wizardhandles.newTemplate=MyTemplate(example,pattern,get(handles.multiChannelCB,'Value'));
wizardhandles.newTemplate=wizardhandles.newTemplate.setPattern(pattern);
%wizardhandles.newTemplate=wizardhandles.newTemplate.setExample(example);




set(handles.groupByL,'String',wizardhandles.newTemplate.getGroupbyList());
setappdata(0,'wizardhandles',wizardhandles);

% --- Executes during object creation, after setting all properties.
function regularExpressionTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to regularExpressionTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function descriptionTF_Callback(hObject, eventdata, handles)
% hObject    handle to descriptionTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of descriptionTF as text
%        str2double(get(hObject,'String')) returns contents of descriptionTF as a double


% --- Executes during object creation, after setting all properties.
function descriptionTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to descriptionTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in groupByL.
function groupByL_Callback(hObject, eventdata, handles)
% hObject    handle to groupByL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns groupByL contents as cell array
%        contents{get(hObject,'Value')} returns selected item from groupByL


% --- Executes during object creation, after setting all properties.
function groupByL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to groupByL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in saveBT.
function saveBT_Callback(hObject, eventdata, handles)
% hObject    handle to saveBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wizardhandles=getappdata(0,'wizardhandles');
example=get(handles.exampleTF,'String');
[existAlready,position] = isExampleExist(example,wizardhandles.templates);
if(existAlready)  
  answer=questdlg(sprintf(['The Template Example exist already.'...
    'Using the same will erase the previous template.\n'...
    'Are you sure you want to do that?']), ...
 'Yes', 'No');
% Handle response
  switch answer
    case 'No'
      return;
  end
else
  position=length(wizardhandles.templates)+1;
end
%Add the new template
pattern=get(handles.regularExpressionTF,'String');
isMultiChannel=get(handles.multiChannelCB,'Value');
wizardhandles.newTemplate=MyTemplate(example,pattern,isMultiChannel);
wizardhandles.newTemplate.Description=get(handles.descriptionTF,'String');
wizardhandles.templates{position}=wizardhandles.newTemplate.setPattern(pattern);

setappdata(0,'wizardhandles',wizardhandles);
delete(gcf);

function [exist,i]=isExampleExist(example,templates)
  exist=0;
  for i=1:length(templates)
    if(strcmp(templates{i}.Example,example))
      exist=1;
      break;
    end
  end


% --- Executes on button press in multiChannelCB.
function multiChannelCB_Callback(hObject, eventdata, handles)
% hObject    handle to multiChannelCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of multiChannelCB
