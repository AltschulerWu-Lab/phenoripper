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

% Last Modified by GUIDE v2.5 21-Jan-2011 14:11:02

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
myhandles.block_size=10;
myhandles.cutoff_intensity=1000;
myhandles.number_of_RGB_clusters=10;
myhandles.number_of_block_clusters=10;
myhandles.number_of_blocks_per_training_image=1000;
myhandles.rgb_samples_per_training_image=3000;
myhandles.number_of_block_representatives=3;
myhandles.number_of_superblocks=20;
myhandles.number_of_channels=3;
myhandles.imageDirectory='';

setappdata(0,'myhandles',myhandles);





% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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
function SelectDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to SelectDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
files = uipickfiles('num',1,'out','ch');

set(handles.ImageRootDirectory','String',files);
guidata(hObject, handles);




% --- Executes on button press in RunBtn.
function RunBtn_Callback(hObject, eventdata, handles)
% hObject    handle to RunBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
block_size = str2double(get(handles.blockSize,'String'));
cutoff_intensity=str2double(get(handles.ThreshodIntensity,'String'));
number_of_RGB_clusters=str2double(get(handles.ReduceColorNr,'String'));
number_of_block_clusters=str2double(get(handles.BlockTypeNr,'String'));
number_of_blocks_per_training_image=1000;
rgb_samples_per_training_image=3000;
number_of_block_representatives=3;
number_of_superblocks=str2double(get(handles.SuperBlockNr,'String'));
number_of_channels=str2double(get(handles.ChannelNr,'String'));
imageDirectory=get(handles.ImageRootDirectory,'String');

if (get(handles.displayByColumn,'Value') == get(handles.displayByColumn,'Max'))
    outputDisplay=1;
elseif (get(handles.displayByRow,'Value') == get(handles.displayByRow,'Max'))
    outputDisplay=2;
else
    outputDisplay=3;
end
if (get(handles.OutputMDS,'Value') == get(handles.displayByColumn,'Max'))
    outputType=1;
elseif (get(handles.OutputHeatMap,'Value') == get(handles.displayByRow,'Max'))
    outputType=2;
else
    outputType=3;
end

if(strcmp(imageDirectory(length(imageDirectory):end),filesep))
    imageDirectory=imageDirectory(1:length(imageDirectory)-1);
end
dir_list=dir(imageDirectory);
subdirs={dir_list([(dir_list(:).isdir)]).name};
subdirs=subdirs(3:end);
global_filenames=cell(length(subdirs),number_of_channels);

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
    
    filenames=cell(length(imagenames),number_of_channels);
    for image_number=1:length(imagenames)
        for channel=1:number_of_channels
            filenames{image_number,channel}=...
                [dir_name imagenames{image_number} '-' num2str(channel) '.png'];
        end
    end
    
    file_num=randi(size(filenames,1));%Pick Random File
    for channel=1:number_of_channels
        global_filenames{subdir_num,channel}=filenames{file_num,channel}; %Change this to a randomly selected file
    end
  
    
end


global_data=wmd_read_data_simple(global_filenames,block_size,...
    cutoff_intensity,number_of_RGB_clusters,number_of_block_clusters,...
    number_of_blocks_per_training_image,...
    rgb_samples_per_training_image,number_of_block_representatives);

third_order=ThirdOrder_Basis(global_filenames,global_data,number_of_superblocks);
global_data.superblock_centroids=third_order.superblock_centroids;

if(strcmp(imageDirectory(length(imageDirectory):end),filesep))
    imageDirectory=imageDirectory(1:length(imageDirectory)-1);
end
dir_list=dir(imageDirectory);
subdirs={dir_list([(dir_list(:).isdir)]).name};
subdirs=subdirs(3:end);
Ripped_Data=struct;
block_profiles=zeros(length(subdirs),number_of_block_clusters);
well_names=cell(length(subdirs),1);
h = waitbar(0,'Please wait...','Name','Second Order Calculations...',...
            'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');

tStart=tic; tElapsed=toc(tStart); 
for subdir_num=1:length(subdirs)
    if getappdata(h,'canceling')
        break
    end
    
    dir_name=[imageDirectory filesep subdirs{subdir_num} filesep];
    
    dir_list=dir(dir_name);
    file_list={dir_list(~[(dir_list(:).isdir)]).name};
    imagenames=cell(0);
    
    for i=1:length(file_list)
        tokens=regexp(cell2mat(file_list(i)),'-','split');
        imagenames(i)=tokens(1);
    end
    imagenames=unique(imagenames);
    
    filenames=cell(length(imagenames),number_of_channels);
    for image_number=1:length(imagenames)
        for channel=1:number_of_channels
            filenames{image_number,channel}=...
                [dir_name imagenames{image_number} '-' num2str(channel) '.png'];
        end
    end
    
    results=SecondOrder(filenames,global_data);
    Ripped_Data(subdir_num).block_profile=results.block_profile;
    block_profiles(subdir_num,:)=results.block_profile;
    dir_name=subdirs{subdir_num};
    Ripped_Data(subdir_num).row_name=dir_name(1);
    Ripped_Data(subdir_num).column_number=dir_name(2:end);
    Ripped_Data(subdir_num).well=dir_name;
    well_names{subdir_num}=dir_name;
    
     tElapsed=toc(tStart); 
     waitbar(subdir_num/length(subdirs),h,sprintf('%3f minutes left',(length(subdirs)-subdir_num)*tElapsed/(60*subdir_num)))
end

delete(h);

row_names=cell(0);
col_names=cell(0);
for subdir_num=1:length(subdirs)
   row_names{subdir_num}= Ripped_Data(subdir_num).row_name;
   col_names{subdir_num}= Ripped_Data(subdir_num).column_number;
end


        
[r,rn]=grp2idx(row_names);
[c,cn]=grp2idx(col_names);

switch(outputDisplay)
    case 1
        colorsGroup=c;
    case 2
        colorsGroup=r;
    case 3
        colorsGroup=(1:length(subdirs));
end


switch(outputType)
    case 1
        
        
        dists=pdist(block_profiles);
        profile_mds=mdscale(dists,3);
        colors=colormap(jet(max(colorsGroup)));
        figure;
        scatter3(profile_mds(:,1),profile_mds(:,2),profile_mds(:,3),10);
        for i=1:size(block_profiles,1)
            text(profile_mds(i,1),profile_mds(i,2),profile_mds(i,3),Ripped_Data(i).well,...
                'BackgroundColor',colors(colorsGroup(i),:));%not always cn
        end
    case 2
        clustergram(block_profiles,'RowLabels',well_names);
        
    case 3
        
        clustergram(block_profiles,'RowLabels',well_names);
        
        dists=pdist(block_profiles);
        profile_mds=mdscale(dists,3);
        colors=colormap(jet(max(colorsGroup)));
        figure;
        scatter3(profile_mds(:,1),profile_mds(:,2),profile_mds(:,3),10);
        for i=1:size(block_profiles,1)
            text(profile_mds(i,1),profile_mds(i,2),profile_mds(i,3),Ripped_Data(i).well,...
                'BackgroundColor',colors(colorsGroup(i),:));%not always cn
            
        end
end





display('end');
    


% --- Executes on button press in SelectDirectory.
function TestThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to SelectDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cutoff_intensity=str2double(get(handles.ThreshodIntensity,'String'));
number_of_channels=str2double(get(handles.ChannelNr,'String'));
imageDirectory=get(handles.ImageRootDirectory,'String');
   
number_of_test_files=10;

selected_files=cell(number_of_test_files,number_of_channels);

if(strcmp(imageDirectory(length(imageDirectory):end),filesep))
    imageDirectory=imageDirectory(1:length(imageDirectory)-1);
end
dir_list=dir(imageDirectory);
subdirs={dir_list([(dir_list(:).isdir)]).name};
subdirs=subdirs(3:end);


for test_num=1:number_of_test_files
  subdir_num=randi(length(subdirs));
dir_name=[imageDirectory filesep subdirs{subdir_num} filesep];
    
    dir_list=dir(dir_name);
    file_list={dir_list(~[(dir_list(:).isdir)]).name};
    imagenames=cell(0);
    
    for i=1:length(file_list)
        tokens=regexp(cell2mat(file_list(i)),'-','split');
        imagenames(i)=tokens(1);
    end
    imagenames=unique(imagenames);
    file_num=randi(length(imagenames));
    
    for channel=1:number_of_channels
        selected_files{test_num,channel}=...
            [dir_name imagenames{file_num} '-' num2str(channel) '.png'];
         
    end

    
end    
myhandles=getappdata(0,'myhandles');
myhandles.test_files=selected_files;
myhandles.cutoff_intensity=cutoff_intensity;
myhandles.block_size=str2double(get(handles.blockSize,'String'));
setappdata(0,'myhandles',myhandles);
h=ThresholdImage;
uiwait(h);
handles=guidata(hObject);
myhandles=getappdata(0,'myhandles');
set(handles.ThreshodIntensity,'String',num2str(myhandles.cutoff_intensity));
guidata(hObject, handles);



    

    
    
function AutoThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to SelectDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cutoff_intensity=str2double(get(handles.ThreshodIntensity,'String'));
number_of_channels=str2double(get(handles.ChannelNr,'String'));
imageDirectory=get(handles.ImageRootDirectory,'String');
number_of_test_files=10;


if(strcmp(imageDirectory(length(imageDirectory):end),filesep))
    imageDirectory=imageDirectory(1:length(imageDirectory)-1);
end
dir_list=dir(imageDirectory);
subdirs={dir_list([(dir_list(:).isdir)]).name};
subdirs=subdirs(3:end);

thresholds=zeros(number_of_test_files,1);
for test_num=1:number_of_test_files
  subdir_num=randi(length(subdirs));
dir_name=[imageDirectory filesep subdirs{subdir_num} filesep];
    
    dir_list=dir(dir_name);
    file_list={dir_list(~[(dir_list(:).isdir)]).name};
    imagenames=cell(0);
    
    for i=1:length(file_list)
        tokens=regexp(cell2mat(file_list(i)),'-','split');
        imagenames(i)=tokens(1);
    end
    imagenames=unique(imagenames);
    file_num=randi(length(imagenames));
    
    filename=[dir_name imagenames{file_num} '-' num2str(1) '.png'];
    test=imfinfo(filename);
    xres=test.Height;
    yres=test.Width;
    img=zeros(xres,yres,number_of_channels);
    
   
    channel_thresholds=zeros(number_of_channels,1);
    for channel=1:number_of_channels
        filename=...
            [dir_name imagenames{file_num} '-' num2str(channel) '.png'];
         img(:,:,channel)=imread(filename);
         intensity= img(:,:,channel);
         max_intensity=max(intensity(:));
         min_intensity=min(intensity(:));
         intensity=(intensity-min_intensity)/(max_intensity-min_intensity);
         channel_thresholds(channel)=graythresh(intensity)*(max_intensity-min_intensity)+min_intensity;
    end

    
%     intensity=sum(double(img).^2,3);
%     max_intensity=max(intensity(:));
%     min_intensity=min(intensity(:));
%     intensity=(intensity-min_intensity)/(max_intensity-min_intensity);
%     thresholds(test_num)=graythresh(intensity)*(max_intensity-min_intensity)+min_intensity;
%     
   thresholds(test_num)=min(channel_thresholds).^2;
end    


set(handles.ThreshodIntensity,'String',num2str(min(thresholds)));
guidata(hObject, handles);
