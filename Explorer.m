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

% Last Modified by GUIDE v2.5 29-Jun-2011 16:03:25

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
dists=pdist(myhandles.superblock_profiles);
myhandles.mds_data=mdscale(dists,3);

myhandles.chosen_points=[0 0];

setappdata(0,'myhandles',myhandles);
myhandles.MDSPlot_handle=handles.MDSPlot;

for i=1:length(myhandles.grouping_fields)
    uimenu(handles.Color_Points_By_Menu,'Label',myhandles.grouping_fields{i}, ...
        'Callback', {@color_by_callback,handles,i});
    uimenu(handles.Label_Points_By_Menu,'Label',myhandles.grouping_fields{i}, ...
        'Callback', {@label_by_callback,handles,i});
end
myhandles.label_field_number=1;
myhandles.color_field_number=1;
myhandles.show_mds_text=true;

setappdata(0,'myhandles',myhandles);

UpdatePlotColors();
myhandles=getappdata(0,'myhandles');
if(size(myhandles.mds_data,2)==2)
%     scatter(handles.MDSPlot,myhandles.mds_data(:,1),myhandles.mds_data(:,2),5,'filled');
%     for i=1:size(myhandles.mds_data,1)
%         text(myhandles.mds_data(i,1),myhandles.mds_data(i,2),myhandles.mds_text{i},...
%             'BackgroundColor',myhandles.mds_colors(i,:),'FontSize',16,...
%             'parent',myhandles.MDSPlot_handle);%not always cn
%         
%     end
%     
    Plot_MDS(myhandles.mds_data,2,myhandles.mds_text,myhandles.mds_colors,...
        myhandles.chosen_points,myhandles.MDSPlot_handle,myhandles.show_mds_text);
else

%     scatter3(myhandles.mds_data(:,1),myhandles.mds_data(:,2),myhandles.mds_data(:,3),50,myhandles.mds_colors,'parent',myhandles.MDSPlot_handle);
%     
%     for i=1:size(myhandles.mds_data,1)
%         text(myhandles.mds_data(i,1),myhandles.mds_data(i,2),myhandles.mds_data(i,3),myhandles.mds_text{i},...
%             'BackgroundColor',myhandles.mds_colors(i,:),'parent',myhandles.MDSPlot_handle,...
%             'FontSize',16);%not always cn
%     end
    
     Plot_MDS(myhandles.mds_data,3,myhandles.mds_text,myhandles.mds_colors,...
        myhandles.chosen_points,myhandles.MDSPlot_handle,myhandles.show_mds_text);
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
myhandles.bar_axes=handles.BarAxes;

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
%disp([num2str(hittest()) ' ' num2str(myhandles.MDS_gca) ' ' num2str(overobj2('type','axes'))]);
if(myhandles.MDSPlot_handle==overobj2('type','axes'))
CP=get(myhandles.MDS_gca,'CurrentPoint');

number_of_points=size(myhandles.mds_data,1);
% sizes=50*ones(number_of_points,1);
% sizes(point_number)=200;
% scatter(myhandles.mds_data(:,1),myhandles.mds_data(:,2),sizes,'filled','parent',myhandles.MDSPlot_handle);
if(size(myhandles.mds_data,2)==2)
    dists=pdist2(myhandles.mds_data,CP(1,1:size(myhandles.mds_data,2)));
    [~,point_number]=min(dists);
    disp(num2str(point_number));
    if(myhandles.axes_chosen==handles.axes2)
        myhandles.chosen_points(2)=point_number;
    else
        myhandles.chosen_points(1)=point_number;
    end
%     scatter(myhandles.mds_data(:,1),myhandles.mds_data(:,2),50,myhandles.mds_colors,'parent',myhandles.MDSPlot_handle);
%     sizes=16*ones(number_of_points,1);
%     sizes(point_number)=24;
%     for i=1:size(myhandles.mds_data,1)
%         text(myhandles.mds_data(i,1),myhandles.mds_data(i,2),myhandles.mds_text{i},...
%             'BackgroundColor',myhandles.mds_colors(i,:),'parent',myhandles.MDSPlot_handle,...
%             'FontSize',sizes(i));%not always cn
%         
%     end
 Plot_MDS(myhandles.mds_data,2,myhandles.mds_text,myhandles.mds_colors,...
        myhandles.chosen_points,myhandles.MDSPlot_handle,myhandles.show_mds_text);
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
        if(myhandles.axes_chosen==handles.axes2)
            myhandles.chosen_points(2)=point_number;
        else
            myhandles.chosen_points(1)=point_number;
        end
        
%         scatter3(myhandles.mds_data(:,1),myhandles.mds_data(:,2),myhandles.mds_data(:,3),50,myhandles.mds_colors,'parent',myhandles.MDSPlot_handle);
%        
%         sizes=16*ones(number_of_points,1);
%         sizes(point_number)=24;
%         for i=1:size(myhandles.mds_data,1)
%             text(myhandles.mds_data(i,1),myhandles.mds_data(i,2),myhandles.mds_data(i,3),myhandles.mds_text{i},...
%                 'BackgroundColor',myhandles.mds_colors(i,:),'parent',myhandles.MDSPlot_handle,...
%                 'FontSize',sizes(i));%not always cn
%         end
        Plot_MDS(myhandles.mds_data,3,myhandles.mds_text,myhandles.mds_colors,...
            myhandles.chosen_points,myhandles.MDSPlot_handle,myhandles.show_mds_text);
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

if(myhandles.axes_chosen==handles.axes2)
   frame_handle=handles.uipanel3; 
else
   frame_handle=handles.uipanel7;  
end

ShowImages(myhandles.grouped_metadata{point_number}.files_in_group,...
    myhandles.axes_chosen,myhandles.mds_colors(point_number,:),...
    myhandles.mds_text{point_number},frame_handle);

setappdata(0,'myhandles',myhandles);
Update_Bar_Plot;
end


function ShowImages(filenames,axis_handle,class_color,point_name,frame_handle)
myhandles=getappdata(0,'myhandles');
set(frame_handle,'Title',point_name,'HighlightColor',class_color,...
    'ShadowColor',class_color);
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
%image(img./max(img(:)),'parent',axis_handle);
Display_Image(img,axis_handle,myhandles.marker_scales,myhandles.display_colors,[]);
set(axis_handle,'XTick',[],'YTick',[]);
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

function Update_Bar_Plot()
myhandles=getappdata(0,'myhandles');
%delete(myhandles.bar_axes);
fraction_cutoff=0.05;
if(all(myhandles.chosen_points~=0))
   %axis(myhandles.bar_axes);
   cla(myhandles.bar_axes);
   %profiles=zeros(2,myhandles.number_of_superblocks);
   profile1=myhandles.superblock_profiles(myhandles.chosen_points(2),:);
   profile2=myhandles.superblock_profiles(myhandles.chosen_points(1),:);
   important_blocks=(profile1>fraction_cutoff|profile2>fraction_cutoff);
   [~,p_indices]=sort(-abs(profile1-profile2));
   number_of_reps=min(nnz(important_blocks),5);
   important_blocks=important_blocks(p_indices);
   p_indices=p_indices(important_blocks);
   bar_matrix=zeros(2,number_of_reps);
   bar_matrix(1,:)=profile1(p_indices(1:number_of_reps));
   bar_matrix(2,:)=profile2(p_indices(1:number_of_reps));
   bar_colormap=zeros(2,3);
   bar_colormap(1,:)=myhandles.mds_colors(myhandles.chosen_points(2),:);
   bar_colormap(2,:)=myhandles.mds_colors(myhandles.chosen_points(1),:);
   valdiff=bar_matrix(2,:)-bar_matrix(1,:);
   [~,bar_order]=sort(valdiff);
   bar(bar_matrix(:,bar_order)','parent',myhandles.bar_axes);
   colormap(bar_colormap);
   ylabel('Superblock Fractions','Color','w','parent',myhandles.bar_axes);
 
    if(all(bar_colormap(1,:)==bar_colormap(2,:)))
         legend(myhandles.bar_axes,[cell2mat(myhandles.mds_text{myhandles.chosen_points(2)}) ' (Left)'] ,...
    [cell2mat(myhandles.mds_text{myhandles.chosen_points(1)}) ' (Right)'],'Location','NorthWest');
    else    
        legend(myhandles.bar_axes,cell2mat(myhandles.mds_text{myhandles.chosen_points(2)}),...
    cell2mat(myhandles.mds_text{myhandles.chosen_points(1)}),'Location','NorthWest');
    end
   %bar(profiles','parent',myhandles.bar_axes);
   set(myhandles.bar_axes,'Color','k','XColor','w','YColor','w');
   scale_factor=0.9;
   XLims=get(myhandles.bar_axes,'XLim');
   YLims=get(myhandles.bar_axes,'YLim');
   x_positions=linspace(1,number_of_reps,number_of_reps)-scale_factor/2;
   y_positions=-(diff(YLims)/12)*ones(number_of_reps,1);
   h=myhandles.bar_axes;
   f=gcf;
   positions=zeros(number_of_reps,4);
  % units=get(gca,'Units');
  if( any(strcmp(fieldnames(myhandles),'temp_handles')))
      for i=1:length(myhandles.temp_handles)
          if(ishandle(myhandles.temp_handles(i)))
              delete(myhandles.temp_handles(i));
          end
      end
  end
      myhandles.temp_handles=zeros(number_of_reps,1);
   for rep_num=1:number_of_reps
       
       
       % set(gca,'Units','normalized');
       positions(rep_num,:)=dsxy2figxy(h,[x_positions(rep_num),y_positions(rep_num),scale_factor*diff(XLims)/number_of_reps,scale_factor*diff(YLims)/5]);
       myhandles.temp_handles(rep_num)=axes('position', positions(rep_num,:));
       img=double(myhandles.global_data.superblock_representatives{p_indices(bar_order(rep_num)),1}(:,:,1:3));
       %max_col=max(img(:));
       %image(img/max_col);axis equal;axis off;
       block_size=myhandles.global_data.block_size;
       Display_Image(img,myhandles.temp_handles(rep_num),myhandles.marker_scales,myhandles.display_colors,[]);
       line([2*block_size,5*block_size],[2*block_size,2*block_size],'Color','y');
       line([2*block_size,2*block_size],[5*block_size,2*block_size],'Color','y');
       line([2*block_size,5*block_size],[5*block_size,5*block_size],'Color','y');
       line([5*block_size,5*block_size],[5*block_size,2*block_size],'Color','y');
       %set(myhandles.temp_handles(rep_num),'Box','on','Color','w');
       %image(representatives{perm2(rep_num)}./max(max(max(representatives{perm2(rep_num)}))));axis equal;axis off;
       axis off;axis equal;
   end
   outerpos=get(h,'Position');
   setappdata(0,'myhandles',myhandles);
  % set(h,'Position',[outerpos(1) outerpos(2)+0.1 outerpos(3) outerpos(4)-0.1]);
   %set(h,'Position',[outerpos(1) outerpos(2)+0.1 outerpos(3) outerpos(4)-0.1]);
end

function Plot_MDS(positions,dim,labels,colors,selected_points,axis_handle,show_text)
bool_points=false(length(labels),1);
bool_points(selected_points(selected_points>0))=true;

default_font_size=12;
selected_font_size=16;
font_sizes=default_font_size*ones(size(bool_points));
font_sizes(bool_points)=selected_font_size;

default_point_size=60;
selected_point_size=200;
point_sizes=default_point_size*ones(size(bool_points));
point_sizes(bool_points)=selected_point_size;

if(dim==2)
    scatter(axis_handle,positions(:,1),positions(:,2),point_sizes,colors,'filled');
    if(show_text)
        for i=1:size(positions,1)
            % text(positions(i,1),positions(i,2),labels{i},...
            %     'BackgroundColor',colors(i,:),'FontSize',font_sizes(i),...
            %     'parent',axis_handle);
            
            text(positions(i,1),positions(i,2),labels{i},...
                'FontSize',font_sizes(i),...
                'parent',axis_handle);
        end
    end
else
    
        rotate3d off;
        camPos = get(gca, 'CameraPosition'); % camera position
        camTgt = get(gca, 'CameraTarget'); % where the camera is pointing to
        camUpVect = get(gca, 'CameraUpVector'); % camera 'up' vector
        
           
    scatter3(positions(:,1),positions(:,2),positions(:,3),point_sizes,colors,'filled','parent',axis_handle);
    if(show_text)
        for i=1:size(positions,1)
            %        text(positions(i,1),positions(i,2),positions(i,3),labels{i},...
            %            'BackgroundColor',colors(i,:),'parent',axis_handle,...
            %            'FontSize',font_sizes(i));
            text(positions(i,1),positions(i,2),positions(i,3),['  ', cell2mat(labels{i})],...
                'parent',axis_handle,...
                'FontSize',font_sizes(i));
        end
    end
    set(gca,'XTickLabel','','YTickLabel','','ZTickLabel','');
         set(gca, 'CameraPosition',camPos);
        set(gca, 'CameraTarget',camTgt);
        set(gca, 'CameraUpVector',camUpVect);
end


% --- Executes on button press in LegendCheckBox.
function LegendCheckBox_Callback(hObject, eventdata, handles)
% hObject    handle to LegendCheckBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
mylegend=figure;
set(mylegend, 'Name', 'MDS Plot Legend', 'NumberTitle', 'off',...
            'MenuBar', 'none', 'Resize', 'off', ...
            'Units', 'normalized', 'Position', [.62 .15 .1 .2],...
            'Color', [0.7 0.7 0.7]);
for i=1:length(myhandles.group_labels)
    addElementToLegend(myhandles.category_colors(i,:), myhandles.group_labels{i}, i, mylegend);
end




function addElementToLegend(color, string, nr, legendFig)
lmarg = 0.02;
startY = 0.99;
startY=startY-0.05*nr;
lightGray=[0.7,0.7,0.7];
uicontrol(...
    'Style','text', 'Parent', legendFig, ...
    'String', string, 'FontWeight',...
    'Bold','FontSize', 9, 'Units','normalized', ...
    'Position',[lmarg+0.05 startY 0.85 0.05],...
    'HorizontalAlignment', 'left',...
    'BackgroundColor', lightGray);
uicontrol( ...
    'Style','frame', 'Parent', legendFig, ...
    'Units','normalized',...
    'Position',[lmarg startY 0.04 0.04], ...
    'BackgroundColor', color);


% --------------------------------------------------------------------
function MDS_Plot_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to MDS_Plot_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Data_Display_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Data_Display_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Show_MDS_Label_Callback(hObject, eventdata, handles)
% hObject    handle to Show_MDS_Label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
myhandles=getappdata(0,'myhandles');
myhandles.show_mds_text=~myhandles.show_mds_text;
setappdata(0,'myhandles',myhandles);
if strcmp(get(gcbo, 'Checked'),'on')
    set(gcbo, 'Checked', 'off');
else 
    set(gcbo, 'Checked', 'on');
end
Plot_MDS(myhandles.mds_data,3,myhandles.mds_text,myhandles.mds_colors,...
            myhandles.chosen_points,myhandles.MDSPlot_handle,myhandles.show_mds_text);


% --------------------------------------------------------------------
function Color_Points_By_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Color_Points_By_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Label_Points_By_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to Label_Points_By_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function color_by_callback(hObject, eventdata, handles,group_num)
myhandles=getappdata(0,'myhandles');
bar_update_needed=false;
myhandles.color_field_number=group_num;
setappdata(0,'myhandles',myhandles);
UpdatePlotColors();
myhandles=getappdata(0,'myhandles');
Plot_MDS(myhandles.mds_data,3,myhandles.mds_text,myhandles.mds_colors,...
            myhandles.chosen_points,myhandles.MDSPlot_handle,myhandles.show_mds_text);
for point_number=1:2
    if(myhandles.chosen_points(point_number)~=0)
        
        switch(point_number)
            case 1
                frame_handle=handles.uipanel7; 
            case 2
                frame_handle=handles.uipanel3; 
        end
        class_color=myhandles.mds_colors(myhandles.chosen_points(point_number),:);
        class_text=myhandles.mds_text{myhandles.chosen_points(point_number)};
         set(frame_handle,'Title',class_text,'HighlightColor',class_color,...
    'ShadowColor',class_color);
        bar_update_needed=true;
    end
end
if(bar_update_needed)
    Update_Bar_Plot();
end





function label_by_callback(hObject, eventdata, handles,group_num)
myhandles=getappdata(0,'myhandles');
myhandles.label_field_number=group_num;
setappdata(0,'myhandles',myhandles);
UpdatePlotColors();
myhandles=getappdata(0,'myhandles');
Plot_MDS(myhandles.mds_data,3,myhandles.mds_text,myhandles.mds_colors,...
    myhandles.chosen_points,myhandles.MDSPlot_handle,myhandles.show_mds_text);
for point_number=1:2
    if(myhandles.chosen_points(point_number)~=0)
        
        switch(point_number)
            case 1
                frame_handle=handles.uipanel7;
            case 2
                frame_handle=handles.uipanel3;
        end
        
        class_text=myhandles.mds_text{myhandles.chosen_points(point_number)};
        set(frame_handle,'Title',class_text);
    end
end


        
        


function UpdatePlotColors()
myhandles=getappdata(0,'myhandles');

label_field=myhandles.grouping_fields{myhandles.label_field_number};
color_field=myhandles.grouping_fields{myhandles.color_field_number};


group_vals=cell(1,myhandles.number_of_conditions);
for condition=1:myhandles.number_of_conditions
   
   if(iscell(myhandles.grouped_metadata{condition}.(color_field)))
        group_vals{condition}=cell2mat(myhandles.grouped_metadata{condition}.(color_field)); 
   else
       group_vals{condition}='Not Defined';
   end
    
end

myhandles.mds_text=cell(size(myhandles.superblock_profiles,1),1);
myhandles.mds_colors=zeros(size(myhandles.superblock_profiles,1),3);  

[colorsGroup,myhandles.group_labels]=grp2idx(group_vals);
%colors=colormap(jet(max(colorsGroup)));
colors=ColorBrewer(max(colorsGroup));
myhandles.category_colors=colors;

for i=1:myhandles.number_of_conditions

    myhandles.mds_text{i}=myhandles.grouped_metadata{i}.(label_field);
    myhandles.mds_colors(i,:)=colors(colorsGroup(i),:);
end
setappdata(0,'myhandles',myhandles);
