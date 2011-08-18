function varargout = wizardMetaData(varargin)
% WIZARDMETADATA MATLAB code for wizardMetaData.fig
%      WIZARDMETADATA, by itself, creates a new WIZARDMETADATA or raises the existing
%      singleton*.
%
%      H = WIZARDMETADATA returns the handle to a new WIZARDMETADATA or the handle to
%      the existing singleton*.
%
%      WIZARDMETADATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WIZARDMETADATA.M with the given input arguments.
%
%      WIZARDMETADATA('Property','Value',...) creates a new WIZARDMETADATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before wizardMetaData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to wizardMetaData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wizardMetaData

% Last Modified by GUIDE v2.5 03-Aug-2011 11:27:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @wizardMetaData_OpeningFcn, ...
                   'gui_OutputFcn',  @wizardMetaData_OutputFcn, ...
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


% --- Executes just before wizardMetaData is made visible.
function wizardMetaData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to wizardMetaData (see VARARGIN)

% Choose default command line output for wizardMetaData
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

% UIWAIT makes wizardMetaData wait for user response (see UIRESUME)
% uiwait(handles.figure1);
% if ismac
%   set(handles.LoadMetaDataButton,'CData',cat(3,zeros(500),zeros(500),zeros(500)));
%   set(handles.RootDirChangeButton,'CData',cat(3,zeros(500),zeros(500),zeros(500)));
%   set(handles.RootDirSaveButton,'CData',cat(3,zeros(500),zeros(500),zeros(500)));
%   set(handles.DoneButton,'CData',cat(3,zeros(500),zeros(500),zeros(500)));
% end


% --- Outputs from this function are returned to the command line.
function varargout = wizardMetaData_OutputFcn(hObject, eventdata, handles) 
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

lastPath=loadLastPath('metadata');
if(~exist(char(lastPath),'dir'))
  [filename,pathname]=uigetfile('*.txt');
else
  [filename,pathname]=uigetfile([lastPath filesep '*.txt']);
end
if(~exist(pathname,'dir'))
  warndlg('Invalid File');
  return;
else
   saveLastPath(pathname,'metadata');
end

%filename='MikeMetaData_atub_Selected2.txt';
%pathname='/home/lab_share/Temp/Ben/PhenoRipper/imageSample';
[filenames,metadata,RootDir,NrChannelPerImage,Markers,errorMessage]=ReadData([pathname filesep filename],',');

if(~strcmp(errorMessage,''))
  errordlg(errorMessage);  
  setGUIVisible(handles,'off');
  return;
end

myhandles=getappdata(0,'myhandles');
myhandles.use_metadata=true;
myhandles.currentMetadatFile=[pathname filesep filename];


if(NrChannelPerImage>1)
  if(length(filenames{1})>1)    
    warndlg('Inconsistency between NrChannelPerImage and number of file per image! Please check your MetaData file.');
    return;
  else
    channelNr=NrChannelPerImage;
  end
else
  channelNr=length(filenames{1});  
end
if(channelNr<1)
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

file_matrix=cell(length(filenames),length(filenames{1}));
for i=1:length(filenames)
    for j=1:length(filenames{1})
        file_matrix{i,j}=filenames{i}{j};
        if(~exist([RootDir file_matrix{i,j}],'file'))
            errordlg(['File Missing:' file_matrix{i,j}] );
            return;
        end
    end
end
myhandles.file_matrix=file_matrix;
%[myhandles.metadata,matched_files]=extract_regexp_metadata(file_matrix,myhandles.regular_expressions);
%matched_files=find(matched_files);
fnames=fieldnames(metadata);
for i=1:length(filenames)
    myhandles.metadata{i}.FileNames={file_matrix{i,:}};
    myhandles.metadata{i}.None=file_matrix{i,1};
    for j=2:length(fnames)    
        myhandles.metadata{i}.(fnames{j})=metadata(i).(fnames{j});
    end
end
myhandles.NrChannelPerImage=NrChannelPerImage;
myhandles.files_per_image=length(filenames{1});
handles=getappdata(0,'handles');
%fnames=fieldnames(myhandles.metadata{1});
%set(handles.groupSelector,'String',fnames);
setappdata(0,'handles',handles);
setappdata(0,'myhandles',myhandles); %Should probably throw in some checks to
                                     % make sure that myhandles.files_per_image is not being reset


                                     
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
WriteData(fileName, myhandles.metadata, rootDir, myhandles.NrChannelPerImage, markers);

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
if(myhandles.use_metadata)
    myhandles.matched_files=true(size(myhandles.file_matrix,1),1);
    myhandles.number_of_channels=length(myhandles.channels_used);
else
    myhandles.allfiles=getAllFiles(myhandles.wizardData.rootDir);
    setappdata(0,'myhandles',myhandles);
    [file_matrix,metadata,matched_files]=construct_filetable();
    myhandles=getappdata(0,'myhandles');
    myhandles.file_matrix=file_matrix;
    myhandles.metadata=metadata;
    myhandles.matched_files=matched_files;
end
%myhandles=getappdata(0,'myhandles');
myhandles.wizardMetdaData_handle=gcf;
setappdata(0,'myhandles',myhandles);
wizard_accept;


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
