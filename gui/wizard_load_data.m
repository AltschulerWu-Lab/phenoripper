function varargout = wizard_load_data(varargin)
% WIZARD_LOAD_DATA MATLAB code for wizard_load_data.fig
%      WIZARD_LOAD_DATA, by itself, creates a new WIZARD_LOAD_DATA or raises the existing
%      singleton*.
%
%      H = WIZARD_LOAD_DATA returns the handle to a new WIZARD_LOAD_DATA or the handle to
%      the existing singleton*.
%
%      WIZARD_LOAD_DATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WIZARD_LOAD_DATA.M with the given input arguments.
%
%      WIZARD_LOAD_DATA('Property','Value',...) creates a new WIZARD_LOAD_DATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before wizard_load_data_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to wizard_load_data_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%
% ------------------------------------------------------------------------------
% Copyright ©2012, The University of Texas Southwestern Medical Center 
% Authors:
% Satwik Rajaram and Benjamin Pavie for the Altschuler and Wu Lab
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
%%




% Edit the above text to modify the response to help wizard_load_data

% Last Modified by GUIDE v2.5 25-Mar-2013 14:28:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @wizard_load_data_OpeningFcn, ...
                   'gui_OutputFcn',  @wizard_load_data_OutputFcn, ...
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


% --- Executes just before wizard_load_data is made visible.
function wizard_load_data_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to wizard_load_data (see VARARGIN)

% Choose default command line output for wizard_load_data
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%Set the Header
img=imread('wizard.png');
image(img,'parent',handles.header);
axis off;


myhandles=getappdata(0,'myhandles');
myhandles.use_metadata=true;
setappdata(0,'myhandles',myhandles);

% UIWAIT makes wizard_load_data wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% if ismac
%   set(handles.LoadMetaDataButton,'CData',cat(3,zeros(500),zeros(500),zeros(500)));
%   set(handles.RootDirChangeButton,'CData',cat(3,zeros(500),zeros(500),zeros(500)));
%   set(handles.RootDirSaveButton,'CData',cat(3,zeros(500),zeros(500),zeros(500)));
%   set(handles.DoneButton,'CData',cat(3,zeros(500),zeros(500),zeros(500)));
% end


% --- Outputs from this function are returned to the command line.
function varargout = wizard_load_data_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in LoadMetaDataButton.
function LoadMetaDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadMetaDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

lastPath=load_last_path('metadata');
if(~exist(char(lastPath),'dir'))
  [filename,pathname]=uigetfile({'*.csv;','Metadata Files';'*.*','All Files'},'Select a Metadata File');
else
  [filename,pathname]=uigetfile({'*.csv;','Metadata Files';'*.*','All Files'},'Select a Metadata File', [lastPath]);
end
if(~exist(pathname,'dir'))
  warndlg('Invalid File');
  return;
else
   save_last_path(pathname,'metadata');
end

parsingMsgDlg = msgbox('Parsing Metadata file, Please wait...');
%Trick to show off the OK button
hc=get(parsingMsgDlg,'Children'); 
set(hc(2),'Visible','off');
drawnow;
pause(0.01);

%try
  [filenames,metadata,RootDir,NrChannelPerImage,Markers,errorMessage]=...
    read_data([pathname filesep filename],',');

  if(~strcmp(errorMessage,''))
    close(parsingMsgDlg);
    drawnow;
    pause(0.01);
    errordlg(errorMessage);  
    setGUIVisible(handles,'off');
    return;
  end

  myhandles=getappdata(0,'myhandles');
  myhandles.use_metadata=true;
  myhandles.currentMetadatFile=[pathname filesep filename];


  if(NrChannelPerImage>1)
    if(size(filenames{1},2)>1)   
      close(parsingMsgDlg);
      warndlg(['Inconsistency between NrChannelPerImage and number'...
        ' of file per image! Please check your MetaData file.']);
      return;
    else
      channelNr=NrChannelPerImage;
    end
  else
    channelNr=size(filenames{1},2);  
  end
  if(channelNr<1)
    close(parsingMsgDlg);
    warndlg('Couldn detect the channel. Check your Metadata file.');
    set(handles.markerTable,'Data',cell(0,3));
    setGUIVisible(handles,'off');
    return;
  end
  data=cell(channelNr,3);
  for i=1:channelNr
    data{i,1}=true;
  end
  for i=1:channelNr
    data{i,2}=num2str(i);
  end
  if(isempty(Markers))
    for i=1:channelNr
      data{i,3}=['marker ' num2str(i)];
    end
  else  
    for i=1:size(Markers,2)
      data{i,3}=Markers{1,i};
    end
  end
  % for i=1:channelNr
  %   data{i,4}='';
  % end
  if(isempty(Markers))
    msgbox(['Marker have been detected, please enter the name of each marker'...
    'and click on Done to use this configuration.']);
  end

  setGUIVisible(handles,'on');
  set(handles.RootDirEdit,'String',RootDir);

  set(handles.markerTable,'Data',data);
  set(handles.markerTable, 'ColumnWidth', {30 110 220, 90});

  file_matrix=cell(length(filenames), size(filenames{1},2),2);
  for i=1:length(filenames)
      %for j=1:length(filenames{1})
      for j=1:size(filenames{1},2)
          file_matrix{i,j,1}=filenames{i}{1,j};
          file_matrix{i,j,2}=filenames{i}{2,j};
          if(~exist([RootDir file_matrix{i,j,1}],'file'))
              close(parsingMsgDlg);
              errordlg(['File Missing:' file_matrix{i,j,1}] );
              return;
          end
      end
  end
  myhandles.file_matrix=file_matrix;
  fnames=fieldnames(metadata);
  for i=1:length(filenames)
      %myhandles.metadata{i}.FileNames={file_matrix{i,:}};
      %myhandles.metadata{i}.None=file_matrix{i,1};
      myhandles.metadata{i}.FileNames=file_matrix(i,:,:);
      myhandles.metadata{i}.None=file_matrix{i,1,1};
      for j=2:length(fnames)    
          myhandles.metadata{i}.(fnames{j})=metadata(i).(fnames{j});
      end
  end
  myhandles.NrChannelPerImage=NrChannelPerImage;
  %myhandles.files_per_image=length(filenames{1});
  myhandles.files_per_image=size(filenames{1},2);
  handles=getappdata(0,'handles');
  %fnames=fieldnames(myhandles.metadata{1});
  %set(handles.groupSelector,'String',fnames);
  setappdata(0,'handles',handles);
  setappdata(0,'myhandles',myhandles); %Should probably throw in some checks to
                                       % make sure that myhandles.files_per_image is not being reset
  close(parsingMsgDlg);
%catch
%  close(parsingMsgDlg);
%end

                                     
function setGUIVisible(handles,isVisible)
set(handles.RootDirLabel,'Visible',isVisible);
set(handles.RootDirEdit,'Visible',isVisible);
set(handles.RootDirChangeButton,'Visible',isVisible);
set(handles.RootDirSaveButton,'Visible',isVisible);
set(handles.markerTable,'Visible',isVisible);
set(handles.DoneButton,'Visible',isVisible);
if(strcmp(isVisible,'off'))
  set(handles.RootDirEdit,'String','');
end


function RootDirEdit_Callback(hObject, eventdata, handles)
% hObject    handle to RootDirEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RootDirEdit as text
%        str2double(get(hObject,'String')) returns contents of RootDirEdit as a double


% --- Executes during object creation, after setting all properties.
function RootDirEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RootDirEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RootDirSaveButton.
function RootDirSaveButton_Callback(hObject, eventdata, handles)
% hObject    handle to RootDirSaveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');


myhandles.currentMetadatFile
[FileName,PathName] = uiputfile({'*.txt','All Metadata Files';...
          '*.*','All Files' },'Save Metadata',...
          myhandles.currentMetadatFile);

fileName=[PathName filesep FileName];
%fileName='/tmp/test.txt';
data=getWizardData(handles);
markers=data.markers;
rootDir=data.rootDir;
write_data(fileName, myhandles.metadata, rootDir, myhandles.NrChannelPerImage, markers);

%Give FileName + the different field 
fieldnames(myhandles.metadata{1})


% --- Executes on button press in RootDirChangeButton.
function RootDirChangeButton_Callback(hObject, eventdata, handles)
% hObject    handle to RootDirChangeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in DoneButton.
function DoneButton_Callback(hObject, eventdata, handles)
% hObject    handle to doneBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data=getWizardData(handles);
myhandles=getappdata(0,'myhandles');
myhandles.wizardData=data;
myhandles.rootDir=data.rootDir;
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
if(myhandles.use_metadata)
    myhandles.matched_files=true(size(myhandles.file_matrix,1),1);
    myhandles.number_of_channels=length(myhandles.channels_used);
else
    myhandles.allfiles=get_all_files_in_dir(myhandles.wizardData.rootDir);
    setappdata(0,'myhandles',myhandles);
    [file_matrix,metadata,matched_files]=construct_filetable();
    myhandles=getappdata(0,'myhandles');
    myhandles.file_matrix=file_matrix;
    myhandles.metadata=metadata;
    myhandles.matched_files=matched_files;
end
%myhandles=getappdata(0,'myhandles');
myhandles.wizardMetaData_handle=gcf;
setappdata(0,'myhandles',myhandles);
%wizard_accept;
wizard_sampling;










function data=getWizardData(handles)
selectedFolder=get(handles.RootDirEdit,'String');

if(~isdir(selectedFolder))
  warndlg('The choosen folder is not a valid directory. Please select a valid directory!');
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

%Return the markerData in Structure
markers=cell(1,size(markersData,1));
for i=1:length(markers)
  markers{i}.isUse=markersData{i,1};
  markers{i}.marker=markersData{i,2};
  markers{i}.name=markersData{i,3};
end
data.markers=markers;
disp(data);


% --- Executes on button press in extractFromFileName.
function extractFromFileName_Callback(hObject, eventdata, handles)
% hObject    handle to extractFromFileName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
myhandles.wizardMetaData_handle=handles.figure1;
setappdata(0,'myhandles',myhandles);
wizard_template;
%set(handles.figure1,'Visible','off');


% --- Executes on button press in phenoLoaderButton.
function phenoLoaderButton_Callback(hObject, eventdata, handles)
% hObject    handle to phenoLoaderButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
myhandles.wizardMetaData_handle=handles.figure1;
setappdata(0,'myhandles',myhandles);
if(ismac==0 && isunix == 1)
  warndlg({'The following GUIs may be glitchy on Linux'},'Linux Implementation Warning','modal');
end
phenoloader_gui;
