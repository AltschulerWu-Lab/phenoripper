function varargout = wizard(varargin)
% WIZARD M-file for wizard.fig
%      WIZARD, by itself, creates a new WIZARD or raises the existing
%      singleton*.
%
%      H = WIZARD returns the handle to a new WIZARD or the handle to
%      the existing singleton*.
%
%      WIZARD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WIZARD.M with the given input arguments.
%
%      WIZARD('Property','Value',...) creates a new WIZARD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before wizard_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to wizard_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wizard

% Last Modified by GUIDE v2.5 21-Feb-2012 11:21:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @wizard_OpeningFcn, ...
                   'gui_OutputFcn',  @wizard_OutputFcn, ...
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


% --- Executes just before wizard is made visible.
function wizard_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to wizard (see VARARGIN)

% Choose default command line output for wizard
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);  
axis(handles.header);
setappdata(0,'handles',handles);
img=imread('wizard.png');
image(img,'parent',handles.header);
axis off;

%set(handles.header,'axes','off');
myhandles=getappdata(0,'myhandles');
myhandles.use_metadata=false;
setappdata(0,'myhandles',myhandles);
%Load the default template list

%Try first if we find some template in the user directory
if ispc
  userdir= getenv('USERPROFILE'); 
else
  userdir= getenv('HOME');
end
if isunix
  templateFile=[userdir filesep 'default-templates_unix.mat'];
else
  templateFile=[userdir filesep 'default-templates_windows.mat'];
end
if(~exist(templateFile, 'file'))%Take the default one if the user didn't save new Template
  if isunix
    templateFile='default-templates_unix.mat';
  else
    templateFile='default-templates_windows.mat';
  end
end

wizardhandles=load(templateFile,'templates');  
% if isunix
%   wizardhandles=load('default-templates_unix.mat','templates');
% else
%   wizardhandles=load('default-templates_windows.mat','templates');  
% end

setappdata(0,'wizardhandles',wizardhandles);
populateTemplateSelectorList(handles);
setappdata(0,'wizardhandles',wizardhandles);
set(handles.templateSelector,'value',1);
templateSelector_Callback('','',handles);
%set(handles.selectSingleChannelCB,'visible','off');



function populateTemplateSelectorList(handles)
  fileExtension=get(handles.fileExtensionTF,'String');
  channelSep=get(handles.channelSeparatorTF,'String');
  %Populate the Template list
  wizardhandles=getappdata(0,'wizardhandles');
  templateList=cell(1,length(wizardhandles.templates));
  for i=1:length(wizardhandles.templates)
    templateName=wizardhandles.templates{i}.getName(fileExtension,channelSep);
    if(wizardhandles.templates{i}.isMultiChannel)
      templateName=['<HTML><FONT color="red">' templateName '</Font></html>'];
    else
      templateName=['<HTML><FONT color="black">' templateName '</Font></html>'];
    end
    templateList{i}=templateName;    
    %templateList{i}=wizardhandles.templates{i}.getName(fileExtension,channelSep);
  end
  set(handles.templateSelector,'String',templateList);
  setappdata(0,'wizardhandles',wizardhandles);


% UIWAIT makes wizard wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = wizard_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
addProgressBarToMyHandle(handles);


function rootdirTF_Callback(hObject, eventdata, handles)
% hObject    handle to rootdirTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rootdirTF as text
%        str2double(get(hObject,'String')) returns contents of rootdirTF as a double


% --- Executes during object creation, after setting all properties.
function rootdirTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rootdirTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rootDirSelectBT.
function rootDirSelectBT_Callback(hObject, eventdata, handles)
% hObject    handle to rootDirSelectBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles=getappdata(0,'handles');
lastPath=loadLastPath('wizard');
if(~exist(char(lastPath),'dir'))
  dir_name=uigetdir();
else
  dir_name=uigetdir(lastPath);
end
myhandles=getappdata(0,'myhandles');
if(~exist(char(dir_name),'dir'))
  dir_name='';
  warndlg('Invalid Root Directory');
else
  set(myhandles.wizardStatusBarHandles.ProgressBar, 'Visible','on', 'Indeterminate','on');
  
  myhandles.wizardStatusBarHandles=statusbar(hObject,'Scanning Folder for images');
  drawnow expose update;
  set(handles.rootDirSelectBT,'Enable','off');
  set(handles.doneBT,'Enable','off');
  try
  myhandles.all_files=files_in_dir(dir_name);
  set(handles.rootDirSelectBT,'Enable','on');
  set(handles.doneBT,'Enable','on');
  catch
    set(handles.rootDirSelectBT,'Enable','on'); 
    set(handles.doneBT,'Enable','on');   
  end
  %temp=regexp(myhandles.all_files,[dir_name filesep],'split');
  saveLastPath(dir_name,'wizard');
end
set(handles.rootdirTF,'String',dir_name);
set(myhandles.wizardStatusBarHandles.ProgressBar, 'Visible','off','StringPainted','off');
myhandles.wizardStatusBarHandles=statusbar(hObject,'');
setappdata(0,'myhandles',myhandles);
setappdata(0,'handles',handles);

% --- Executes on button press in selectSingleChannelCB.
function selectSingleChannelCB_Callback(hObject, eventdata, handles)
% hObject    handle to selectSingleChannelCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% wizardhandles=getappdata(0','wizardhandles');

% selectedTemplateNr=get(handles.templateSelector,'value');
% if(wizardhandles.templates{selectedTemplateNr}.isMultiChannel)
%    msgbox({'You selected a MultiChannel Template :'...
%      'If your image is an RGB (JPEG, RGB TIFF etc...) one,'...
%      'the #Channels/image has to be set to 3 (as Red,Green and Blue)'},...
%      'MultiChannel Template Selected')
%    set(handles.nrChannelPerImageDB,'Value',3);
% end



% Hint: get(hObject,'Value') returns toggle state of selectSingleChannelCB
if(get(handles.selectSingleChannelCB,'Value')==0)
  %set(handles.nrChannelPerImageDB,'Visible','on');
  %set(handles.channelImageText,'Visible','on');
  %set(handles.detectChannelBT,'Visible','off');
else
  set(handles.nrChannelPerImageDB,'Visible','off');
  set(handles.channelImageText,'Visible','off');  
  myhandles=getappdata(0,'myhandles');
  if(~myhandles.use_metadata)
    set(handles.detectChannelBT,'Visible','on');
  end 
end

% --- Executes on selection change in nrChannelPerImageDB.
function nrChannelPerImageDB_Callback(hObject, eventdata, handles)
% hObject    handle to nrChannelPerImageDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns nrChannelPerImageDB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from nrChannelPerImageDB
% channelNr=get(handles.nrChannelPerImageDB,'Value');
% data=cell(channelNr,3);
% for i=1:channelNr
%   data{i,1}=true;
% end
% for i=1:channelNr
%   data{i,2}=num2str(i);
% end
% for i=1:channelNr
%   data{i,3}='';
% end
% set(handles.markerTable,'Visible','on');
% set(handles.ExportMetaDataButton,'Visible','on');
% set(handles.markerTable,'Data',data);
% set(handles.markerTable, 'ColumnWidth', {30 110 240, 90});
% msgbox(['Marker have been detected, please enter the name'...
%   'of each marker and click on Done to use this configuration.']);


% --- Executes during object creation, after setting all properties.
function nrChannelPerImageDB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nrChannelPerImageDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), ...
    get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in nrChannelDB.
function nrChannelDB_Callback(hObject, eventdata, handles)
% hObject    handle to nrChannelDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns nrChannelDB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from nrChannelDB


% --- Executes during object creation, after setting all properties.
function nrChannelDB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nrChannelDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
    get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fileExtensionTF_Callback(hObject, eventdata, handles)
% hObject    handle to fileExtensionTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fileExtensionTF as text
%        str2double(get(hObject,'String')) returns contents of fileExtensionTF as a double
populateTemplateSelectorList(handles);


% --- Executes during object creation, after setting all properties.
function fileExtensionTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileExtensionTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
    get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function channelSeparatorTF_Callback(hObject, eventdata, handles)
% hObject    handle to channelSeparatorTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of channelSeparatorTF as text
%        str2double(get(hObject,'String')) returns contents of channelSeparatorTF as a double
populateTemplateSelectorList(handles);

% --- Executes during object creation, after setting all properties.
function channelSeparatorTF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channelSeparatorTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
    get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in templateSelector.
function templateSelector_Callback(hObject, eventdata, handles)
% hObject    handle to templateSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns templateSelector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from templateSelector
[~, groupbyList,description]=getGroups(handles);
%Display group and the corresponding matching with the example
set(handles.groupSelector,'String',groupbyList);
description=strrep(description, '%s', char(10));
set(handles.descriptionText,'String',description);

%set(handles.descriptionText,'String',description);
set(handles.groupSelector,'Visible','on');
set(handles.text8,'Visible','on');
viewChannelSeparator(handles);
set(handles.markerTable,'Visible','off');
set(handles.ExportMetaDataButton,'Visible','off');

function [groups, groupExample,description]=getGroups(handles)
selectedTemplateNr = get(handles.templateSelector,'Value');
if(selectedTemplateNr<1)
  groups=[];
  return;
end
wizardhandles=getappdata(0','wizardhandles');
groups=wizardhandles.templates{selectedTemplateNr}.getGroupbyList();
regExp=getSelectedRegExp(handles);
if(isempty(regExp))
  warndlg('No Template have been selected, you must select a template!');
  return;
end
groupExample=wizardhandles.templates{selectedTemplateNr}.getGroupExampleList();
description=wizardhandles.templates{selectedTemplateNr}.Description;


function viewChannelSeparator(handles)
selectedTemplateNr = get(handles.templateSelector,'Value');
if(selectedTemplateNr<1)
  return;
end
wizardhandles=getappdata(0','wizardhandles');
if(wizardhandles.templates{selectedTemplateNr}.isMultiChannel)
  set(handles.channelSeparatorTF,'Visible','off');
  set(handles.text5,'Visible','off');
  set(handles.selectSingleChannelCB,'Value',0);
  set(handles.templateType,'String','Multi-Channel Template (n channels/image)');
  set(handles.templateType,'Foreground','red');
else
  set(handles.channelSeparatorTF,'Visible','on');
  set(handles.text5,'Visible','on');
  set(handles.selectSingleChannelCB,'Value',1);
  set(handles.templateType,'String','Single-Channel Template (1 channel/image)');
  set(handles.templateType,'Foreground','white');  
end
selectSingleChannelCB_Callback('','',handles);



% --- Executes during object creation, after setting all properties.
function templateSelector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to templateSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
    get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in editTemplateBT.
function editTemplateBT_Callback(hObject, eventdata, handles)

wizardhandles=getappdata(0,'wizardhandles');
wizardhandles.selectedTemplateID = get(handles.templateSelector,'Value');
wizardhandles.fileExtension = get(handles.fileExtensionTF,'String');
wizardhandles.channelSeparator = get(handles.channelSeparatorTF,'String');
setappdata(0,'wizardhandles',wizardhandles);
editTemplate;
uiwait;
populateTemplateSelectorList(handles);

% hObject    handle to editTemplateBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in groupSelector.
function groupSelector_Callback(hObject, eventdata, handles)
% hObject    handle to groupSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns groupSelector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from groupSelector


% --- Executes during object creation, after setting all properties.
function groupSelector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to groupSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'),...
    get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in doneBT.
function doneBT_Callback(hObject, eventdata, handles)
% hObject    handle to doneBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

myhandles=getappdata(0,'myhandles');
set(myhandles.wizardStatusBarHandles.ProgressBar, 'Visible','on', 'Indeterminate','on');
myhandles.wizardStatusBarHandles=statusbar(hObject,'Scanning through all images');
drawnow;
data=getWizardData(handles);
% myhandles=getappdata(0,'myhandles');
myhandles.rootDir=data.rootDir;
myhandles.wizardData=data;
setappdata(0,'myhandles',myhandles);
total_number_of_channels=length(myhandles.wizardData.markers);
myhandles.channels_used=[];
for i=1:total_number_of_channels
   if(myhandles.wizardData.markers{i}.isUse)
       myhandles.channels_used=[myhandles.channels_used;i];
   end
end
data=getWizardData(handles);
myhandles.markers=data.markers;
myhandles.allfiles=getAllFiles(myhandles.rootDir);
%Remove the rootDir from the full path    
myhandles.allfiles=cellfun(@(x) substring(myhandles.rootDir,x),...
  myhandles.allfiles,'UniformOutput',false);
setappdata(0,'myhandles',myhandles);
%Add the file separator at the end of the root directory if not exist
if ~strcmp(myhandles.rootDir(1:end-1),'/')
  myhandles.rootDir=[myhandles.rootDir '/'];
end

setappdata(0,'myhandles',myhandles);
[file_matrix,metadata,matched_files]=construct_filetable();
myhandles=getappdata(0,'myhandles');
myhandles.file_matrix=file_matrix;
myhandles.metadata=metadata;
myhandles.matched_files=matched_files;
myhandles.wizard_handle=gcf;
setappdata(0,'myhandles',myhandles);
%wizard_accept;
wizardAccept;


function result=substring(removeString,original)
  result=original(length(removeString)+2:end);


function [file_matrix,metadata,matched_files]=construct_filetable()
myhandles=getappdata(0,'myhandles');
handles=getappdata(0,'handles');
myhandles.number_of_channels=length(myhandles.channels_used);
myhandles.files_per_image=myhandles.number_of_channels;
if(myhandles.wizardData.nrChannelPerFile>1)
    myhandles.files_per_image=1;
end
setappdata(0,'myhandles',myhandles);
root_directory=myhandles.wizardData.rootDir;
root_directoryRegExp=regexptranslate('escape', [root_directory filesep]);
temp=regexp(myhandles.allfiles, root_directoryRegExp,'split');
all_files=cellfun(@(x) x(end),temp);
rexp=cell(1,myhandles.files_per_image);
for channel=1:myhandles.files_per_image
    rexp{channel}=myhandles.wizardData.markers{myhandles.channels_used(channel)}.regExp;
    channel_names{channel}=myhandles.wizardData.markers{myhandles.channels_used(channel)}.marker;
end
[mat nam] = regexp(all_files,rexp{1}, 'match','names');
matched_bool=~cellfun('isempty',mat);    
matches=all_files(matched_bool);
matched=find(matched_bool);
if(~isempty(matches))
   fnames=fieldnames(nam{matched(1)});
else
   errordlg('No matches');
end 
regExp=getSelectedRegExp(handles);
if(myhandles.files_per_image~=1)
    file_matrix=matched_filenames(matches,regExp,channel_names);
else
    file_matrix=matches;
end
[membership_matrix,member_position]=ismember(file_matrix,all_files);
file_matrix=file_matrix(all(membership_matrix,2),:);
matched_files=false(length(all_files),1);
matched_files(member_position(:))=true;

[number_of_images,files_per_image]=size(file_matrix);
metadata=cell(1,number_of_images);

dir_start=regexp(file_matrix(:,1),filesep);

for i=1:number_of_images
 temp=file_matrix(i,:);
  for j=1:files_per_image
    metadata{i}.FileNames{j}=temp{j};
  end
  metadata{i}.None=file_matrix{i,1}; 
  if(~isempty(dir_start{i}))
    metadata{i}.Directory=file_matrix{i,1}(1:dir_start{i}(end));
  else
    metadata{i}.Directory='';
  end
end

nam=nam(matched_bool);
for i=1:number_of_images
  for j=1:length(fnames)
    temp=nam{i}.(fnames{j});
    if(strcmp(temp,''))
        metadata{i}.(fnames{j})=[];
    else
        metadata{i}.(fnames{j})=temp;
    end
  end
end
setappdata(0,'myhandles',myhandles);


function data=getWizardData(handles)
selectedFolder=get(handles.rootdirTF,'String');
if(~isdir(selectedFolder))
  warndlg(['The choosen folder is not a valid directory.'...
    ' Please select a valid directory!']);
  return;
end
%Get the root directory
data.rootDir=selectedFolder;
%For each marker, get the information
markersData=get(handles.markerTable,'Data');
%Test if at least 1 marker has been selected
if(any(vertcat(markersData{:,1}))==0)
  warndlg('At least 1 marker has to be selected!');
  return;
end  
%Test is the selected marker data have all been filled
selectedMarkerIndex=find([markersData{:,1}]);
indx=~cellfun(@isempty,markersData(selectedMarkerIndex,:));
[rx,cx]=find(indx<1);
if(length(rx)>0 && length(cx))
  warndlg('You must described all the markers (Name)');
  return;
end

%Get the choosen Regular Expression
regExp=getSelectedRegExp(handles);
if(isempty(regExp))
  warndlg('No Template have been selected, you must select a template!');
  return;
end
%Remove the groups Separator and Extension from the regular expression
regExp=regexprep(regExp,'?<Separator>','');
regExp=regexprep(regExp,'?<Extension>','');

%Return the markerData in Structure
markers=cell(1,size(markersData,1));
for i=1:length(markers)
  markers{i}.isUse=markersData{i,1};
  markers{i}.marker=markersData{i,2};
  markers{i}.name=markersData{i,3};
  markers{i}.regExp=regexprep(regExp,'\(\?<Channel>.+?\)',markersData{i,2});
end
data.markers=markers;
data.nrChannelPerFile=1;
if(get(handles.selectSingleChannelCB,'Value')==0)
  data.nrChannelPerFile=get(handles.nrChannelPerImageDB,'Value');
end
data.pattern=getFullRegExp(handles);
data.groups=getGroups(handles);
disp(data);


% --- Executes on button press in testTemplateBT.
function testTemplateBT_Callback(hObject, eventdata, handles)
% hObject    handle to testTemplateBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in advancedEditBT.
 function advancedEditBT_Callback(hObject, eventdata, handles)
   
myhandles=getappdata(0,'myhandles');
myhandles.wizard_handle=gcf;
setappdata(0,'myhandles',myhandles);
 % hObject    handle to advancedEditBT (see GCBO)
 % eventdata  reserved - to be defined in a future version of MATLAB
 % handles    structure with handles and user data (see GUIDATA)
%wizardMetaData;



% --- Executes on button press in saveAllTemplatesBT.
function saveAllTemplatesBT_Callback(hObject, eventdata, handles)
% hObject    handle to saveAllTemplatesBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wizardhandles=getappdata(0,'wizardhandles');
answer=questdlg(sprintf('Save this pattern list as the default one?'), ...
'Yes', 'No');
%answer='No';%Always save for the specific user only...
if ispc
  userdir= getenv('USERPROFILE'); 
else
  userdir= getenv('HOME');
end

% Handle response
  switch answer
    case 'Yes'
%       try
%         templates=wizardhandles.templates;
%         if isunix
%           save('default-templates_unix.mat','templates');
%         else        
%           save('default-templates_windows.mat','templates');
%         end
%         msgbox(['Default Templates have been saved'],'Saved Template with success');
%       catch
        templates=wizardhandles.templates;
        if isunix
          save([userdir filesep 'default-templates_unix.mat'],'templates');
        else        
          save([userdir filesep 'default-templates_windows.mat'],'templates');
        end
        msgbox(['Default Templates have been saved'],'Saved Template with success');
%       end
    case 'No'
      templates=wizardhandles.templates;
      [fileName, pathName]=uiputfile('*.mat','Save as',...
          'template.mat');
      if(fileName)
        save([pathName fileName],'templates'); 
        msgbox(['Template has been saved in ' pathName fileName],...
          'Saved Template with success');
      end
  end



% --- Executes on button press in removeSelectedTemplateBT.
function removeSelectedTemplateBT_Callback(hObject, eventdata, handles)
% hObject    handle to removeSelectedTemplateBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

answer=questdlg(sprintf(['Are you sure you want to delete this Pattern']), ...
 'Yes', 'No');
% Handle response
  switch answer
    case 'No'
      return;
  end
wizardhandles=getappdata(0,'wizardhandles');
selected = get(handles.templateSelector,'Value');
templates= cell(1,length(wizardhandles.templates)-1);


wizardhandles.templates=removeFromCellArray(wizardhandles.templates,selected)

% index=1;
% for i=1:length(wizardhandles.templates)
%   if(i~=selected)
%   templates{index}=wizardhandles.templates{i};
%   end
%   index=index+1;
% end
% wizardhandles.templates=templates;
setappdata(0,'wizardhandles',wizardhandles);
populateTemplateSelectorList(handles);
set(handles.templateSelector,'Value',selected-1);



% --- Executes on button press in upTemplateBT.
function upTemplateBT_Callback(hObject, eventdata, handles)
% hObject    handle to upTemplateBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wizardhandles=getappdata(0,'wizardhandles');
selected = get(handles.templateSelector,'Value');
if(selected==1)
  return;
end
templates= wizardhandles.templates;
templates{selected-1}=wizardhandles.templates{selected};
templates{selected}=wizardhandles.templates{selected-1};
wizardhandles.templates=templates;
setappdata(0,'wizardhandles',wizardhandles);
populateTemplateSelectorList(handles);
set(handles.templateSelector,'Value',selected-1);



% --- Executes on button press in downTemplateBT.
function downTemplateBT_Callback(hObject, eventdata, handles)
% hObject    handle to downTemplateBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wizardhandles=getappdata(0,'wizardhandles');
selected = get(handles.templateSelector,'Value');
if(selected==length(wizardhandles.templates))
  return;
end
templates= wizardhandles.templates;
templates{selected+1}=wizardhandles.templates{selected};
templates{selected}=wizardhandles.templates{selected+1};
wizardhandles.templates=templates;
setappdata(0,'wizardhandles',wizardhandles);
populateTemplateSelectorList(handles);
set(handles.templateSelector,'Value',selected+1);


% --- Executes on button press in detectChannelBT.
function detectChannelBT_Callback(hObject, eventdata, handles)
% hObject    handle to detectChannelBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(get(handles.selectSingleChannelCB,'Value')==1)
  selectedFolder=get(handles.rootdirTF,'String');
  if(~isdir(selectedFolder))
    warndlg('The choosen folder is not a valid directory. Please select a valid directory!');
    return;
  end
  regExp=getSelectedRegExp(handles);
  if(isempty(regExp))
    warndlg('No Template have been selected, you must select a template!');
    return;
  end
  try    
    set(handles.rootDirSelectBT,'Enable','off');
    set(handles.doneBT,'Enable','off');
    channelList=getMarkersFromDir(selectedFolder,regExp,selectedFolder);
    set(handles.rootDirSelectBT,'Enable','on');
    set(handles.doneBT,'Enable','on');
  catch
    set(handles.rootDirSelectBT,'Enable','on');
    set(handles.doneBT,'Enable','on');
  end
  if(isempty(channelList))
    warndlg('Couldn detect the channel. Did you select the template corresponding to your data?');
    set(handles.markerTable,'Data',cell(0,3));
    set(handles.ExportMetaDataButton,'Visible','off');
    set(handles.markerTable,'Visible','off');
    return;
  end
  data=cell(length(channelList),3);
  for i=1:length(channelList)
    data{i,1}=true;
  end
  for i=1:length(channelList)
    data{i,2}=channelList{i};
  end
  for i=1:length(channelList)
    data{i,3}=['marker ' num2str(i)];
  end
  set(handles.markerTable,'Visible','on');
  set(handles.ExportMetaDataButton,'Visible','on');
  set(handles.markerTable,'Data',data);
  set(handles.markerTable, 'ColumnWidth', {30 110 220, 90});
  disp(channelList);
  msgbox(['Marker have been detected, please enter the name of each marker'...
    ' and click on Done to use this configuration.']);
else  
  %Read the first matching file and extract the number of channel from it!
  %Get the choosen Regular Expression
  regExp=getSelectedRegExp(handles);
  if(isempty(regExp))
    warndlg('No Template have been selected, you must select a template!');
    return;
  end
  %Remove the groups Separator and Extension from the regular expression
  regExp=regexprep(regExp,'?<Separator>','');
  rexp=regexprep(regExp,'?<Extension>','');  
  selectedFolder=get(handles.rootdirTF,'String');
  myhandles=getappdata(0,'myhandles');
  myhandles.rootDir=selectedFolder;
  
  try    
    set(handles.rootDirSelectBT,'Enable','off');
    set(handles.doneBT,'Enable','off');
    myhandles.allfiles=getAllFiles(selectedFolder); 
    root_directoryRegExp=regexptranslate('escape', [selectedFolder filesep]);
    %Should do the regexp in a loop so at the first match we stop!
    temp=regexp(myhandles.allfiles, root_directoryRegExp,'split');
    all_files=cellfun(@(x) x(end),temp);
    [mat ~]=regexp(all_files,rexp, 'match','names');
    fileName=[];
    for i=1:length(mat)
      if(~isempty(mat{i}))
        fileName=mat{i}{1};
        break;
      end
    end
    set(handles.rootDirSelectBT,'Enable','on');
    set(handles.doneBT,'Enable','on');
  catch
    set(handles.rootDirSelectBT,'Enable','on');
    set(handles.doneBT,'Enable','on');    
  end
  if isempty(fileName)
    errordlg('The regular expression does not match with your multichannel Images');
    return;
  end
  image1=imread2([selectedFolder filesep fileName]);  
  if(length(size(image1))~=3)
    errordlg('The regular expression does not match with your multichannel Images');
    return;
  end
  numberChannel=size(image1,3);
  set(handles.nrChannelPerImageDB,'Value',numberChannel);
  channelNr=get(handles.nrChannelPerImageDB,'Value');
  data=cell(channelNr,3);
  for i=1:channelNr
    data{i,1}=true;
  end
  for i=1:channelNr
    data{i,2}=num2str(i);
  end
  for i=1:channelNr
    data{i,3}='';
  end
  set(handles.markerTable,'Visible','on');
  set(handles.ExportMetaDataButton,'Visible','on');
  set(handles.markerTable,'Data',data);
  set(handles.markerTable, 'ColumnWidth', {30 110 240, 90});
  msgbox(['Marker have been detected, please enter the name'...
    'of each marker and click on Done to use this configuration.']);
end


function regExp=getSelectedRegExp(handles)
selectedTemplateNr = get(handles.templateSelector,'Value');
if(selectedTemplateNr<1)
  regExp=[];
  return;
end
wizardhandles=getappdata(0,'wizardhandles');
selectedTemplate=wizardhandles.templates{selectedTemplateNr};
fileExtension=get(handles.fileExtensionTF,'String');
channelSep=get(handles.channelSeparatorTF,'String');
regExp=selectedTemplate.getRegularExpression(fileExtension,channelSep);


function regExp=getFullRegExp(handles)
selectedTemplateNr = get(handles.templateSelector,'Value');
if(selectedTemplateNr<1)
  regExp=[];
  return;
end
wizardhandles=getappdata(0,'wizardhandles');
selectedTemplate=wizardhandles.templates{selectedTemplateNr};
regExp=selectedTemplate.Pattern;


% function enable_regexp_gui(is_visible,handles)
% set(handles.text4,'Visible',is_visible);
% set(handles.text5,'Visible',is_visible);
% set(handles.fileExtensionTF,'Visible',is_visible);
% set(handles.channelSeparatorTF,'Visible',is_visible);
% set(handles.testTemplateBT,'Visible',is_visible);
% if(strcmp(is_visible,'on'))
%     set(handles.selectSingleChannelCB,'Enable','off');
% else    
%     set(handles.selectSingleChannelCB,'Enable','on');
% end
% set(handles.templateSelector,'Visible',is_visible);
% set(handles.editTemplateBT,'Visible',is_visible);
% set(handles.saveAllTemplatesBT,'Visible',is_visible);
% set(handles.removeSelectedTemplateBT,'Visible',is_visible);
% set(handles.upTemplateBT,'Visible',is_visible);
% set(handles.downTemplateBT,'Visible',is_visible);
% set(handles.detectChannelBT,'Visible',is_visible);
% set(handles.text6,'Visible',is_visible);


% --- Executes on button press in ExportMetaDataButton.
function ExportMetaDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to ExportMetaDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
data=getWizardData(handles);
nrChannelPerImage=get(handles.nrChannelPerImageDB,'Value');
myhandles.rootDir=data.rootDir;
myhandles.wizardData=data;

%Get the last directory name
dirNames=regexp(myhandles.rootDir,filesep,'split');
dirName=dirNames{length(dirNames)};
[filename,pathname]=uiputfile('*.csv','Save Metadata into file',[dirName '_Metadata.csv']);

%setappdata(0,'myhandles',myhandles);
total_number_of_channels=length(myhandles.wizardData.markers);
myhandles.channels_used=[];
markersUsed=[];
markerUsedNr=1;
for i=1:total_number_of_channels
  if(myhandles.wizardData.markers{i}.isUse)
     myhandles.channels_used=[myhandles.channels_used;i];
     %Store the used marker for the metadata
     markersUsed{markerUsedNr}=myhandles.wizardData.markers{i};
     markerUsedNr=markerUsedNr+1;
  end
end
%nrChannelPerImage=length(myhandles.channels_used);
myhandles.allfiles=getAllFiles(myhandles.rootDir);
%Remove the rootDir from the full path    
myhandles.allfiles=cellfun(@(x) substring(myhandles.rootDir,x),...
  myhandles.allfiles,'UniformOutput',false);
%setappdata(0,'myhandles',myhandles);
%Add the file separator at the end of the root directory if not exist
if ~strcmp(myhandles.rootDir(1:end-1),'/')
  myhandles.rootDir=[myhandles.rootDir '/'];
end
setappdata(0,'myhandles',myhandles);
[~,metadata,~]=construct_filetable();
WriteData([pathname filesep filename], metadata, myhandles.rootDir, nrChannelPerImage, markersUsed)
msgbox('Metatadata file saved successfully');


function addProgressBarToMyHandle(handles)
myhandles=getappdata(0,'myhandles');
warning off;
myhandles.wizardStatusBarHandles=statusbar(handles.figure1,...
  'PhenoWizard, define your data.');
set(myhandles.wizardStatusBarHandles.TextPanel, 'Foreground',[1,1,1],...
  'Background','black', 'ToolTipText','Loading...');
set(myhandles.wizardStatusBarHandles.ProgressBar, 'Background','white',...
  'Foreground',[0.4,0,0]);
warning on;
setappdata(0,'myhandles',myhandles);


% --- Executes on button press in importTemplatesBT.
function importTemplatesBT_Callback(hObject, eventdata, handles)
% hObject    handle to importTemplatesBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
lastPath=loadLastPath('importtemplate');
if(~exist(char(lastPath),'dir'))
  [filename,pathname]=uigetfile({'*.csv;','PhenoRipper Regular Expression';'*.*','All Files'},'Select a Metadata File');
else
  [filename,pathname]=uigetfile({'*.csv;','PhenoRipper Regular Expression';'*.*','All Files'},'Select a Metadata File', lastPath);
end
if(isnumeric(pathname))%If user pressed cancle button
  return;
end
if(~exist(pathname,'dir'))
  warndlg('Invalid File');
  return;
else
   saveLastPath(pathname,'importtemplate');
end
parsingMsgDlg = msgbox('Parsing Regular Expression file, Please wait...');
%Trick to show off the OK button
hc=get(parsingMsgDlg,'Children'); 
set(hc(2),'Visible','off');
drawnow;
pause(0.01);
try
  [pattern,description,example,isMultiChannel,errorMessag]=...
    readRegularExpressionFile([pathname filesep filename]);
  wizardhandles=getappdata(0,'wizardhandles');
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
  wizardhandles.newTemplate=MyTemplate(example,pattern,isMultiChannel);
  wizardhandles.newTemplate.Description=description;
  wizardhandles.templates{position}=wizardhandles.newTemplate.setPattern(pattern);
  setappdata(0,'wizardhandles',wizardhandles);
  close(parsingMsgDlg);
  populateTemplateSelectorList(handles);
catch
  close(parsingMsgDlg);
end

%TODO MAKE THIS FUNCTION A FILE ?
function [regularExpression,description,example,isMultiChannel,...
    errorMessage]=readRegularExpressionFile(filename)
  CommonVar=cell(1,1);
  n=1;
  fid =fopen(filename);
  data=textscan(fid,'%s',1,'delimiter','\n');
  while(~strcmp(data{1,1},'')&&~strcmp(data{1,1}{1}(1),',') )
    CommonVar(n,1)=data{1,1};
    n=n+1;
    data=textscan(fid,'%s',1,'delimiter','\n');
  end
  %Extract the variables(RegularExpression, RegularExpressionExample,
  %RegularExpressionIsMultiChannel and RegularExpressionDescription)
  %Only RegularExpression,RegularExpressionIsMultiChannel and
  %RegularExpressionExample is required,
  %RegularExpressionDescription will be empty per default
  errorMessage='';
  regularExpression = getVarValue(CommonVar,'#RegularExpression:');
  if(isempty(regularExpression))
    errorMessage=['Regular Expression has not been specified. You should'...
    ' have a line like : #RegularExpression:Your Regular Expression'];
    isMultiChannel='';
    regularExpression='';
    description='';
    example='';
    return;
  end    
  example = getVarValue(CommonVar,'#RegularExpressionExample:');
  if(isempty(example))
    errorMessage=['Regular Expression Example has not been specified.'...
      'You should have a line like:'...
      ' #RegularExpressionExample:Your Regular Expression Example'];
    isMultiChannel='';
    regularExpression='';
    description='';
    example='';
    return;
  end    
  isMultiChannel = getVarValue(CommonVar,'#RegularExpressionIsMultiChannel:');
  if(~isempty(isMultiChannel))
    isMultiChannel=str2num(isMultiChannel);
  end
  if(isempty(isMultiChannel))
    errorMessage=['Regular Expression Is Multi Channel has not been specified.'...
      'You should have a line like:'...
      ' #RegularExpressionIsMultiChannel:0'];
    isMultiChannel='';
    regularExpression='';
    description='';
    example='';
    return;
  end    
  description = getVarValue(CommonVar,'#RegularExpressionDescription:');
    
%TODO USED ALSO IN ReadData.m, SHOUDL BE EXTERNALIZED  
%Internal function to extract the value of the Common Variable present
%in the header of the Metadata file.
function value=getVarValue(varCell,var)
  [startIndex, ~, ~, ~, ~, ~, valueCell]=regexp(varCell,var);
  index = find(~cellfun('isempty',startIndex));
  if(~isempty(index))
    valueCell=valueCell{index};
    value=valueCell{1,2};
  else
    value=[];
  end
  
%TODO USED ALSO IN editTemplate.m, SHOUDL BE EXTERNALIZED  
function [exist,i]=isExampleExist(example,templates)
  exist=0;
  for i=1:length(templates)
    if(strcmp(templates{i}.Example,example))
      exist=1;
      break;
    end
  end
