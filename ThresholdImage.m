function varargout = ThresholdImage(varargin)
% THRESHOLDIMAGE M-file for ThresholdImage.fig
%      THRESHOLDIMAGE, by itself, creates a new THRESHOLDIMAGE or raises the existing
%      singleton*.
%
%      H = THRESHOLDIMAGE returns the handle to a new THRESHOLDIMAGE or the handle to
%      the existing singleton*.
%
%      THRESHOLDIMAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in THRESHOLDIMAGE.M with the given input arguments.
%
%      THRESHOLDIMAGE('Property','Value',...) creates a new THRESHOLDIMAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ThresholdImage_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ThresholdImage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ThresholdImage

% Last Modified by GUIDE v2.5 02-Mar-2012 13:33:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ThresholdImage_OpeningFcn, ...
                   'gui_OutputFcn',  @ThresholdImage_OutputFcn, ...
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


% --- Executes just before ThresholdImage is made visible.
function ThresholdImage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ThresholdImage (see VARARGIN)
myhandles=getappdata(0,'myhandles');
%TODO modify it
%myhandles.bit_depth=14;
myhandles.show_blocks=false;
number_of_channels=myhandles.number_of_channels;
files_per_image=myhandles.files_per_image;
filenames=myhandles.test_files;
myhandles.image_number=1;
test=imfinfo(filenames{myhandles.image_number,1});
xres=test.Height;
yres=test.Width;
myhandles.xres=xres;
myhandles.yres=yres;
img=zeros(xres,yres,number_of_channels);
if(isnan(myhandles.block_size))
   myhandles.block_size=10; 
end
SetFileLabel(filenames{myhandles.image_number,1},handles);

% intModel = javax.swing.SpinnerNumberModel(myhandles.block_size, 2, 50, 1);
% jhSpinner = addLabeledSpinner('', intModel, [20,20,60,20], {@blockSizeChangedCallback,handles},hObject);
% jEditor = javaObject('javax.swing.JSpinner$NumberEditor',jhSpinner, '#');
% jhSpinner.setEditor(jEditor);


if(number_of_channels~=files_per_image)
  img=imread2(filenames{myhandles.image_number,1});
else
  for channel=1:myhandles.number_of_channels
    %USE IMREAD FOR SINGLE CHANNEL ALWAYS
    img(:,:,channel)=imread(filenames{myhandles.image_number,channel});
  end
end
myhandles.intensity=CalculateIntensity(img,myhandles.marker_scales);
myhandles.h=gca;
myhandles.img=img;
myhandles.img1=tanh(double(img)/2^myhandles.bit_depth*10);

setappdata(0,'myhandles',myhandles);

display_image(handles);
% intensity=sum(img.^2,3);
% cutoff_intensity=myhandles.cutoff_intensity;
% mask=intensity>cutoff_intensity;
% img1=tanh(img/2^14*10);
% for channel=1:3
%   img1(:,:,channel)=min(img1(:,:,channel)+ 0.25*(~mask),1);
%  
% end
% image(img1);
% if(get(handles.show_block_grid_checkbox,'Value'))
% set(gca,'XTick',[0:myhandles.block_size:myhandles.yres])
% set(gca,'XTickLabel',[])
% set(gca,'YTick',[0:myhandles.block_size:myhandles.xres])
% set(gca,'YTickLabel',[])
% set(gca,'GridLineStyle','-')
% grid on;
% else
%     grid off;
% end


setappdata(0,'myhandles',myhandles);

hListener=handle.listener(handles.slider1,'ActionEvent',@update_threshold);
setappdata(handles.slider1,'myListener',hListener);


% Choose default command line output for ThresholdImage
handles.output = hObject;
set(handles.slider1,'Value',myhandles.cutoff_intensity/myhandles.amplitude_range);
set(handles.PreviousButton,'Enable','off');
if(myhandles.image_number==size(myhandles.test_files,1))
    set(handles.NextButton,'Enable','off');
end
%Set default or previous set values
set(handles.ThresholdLevel,'String',num2str(myhandles.cutoff_intensity));
set(handles.blockSize,'String',num2str(myhandles.block_size));
set(handles.ThresholdLevel,'String',num2str(myhandles.cutoff_intensity));
set(handles.ReduceColorNr,'String',num2str(myhandles.number_of_RGB_clusters));
set(handles.BlockTypeNr,'String',num2str(myhandles.number_of_block_clusters));
set(handles.SuperBlockNr,'String',num2str(myhandles.number_of_superblocks));
set(handles.MinImageTraining,'String',num2str(min(myhandles.minimum_training_files),length(myhandles.metadata)));
set(handles.MaxImageTraining,'String',num2str(myhandles.maximum_training_files));
set(handles.useBackgroundInfoCB,'Value',myhandles.include_background_superblocks);

% myhandles.block_size = str2double(get(handles.blockSize,'String'));
% myhandles.cutoff_intensity=str2double(get(handles.ThresholdLevel,'String'));
% myhandles.number_of_RGB_clusters=str2double(get(handles.ReduceColorNr,'String'));
% myhandles.number_of_block_clusters=str2double(get(handles.BlockTypeNr,'String'));
% myhandles.number_of_superblocks=str2double(get(handles.SuperBlockNr,'String'));
% myhandles.minimum_training_files=min(str2double(get(handles.MinImageTraining,'String')),length(myhandles.metadata));
% myhandles.maximum_training_files=str2double(get(handles.MaxImageTraining,'String'));
% myhandles.include_background_superblocks=get(handles.useBackgroundInfoCB,'value');

















% Update handles structure

%units=get(gca,'Units');
%set(gca,'Units',units);
axlim = axis(gca); 
axwidth = diff(axlim(1:2));
axheight = diff(axlim(3:4));

text(axwidth/2,axheight/2,'\color{white}Greyed Out Portions are Background And Won''t be Analyzed',...
    'FontSize',20,'parent',myhandles.h, 'HorizontalAlignment', 'center');
%set(gca,'Units',units);
guidata(hObject, handles);

% UIWAIT makes ThresholdImage wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% function jhSpinner = addLabeledSpinner(label,model,pos,callbackFunc,hFig)
%     % Set the spinner control
%     jSpinner = com.mathworks.mwswing.MJSpinner(model);
%     %jTextField = jSpinner.getEditor.getTextField;
%     %jTextField.setHorizontalAlignment(jTextField.RIGHT);  % unneeded
%     jhSpinner = javacomponent(jSpinner,pos,hFig);
%     jhSpinner.setToolTipText('<html>This spinner is editable, but only the<br/>preconfigured values can be entered')
%     set(jhSpinner,'StateChangedCallback',callbackFunc);
% 
%     % Set the attached label
%     %jLabel = com.mathworks.mwswing.MJLabel(label);
%     %jLabel.setLabelFor(jhSpinner);
%     color = get(hFig,'Color');
%    colorStr = mat2cell(color,1,[1,1,1]);
%    jColor = java.awt.Color(colorStr{:});
% %     jLabel.setBackground(jColor);
% %     if jLabel.getDisplayedMnemonic > 0
% %         hotkey = char(jLabel.getDisplayedMnemonic);
% %         jLabel.setToolTipText(['<html>Press <b><font color="blue">Alt-' hotkey '</font></b> to focus on<br/>adjacent spinner control']);
% %     end
%     pos = [20,pos(2),pos(1)-20,pos(4)];
% %     jhLabel = javacomponent(jLabel,pos,hFig);
%   % addLabeledSpinner

% function blockSizeChangedCallback(jSpinner,jEventData,handles)
%    persistent inCallback
%    inCallback = 1;  %#ok used
%    blockSize = jSpinner.getValue;
%    myhandles=getappdata(0,'myhandles');
%    myhandles.block_size=blockSize;
%    setappdata(0,'myhandles',myhandles);
%    display_image(handles);
%    setappdata(0,'myhandles',myhandles);
%    inCallback = [];

% --- Outputs from this function are returned to the command line.
function varargout = ThresholdImage_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function update_threshold(hObject, eventdata, handles)
handles=guidata(hObject);
myhandles=getappdata(0,'myhandles');
slidval=get(handles.slider1,'Value');
cutoff_intensity=round(myhandles.amplitude_range*slidval);
set(handles.ThresholdLevel,'String',num2str(cutoff_intensity));
% handles=guidata(hObject);
% myhandles=getappdata(0,'myhandles');
% slidval=get(handles.slider1,'Value');
% myhandles.cutoff_intensity=round(myhandles.amplitude_range*slidval);
% setappdata(0,'myhandles',myhandles);
% set(handles.ThresholdLevel,'String',num2str(myhandles.cutoff_intensity));
% display_image(handles);
guidata(hObject, handles);
% ThresholdLevel_Callback(hObject, eventdata, handles);
changeThreshold(handles);

function changeThreshold(handles)
myhandles=getappdata(0,'myhandles');
% slidval=get(handles.ThresholdLevel,'Value');
% myhandles.cutoff_intensity=round(myhandles.amplitude_range*slidval);
myhandles.cutoff_intensity=str2double(get(handles.ThresholdLevel,'String'));
setappdata(0,'myhandles',myhandles);
%set(handles.ThresholdLevel,'String',num2str(myhandles.cutoff_intensity));
display_image(handles);
% guidata(hObject, handles);
setappdata(0,'myhandles',myhandles);



% --- Executes on button press in PreviousButton.
function PreviousButton_Callback(hObject, eventdata, handles)
% hObject    handle to PreviousButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
filenames=myhandles.test_files;
myhandles.image_number=myhandles.image_number-1;
if(myhandles.image_number==1)
    set(handles.PreviousButton,'Enable','off');
end
set(handles.NextButton,'Enable','on');
%set(handles.fileName,'String',filenames{myhandles.image_number,1});
SetFileLabel(filenames{myhandles.image_number,1},handles);
guidata(hObject, handles);
img=zeros(myhandles.xres,myhandles.yres,myhandles.number_of_channels);
if(myhandles.number_of_channels~=myhandles.files_per_image)
  img=imread2(filenames{myhandles.image_number,1});
else
  for channel=1:myhandles.number_of_channels
    %USE IMREAD FOR SINGLE CHANNEL ALWAYS
    img(:,:,channel)=imread(filenames{myhandles.image_number,channel});
  end
end
myhandles.img=img;
myhandles.intensity=CalculateIntensity(img,myhandles.marker_scales);
myhandles.img1=tanh(double(img)/2^myhandles.bit_depth*10);
setappdata(0,'myhandles',myhandles);
display_image(handles);
%This could be displaying something different from the real thing
% 
% intensity=sum(img.^2,3);
% cutoff_intensity=myhandles.cutoff_intensity;
% mask=intensity>cutoff_intensity;
% img1=tanh(img/2^14*10);
% for channel=1:myhandles.number_of_channels
%   img1(:,:,channel)=min(img1(:,:,channel)+ 0.25*(~mask),1);
%  
% end
% axis(myhandles.h);
% image(img1,'parent',myhandles.h);
% if(get(handles.show_block_grid_checkbox,'Value'))
% set(gca,'XTick',[0:myhandles.block_size:yres])
% set(gca,'XTickLabel',[])
% set(gca,'YTick',[0:myhandles.block_size:xres])
% set(gca,'YTickLabel',[])
% set(gca,'GridLineStyle','-')
% grid on;
% else
%     grid off;
% end
% myhandles.img=img;
% 
% setappdata(0,'myhandles',myhandles);


% --- Executes on button press in NextButton.
function NextButton_Callback(hObject, eventdata, handles)
% hObject    handle to NextButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
filenames=myhandles.test_files;
myhandles.image_number=myhandles.image_number+1;
if(myhandles.image_number==size(myhandles.test_files,1))
    set(handles.NextButton,'Enable','off');
end
set(handles.PreviousButton,'Enable','on');
%set(handles.fileName,'String',filenames{myhandles.image_number,1});
SetFileLabel(filenames{myhandles.image_number,1},handles);
guidata(hObject, handles);
img=zeros(myhandles.xres,myhandles.yres,myhandles.number_of_channels);
if(myhandles.number_of_channels~=myhandles.files_per_image)
  img=imread2(filenames{myhandles.image_number,1});
else
  for channel=1:myhandles.number_of_channels
    %USE IMREAD FOR SINGLE CHANNEL ALWAYS
    img(:,:,channel)=imread(filenames{myhandles.image_number,channel});
  end
end
myhandles.img=img;
myhandles.intensity=CalculateIntensity(img,myhandles.marker_scales);
%myhandles.img1=tanh(double(img)/2^myhandles.bit_depth*10);
setappdata(0,'myhandles',myhandles);
display_image(handles);


% --- Executes on button press in AcceptButton.
function AcceptButton_Callback(hObject, eventdata, handles)
% hObject    handle to AcceptButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
slidval=get(handles.slider1,'Value');
cutoff_intensity=myhandles.amplitude_range*slidval;
myhandles.cutoff_intensity=cutoff_intensity;



myhandles.block_size = str2double(get(handles.blockSize,'String'));
myhandles.cutoff_intensity=str2double(get(handles.ThresholdLevel,'String'));
myhandles.number_of_RGB_clusters=str2double(get(handles.ReduceColorNr,'String'));
myhandles.number_of_block_clusters=str2double(get(handles.BlockTypeNr,'String'));
myhandles.number_of_superblocks=str2double(get(handles.SuperBlockNr,'String'));
myhandles.minimum_training_files=min(str2double(get(handles.MinImageTraining,'String')),length(myhandles.metadata));
myhandles.maximum_training_files=str2double(get(handles.MaxImageTraining,'String'));
myhandles.include_background_superblocks=get(handles.useBackgroundInfoCB,'value');







setappdata(0,'myhandles',myhandles);
delete(gcf);


% --- Executes on button press in show_block_grid_checkbox.
function show_block_grid_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to show_block_grid_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of show_block_grid_checkbox
myhandles=getappdata(0,'myhandles');
myhandles.show_blocks=~myhandles.show_blocks;
setappdata(0,'myhandles',myhandles);
display_image(handles);
setappdata(0,'myhandles',myhandles);


function display_image(handles)
myhandles=getappdata(0,'myhandles');

xres=myhandles.xres;
yres=myhandles.yres;
img=myhandles.img;
intensity=myhandles.intensity;
cutoff_intensity=myhandles.cutoff_intensity;
mask=intensity>cutoff_intensity;
if(get(handles.show_mask_checkbox,'Value'))
    Display_Image(img,myhandles.h,myhandles.marker_scales,myhandles.display_colors,mask);
else
    Display_Image(img,myhandles.h,myhandles.marker_scales,myhandles.display_colors,[]);
end
axis(myhandles.h,'image');
if(get(handles.show_block_grid_checkbox,'Value'));
    set(myhandles.h,'XTick',[0:myhandles.block_size:yres]);
    set(myhandles.h,'XTickLabel',[]);
    set(myhandles.h,'YTick',[0:myhandles.block_size:xres]);
    set(myhandles.h,'YTickLabel',[]);
    set(myhandles.h,'GridLineStyle','-');
    set(myhandles.h,'XGrid','on','XColor',[0.7 0.7 0.7]);
    set(myhandles.h,'YGrid','on','YColor',[0.7 0.7 0.7]);    
else
    axis off
    set(myhandles.h,'XTickLabel',[]);
    set(myhandles.h,'YTickLabel',[]);
    set(myhandles.h,'XGrid','off');
    set(myhandles.h,'YGrid','off');
    set(myhandles.h,'LineWidth',1);
end


function SetFileLabel(filename,handles)
length_limit=100;
if(length(filename)<length_limit+3)
    set(handles.fileName,'String',filename);
else
    filelabel=['...' filename(length(filename)-length_limit:end)];
    set(handles.fileName,'String',filelabel);
end


% --- Executes on button press in Intensity_Scale_Button.
function Intensity_Scale_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Intensity_Scale_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
img=myhandles.img;
intensity=myhandles.intensity;
cutoff_intensity=myhandles.cutoff_intensity;
mask=intensity>cutoff_intensity;
set(handles.show_mask_checkbox,'Value',0.0);
Scale_Intensities(myhandles.h,[]);
uiwait;
myhandles=getappdata(0,'myhandles');
display_image(handles);     
setappdata(0,'myhandles',myhandles);


% --- Executes on button press in show_mask_checkbox.
function show_mask_checkbox_Callback(hObject, eventdata, handles)
% hObject    handle to show_mask_checkbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of show_mask_checkbox
display_image(handles);

function intensity=CalculateIntensity(img,marker_scales)
img=double(img);
  number_of_channels=size(img,3);
  for channel=1:number_of_channels
   img(:,:,channel)=min(max(img(:,:,channel)-marker_scales(channel,1),0)/...
       (marker_scales(channel,2)-marker_scales(channel,1)),1)*100; 
  end
  intensity=sqrt(sum(img.^2,3)/number_of_channels);


% --- Executes on button press in ShowAdvanced.
function ShowAdvanced_Callback(hObject, eventdata, handles)
% hObject    handle to ShowAdvanced (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ShowAdvanced
isChecked=get(hObject,'Value');
if(isChecked)
  isVisible='on';
else
  isVisible='off';
end
set(handles.advancedPanel,'Visible',isVisible);


function ThresholdLevel_Callback(hObject, eventdata, handles)
% hObject    handle to ThresholdLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
ThresholdLevel = get(hObject,'String');
ThresholdLevel=str2double(ThresholdLevel);
set(handles.slider1,'Value',ThresholdLevel/myhandles.amplitude_range);
changeThreshold(handles);
% update_threshold(handles.slider1, eventdata, handles);
%update_threshold(hObject, eventdata, handles);
% handles=guidata(hObject);
% myhandles=getappdata(0,'myhandles');



% --- Executes during object creation, after setting all properties.
function ThresholdLevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ThresholdLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function blockSize_Callback(hObject, eventdata, handles)
% hObject    handle to blockSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
blockSize = get(hObject,'String');
blockSize=str2double(blockSize);
myhandles=getappdata(0,'myhandles');
myhandles.block_size=blockSize;
setappdata(0,'myhandles',myhandles);
display_image(handles);
setappdata(0,'myhandles',myhandles);



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


% --- Executes on button press in useBackgroundInfoCB.
function useBackgroundInfoCB_Callback(hObject, eventdata, handles)
% hObject    handle to useBackgroundInfoCB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of useBackgroundInfoCB


% --- Executes on button press in checkbox5.
function checkbox5_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox5



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
