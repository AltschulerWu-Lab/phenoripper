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

% Last Modified by GUIDE v2.5 17-Feb-2011 13:36:01

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
%myhandles.files_per_image=3;
myhandles.imageDirectory='/home/z/My Paper Stuff/Images/Test';
myhandles.is_directory_usable=false;

setappdata(0,'myhandles',myhandles);

%Status Bar
% jFrame = get(hObject,'JavaFrame');
% jRootPane = jFrame.fHG1Client.getWindow;
% statusbarObj = com.mathworks.mwswing.MJStatusBar;
% jRootPane.setStatusBar(statusbarObj);
% statusbarObj.setText(statusText);
splash('logo','png');
% Choose default command line output for gui
handles.output = hObject;
set(handles.ExplorerButton,'Visible','off');
set(handles.SaveOutputButton,'Visible','off');
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
myhandles=getappdata(0,'myhandles');
myhandles.statusbarHandles=statusbar(hObject,'Welcome to PhenoRipper ...Prepare to be amazed.');
set(myhandles.statusbarHandles.TextPanel, 'Foreground',[1,1,1], 'Background','black', 'ToolTipText','Loading...')

set(myhandles.statusbarHandles.ProgressBar, 'Background','white', 'Foreground',[0.4,0,0]);

setappdata(0,'myhandles',myhandles);
% myhandles.statusbarTxt = myhandles.statusbarHandles.getComponent(0);
% myhandles.statusbarTxt.setForeground(java.awt.Color.white);
% set(myhandles.statusbarTxt,'Background','black');


% Add a progress-bar to left side of standard MJStatusBar container
% jProgressBar = javax.swing.JProgressBar;
% set(jProgressBar, 'Minimum',0, 'Maximum',500, 'Value',234);
% set(jProgressBar, 'Background','black','Foreground',[0.4,0,0]);
% set(jProgressBar, 'BorderPainted','off');
% myhandles.statusbarHandles.add(jProgressBar,'West');  % 'West' => left of text; 'East' => right
% Beware: 'East' also works but doesn't resize automatically
 
% Set this container as the figure's status-bar
%jRootPane.setStatusBar(statusbarObj);
 
% Note: setting setStatusBarVisible(1) is not enough to display the status-bar
% - we also need to call setText(), even if only with an empty string ''
% myhandles.statusbarHandles.setText('testing 123...');
%jRootPane.setStatusBarVisible(1);



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
function SelectDirectory_Callback(hObject, eventdata, handles)
% hObject    handle to SelectDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%SetButtonState(hObject,handles,false);
% myhandles=getappdata(0,'myhandles');
% %files = uipickfiles('num',1,'out','ch','FilterSpec','/home/z/My Paper Stuff/Images/Test');
% files = uipickfiles('num',1,'out','ch','FilterSpec',myhandles.imageDirectory);
% %files = uipickfiles('num',1,'out','ch','FilterSpec','TestImages/');
% if(files~=0)
% set(handles.ImageRootDirectory','String',files);
% myhandles.imageDirectory=files;
% setappdata(0,'myhandles',myhandles);
% end
% if(~Test_Directory(files))
%     warndlg('Directory Unusable');
% else
%     myhandles=getappdata(0,'myhandles');
%     myhandles.is_directory_usable=true;
%     setappdata(0,'myhandles',myhandles);
% end

scroll_panel;
uiwait;
myhandles=getappdata(0,'myhandles');

myhandles.number_of_conditions=length(myhandles.grouped_metadata);
myhandles.number_of_files=0;
for i=1:myhandles.number_of_conditions
    myhandles.number_of_files=myhandles.number_of_files+...
        size(myhandles.grouped_metadata{i}.files_in_group,1);
end
set(handles.PointColor_popupmenu,'String',myhandles.grouping_fields);
set(handles.PointLabel_popupmenu,'String',myhandles.grouping_fields);
setappdata(0,'myhandles',myhandles);
%SetButtonState(hObject,handles,true);
guidata(hObject, handles);



% --- Executes on button press in RunBtn.
function RunBtn_Callback(hObject, eventdata, handles)
% hObject    handle to RunBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

myhandles=getappdata(0,'myhandles');
% if(~myhandles.is_directory_usable)
%     warndlg('Change Root Directory');
%     return;
% end

%SetButtonState(hObject,handles,false);

block_size = str2double(get(handles.blockSize,'String'));
cutoff_intensity=str2double(get(handles.ThreshodIntensity,'String'));
number_of_RGB_clusters=str2double(get(handles.ReduceColorNr,'String'));
number_of_block_clusters=str2double(get(handles.BlockTypeNr,'String'));
number_of_blocks_per_training_image=1000;
rgb_samples_per_training_image=3000;
number_of_block_representatives=3;
number_of_superblocks=str2double(get(handles.SuperBlockNr,'String'));
files_per_image=myhandles.files_per_image;%str2double(get(handles.ChannelNr,'String'));
imageDirectory=get(handles.ImageRootDirectory,'String');

if(myhandles.number_of_conditions>100)
   chosen_conditions=randsample(myhandles.number_of_conditions,100); 
else
    chosen_conditions=1:myhandles.number_of_conditions;
end

global_filenames=cell(length(chosen_conditions),files_per_image);
for condition=1:length(chosen_conditions)
    filenames=myhandles.grouped_metadata{chosen_conditions(condition)}.files_in_group;
    file_num=randi(size(filenames,1));%Pick Random File
    for channel=1:files_per_image
        global_filenames{condition,channel}=filenames{file_num,channel}; 
    end
  
end


set(myhandles.statusbarHandles.ProgressBar, 'Visible','on', 'Indeterminate','on');
%set(myhandles.statusbarHandles.ProgressBar, 'Visible','on', 'Minimum',0, 'Maximum',myhandles.number_of_files, 'Value',0);
myhandles.statusbarHandles=statusbar(hObject,'Generating Global Basis');
global_data=wmd_read_data_simple(global_filenames,block_size,...
    cutoff_intensity,number_of_RGB_clusters,number_of_block_clusters,...
    number_of_blocks_per_training_image,...
    rgb_samples_per_training_image,number_of_block_representatives);



set(myhandles.statusbarHandles.ProgressBar, 'Visible','on', 'Indeterminate','on');
%set(myhandles.statusbarHandles.ProgressBar, 'Visible','on', 'Minimum',0, 'Maximum',myhandles.number_of_files, 'Value',0);
myhandles.statusbarHandles=statusbar(hObject,'Generating Neighborhood Statistics');
%try
third_order=ThirdOrder_Basis(global_filenames,global_data,number_of_superblocks);
global_data.superblock_centroids=third_order.superblock_centroids;
global_data.mean_superblock_profile=third_order.mean_superblock_profile;
global_data.superblock_representatives=third_order.superblock_representatives;
myhandles.global_data=global_data;
%catch exception
%   disp(exception); 
%end

% 
% if(strcmp(imageDirectory(length(imageDirectory):end),filesep))
%     imageDirectory=imageDirectory(1:length(imageDirectory)-1);
% end
%     
% dir_list=dir(imageDirectory);
% subdirs={dir_list([(dir_list(:).isdir)]).name};
% subdirs=subdirs(3:end);
Ripped_Data=struct;
block_profiles=zeros(myhandles.number_of_conditions,number_of_block_clusters);
superblock_profiles=zeros(myhandles.number_of_conditions,number_of_superblocks);
well_names=cell(myhandles.number_of_conditions,1);
set(myhandles.statusbarHandles.ProgressBar, 'Visible','on', 'Indeterminate','off');
set(myhandles.statusbarHandles.ProgressBar, 'Visible','on', 'Minimum',0, 'Maximum',myhandles.number_of_files, 'Value',0);
myhandles.statusbarHandles=statusbar(hObject,'Calculating Block Profiles per Image...');

tStart=tic; 
 myhandles.files_analyzed=0;
 
for condition=1:myhandles.number_of_conditions
    myhandles.tElapsed=toc(tStart); 
    setappdata(0,'myhandles',myhandles);
    filenames=myhandles.grouped_metadata{condition}.files_in_group;
       
    results=SecondOrder(filenames,global_data);
    Ripped_Data(condition).block_profile=results.block_profile;
    block_profiles(condition,:)=results.block_profile;
    superblock_profiles(condition,:)=results.superblock_profile;
    Ripped_Data(condition).superblock_profile=results.superblock_profile;
%     dir_name=subdirs{condition};
%     Ripped_Data(condition).row_name=dir_name(1);
%     Ripped_Data(condition).column_number=dir_name(2:end);
%     Ripped_Data(condition).well=dir_name;
%     well_names{condition}=dir_name;
    
%    waitbar(subdir_num/length(subdirs),h,sprintf('%3f minutes
%    left',(length(subdirs)-subdir_num)*tElapsed/(60*subdir_num)));
   %set(myhandles.statusbarHandles.ProgressBar, 'Value',subdir_num);
    myhandles.files_analyzed=myhandles.files_analyzed+size(filenames,1);
    setappdata(0,'myhandles',myhandles);
    drawnow;
    
end
 
set(myhandles.statusbarHandles.ProgressBar, 'Visible','off','StringPainted','off');
myhandles.Ripped_Data=Ripped_Data;
myhandles.superblock_profiles=superblock_profiles;
myhandles.block_profiles=block_profiles;
setappdata(0,'myhandles',myhandles);
% 
% row_names=cell(0);
% col_names=cell(0);
% for subdir_num=1:length(subdirs)
%    row_names{subdir_num}= Ripped_Data(subdir_num).row_name;
%    col_names{subdir_num}= Ripped_Data(subdir_num).column_number;
% end
% 
% 
%         
% [r,rn]=grp2idx(row_names);
% [c,cn]=grp2idx(col_names);
% 
% switch(outputDisplay)
%     case 1
%         colorsGroup=c;
%     case 2
%         colorsGroup=r;
%     case 3
%         colorsGroup=(1:length(subdirs));
% end
% 
% myhandles.mds_text=cell(size(block_profiles,1),1);
% myhandles.mds_colors=zeros(size(block_profiles,1),3);
% switch(outputType)
%     case 1
%         
%         
%         dists=pdist(superblock_profiles);
%         profile_mds=mdscale(dists,3);
%         colors=colormap(jet(max(colorsGroup)));
%         figure;
%         scatter3(profile_mds(:,1),profile_mds(:,2),profile_mds(:,3),10);
%         for i=1:size(block_profiles,1)
%             text(profile_mds(i,1),profile_mds(i,2),profile_mds(i,3),Ripped_Data(i).well,...
%                 'BackgroundColor',colors(colorsGroup(i),:));%not always cn
%             myhandles.mds_text{i}=Ripped_Data(i).well;
%             myhandles.mds_colors(i,:)=colors(colorsGroup(i),:);
%         end
%     case 2
%         clustergram(superblock_profiles,'RowLabels',well_names);
%         
%     case 3
%         
%         clustergram(superblock_profiles,'RowLabels',well_names);
%         
%         dists=pdist(superblock_profiles);
%         profile_mds=mdscale(dists,3);
%         colors=colormap(jet(max(colorsGroup)));
%         figure;
%         scatter3(profile_mds(:,1),profile_mds(:,2),profile_mds(:,3),10);
%         for i=1:size(block_profiles,1)
%             text(profile_mds(i,1),profile_mds(i,2),profile_mds(i,3),Ripped_Data(i).well,...
%                 'BackgroundColor',colors(colorsGroup(i),:));%not always cn
%             myhandles.mds_text{i}=Ripped_Data(i).well;
%             myhandles.mds_colors(i,:)=colors(colorsGroup(i),:);
%         end
% end
% 
mean_sb=mean(superblock_profiles);
% for i=1:size(superblock_profiles,1)
%     superblock_profiles(i,:)=log((superblock_profiles(i,:)+1E-7)./mean_sb);
% end

%dists=pdist(superblock_profiles);


%myhandles.mds_data=mdscale(dists,3);
setappdata(0,'myhandles',myhandles);
%SetButtonState(hObject,handles,true);
set(handles.ExplorerButton,'Visible','on');
set(handles.SaveOutputButton,'Visible','on');
set(handles.ExplorerButton,'Enable','on');
set(handles.SaveOutputButton,'Enable','on');
%set(hObject,handles,true);
guidata(hObject, handles); 
%display('end');

% --- Executes on button press in SelectDirectory.
function TestThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to SelectDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

myhandles=getappdata(0,'myhandles');
% if(~myhandles.is_directory_usable)
%     warndlg('Change Root Directory');
%     return;
% end
%SetButtonState(hObject,handles,false);


cutoff_intensity=str2double(get(handles.ThreshodIntensity,'String'));
files_per_image=myhandles.files_per_image;%str2double(get(handles.ChannelNr,'String'));
number_of_channels=myhandles.number_of_channels;
%imageDirectory=get(handles.ImageRootDirectory,'String');
   
number_of_test_files=10;

selected_files=cell(number_of_test_files,files_per_image);

% if(strcmp(imageDirectory(length(imageDirectory):end),filesep))
%     imageDirectory=imageDirectory(1:length(imageDirectory)-1);
% end
% dir_list=dir(imageDirectory);
% subdirs={dir_list([(dir_list(:).isdir)]).name};


for test_num=1:number_of_test_files
    condition=randi(myhandles.number_of_conditions);
    imagenames=myhandles.grouped_metadata{condition}.files_in_group;
    
    file_num=randi(size(imagenames,1));
    
    for channel=1:files_per_image
        selected_files{test_num,channel}=imagenames{file_num,channel};
          
        
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
max_val=0;
for file_num=1:size(selected_files,1)
    if(number_of_channels~=files_per_image)
        img=selected_files{file_num,1};
    else
        for channel=1:number_of_channels
                img(:,:,channel)=imread(selected_files{file_num,channel});
        end
    end
    max_val=max(max(img(:)),max_val);
    amp=sum(double(img).^2,3);
    amplitudes(file_num)=quantile(amp(:),0.66);
    set(myhandles.statusbarHandles.ProgressBar, 'Value',file_num);
end
set(myhandles.statusbarHandles.ProgressBar, 'Visible','off');
myhandles.amplitude_range=max(cutoff_intensity,mean(amplitudes));
myhandles.bit_depth=bit_depth(max_val,[8,12,14,16,32]);

%myhandles=getappdata(0,'myhandles');
myhandles.test_files=selected_files;
myhandles.cutoff_intensity=cutoff_intensity;
myhandles.block_size=str2double(get(handles.blockSize,'String'));
%set(handles.ThreshodIntensity,'String',num2str(max(myhandles.cutoff_intensity,myhandles.amplitude_range)));
setappdata(0,'myhandles',myhandles);
myhandles.statusbarHandles=statusbar(hObject,'Testing Image In Other Window');
try
h=ThresholdImage;
uiwait(h);
catch exception
     rethrow(exception);
end

myhandles.statusbarHandles=statusbar(hObject,'');
handles=guidata(hObject);
myhandles=getappdata(0,'myhandles');
set(handles.ThreshodIntensity,'String',num2str(myhandles.cutoff_intensity));
set(handles.blockSize,'String',num2str(myhandles.block_size));
SetButtonState(hObject,handles,true);
guidata(hObject, handles); 




    

    
    
function AutoThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to SelectDirectory (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
% if(~myhandles.is_directory_usable)
%     warndlg('Change Root Directory');
%     return;
% end
%SetButtonState(hObject,handles,false);
cutoff_intensity=str2double(get(handles.ThreshodIntensity,'String'));
files_per_image=myhandles.files_per_image;
number_of_channels=myhandles.number_of_channels;
%imageDirectory=get(handles.ImageRootDirectory,'String');
number_of_test_files=10;


% if(strcmp(imageDirectory(length(imageDirectory):end),filesep))
%     imageDirectory=imageDirectory(1:length(imageDirectory)-1);
% end
% dir_list=dir(imageDirectory);
% subdirs={dir_list([(dir_list(:).isdir)]).name};
% subdirs=subdirs(3:end);

thresholds=zeros(number_of_test_files,1);
set(myhandles.statusbarHandles.ProgressBar, 'Visible','on', 'Minimum',0, 'Maximum',number_of_test_files, 'Value',0);
myhandles.statusbarHandles=statusbar(hObject,'Calculating Best Threshold ...');
for test_num=1:number_of_test_files
 
    condition=randi(myhandles.number_of_conditions);
    imagenames=myhandles.grouped_metadata{condition}.files_in_group;
    
    file_num=randi(size(imagenames,1));
    
    filename=imagenames{1};
    test=imfinfo(filename);
    xres=test.Height;
    yres=test.Width;
    img=zeros(xres,yres,number_of_channels);
    
    
    channel_thresholds=zeros(number_of_channels,1);
    if(number_of_channels==files_per_image)
        for channel=1:number_of_channels
            filename=imagenames{file_num,channel};
            img(:,:,channel)=imread(filename);
        end
    else
        filename=imagenames{file_num,1};
        img=imread(filename);
    end

    for channel=1:number_of_channels
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
   set(myhandles.statusbarHandles.ProgressBar, 'Value',test_num);
end
myhandles.statusbarHandles=statusbar(hObject,'');
set(myhandles.statusbarHandles.ProgressBar, 'Visible','off');
set(handles.ThreshodIntensity,'String',num2str(round(min(thresholds))));
SetButtonState(hObject,handles,true);
guidata(hObject, handles);
setappdata(0,'myhandles',myhandles);


function ShowAdvanced_Callback(hObject, eventdata, handles)
if(get(hObject,'Value'))
    set(handles.AdvancedOptions,'Visible','on');
    set(handles.text4,'Visible','on');
    set(handles.text6,'Visible','on');
    set(handles.text7,'Visible','on');
    %set(handles.text8,'Visible','on');
    set(handles.ReduceColorNr,'Visible','on');
    set(handles.BlockTypeNr,'Visible','on');
    set(handles.SuperBlockNr,'Visible','on');
    %set(handles.ChannelNr,'Visible','on');
else
    set(handles.AdvancedOptions,'Visible','off');
    set(handles.text4,'Visible','off');
    set(handles.text6,'Visible','off');
    set(handles.text7,'Visible','off');
    %set(handles.text8,'Visible','off');
    set(handles.ReduceColorNr,'Visible','off');
    set(handles.BlockTypeNr,'Visible','off');
    set(handles.SuperBlockNr,'Visible','off');
    %set(handles.ChannelNr,'Visible','off');
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
    set(handles.AutoThreshold,'Enable','on');
    set(handles.SelectDirectory,'Enable','on');
else
    set(handles.RunBtn,'Enable','off');
    set(handles.TestThreshold,'Enable','off');
    set(handles.AutoThreshold,'Enable','off');
    set(handles.SelectDirectory,'Enable','off');
end
drawnow;
guidata(hObject, handles); 


% --- Executes on button press in ExplorerButton.
function ExplorerButton_Callback(hObject, eventdata, handles)
% hObject    handle to ExplorerButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
Explainer;
MakePlots(hObject,eventdata,handles);
myhandles=getappdata(0,'myhandles');
CoolClustergram(myhandles.superblock_profiles,...
     myhandles.global_data.superblock_representatives,myhandles.mds_text);
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
filename=uiputfile;
setappdata(gcf,'myhandles', myhandles);
hgsave(gcf,filename);



% --- Executes on button press in LoadResultsButton.
function LoadResultsButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadResultsButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%uirestore;
%guidata(hObject, handles);
[filename,pathname]=uigetfile;
h=gcf;
delete(h);
hgload([pathname filesep filename]);
myhandles = getappdata(gcf,'myhandles');
% Lines below are added since loading the file does not initialize the
% status bar (it is a java hack, not officially supported by matlab)
myhandles.statusbarHandles=statusbar(gcf,'Welcome to PhenoRipper ...Prepare to be amazed.');
set(myhandles.statusbarHandles.TextPanel, 'Foreground',[1,1,1], 'Background','black', 'ToolTipText','Loading...')
set(myhandles.statusbarHandles.ProgressBar, 'Background','white', 'Foreground',[0.4,0,0]);
setappdata(0,'myhandles',myhandles);


% old_handles=handles;
% old_hObject=hObject;
% uiopen('LOAD');
% LoadParameters(handles,old_handles,old_hObject);
%guidata(hObject, handles);
%setappdata(0,'myhandles',myhandles);

function MakePlots(hObject,eventdata,handles)
myhandles=getappdata(0,'myhandles');

label_field=myhandles.grouping_fields{get(handles.PointLabel_popupmenu,'Value')};
color_field=myhandles.grouping_fields{get(handles.PointColor_popupmenu,'Value')};


% if (get(handles.OutputMDS,'Value') == get(handles.displayByColumn,'Max'))
%     outputType=1;
% elseif (get(handles.OutputHeatMap,'Value') == get(handles.displayByRow,'Max'))
%     outputType=2;
% else
%     outputType=3;
% end

group_vals=cell(1,myhandles.number_of_conditions);
for condition=1:myhandles.number_of_conditions
   group_vals{condition}=cell2mat(myhandles.grouped_metadata{condition}.(color_field)); 
end

myhandles.mds_text=cell(size(myhandles.superblock_profiles,1),1);
myhandles.mds_colors=zeros(size(myhandles.superblock_profiles,1),3);       
[colorsGroup,GN]=grp2idx(group_vals);
colors=colormap(jet(max(colorsGroup)));
dists=pdist(myhandles.superblock_profiles);
profile_mds=mdscale(dists,3);
figure;
scatter3(profile_mds(:,1),profile_mds(:,2),profile_mds(:,3),10);
for i=1:myhandles.number_of_conditions
    text(profile_mds(i,1),profile_mds(i,2),profile_mds(i,3),...
        myhandles.grouped_metadata{i}.(label_field),...
        'BackgroundColor',colors(colorsGroup(i),:));%not always cn
    myhandles.mds_text{i}=myhandles.grouped_metadata{i}.(label_field);
    myhandles.mds_colors(i,:)=colors(colorsGroup(i),:);
end
setappdata(0,'myhandles',myhandles);
% 
% 
% well_names={Ripped_Data(:).well};
% switch(outputType)
%     case 1
%         
%         
%         dists=pdist(myhandles.superblock_profiles);
%         profile_mds=mdscale(dists,3);
%         colors=colormap(jet(max(colorsGroup)));
%         figure;
%         scatter3(profile_mds(:,1),profile_mds(:,2),profile_mds(:,3),10);
%         for i=1:length(Ripped_Data)
%             text(profile_mds(i,1),profile_mds(i,2),profile_mds(i,3),Ripped_Data(i).well,...
%                 'BackgroundColor',colors(colorsGroup(i),:));%not always cn
%             myhandles.mds_text{i}=Ripped_Data(i).well;
%             myhandles.mds_colors(i,:)=colors(colorsGroup(i),:);
%         end
%     case 2
%         clustergram(myhandles.superblock_profiles,'RowLabels',well_names);
%         
%     case 3
%         
%         
%         
%         dists=pdist(myhandles.superblock_profiles);
%         profile_mds=mdscale(dists,3);
%         colors=colormap(jet(max(colorsGroup)));
%         figure;
%         scatter3(profile_mds(:,1),profile_mds(:,2),profile_mds(:,3),10);
%         for i=1:length(Ripped_Data)
%             text(profile_mds(i,1),profile_mds(i,2),profile_mds(i,3),Ripped_Data(i).well,...
%                 'BackgroundColor',colors(colorsGroup(i),:));%not always cn
%            
%         end
%         %clustergram(myhandles.superblock_profiles,'RowLabels',well_names);
% end



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
