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

% Last Modified by GUIDE v2.5 24-May-2011 14:55:09

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
wizardhandles=load('default-templates.mat','templates');
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
    templateList{i}=wizardhandles.templates{i}.getName(fileExtension,channelSep);
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
lastPath=loadLastPath();
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
        myhandles.all_files=files_in_dir(dir_name);
        %temp=regexp(myhandles.all_files,[dir_name filesep],'split');
        saveLastPath(dir_name);
end
set(handles.rootdirTF,'String',dir_name);
setappdata(0,'myhandles',myhandles);   
setappdata(0,'handles',handles);

function saveLastPath(path)
fid = fopen('.lastPath.txt','w');
fprintf(fid, '%s', path);
fclose(fid);

function path=loadLastPath()
path=[];
if(exist('.lastPath.txt','file'))
  fid = fopen('.lastPath.txt', 'r');
  path = fgetl(fid);
end


% --- Executes on button press in selectSingleChannelCB.
function selectSingleChannelCB_Callback(hObject, eventdata, handles)
% hObject    handle to selectSingleChannelCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of selectSingleChannelCB
if(get(handles.selectSingleChannelCB,'Value')==0)
  set(handles.nrChannelPerImageDB,'Visible','on');
  set(handles.channelImageText,'Visible','on');
  set(handles.detectChannelBT,'Visible','off');
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
for i=1:channelNr
  data{i,4}='';
end

set(handles.markerTable,'Visible','on');
set(handles.markerTable,'Data',data);
set(handles.markerTable, 'ColumnWidth', {30 110 240, 90});
msgbox('Marker have been detected, please enter the name of each marker and click on Done to use this configuration.');





% --- Executes during object creation, after setting all properties.
function nrChannelPerImageDB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nrChannelPerImageDB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
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
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
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
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
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
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in templateSelector.
function templateSelector_Callback(hObject, eventdata, handles)
% hObject    handle to templateSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns templateSelector contents as cell array
%        contents{get(hObject,'Value')} returns selected item from templateSelector
[~, groupbyList]=getGroups(handles);
%Display group and the corresponding matching with the example
set(handles.groupSelector,'String',groupbyList);
set(handles.groupSelector,'Visible','on');
set(handles.text8,'Visible','on');
viewChannelSeparator(handles);
set(handles.markerTable,'Visible','off');

function [groups, groupExample]=getGroups(handles)
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
else
  set(handles.channelSeparatorTF,'Visible','on');
  set(handles.text5,'Visible','on');
  set(handles.selectSingleChannelCB,'Value',1);  
end
selectSingleChannelCB_Callback('','',handles);


% --- Executes during object creation, after setting all properties.
function templateSelector_CreateFcn(hObject, eventdata, handles)
% hObject    handle to templateSelector (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
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
wizardhandles=getappdata(0,'wizardhandles');
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
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in doneBT.
function doneBT_Callback(hObject, eventdata, handles)
% hObject    handle to doneBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data=getWizardData(handles);
myhandles=getappdata(0,'myhandles');
myhandles.wizardData=data;
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
myhandles.wizard_handle=gcf;
setappdata(0,'myhandles',myhandles);
wizard_accept;
%disp('meow');
%delete(gcf);



function [file_matrix,metadata,matched_files]=construct_filetable()
myhandles=getappdata(0,'myhandles');
handles=getappdata(0,'handles');
myhandles.number_of_channels=length(myhandles.channels_used);
myhandles.files_per_image=myhandles.number_of_channels;
if(myhandles.wizardData.nrChannelPerFile>1)
    myhandles.files_per_image=1;
end

setappdata(0,'myhandles',myhandles);

channel_wise_matches=cell(1,myhandles.files_per_image);
root_directory=myhandles.wizardData.rootDir;
%temp=regexp(myhandles.allfiles,[root_directory filesep],'split');
root_directoryRegExp=regexptranslate('escape', [root_directory filesep]);
temp=regexp(myhandles.allfiles,[root_directoryRegExp],'split');
all_files=cellfun(@(x) x(end),temp);

rexp=cell(1,myhandles.files_per_image);
%matches=true(length(myhandles.all_files));


for channel=1:myhandles.files_per_image
    rexp{channel}=myhandles.wizardData.markers{myhandles.channels_used(channel)}.regExp;
    channel_names{channel}=myhandles.wizardData.markers{myhandles.channels_used(channel)}.marker;
    %rexp{channel}=get(myhandles.marker_handles(channel).marker_ending_edit,'String');
    
    %temp=regexp(matches,[rexp{channel} '$'] ,'split');
    %channel_wise_matches{channel}=cellfun(@(x) x(1),temp);
end
%matches=myhandles.all_files(~cellfun('isempty',regexp(myhandles.all_files,...
     %   [rexp{1} '$'],'match')));
 [idx edx ext mat tok nam] = regexp(all_files,rexp{1},...
                    'start','end','tokenExtents','match','tokens','names');
               
 matched_bool=~cellfun('isempty',mat);    
 matches=all_files(matched_bool);
 matched=find(matched_bool);
 if(~isempty(matches))
     fnames=fieldnames(nam{matched(1)});
 else
     errordlg('No matches');
 end
 
 
%file_matrix=cell(length(matches),myhandles.files_per_image);
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

nam=nam(matched_bool);
for i=1:number_of_images
    %if(matched_bool(i))
        for j=1:length(fnames)
            temp=nam{i}.(fnames{j});
            if(strcmp(temp,''))
                metadata{i}.(fnames{j})=[];
            else
                metadata{i}.(fnames{j})=temp;
            end
            
        end
        
%     else
%         for j=1:length(fnames)
%             metadata{i}.(fnames{j})=[];
%         end
%     end
end
%disp('meow');
% files_with_matches(:,channel)=matched_bool;
% files_with_matches=any(files_with_matches,2);
% metadata=metadata(files_with_matches);
%metadata=metadata(matched_bool);
% 
% for channel=2:myhandles.files_per_image
%     common_files=intersect(common_files,channel_wise_matches{channel});
% end
% 
% if(isempty(common_files))
%    file_matrix={'No Files In Common'}; 
% else
%     file_matrix=cell(length(common_files),myhandles.files_per_image);
%     for match_num=1:length(common_files)
%         temp=common_files{match_num}(length(get(handles.rootdirectory_edit,'String'))+2:end);
%         for channel=1:myhandles.files_per_image
%             file_matrix{match_num,channel}=[temp rexp{channel}];
%         end
%     end
%   myhandles.common_files=file_matrix;
  setappdata(0,'myhandles',myhandles);




function data=getWizardData(handles)
selectedFolder=get(handles.rootdirTF,'String');
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
  warndlg('You must described all the markers (Name and Color)');
  return;
end
%Warn if a color is used twice or more for markers
if(length(unique(markersData(selectedMarkerIndex,4)))~=length(selectedMarkerIndex)) 
  answer=questdlg(sprintf(['Color should be different for each marker.\n'...
    'Are you sure you want to attribute the same color to more than 1 marker?']), ...
 'Yes', 'No');
% Handle response
  switch answer
    case 'No'
      return;
  end
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
  markers{i}.color=markersData{i,4};
  markers{i}.regExp=regexprep(regExp,'\(\?<Channel>.+?\)',markersData{i,2});
  %markers{i}.regExp=regexprep(regExp,'\(\?<Channel>.\*\)',markersData{i,2});
  %markers{i}.regexp=
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
% hObject    handle to advancedEditBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
h=gcf;
[filename,pathname]=uigetfile('*.txt');
[filenames,metadata]=ReadData([pathname filesep filename],',');
myhandles=getappdata(0,'myhandles');
myhandles.use_metadata=true;
enable_regexp_gui('off',handles);

channelNr=length(filenames{1});
if(channelNr<1)
  warndlg('Couldn detect the channel. Did you select the template corresponding to your data?');
  set(handles.markerTable,'Data',cell(0,3));
  set(handles.markerTable,'Visible','off');
  return;
end
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
for i=1:channelNr
  data{i,4}='';
end
set(handles.markerTable,'Visible','on');
set(handles.markerTable,'Data',data);
set(handles.markerTable, 'ColumnWidth', {30 110 220, 90});
msgbox(['Marker have been detected, please enter the name of each marker'...
  'and click on Done to use this configuration.']);

file_matrix=cell(length(filenames),length(filenames{1}));
for i=1:length(filenames)
    for j=1:length(filenames{1})
        file_matrix{i,j}=filenames{i}{j};
        if(~exist(file_matrix{i,j},'file'))
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

myhandles.files_per_image=length(filenames{1});
handles=getappdata(0,'handles');
%fnames=fieldnames(myhandles.metadata{1});
set(handles.groupSelector,'String',fnames);
setappdata(0,'handles',handles);
setappdata(0,'myhandles',myhandles); %Should probably throw in some checks to
                                     % make sure that myhandles.files_per_image is not being reset
                                    
%scroll_panel;
%delete(h);



% --- Executes on button press in saveAllTemplatesBT.
function saveAllTemplatesBT_Callback(hObject, eventdata, handles)
% hObject    handle to saveAllTemplatesBT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wizardhandles=getappdata(0,'wizardhandles');
answer=questdlg(sprintf('Save this pattern list as the default one?'), ...
 'Yes', 'No');
% Handle response
  switch answer
    case 'Yes'
      templates=wizardhandles.templates;
      save('default-templates.mat','templates');
      msgbox(['Default Templates have been saved'],'Saved Template with success');
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
index=1;
for i=1:length(wizardhandles.templates)
  if(i~=selected)
  templates{index}=wizardhandles.templates{i};
  end
  index=index+1;
end
wizardhandles.templates=templates;
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
channelList=getMarkersFromDir(selectedFolder,regExp,selectedFolder);
if(isempty(channelList))
  warndlg('Couldn detect the channel. Did you select the template corresponding to your data?');
  set(handles.markerTable,'Data',cell(0,3));
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
  data{i,3}='';
end
for i=1:length(channelList)
  data{i,4}='';
end

set(handles.markerTable,'Visible','on');
set(handles.markerTable,'Data',data);
set(handles.markerTable, 'ColumnWidth', {30 110 220, 90});
disp(channelList);
msgbox(['Marker have been detected, please enter the name of each marker'...
  'and click on Done to use this configuration.']);


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

function enable_regexp_gui(is_visible,handles)

set(handles.text4,'Visible',is_visible);
set(handles.text5,'Visible',is_visible);
set(handles.fileExtensionTF,'Visible',is_visible);
%set(handles.channelImageText,'Visible',is_visible);
%set(handles.nrChannelPerImageDB,'Visible',is_visible);
set(handles.channelSeparatorTF,'Visible',is_visible);
set(handles.testTemplateBT,'Visible',is_visible);
%set(handles.selectSingleChannelCB,'Visible',is_visible);

if(strcmp(is_visible,'on'))
    set(handles.selectSingleChannelCB,'Enable','off');
else    
    set(handles.selectSingleChannelCB,'Enable','on');
end
set(handles.templateSelector,'Visible',is_visible);
set(handles.editTemplateBT,'Visible',is_visible);
set(handles.saveAllTemplatesBT,'Visible',is_visible);
set(handles.removeSelectedTemplateBT,'Visible',is_visible);
set(handles.upTemplateBT,'Visible',is_visible);
set(handles.downTemplateBT,'Visible',is_visible);
set(handles.detectChannelBT,'Visible',is_visible);
set(handles.text6,'Visible',is_visible);
%set(handles.text9,'Visible',is_visible);
%set(handles.descriptionText,'Visible',is_visible);
