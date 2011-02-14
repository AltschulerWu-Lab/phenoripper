function varargout = RegExp_Wizard(varargin)
% REGEXP_WIZARD M-file for RegExp_Wizard.fig
%      REGEXP_WIZARD, by itself, creates a new REGEXP_WIZARD or raises the existing
%      singleton*.
%
%      H = REGEXP_WIZARD returns the handle to a new REGEXP_WIZARD or the handle to
%      the existing singleton*.
%
%      REGEXP_WIZARD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REGEXP_WIZARD.M with the given input arguments.
%
%      REGEXP_WIZARD('Property','Value',...) creates a new REGEXP_WIZARD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RegExp_Wizard_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RegExp_Wizard_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RegExp_Wizard

% Last Modified by GUIDE v2.5 11-Feb-2011 15:16:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RegExp_Wizard_OpeningFcn, ...
                   'gui_OutputFcn',  @RegExp_Wizard_OutputFcn, ...
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


% --- Executes just before RegExp_Wizard is made visible.
function RegExp_Wizard_OpeningFcn(hObject, eventdata, handles)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RegExp_Wizard (see VARARGIN)

% Choose default command line output for RegExp_Wizard
handles.output = hObject;
%myhandles.all_files=files_in_dir('./');
myhandles=getappdata(0','myhandles');
set(handles.FileTable,'Data',myhandles.wizard_files);
% Update handles structure
setappdata(0,'myhandles',myhandles);
guidata(hObject, handles);

% UIWAIT makes RegExp_Wizard wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = RegExp_Wizard_OutputFcn(hObject, eventdata, handles) 
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



function DefineRegExp_Callback(hObject, eventdata, handles)
% hObject    handle to DefineRegExp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
        
file_names=myhandles.wizard_files;
pattern=get(hObject,'String');
[idx edx ext mat tok nam] = regexp(file_names,pattern,...
            'start','end','tokenExtents','match','tokens','names');
        matched=find(~cellfun('isempty',mat));
        matched_bool=~cellfun('isempty',mat);
       % no_matches=find(cellfun('isempty',mat));
        if(~isempty(matched))
            fnames=fieldnames(nam{matched(1)});
        else
            error('No matches');
        end
        cnames=cell(length(fnames)+1,1);
        cnames{1}='File Name';
      
        for i=1:length(fnames)
            cnames{1+i}=fnames{i};
        end
        file_data=cell(length(file_names),length(fnames)+1);
        file_data(:,1)=file_names;
        matched_data=cell(length(matched),length(fnames)+2);
        %non_matched_data=cell(length(no_matches),1);
        non_matched_data=file_data(cellfun('isempty',mat));
        
        multiple_matches_bool=true(length(file_names),1);
         for i=1:length(file_names)
            if(matched_bool(i))
                if(length(nam{i})>1)
                multiple_matches_bool(i)=false;
                end
            end
         end
         matched_bool=(multiple_matches_bool) & (matched_bool);
        
        for i=1:length(file_names)
            if(matched_bool(i))
                is_empty=false;
                for j=1:length(fnames)
                    temp=nam{i}.(fnames{j});
                    if(strcmp(temp,''))
                        is_empty=true;
                        break;
                    end
                    
                end
                
                file_data{i,1}=file_names{i};
                if(is_empty)
                    file_data{i,1}=['<HTML><font color="blue">' file_data{i,1} '</font></HTML>'];
                end
                
                
                for j=1:length(fnames)
                    if(is_empty)
                        file_data{i,j+1}=['<HTML><font color="blue">' nam{i}.(fnames{j}) '</font></HTML>'];
                    else
                        file_data{i,j+1}=nam{i}.(fnames{j});
                    end
                end
                
            else
                file_data{i,1}=['<HTML><font color="red">' file_names{i} '</font></HTML>'];
            end
        end
        
        for i=1:length(matched)
           is_empty=false;
           matched_data{i,1}=file_names{matched(i)};
           for j=1:length(fnames)
               %file_data{matched(i),j+1}=nam{matched(i)}.(fnames{j});
               matched_data{i,j+2}=nam{matched(i)}.(fnames{j});
               if(strcmp(matched_data{i,j+2},''))
                   is_empty=true;
               end
           end
           if(is_empty)
               matched_data{i,2}='<HTML><font color="red">*</font></HTML>';
           else
                matched_data{i,2}='';
           end
           
        end
        set(handles.FileTable,'Data',file_data,'ColumnName',cnames);
        %set(handles.FileTable,'Data',matched_data,'ColumnName',cnames);
        %set(handles.Nonmatched_Table,'Data',non_matched_data,'ColumnName','Non-Matched Files');
        

% Hints: get(hObject,'String') returns contents of DefineRegExp as text
%        str2double(get(hObject,'String')) returns contents of DefineRegExp as a double


% --- Executes during object creation, after setting all properties.
function DefineRegExp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DefineRegExp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
