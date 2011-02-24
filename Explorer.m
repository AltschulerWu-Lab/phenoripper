function varargout = Explorer(varargin)
% EXPLORER M-file for Explorer.fig
%      EXPLORER, by itself, creates a new EXPLORER or raises the existing
%      singleton*.
%
%      H = EXPLORER returns the handle to a new EXPLORER or the handle to
%      the existing singleton*.
%
%      EXPLORER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPLORER.M with the given input arguments.
%
%      EXPLORER('Property','Value',...) creates a new EXPLORER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Explorer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Explorer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Explorer

% Last Modified by GUIDE v2.5 30-Jan-2011 17:31:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Explorer_OpeningFcn, ...
                   'gui_OutputFcn',  @Explorer_OutputFcn, ...
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


% --- Executes just before Explorer is made visible.
function Explorer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Explorer (see VARARGIN)

% Choose default command line output for Explorer
myhandles=getappdata(0,'myhandles');
myhandles.MDSPlot_handle=handles.MDSPlot;
if(size(myhandles.mds_data,2)==2)
    scatter(handles.MDSPlot,myhandles.mds_data(:,1),myhandles.mds_data(:,2),5,'filled');
    for i=1:size(myhandles.mds_data,1)
        text(myhandles.mds_data(i,1),myhandles.mds_data(i,2),myhandles.mds_text{i},...
            'BackgroundColor',myhandles.mds_colors(i,:),'FontSize',16,...
            'parent',myhandles.MDSPlot_handle);%not always cn
        
    end
else
    
    
  
    
    scatter3(myhandles.mds_data(:,1),myhandles.mds_data(:,2),myhandles.mds_data(:,3),5,'parent',myhandles.MDSPlot_handle);
    
    for i=1:size(myhandles.mds_data,1)
        text(myhandles.mds_data(i,1),myhandles.mds_data(i,2),myhandles.mds_data(i,3),myhandles.mds_text{i},...
            'BackgroundColor',myhandles.mds_colors(i,:),'parent',myhandles.MDSPlot_handle,...
            'FontSize',16);%not always cn
    end
   set(gca,...
'XTickLabel','');
set(gca,...
'YTickLabel','');
set(gca,...
'ZTickLabel','');
   %zoom  on;
   %dragzoom on;
   %h=zoom;
   %setAllowAxesZoom(h,gca,true);
      myhandles.camPos = get(handles.MDSPlot, 'CameraPosition'); % camera position
    myhandles.camTgt = get(handles.MDSPlot, 'CameraTarget'); % where the camera is pointing to
    
    myhandles.camUpVect = get(handles.MDSPlot, 'CameraUpVector'); % camera 'up' vector
    myhandles.camViewAngle = get(handles.MDSPlot, 'CameraViewAngle');
    
   %  set(handles.MDSPlot, 'CameraViewAngle',myhandles.camViewAngle);
     set(handles.MDSPlot, 'CameraPosition',myhandles.camPos);
     set(handles.MDSPlot, 'CameraTarget',myhandles.camTgt);
     set(handles.MDSPlot, 'CameraUpVector',myhandles.camUpVect);

%     
    
    rotate3d off;
    myhandles.mds_rotatable=0;
    
end

set(gca,'GridLineStyle','-')
grid on;
%set(gca,'ButtonDownFcn', @MDSPlot_ButtonDownFcn);
set(gcf,'WindowButtonDownFcn',{@MDSPlot_ButtonDownFcn,handles});
myhandles.MDS_gca=gca;
myhandles.MDS_gcf=gcf;
myhandles.axes2_handle=handles.axes2;
myhandles.axes3_handle=handles.axes3;
myhandles.axes_chosen=handles.axes2;


%rotate3d off;

%set(handles.MDSPlot, 'CameraPositionMode','manual');
%set(handles.MDSPlot, 'CameraTargetMode','manual');
%set(handles.MDSPlot, 'CameraUpVectorMode','manual');
%set(handles.MDSPlot, 'CameraViewAngleMode','manual');

    


% for i=1:size(myhandles.mds_data,1)
%    %text 
% end

handles.output = hObject;
setappdata(0,'myhandles',myhandles);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Explorer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Explorer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




% --- Executes on mouse press over axes background.
function MDSPlot_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to MDSPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
CP=get(myhandles.MDS_gca,'CurrentPoint');

number_of_points=size(myhandles.mds_data,1);
% sizes=50*ones(number_of_points,1);
% sizes(point_number)=200;
% scatter(myhandles.mds_data(:,1),myhandles.mds_data(:,2),sizes,'filled','parent',myhandles.MDSPlot_handle);
if(size(myhandles.mds_data,2)==2)
    dists=pdist2(myhandles.mds_data,CP(1,1:size(myhandles.mds_data,2)));
    [~,point_number]=min(dists);
    disp(num2str(point_number));
    
    scatter(myhandles.mds_data(:,1),myhandles.mds_data(:,2),5,'parent',myhandles.MDSPlot_handle);
    sizes=16*ones(number_of_points,1);
    sizes(point_number)=24;
    for i=1:size(myhandles.mds_data,1)
        text(myhandles.mds_data(i,1),myhandles.mds_data(i,2),myhandles.mds_text{i},...
            'BackgroundColor',myhandles.mds_colors(i,:),'parent',myhandles.MDSPlot_handle,...
            'FontSize',sizes(i));%not always cn
        
    end
else
    
    if(~myhandles.mds_rotatable)
        
    
        
        rotate3d off;
        point = get(gca, 'CurrentPoint'); % mouse click position
        camPos = get(gca, 'CameraPosition'); % camera position
        camTgt = get(gca, 'CameraTarget'); % where the camera is pointing to
        camViewAngle = get(gca, 'CameraViewAngle');
        camDir = camPos - camTgt; % camera direction
        camUpVect = get(gca, 'CameraUpVector'); % camera 'up' vector
        
        % build an orthonormal frame based on the viewing direction and the
        % up vector (the "view frame")
        zAxis = camDir/norm(camDir);
        upAxis = camUpVect/norm(camUpVect);
        xAxis = cross(upAxis, zAxis);
        yAxis = cross(zAxis, xAxis);
        
        rot = [xAxis; yAxis; zAxis]; % view rotation
        
        
        % the point cloud represented in the view frame
        rotatedPointCloud = rot * myhandles.mds_data';
        
        % the clicked point represented in the view frame
        rotatedPointFront = rot * point' ;
        
        point_number = dsearchn(rotatedPointCloud(1:2,:)', ...
            rotatedPointFront(1:2));
        %disp(num2str(point_number));
        if(myhandles.axes_chosen==handles.axes2)
           set(handles.Point1Info,'String',['Point Chosen=' myhandles.mds_text{point_number} ]); 
        else
           set(handles.Point2Info,'String',['Point Chosen=' myhandles.mds_text{point_number}]);  
        end
        
        
        scatter3(myhandles.mds_data(:,1),myhandles.mds_data(:,2),myhandles.mds_data(:,3),5,'parent',myhandles.MDSPlot_handle);
       
        sizes=16*ones(number_of_points,1);
        sizes(point_number)=24;
        for i=1:size(myhandles.mds_data,1)
            text(myhandles.mds_data(i,1),myhandles.mds_data(i,2),myhandles.mds_data(i,3),myhandles.mds_text{i},...
                'BackgroundColor',myhandles.mds_colors(i,:),'parent',myhandles.MDSPlot_handle,...
                'FontSize',sizes(i));%not always cn
        end
        set(gca,'XTickLabel','','YTickLabel','','ZTickLabel','');
         set(gca, 'CameraPosition',camPos);
        set(gca, 'CameraTarget',camTgt);
        set(gca, 'CameraUpVector',camUpVect);
        %set(gca, 'CameraViewAngle',camViewAngle);
    else
        rotate3d on;
    end
    
end
myhandles.MDS_gca=gca;
myhandles.MDS_gcf=gcf;
myhandles.selected_point=point_number;
ShowImages(myhandles.grouped_metadata{point_number}.files_in_group,myhandles.axes_chosen);
setappdata(0,'myhandles',myhandles);

function ShowImages(filenames,axis_handle)
myhandles=getappdata(0,'myhandles');
axis(axis_handle);
file_number=1;
test=imfinfo(filenames{1,1});
xres=test.Height;
yres=test.Width;
img=zeros(xres,yres,myhandles.number_of_channels);
if(myhandles.files_per_image~=myhandles.number_of_channels)
    img=imread(filenames{file_number,1});
else
    for channel=1:myhandles.number_of_channels
        img(:,:,channel)=imread(filenames{file_number,channel});
    end
end
image(img./max(img(:)),'parent',axis_handle);
box on;


% --- Executes on button press in PointSelected2.
function PointSelected2_Callback(hObject, eventdata, handles)
% hObject    handle to PointSelected2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
myhandles.axes_chosen=myhandles.axes2_handle;
setappdata(0,'myhandles',myhandles);

% Hint: get(hObject,'Value') returns toggle state of PointSelected2


% --- Executes on button press in PointSelected1.
function PointSelected1_Callback(hObject, eventdata, handles)
% hObject    handle to PointSelected1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
myhandles.axes_chosen=myhandles.axes1_handle;
setappdata(0,'myhandles',myhandles);


% Hint: get(hObject,'Value') returns toggle state of PointSelected1


% --- Executes when selected object is changed in uipanel1.
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel1 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
if(eventdata.NewValue==handles.PointSelected1)
    myhandles.axes_chosen=myhandles.axes2_handle;
else
    myhandles.axes_chosen=myhandles.axes3_handle;
end
setappdata(0,'myhandles',myhandles);


% --- Executes on button press in MDS_Rotatable.
function MDS_Rotatable_Callback(hObject, eventdata, handles)
% hObject    handle to MDS_Rotatable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
myhandles.mds_rotatable= get(hObject,'Value');
if(get(hObject,'Value'))
    rotate3d on;
    
else
    myhandles.camPos = get(handles.MDSPlot, 'CameraPosition'); % camera position
    myhandles.camTgt = get(handles.MDSPlot, 'CameraTarget'); % where the camera is pointing to
    
    myhandles.camUpVect = get(handles.MDSPlot, 'CameraUpVector'); % camera 'up' vector
    myhandles.camViewAngle = get(handles.MDSPlot, 'CameraViewAngle');
   
    rotate3d off;
    
    %set(handles.MDSPlot, 'CameraPositionMode','manual');
    %set(handles.MDSPlot, 'CameraTargetMode','manual');
    %set(handles.MDSPlot, 'CameraUpVectorMode','manual');
    %set(handles.MDSPlot, 'CameraViewAngleMode','manual');
    
    set(handles.MDSPlot, 'CameraPosition',myhandles.camPos);
    set(handles.MDSPlot, 'CameraTarget',myhandles.camTgt);
    set(handles.MDSPlot, 'CameraUpVector',myhandles.camUpVect);
    
  %  set(handles.MDSPlot, 'CameraViewAngle',myhandles.camViewAngle);
end
setappdata(0,'myhandles',myhandles);
% Hint: get(hObject,'Value') returns toggle state of MDS_Rotatable
