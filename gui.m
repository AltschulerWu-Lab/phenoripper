function varargout = gui(varargin)
% GUI M-file for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES 
 
% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 17-Sep-2011 18:05:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)
initializeMyHandle();
splash('logo','png');
% Choose default command line output for gui
handles.output = hObject;
set(handles.ExplorerButton,'Visible','off');
% set(handles.uipanel9,'Visible','off');
set(handles.SaveOutputButton,'Visible','off');
% Update handles structure
guidata(hObject, handles);

%Change the button color to black for Mac because of a Matlab Bug
% if ismac
%   set(handles.SelectDirectory,'CData',cat(3,zeros(500),zeros(500),zeros(500)));
%   set(handles.useMetadaFileButton,'CData',cat(3,zeros(500),zeros(500),zeros(500)));
%   set(handles.TestThreshold,'CData',cat(3,zeros(500),zeros(500),zeros(500)));
%   set(handles.RunBtn,'CData',cat(3,zeros(500),zeros(500),zeros(500)));
%   set(handles.SaveOutputButton,'CData',cat(3,zeros(500),zeros(500),zeros(500)));
%   set(handles.LoadResultsButton,'CData',cat(3,zeros(500),zeros(500),zeros(500)));
%   set(handles.ExplorerButton,'CData',cat(3,zeros(500),zeros(500),zeros(500)));
% end


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
addProgressBarToMyHandle(handles.figure1);



function blockSize_Callback(hObject, eventdata, handles)
% hObject    handle to blockSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blockSize as text
%        str2double(get(hObject,'String')) returns contents of blockSize as a double



% --- Executes during object creation, after setting all properties.
function blockSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blockSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ThreshodIntensity_Callback(hObject, eventdata, handles)
% hObject    handle to ThreshodIntensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% Hints: get(hObject,'String') returns contents of ThreshodIntensity as text
%        str2double(get(hObject,'String')) returns contents of ThreshodIntensity as a double


% --- Executes during object creation, after setting all properties.
function ThreshodIntensity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ThreshodIntensity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ReduceColorNr_Callback(hObject, eventdata, handles)
% hObject    handle to ReduceColorNr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ReduceColorNr as text
%        str2double(get(hObject,'String')) returns contents of ReduceColorNr as a double


% --- Executes during object creation, after setting all properties.
function ReduceColorNr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ReduceColorNr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BlockTypeNr_Callback(hObject, eventdata, handles)
% hObject    handle to BlockTypeNr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BlockTypeNr as text
%        str2double(get(hObject,'String')) returns contents of BlockTypeNr as a double


% --- Executes during object creation, after setting all properties.
function BlockTypeNr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BlockTypeNr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SuperBlockNr_Callback(hObject, eventdata, handles)
% hObject    handle to SuperBlockNr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SuperBlockNr as text
%        str2double(get(hObject,'String')) returns contents of SuperBlockNr as a double


% --- Executes during object creation, after setting all properties.
function SuperBlockNr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SuperBlockNr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ChannelNr_Callback(hObject, eventdata, handles)
% hObject    handle to ChannelNr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ChannelNr as text
%        str2double(get(hObject,'String')) returns contents of ChannelNr as a double


% --- Executes during object creation, after setting all properties.
function ChannelNr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ChannelNr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ImageRootDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to ImageRootDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ImageRootDirectory as text
%        str2double(get(hObject,'String')) returns contents of ImageRootDirectory as a double
if(~Test_Directory(get(hObject,'String')))
    warndlg('Directory Unusable');
else
    myhandles=getappdata(0,'myhandles');
    myhandles.is_directory_usable=true;
    
    setappdata(0,'myhandles',myhandles);
end



% --- Executes during object creation, after setting all properties.
function ImageRootDirectory_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ImageRootDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in SelectDirectory.
% function SelectDirectory_Callback(hObject, eventdata, handles)
% % hObject    handle to SelectDirectory (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% %Re-initialize myhandles
% myhandles_BK=getappdata(0,'myhandles');
% blankMyHandle=struct;
% setappdata(0,'myhandles',blankMyHandle);
% initializeMyHandle();
% addProgressBarToMyHandle(handles.figure1);
% %Launch the Wizard and wait
% wizard;
% uiwait;
% drawnow;
% %If wizard has been stopped before the end, 
% % restore the previous myhandle and return
% myhandles=getappdata(0,'myhandles');
% if isfield(myhandles,'grouped_metadata')==0
%   setappdata(0,'myhandles',myhandles_BK);
%   return;
% end
% myhandles.number_of_conditions=length(myhandles.grouped_metadata);
% setappdata(0,'myhandles',myhandles);
% Calculate_Image_Parameters(hObject,handles,false);
% myhandles=getappdata(0,'myhandles');
% msgbox('Data Loaded Successfully');
% myhandles.number_of_files=0;
% for i=1:myhandles.number_of_conditions
%     myhandles.number_of_files=myhandles.number_of_files+...
%         size(myhandles.grouped_metadata{i}.files_in_group,1);
% end
% setappdata(0,'myhandles',myhandles);
% SetButtonState(hObject,handles,true);
% guidata(hObject, handles);

% --- Executes on button press in useMetadaFileButton.
function useMetadaFileButton_Callback(hObject, eventdata, handles)  
myhandles_BK=getappdata(0,'myhandles');
blankMyHandle=struct;
setappdata(0,'myhandles',blankMyHandle);
initializeMyHandle();
addProgressBarToMyHandle(handles.figure1);
%Launch the WizardMetadata and wait
h=wizardMetaData;
uiwait(h);
drawnow;
pause(0.5);
%If wizard has been stopped before the end, 
% restore the previous myhandle and return
myhandles=getappdata(0,'myhandles');
if isfield(myhandles,'grouped_metadata')==0
  setappdata(0,'myhandles',myhandles_BK);
  return;
end
myhandles.number_of_conditions=length(myhandles.grouped_metadata);
setappdata(0,'myhandles',myhandles);
Calculate_Image_Parameters(hObject,handles,false);
myhandles=getappdata(0,'myhandles');
msgbox('Data Loaded Successfully');
myhandles.number_of_files=0;
for i=1:myhandles.number_of_conditions
    myhandles.number_of_files=myhandles.number_of_files+...
        size(myhandles.grouped_metadata{i}.files_in_group,1);
end
setappdata(0,'myhandles',myhandles);
SetButtonState(hObject,handles,true);
set(handles.ExplorerButton,'Visible','off');
% set(handles.uipanel9,'Visible','off');
set(handles.SaveOutputButton,'Visible','off');


guidata(hObject, handles);


% --- Executes on button press in RunBtn.
function RunBtn_Callback(hObject, eventdata, handles)
% hObject    handle to RunBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
if(~isfield(myhandles,'files_per_image'))
  warndlg('You must load data first');
  return;
end
%try
set(myhandles.statusbarHandles.ProgressBar, 'Visible','on', 'Indeterminate','on');
myhandles.statusbarHandles=statusbar(hObject,'Calculating File Structure');
analysistime_handle=tic;


block_size = myhandles.block_size;
cutoff_intensity=myhandles.cutoff_intensity;
number_of_RGB_clusters=myhandles.number_of_RGB_clusters;
number_of_block_clusters=myhandles.number_of_block_clusters;
number_of_superblocks=myhandles.number_of_superblocks;
minimum_training_files=myhandles.minimum_training_files;
maximum_training_files=myhandles.maximum_training_files;
number_of_blocks_per_training_image=1000;
rgb_samples_per_training_image=3000;
number_of_block_representatives=3;
myhandles.number_of_superblocks=number_of_superblocks;
files_per_image=myhandles.files_per_image;



if(myhandles.number_of_conditions>maximum_training_files)
    chosen_files=zeros(maximum_training_files,2);
    chosen_files(:,1)=randsample(myhandles.number_of_conditions,maximum_training_files)'; 
    
    for i=1:maximum_training_files
        chosen_files(i,2)=randi(size(myhandles.grouped_metadata{chosen_files(i,1)}.files_in_group,1));
    end
else
    if(myhandles.number_of_conditions<minimum_training_files)
        chosen_files=zeros(minimum_training_files,2);
        rand_condition=randperm(myhandles.number_of_conditions);
        counter=0;
        loop_number=1;
        condition_perm=cell(myhandles.number_of_conditions,1);
        for i=1:myhandles.number_of_conditions
            condition_perm{i}=randperm(size(myhandles.grouped_metadata{rand_condition(i)}.files_in_group,1));
        end
        
        while(counter<minimum_training_files)
            for i=1:myhandles.number_of_conditions
                selectedCondition=rand_condition(i);
                if((counter<minimum_training_files)&&(loop_number<=size(myhandles.grouped_metadata{selectedCondition}.files_in_group,1)))
                    counter=counter+1;
                    chosen_files(counter,1)=selectedCondition;
                    chosen_files(counter,2)=condition_perm{i}(loop_number);
                end
               
            end
            loop_number=loop_number+1;
        end
        
    else
        chosen_files=zeros(myhandles.number_of_conditions,2);
        chosen_files(:,1)=(1:myhandles.number_of_conditions)';
        
        for i=1:myhandles.number_of_conditions
            chosen_files(i,2)=randi(size(myhandles.grouped_metadata{chosen_files(i,1)}.files_in_group,1));
        end
    end
end
global_filenames=cell(size(chosen_files,1),files_per_image);
for i=1:size(chosen_files,1)
%     filenames=cellfun(@(x) strcat(myhandles.rootDir,x),...
%           myhandles.grouped_metadata{condition}.files_in_group,'UniformOutput',false);
    condition=chosen_files(i,1);
    file_num=chosen_files(i,2);%randi(size(myhandles.grouped_metadata{condition}.files_in_group,1));%Pick Random File
    for channel=1:files_per_image
        global_filenames{i,channel}=strcat(myhandles.rootDir,...
          myhandles.grouped_metadata{condition}.files_in_group{file_num,channel}); 
    end
end
setappdata(0,'myhandles',myhandles);
%Generate Global Basis
warning off;
set(myhandles.statusbarHandles.ProgressBar, 'Visible','on', 'Indeterminate','on');
myhandles.statusbarHandles=statusbar(hObject,'Learning Block Types (1/3)');
global_data=wmd_read_data_simple(global_filenames,block_size,...
    cutoff_intensity,number_of_RGB_clusters,number_of_block_clusters,...
    number_of_blocks_per_training_image,...
    rgb_samples_per_training_image,number_of_block_representatives,myhandles.marker_scales,...
    myhandles.include_background_superblocks);
set(myhandles.statusbarHandles.ProgressBar, 'Visible','on', 'Indeterminate','on');
myhandles.statusbarHandles=statusbar(hObject,'Learning Superblock Types (2/3)');

warning on;
try
third_order=ThirdOrder_Basis(global_filenames,global_data,number_of_superblocks,...
    myhandles.marker_scales,myhandles.include_background_superblocks);
catch exception
  if(strcmp(exception.identifier,'MATLAB:nomem'))    
    errordlg(['You are running out of Memory due to :' char(10)... 
       ' 1) A too small block size value (try to increase it)' char(10)... 
       ' 2) A too large number of group: try to use a smaller '...
       'set of image groups used during the training step '...
       '(e.g. analyse your image by row instead well)']);
     myhandles.statusbarHandles=statusbar(hObject,'Error in the data processing, Out of Memory');
     set(myhandles.statusbarHandles.ProgressBar, 'Visible','off', 'Indeterminate','off');
     rethrow(exception);
  else
    errordlg('Error in the data processing');
    rethrow(exception);
  end
end
global_data.superblock_centroids=third_order.superblock_centroids;
global_data.superblock_representatives=third_order.superblock_representatives;
myhandles.global_data=global_data;
%third_order=ThirdOrder_Basis(global_filenames,global_data,number_of_superblocks,...
%    myhandles.marker_scales,myhandles.include_background_superblocks);
Ripped_Data=struct;
individual_block_profiles=zeros(myhandles.number_of_files,number_of_block_clusters);
individual_superblock_profiles=zeros(myhandles.number_of_files,number_of_superblocks);
individual_number_foreground_blocks=zeros(myhandles.number_of_files,1);
%Calculating Block Profiles per Image
warning off;
set(myhandles.statusbarHandles.ProgressBar, 'Visible','on', 'Indeterminate','off');
set(myhandles.statusbarHandles.ProgressBar, 'Visible','on', 'Minimum',0, 'Maximum',myhandles.number_of_files, 'Value',0);
myhandles.statusbarHandles=statusbar(hObject,'Analysing Images (3/3)');
tStart=tic; 
 myhandles.files_analyzed=0;
filenames=cell(1,files_per_image); 
for file_num=1:length(myhandles.metadata)
    myhandles.tElapsed=toc(tStart); 
    setappdata(0,'myhandles',myhandles);
    for i=1:files_per_image
        filenames{1,i}=strcat(myhandles.rootDir,myhandles.metadata{file_num}.FileNames{i});
    end
%     filenames=cellfun(@(x) strcat(myhandles.rootDir,x),...
%           myhandles.metadata{file_num}.FileNames,'UniformOutput',false);       
    results=SecondOrder(filenames,global_data,myhandles.marker_scales,...
        myhandles.include_background_superblocks);
    Ripped_Data(file_num).block_profile=results.block_profile;
    individual_block_profiles(file_num,:)=results.block_profile;
    individual_superblock_profiles(file_num,:)=results.superblock_profile;
    individual_number_foreground_blocks(file_num)=results.number_of_foreground_blocks;    
    Ripped_Data(condition).superblock_profile=results.superblock_profile;
    myhandles.files_analyzed=myhandles.files_analyzed+size(filenames,1);
    setappdata(0,'myhandles',myhandles);
    drawnow;
end
set(myhandles.statusbarHandles.ProgressBar, 'Visible','off','StringPainted','off');
warning on;
myhandles.Ripped_Data=Ripped_Data;
myhandles.individual_superblock_profiles=individual_superblock_profiles;
myhandles.individual_block_profiles=individual_block_profiles;
myhandles.individual_number_foreground_blocks=individual_number_foreground_blocks;
myhandles.is_file_blacklisted=false(length(myhandles.metadata),1);
SetButtonState(hObject,handles,true);
[myhandles.grouped_metadata,myhandles.superblock_profiles,~,~,...
myhandles.metadata_file_indices]=CalculateGroups(...
  myhandles.chosen_grouping_field,myhandles.metadata,...
  individual_superblock_profiles,individual_number_foreground_blocks,myhandles.is_file_blacklisted);
warning off;
myhandles.statusbarHandles=statusbar(hObject,'Done... Click on Xplorer to Explore your data!');
warning on;
myhandles.analysis_time=toc(analysistime_handle);
setappdata(0,'myhandles',myhandles);
set(handles.ExplorerButton,'Visible','on');
set(handles.SaveOutputButton,'Visible','on');
set(handles.ExplorerButton,'Enable','on');
set(handles.SaveOutputButton,'Enable','on');
%catch
%  myhandles.statusbarHandles=statusbar(hObject,'Error in the data processing');
%end
%guidata(hObject, handles);



% --- Executes on button press in SelectDirectory.
function TestThreshold_Callback(hObject, eventdata, handles)
myhandles=getappdata(0,'myhandles');
if(~isfield(myhandles,'files_per_image'))
  warndlg('You must load data or result first');
  return;
end
Calculate_Image_Parameters(hObject,handles,true);



% function AutoThreshold_Callback(hObject, eventdata, handles)
% % hObject    handle to SelectDirectory (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% myhandles=getappdata(0,'myhandles');
% % if(~myhandles.is_directory_usable)
% %     warndlg('Change Root Directory');
% %     return;
% % end
% %cutoff_intensity=str2double(get(handles.ThreshodIntensity,'String'));
% if(~isfield(myhandles,'files_per_image'))
%   warndlg('You must load data or result first');
%   return;
% end
% files_per_image=myhandles.files_per_image;
% number_of_channels=myhandles.number_of_channels;
% number_of_test_files=10;
% thresholds=zeros(number_of_test_files,1);
% set(myhandles.statusbarHandles.ProgressBar, 'Visible','on', 'Minimum',0,...
%   'Maximum',number_of_test_files, 'Value',0);
% myhandles.statusbarHandles=statusbar(hObject,'Calculating Best Threshold ...');
% for test_num=1:number_of_test_files
%   condition=randi(myhandles.number_of_conditions);
%   imagenames=myhandles.grouped_metadata{condition}.files_in_group;
%   file_num=randi(size(imagenames,1));
%   filename=imagenames{1};
%   test=imfinfo(filename);
%   xres=test.Height;
%   yres=test.Width;
%   img=zeros(xres,yres,number_of_channels);
%   channel_thresholds=zeros(number_of_channels,1);
%   if(number_of_channels==files_per_image)
%     for channel=1:number_of_channels
%       filename=imagenames{file_num,channel};
%       img(:,:,channel)=imread2(filename);
%     end
%   else
%     filename=imagenames{file_num,1};
%     img=imread2(filename);
%   end
%   
%   for channel=1:number_of_channels
%          intensity= img(:,:,channel);
%          max_intensity=max(intensity(:));
%          min_intensity=min(intensity(:));
%          intensity=(intensity-min_intensity)/(max_intensity-min_intensity);
%          channel_thresholds(channel)=graythresh(intensity)*(max_intensity-min_intensity)+min_intensity;
%     end
%   thresholds(test_num)=min(channel_thresholds).^2;
%   set(myhandles.statusbarHandles.ProgressBar, 'Value',test_num);
% end
% myhandles.statusbarHandles=statusbar(hObject,'');
% set(myhandles.statusbarHandles.ProgressBar, 'Visible','off');
% set(handles.ThreshodIntensity,'String',num2str(round(quantile(thresholds,0.25))));
% SetButtonState(hObject,handles,true);
% guidata(hObject, handles);
% setappdata(0,'myhandles',myhandles);



function ShowAdvanced_Callback(hObject, eventdata, handles)
if(get(hObject,'Value'))
  set(handles.AdvancedOptions,'Visible','on');
  set(handles.text4,'Visible','on');
  set(handles.text6,'Visible','on');
  set(handles.text7,'Visible','on');
  set(handles.ReduceColorNr,'Visible','on');
  set(handles.BlockTypeNr,'Visible','on');
  set(handles.SuperBlockNr,'Visible','on');
  set(handles.text23,'Visible','on');
  set(handles.text24,'Visible','on');
  set(handles.text25,'Visible','on');
  set(handles.MinImageTraining,'Visible','on');
  set(handles.MaxImageTraining,'Visible','on');
  
else
  set(handles.AdvancedOptions,'Visible','off');
  set(handles.text4,'Visible','off');
  set(handles.text6,'Visible','off');
  set(handles.text7,'Visible','off');
  set(handles.ReduceColorNr,'Visible','off');
  set(handles.BlockTypeNr,'Visible','off');
  set(handles.SuperBlockNr,'Visible','off');
  set(handles.text23,'Visible','off');
  set(handles.text24,'Visible','off');
  set(handles.text25,'Visible','off');
  set(handles.MinImageTraining,'Visible','off');
  set(handles.MaxImageTraining,'Visible','off');
end
guidata(hObject, handles);



function dir_ok=Test_Directory(imageDirectory)
myhandles=getappdata(0,'myhandles');
files_per_image=myhandles.files_per_image;
number_of_files=0;
if(strcmp(imageDirectory(length(imageDirectory):end),filesep))
  imageDirectory=imageDirectory(1:length(imageDirectory)-1);
end
try
  dir_list=dir(imageDirectory);
catch exception
  dir_ok=false;
  return;
end
subdirs={dir_list([(dir_list(:).isdir)]).name};
subdirs=subdirs(3:end);
if(isempty(subdirs))
  dir_ok=false;
  return;
end
subdirs_ok=true(length(subdirs),1);
file_structure=cell(length(subdirs),1);
for subdir_num=1:length(subdirs)
  
  dir_name=[imageDirectory filesep subdirs{subdir_num} filesep];
  
  dir_list=dir(dir_name);
  file_list={dir_list(~[(dir_list(:).isdir)]).name};
  imagenames=cell(0);
  
  for i=1:length(file_list)
    tokens=regexp(cell2mat(file_list(i)),'-','split');
    imagenames(i)=tokens(1);
  end
  imagenames=unique(imagenames);
  
  filenames=cell(length(imagenames),files_per_image);
  for image_number=1:length(imagenames)
    for channel=1:files_per_image
      filename=...
        [dir_name imagenames{image_number} '-' num2str(channel) '.png'];
      filenames{image_number,channel}=filename;
      if(exist(filename,'file')==0)
        subdirs_ok(subdir_num)=false;
        disp(filename);
      end
    end
    number_of_files=number_of_files+1;
  end
  file_structure{subdir_num}=filenames;
  if(~subdirs_ok(subdir_num))
    break;
  end
  
end
myhandles.number_of_files=number_of_files;
myhandles.file_structure=file_structure;
setappdata(0,'myhandles',myhandles);
dir_ok=~any(~subdirs_ok);



function SetButtonState(hObject,handles,state)
if(state)
    set(handles.RunBtn,'Enable','on');
    set(handles.TestThreshold,'Enable','on');
%    set(handles.SelectDirectory,'Enable','on');
else
    set(handles.RunBtn,'Enable','off');
    set(handles.TestThreshold,'Enable','off');
%    set(handles.SelectDirectory,'Enable','off');
end
drawnow;
guidata(hObject, handles); 



% --- Executes on button press in ExplorerButton.
function ExplorerButton_Callback(hObject, eventdata, handles)
% hObject    handle to ExplorerButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Explorer;



% --- Executes on button press in SaveOutputButton.
function SaveOutputButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveOutputButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%myhandles=getappdata(0,'myhandles');
%uisave;
%uiremember(findobj(gcf,'-depth',inf));
myhandles=getappdata(0,'myhandles');
lastPath=loadLastPath('result');
if(~exist(char(lastPath),'dir'))
  [filename,pathname]=uiputfile('*.mat','Save PhenoRipped Data','result.mat');
else
  [filename,pathname]=uiputfile('*.mat','Save PhenoRipped Data',[lastPath filesep 'result.mat']);
end
if(filename==0)
  return;
end
setappdata(gcf,'myhandles', myhandles);
hgsave(gcf,[pathname filesep filename]);
saveLastPath(pathname,'result');
h=msgbox('Data Saved Successfully');
% set(h, 'Position', [20 40 120 50]);



% --- Executes on button press in LoadResultsButton.
function LoadResultsButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadResultsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%[filename,pathname]=uigetfile;
lastPath=loadLastPath('result');
if(~exist(char(lastPath),'dir'))
  [filename,pathname]=uigetfile({'*.mat;','PhenoRipper Result (*.mat)'},'Select a previous result');
else
  [filename,pathname]=uigetfile({'*.mat;','PhenoRipper Result (*.mat)'},'Select a previous result', [lastPath]);
end
if(filename==0)
  return;
end
h=gcf;
delete(h);
hgload([pathname filesep filename]);
myhandles = getappdata(gcf,'myhandles');
% Lines below are added since loading the file does not initialize the
% status bar (it is a java hack, not officially supported by matlab)
myhandles.statusbarHandles=statusbar(gcf,'Welcome to PhenoRipper.');
set(myhandles.statusbarHandles.TextPanel, 'Foreground',[1,1,1], 'Background','black', 'ToolTipText','Loading...')
set(myhandles.statusbarHandles.ProgressBar, 'Background','white', 'Foreground',[0.4,0,0]);
setappdata(0,'myhandles',myhandles);
saveLastPath(pathname,'result');
h=msgbox('Data Load Successfully','modal');


function LoadParameters(loaded_handles,handles,hObject)
set(handles.SelectDirectory,'String',get(loaded_handles.SelectDirectory,'String'));
guidata(hObject, handles);



% --- Executes on selection change in PointColor_popupmenu.
function PointColor_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to PointColor_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PointColor_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PointColor_popupmenu



% --- Executes during object creation, after setting all properties.
function PointColor_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PointColor_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in PointLabel_popupmenu.
function PointLabel_popupmenu_Callback(hObject, eventdata, handles)
% hObject    handle to PointLabel_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PointLabel_popupmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PointLabel_popupmenu



% --- Executes during object creation, after setting all properties.
function PointLabel_popupmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PointLabel_popupmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in SelectDirectory.
function Calculate_Image_Parameters(hObject,handles,Show_Visualization_Window)
myhandles=getappdata(0,'myhandles');
if(~Show_Visualization_Window)
  warning off;
  %cutoff_intensity=str2double(get(handles.ThreshodIntensity,'String'));
  files_per_image=myhandles.files_per_image;
  number_of_channels=myhandles.number_of_channels;
  number_of_test_files=10;
  selected_files=cell(number_of_test_files,files_per_image);
  
    set(myhandles.statusbarHandles.ProgressBar, 'Visible','on', 'Minimum',0, 'Maximum',number_of_test_files, 'Value',0);
  myhandles.statusbarHandles=statusbar(hObject,'Scanning through all images');
  drawnow;
  for test_num=1:number_of_test_files
    condition=randi(myhandles.number_of_conditions);
%     imagenames=cellfun(@(x) strcat(myhandles.rootDir,x),...
%       myhandles.grouped_metadata{condition}.files_in_group,'UniformOutput',false);
    file_num=randi(size(myhandles.grouped_metadata{condition}.files_in_group,1));
    for channel=1:files_per_image
      selected_files{test_num,channel}=strcat(myhandles.rootDir,...
          myhandles.grouped_metadata{condition}.files_in_group{file_num,channel});
%       
%       imagenames{file_num,channel};
    end
    set(myhandles.statusbarHandles.ProgressBar, 'Value',test_num);
    if(test_num==1)
      drawnow;
    end
  end 
    
    set(myhandles.statusbarHandles.ProgressBar, 'Visible','on', 'Minimum',0, 'Maximum',size(selected_files,1), 'Value',0);
    %myhandles.statusbarHandles(hObject, 'Calculating Image Parameters ...');
    myhandles.statusbarHandles=statusbar(hObject,'Calculating Image Parameters ...');
    test=imfinfo(selected_files{1,1});
    xres=test.Height;
    yres=test.Width;
    img=zeros(xres,yres,number_of_channels);
    amplitudes=zeros(size(selected_files,1),1);
    thresholds=zeros(size(selected_files,1),number_of_channels);
    max_val=0;
    color_scales=zeros(size(selected_files,1),number_of_channels);
    for file_num=1:size(selected_files,1)
        if(number_of_channels~=files_per_image)
            img=double(imread2(selected_files{file_num,1}));
        else
            for channel=1:number_of_channels
                %USE IMREAD FOR SINGLE CHANNEL ALWAYS
                img(:,:,channel)=double(imread(selected_files{file_num,channel}));
            end
        end
        channel_thresholds=zeros(number_of_channels,1);
        for channel=1:number_of_channels
            intensity=img(:,:,channel);
            color_scales(file_num,channel)=prctile(intensity(:),99.9);
            max_intensity=max(intensity(:));
            min_intensity=min(intensity(:));
            intensity=(intensity-min_intensity)/(max_intensity-min_intensity);
            channel_thresholds(channel)=graythresh(intensity)*(max_intensity-min_intensity)+min_intensity;
            thresholds(file_num,channel)=channel_thresholds(channel);
        end
        max_val=max(max(img(:)),max_val);
        amp=sum(double(img).^2,3);
        amplitudes(file_num)=quantile(amp(:),0.66);
        %thresholds(file_num)=min(channel_thresholds).^2;
        set(myhandles.statusbarHandles.ProgressBar, 'Value',file_num);
    end
   
    myhandles.marker_scales=zeros(number_of_channels,2);
    myhandles.marker_scales(:,2)=median(color_scales,1)';
    for channel=1:number_of_channels
       thresholds(:,channel)=100*thresholds(:,channel)/myhandles.marker_scales(channel,2); 
    end
    thresholds=min(thresholds,[],2);
    cutoff_intensity=round(quantile(thresholds(:),0.2));
    myhandles.cutoff_intensity=cutoff_intensity;
%     set(handles.ThreshodIntensity,'String',num2str(cutoff_intensity));
    myhandles.color_order={'Blue','Green','Red','Yellow','Magenta','Gray'};
    myhandles.display_colors=myhandles.color_order(1:number_of_channels);
    myhandles.statusbarHandles=statusbar(hObject,'');
    set(myhandles.statusbarHandles.ProgressBar, 'Visible','off'); 
    myhandles.amplitude_range=max(cutoff_intensity,30);
    myhandles.bit_depth=bit_depth(double(max_val),[8,12,14,16,32]);
    
    %myhandles=getappdata(0,'myhandles');
    myhandles.test_files=selected_files;
    myhandles.cutoff_intensity=cutoff_intensity;
%     myhandles.block_size=str2double(get(handles.blockSize,'String'));
    myhandles.block_size=10;
    %set(handles.ThreshodIntensity,'String',num2str(max(myhandles.cutoff_intensity,myhandles.amplitude_range)));
    setappdata(0,'myhandles',myhandles);
    
    
else
  myhandles.statusbarHandles=statusbar(hObject,'Testing Image In Other Window');
  try
    h=ThresholdImage;
    uiwait(h);
  catch exception
    rethrow(exception);
    warning on;
  end
  myhandles.statusbarHandles=statusbar(hObject,'');
  handles=guidata(hObject);
  myhandles=getappdata(0,'myhandles');
%   set(handles.ThreshodIntensity,'String',num2str(myhandles.cutoff_intensity));
%   set(handles.blockSize,'String',num2str(myhandles.block_size));
  SetButtonState(hObject,handles,true);
end
warning on;
guidata(hObject, handles);

% function result=concatenateString(string1,string2)
%   result=[string1 string2];

function initializeMyHandle()
myhandles.block_size=10;
myhandles.cutoff_intensity=9;
myhandles.number_of_RGB_clusters=10;
myhandles.number_of_block_clusters=10;
myhandles.number_of_blocks_per_training_image=1000;
myhandles.rgb_samples_per_training_image=3000;
myhandles.number_of_block_representatives=3;
myhandles.is_directory_usable=false;
%Added by default
myhandles.number_of_superblocks=30;
myhandles.minimum_training_files=50;
myhandles.maximum_training_files=100;
myhandles.include_background_superblocks=1;



setappdata(0,'myhandles',myhandles);

function addProgressBarToMyHandle(mainFigure)
myhandles=getappdata(0,'myhandles');
warning off;
myhandles.statusbarHandles=statusbar(mainFigure,...
  'Welcome to PhenoRipper...');
set(myhandles.statusbarHandles.TextPanel, 'Foreground',[1,1,1],...
  'Background','black', 'ToolTipText','Loading...');
set(myhandles.statusbarHandles.ProgressBar, 'Background','white',...
  'Foreground',[0.4,0,0]);
warning on;
setappdata(0,'myhandles',myhandles);


% --- Executes on button press in useBackgroundInfoCB.
function useBackgroundInfoCB_Callback(hObject, eventdata, handles)
% hObject    handle to useBackgroundInfoCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of useBackgroundInfoCB



function MinImageTraining_Callback(hObject, eventdata, handles)
% hObject    handle to MinImageTraining (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MinImageTraining as text
%        str2double(get(hObject,'String')) returns contents of MinImageTraining as a double


% --- Executes during object creation, after setting all properties.
function MinImageTraining_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MinImageTraining (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MaxImageTraining_Callback(hObject, eventdata, handles)
% hObject    handle to MaxImageTraining (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxImageTraining as text
%        str2double(get(hObject,'String')) returns contents of MaxImageTraining as a double


% --- Executes during object creation, after setting all properties.
function MaxImageTraining_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxImageTraining (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
