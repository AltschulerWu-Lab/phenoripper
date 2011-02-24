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

% Last Modified by GUIDE v2.5 25-Jan-2011 18:21:07

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

intModel = javax.swing.SpinnerNumberModel(myhandles.block_size, 2, 50, 1);
jhSpinner = addLabeledSpinner('', intModel, [20,20,60,20], @blockSizeChangedCallback,hObject);
jEditor = javaObject('javax.swing.JSpinner$NumberEditor',jhSpinner, '#');
jhSpinner.setEditor(jEditor);


if(number_of_channels~=files_per_image)
img=imread(filenames{myhandles.image_number,1});

else
      for channel=1:myhandles.number_of_channels
          img(:,:,channel)=imread(filenames{myhandles.image_number,channel});
      end
end
myhandles.intensity=sum(img.^2,3);
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
% if(get(handles.checkbox1,'Value'))
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
set(handles.ThresholdLevel,'String',['Threshold Intensity:' num2str(myhandles.cutoff_intensity)]);
% Update handles structure

%units=get(gca,'Units');
%set(gca,'Units',units);
axlim = axis(gca); 
axwidth = diff(axlim(1:2));
axheight = diff(axlim(3:4));

text(axwidth/2,axheight/2,'\color{white}Greyed Out Portions are Background And Won''t be Analyzed',...
    'FontSize',20,'parent',myhandles.h,'HorizontalAlignment','center');
%set(gca,'Units',units);
guidata(hObject, handles);

% UIWAIT makes ThresholdImage wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function jhSpinner = addLabeledSpinner(label,model,pos,callbackFunc,hFig)
    % Set the spinner control
    jSpinner = com.mathworks.mwswing.MJSpinner(model);
    %jTextField = jSpinner.getEditor.getTextField;
    %jTextField.setHorizontalAlignment(jTextField.RIGHT);  % unneeded
    jhSpinner = javacomponent(jSpinner,pos,hFig);
    jhSpinner.setToolTipText('<html>This spinner is editable, but only the<br/>preconfigured values can be entered')
    set(jhSpinner,'StateChangedCallback',callbackFunc);

    % Set the attached label
    %jLabel = com.mathworks.mwswing.MJLabel(label);
    %jLabel.setLabelFor(jhSpinner);
    color = get(hFig,'Color');
   colorStr = mat2cell(color,1,[1,1,1]);
   jColor = java.awt.Color(colorStr{:});
%     jLabel.setBackground(jColor);
%     if jLabel.getDisplayedMnemonic > 0
%         hotkey = char(jLabel.getDisplayedMnemonic);
%         jLabel.setToolTipText(['<html>Press <b><font color="blue">Alt-' hotkey '</font></b> to focus on<br/>adjacent spinner control']);
%     end
    pos = [20,pos(2),pos(1)-20,pos(4)];
%     jhLabel = javacomponent(jLabel,pos,hFig);
  % addLabeledSpinner

function blockSizeChangedCallback(jSpinner,jEventData)
   persistent inCallback
%    try
      %if ~isempty(inCallback),  return;  end
      inCallback = 1;  %#ok used
      blockSize = jSpinner.getValue;
      myhandles=getappdata(0,'myhandles');
      myhandles.block_size=blockSize;
      
     
      if(myhandles.show_blocks) 
          
          img=myhandles.img;
          intensity=myhandles.intensity;
          cutoff_intensity=myhandles.cutoff_intensity;
          mask=intensity>cutoff_intensity;
          %img1=tanh(img/2^14*10);
          img1=myhandles.img1;
          for channel=1:myhandles.number_of_channels
              img1(:,:,channel)=min(img1(:,:,channel)+ 0.25*(~mask),1);
              
          end
          
          axis(myhandles.h);
      
          image(img1,'parent',myhandles.h);
          set(gca,'XTick',[0:myhandles.block_size:myhandles.yres])
          set(gca,'XTickLabel',[])
          set(gca,'YTick',[0:myhandles.block_size:myhandles.xres])
          set(gca,'YTickLabel',[])
          set(gca,'GridLineStyle','-')
          grid on;
     
      end
setappdata(0,'myhandles',myhandles);
      
      
      
%    catch
%        a=1; % never mind...
   %end
   inCallback = [];
  % monthChangedCallback

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
myhandles.cutoff_intensity=round(myhandles.amplitude_range*slidval);
setappdata(0,'myhandles',myhandles);
set(handles.ThresholdLevel,'String',['Threshold Intensity:' num2str(myhandles.cutoff_intensity)]);
display_image(handles);
guidata(hObject, handles);
% 
% for channel=1:3
%   img(:,:,channel)=min(img(:,:,channel)+ 0.25*(~mask),1);
%   %img(:,:,channel)=min(img(:,:,channel)+ 0.18*mask,1)
%   %img(:,:,channel)=max(img(:,:,channel)-5000*mask,0);
% end
% axis(myhandles.h);
% image(img,'parent',myhandles.h);
% [xres,yres]=size(img);
% if(get(handles.checkbox1,'Value'))
% set(gca,'XTick',[0:myhandles.block_size:yres])
% set(gca,'XTickLabel',[])
% set(gca,'YTick',[0:myhandles.block_size:xres])
% set(gca,'YTickLabel',[])
% set(gca,'GridLineStyle','-')
% grid on;
% else
%     grid off;
% end
% %image(tanh(img./2^14*5),'parent',myhandles.h);
% %imagesc(intensity>cutoff_intensity,'parent',myhandles.h);
% setappdata(0,'myhandles',myhandles);
% guidata(hObject, handles);


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
img=imread(filenames{myhandles.image_number,1});

else
      for channel=1:myhandles.number_of_channels
          img(:,:,channel)=imread(filenames{myhandles.image_number,channel});
      end
end
myhandles.img=img;
myhandles.intensity=sum(img.^2,3);
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
% if(get(handles.checkbox1,'Value'))
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
img=imread(filenames{myhandles.image_number,1});

else
      for channel=1:myhandles.number_of_channels
          img(:,:,channel)=imread(filenames{myhandles.image_number,channel});
      end
end
myhandles.img=img;
myhandles.intensity=sum(img.^2,3);
myhandles.img1=tanh(double(img)/2^myhandles.bit_depth*10);
setappdata(0,'myhandles',myhandles);
display_image(handles);
% %This could be displaying something different from the real thing
% 
% intensity=sum(img.^2,3);
% cutoff_intensity=myhandles.cutoff_intensity;
% mask=intensity>cutoff_intensity;
% img1=tanh(img/2^14*10);
% for channel=1:myhandles.number_of_channels
%  img1(:,:,channel)=min(img1(:,:,channel)+ 0.25*(~mask),1);
%  
% end
% axis(myhandles.h);
% image(img1,'parent',myhandles.h);
% if(get(handles.checkbox1,'Value'))
% set(gca,'XTick',[0:myhandles.block_size:yres])
% set(gca,'XTickLabel',[])
% set(gca,'YTick',[0:myhandles.block_size:xres])
% set(gca,'YTickLabel',[])
% set(gca,'GridLineStyle','-')
% grid on;
% end
%myhandles.img=img;
%setappdata(0,'myhandles',myhandles);


% --- Executes on button press in AcceptButton.
function AcceptButton_Callback(hObject, eventdata, handles)
% hObject    handle to AcceptButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
slidval=get(handles.slider1,'Value');
cutoff_intensity=myhandles.amplitude_range*slidval;
myhandles.cutoff_intensity=cutoff_intensity;
setappdata(0,'myhandles',myhandles);
delete(gcf);


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
myhandles=getappdata(0,'myhandles');
myhandles.show_blocks=~myhandles.show_blocks;
setappdata(0,'myhandles',myhandles);
display_image(handles);
% filenames=myhandles.test_files;
% test=imfinfo(filenames{myhandles.image_number,1});
% xres=test.Height;
% yres=test.Width;
% img=myhandles.img;
% 
% 
% %This could be displaying something different from the real thing
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
% if(get(handles.checkbox1,'Value'));
% set(gca,'XTick',[0:myhandles.block_size:yres]);
% set(gca,'XTickLabel',[]);
% set(gca,'YTick',[0:myhandles.block_size:xres]);
% set(gca,'YTickLabel',[]);
% set(gca,'GridLineStyle','-');
% grid on;
% else
%     grid off;
% end
% myhandles.img=img;

setappdata(0,'myhandles',myhandles);


function display_image(handles)
myhandles=getappdata(0,'myhandles');

xres=myhandles.xres;
yres=myhandles.yres;
img=myhandles.img;
intensity=myhandles.intensity;
cutoff_intensity=myhandles.cutoff_intensity;
mask=intensity>cutoff_intensity;
img1=myhandles.img1;
%img1=tanh(img/2^myhandles.bit_depth*10);
for channel=1:myhandles.number_of_channels
  img1(:,:,channel)=min(img1(:,:,channel)+ 0.25*(~mask),1);
end
axis(myhandles.h);
image(img1,'parent',myhandles.h);
if(get(handles.checkbox1,'Value'));
    set(gca,'XTick',[0:myhandles.block_size:yres]);
    set(gca,'XTickLabel',[]);
    set(gca,'YTick',[0:myhandles.block_size:xres]);
    set(gca,'YTickLabel',[]);
    set(gca,'GridLineStyle','-');
    grid on;
else
    grid off;
end


function SetFileLabel(filename,handles)
length_limit=60;
if(length(filename)<length_limit+3)
    set(handles.fileName,'String',filename);
else
    filelabel=['...' filename(length(filename)-length_limit:end)];
    set(handles.fileName,'String',filelabel);
end
