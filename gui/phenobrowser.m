function varargout = phenobrowser(varargin)
    % PHENOBROWSER M-file for phenobrowser.fig
    %      PHENOBROWSER, by itself, creates a new PHENOBROWSER or raises the existing
    %      singleton*.
    %
    %      H = PHENOBROWSER returns the handle to a new PHENOBROWSER or the handle to
    %      the existing singleton*.
    %
    %      PHENOBROWSER('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in PHENOBROWSER.M with the given input arguments.
    %
    %      PHENOBROWSER('Property','Value',...) creates a new PHENOBROWSER or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before phenobrowser_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to phenobrowser_OpeningFcn via varargin.
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
    
    
    % Edit the above text to modify the response to help phenobrowser
    
    % Last Modified by GUIDE v2.5 09-May-2013 11:33:37
    
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @phenobrowser_OpeningFcn, ...
        'gui_OutputFcn',  @phenobrowser_OutputFcn, ...
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
    
    
    % --- Executes just before phenobrowser is made visible.
function phenobrowser_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to phenobrowser (see VARARGIN)
    
    % Choose default command line output for phenobrowser
    myhandles=getappdata(0,'myhandles');
    %myhandles.MDS_gca=gca;
    myhandles.MDS_gcf=handles.explorer;
    myhandles.MDS_panel=handles.uipanel2;
    % superblock_profiles=myhandles.superblock_profiles;
    % superblock_profiles(isnan(superblock_profiles))=0;
    % dists=pdist(superblock_profiles);
    %
    % myhandles.mds_data=mdscale(dists,3);
    myhandles.mds_dim=3;
    myhandles.mds_data=Calculate_MDS(myhandles.superblock_profiles,myhandles.mds_dim);
    %myhandles.distanceBetweenPoints=squareform(pdist(myhandles.superblock_profiles));
    B=mean(myhandles.superblock_profiles);
    %myhandles.centroidDistance =  pdist2(myhandles.superblock_profiles,B,'euclidean');
    %Possible improvement: divide number of point into n clusters (using kmean),
    %get the ceontroid of all clusters then identify the 2 futhers (K1 and K2).
    %Then compare the distance from the point in cluter K1 with the one in K2
    %and identify the max distance.
    
    myhandles.maxCentroidDistance =max(pdist2(myhandles.superblock_profiles,B,'euclidean'));
    set(handles.distanceLabel,'String','')
    myhandles.chosen_points=[0 0];
    myhandles.showOnlyFGPixels=false;
    myhandles.labelToDisplay='All';
    
    setappdata(0,'myhandles',myhandles);
    %myhandles.MDSPlot_handle=handles.MDSPlot;
    grouping_fields={myhandles.grouping_fields{:},'Number_FG_Blocks'};
    %myhandles.grouping_fields_extended=grouping_fields;
    setappdata(0,'myhandles',myhandles);
    
    myhandles.Color_Points_By_Menu_Handles=zeros(length(grouping_fields),1);
    myhandles.Label_Points_By_Menu_Handles=zeros(length(grouping_fields),1);
    for i=1:length(grouping_fields)
        myhandles.Color_Points_By_Menu_Handles(i)=...
            uimenu(handles.Color_Points_By_Menu,'Label',grouping_fields{i}, ...
            'Callback', {@color_by_callback,handles,i});
        myhandles.Label_Points_By_Menu_Handles(i)=...
            uimenu(handles.Label_Points_By_Menu,'Label',grouping_fields{i}, ...
            'Callback', {@label_by_callback,handles,i});
        
    end
    myhandles.Group_Points_By_Menu_Handles=zeros(length(myhandles.grouping_fields),1);
    myhandles.Group_Points_By_Menu_Handles(1)=uimenu(handles.Group_By_Menu,'Label','Do Not Group', ...
        'Callback', {@group_by_callback,handles,1});
    for i=1:length(myhandles.grouping_fields)
        myhandles.Group_Points_By_Menu_Handles(i+1)=...
            uimenu(handles.Group_By_Menu,'Label',myhandles.grouping_fields{i}, ...
            'Callback', {@group_by_callback,handles,i+1});
    end
    setappdata(0,'myhandles',myhandles);
    
    myhandles.Barplot_Method_Chosen_Handles=[handles.BarPlot_Method1,...
        handles.BarPlot_Method2,handles.BarPlot_Method3,handles.BarPlot_Method4];
    for i=1:length(myhandles.Barplot_Method_Chosen_Handles)
        set(myhandles.Barplot_Method_Chosen_Handles(i),'Callback',...
            {@Barplot_Method_Chosen_Callback,handles,i});
    end
    
    
    myhandles.MDS_Dim_Menu_Handles=[handles.MDS_2D_Menu,handles.MDS_3D_Menu];
    for i=1:2
        set(myhandles.MDS_Dim_Menu_Handles(i),'Callback',...
            {@MDS_Dim_Menu_Callback,handles,i+1});
    end
    
    myhandles.Clustergram_SB_Displayed_Menu_Handles=[handles.Clustergram_SB_Displayed_All,...
        handles.Clustergram_SB_Displayed_5percent,handles.Clustergram_SB_Displayed_10percent];
    for i=1:length(myhandles.Clustergram_SB_Displayed_Menu_Handles)
        set(myhandles.Clustergram_SB_Displayed_Menu_Handles(i),'Callback',...
            {@Clustergram_SB_Displayed_Menu_Handles_Callback,handles,i});
    end
    
    
    myhandles.Superblocks_Shown_Menu_Handles=zeros(4,1);
    myhandles.Superblocks_Shown_Menu_Handles(1)=...
        uimenu(handles.Superblocks_Shown_Menu,'Label','Top 5','Callback',...
        {@superblocks_shown_callback,handles,1});
    myhandles.Superblocks_Shown_Menu_Handles(2)=...
        uimenu(handles.Superblocks_Shown_Menu,'Label','Top 30%','Callback',...
        {@superblocks_shown_callback,handles,2});
    myhandles.Superblocks_Shown_Menu_Handles(3)=...
        uimenu(handles.Superblocks_Shown_Menu,'Label','Top 60%','Callback',...
        {@superblocks_shown_callback,handles,3});
    myhandles.Superblocks_Shown_Menu_Handles(4)=...
        uimenu(handles.Superblocks_Shown_Menu,'Label','All','Callback',...
        {@superblocks_shown_callback,handles,4});
    
    %myhandles.Clustergram_SB_Ordering_Menu_Handles=zeros(length(myhandles.wizardData.markers)+1,1);
    myhandles.Clustergram_SB_Ordering_Menu_Handles=[];
    myhandles.Clustergram_SB_Ordering_Menu_Handles(1)=handles.CG_SB_Optimal_Order_Menu;
    set(myhandles.Clustergram_SB_Ordering_Menu_Handles(1),'Callback',...
        {@cg_sb_ordering_callback,handles,1,1});
    counter=1;
    for i=1:length(myhandles.wizardData.markers)
        counter=counter+1;
        myhandles.Clustergram_SB_Ordering_Menu_Handles(counter)=...
            uimenu(handles.CG_SB_Marker_Level_Order_Menu,'Label',myhandles.wizardData.markers{i}.name,...
            'Callback', {@cg_sb_ordering_callback,handles,2,i});
        % guidata(hObject, handles);
        
    end
    for i=1:length(myhandles.wizardData.markers)
        counter=counter+1;
        myhandles.Clustergram_SB_Ordering_Menu_Handles(counter)=...
            uimenu(handles.CG_SB_DG_Marker_Level_Order_Menu,'Label',myhandles.wizardData.markers{i}.name,...
            'Callback', {@cg_sb_ordering_callback,handles,3,i});
        
    end
    
    
    % for i=1:length(myhandles.grouping_fields)
    %     myhandles.Clustergram_SB_Ordering_Menu_Handles(i+1)=...
    %     uimenu(handles.CG_SB_Marker_Level_Order_Menu,'Label',myhandles.grouping_fields{i}, ...
    %         'Callback', {@cg_sb_ordering_callback,handles,handles,i+1});
    % end
    
    setappdata(0,'myhandles',myhandles);
    
    set(handles.DiscardFrame1_Pushbutton,'Callback',{@DiscardFrame_Callback,1});
    set(handles.DiscardFrame2_Pushbutton,'Callback',{@DiscardFrame_Callback,2});
    
    myhandles.is_sb_in_images_calculated=false;
    
    if(~exist('myhandles.label_field_number','var'))
        myhandles.label_field_number=1;
    end
    if(~exist('myhandles.color_field_number','var'))
        myhandles.color_field_number=1;
    end
    
    myhandles.show_mds_text=true;
    if(~exist('myhandles.bar_plot_method','var'))
        myhandles.bar_plot_method=1;
    end
    if(~exist('myhandles.superblock_shown_choice','var'))
        myhandles.superblocks_shown_choice=2;
    end
    
    if(~exist('myhandles.clustergram_SB_diplayed_method','var'))
        myhandles.clustergram_SB_diplayed_method=1;
    end
    if(~exist('myhandles.cg_sb_ordering_method','var'))
        myhandles.cg_sb_ordering_method=1;
    end
    if(~exist('myhandles.cg_sb_ordering_method_type','var'))
        myhandles.cg_sb_ordering_method_type=1;
    end
    if(~exist('myhandles.cg_sb_ordering_method_number','var'))
        myhandles.cg_sb_ordering_method_number=1;
    end
    
    MenuList_Checkmark(myhandles.color_field_number,myhandles.Color_Points_By_Menu_Handles);
    MenuList_Checkmark(myhandles.label_field_number,myhandles.Label_Points_By_Menu_Handles);
    MenuList_Checkmark(myhandles.chosen_grouping_field,myhandles.Group_Points_By_Menu_Handles);
    MenuList_Checkmark(myhandles.bar_plot_method,myhandles.Barplot_Method_Chosen_Handles);
    MenuList_Checkmark(myhandles.superblocks_shown_choice,myhandles.Superblocks_Shown_Menu_Handles);
    MenuList_Checkmark(myhandles.mds_dim-1,myhandles.MDS_Dim_Menu_Handles);
    MenuList_Checkmark(myhandles.clustergram_SB_diplayed_method,...
        myhandles.Clustergram_SB_Displayed_Menu_Handles);
    MenuList_Checkmark_By_Handle(myhandles.Clustergram_SB_Ordering_Menu_Handles(1),myhandles.Clustergram_SB_Ordering_Menu_Handles);
    setappdata(0,'myhandles',myhandles);
    
    UpdatePlotColors();
    myhandles=getappdata(0,'myhandles');
    if(myhandles.mds_dim==2)
        %     scatter(handles.MDSPlot,myhandles.mds_data(:,1),myhandles.mds_data(:,2),5,'filled');
        %     for i=1:size(myhandles.mds_data,1)
        %         text(myhandles.mds_data(i,1),myhandles.mds_data(i,2),myhandles.mds_text{i},...
        %             'BackgroundColor',myhandles.mds_colors(i,:),'FontSize',16,...
        %             'parent',myhandles.MDSPlot_handle);%not always cn
        %
        %     end
        %
        Plot_MDS(myhandles.mds_data,myhandles.mds_dim,myhandles.mds_text,myhandles.mds_colors,...
            myhandles.chosen_points,handles.MDSPlot,myhandles.show_mds_text,myhandles.labelToDisplay);
    else
        
        %     scatter3(myhandles.mds_data(:,1),myhandles.mds_data(:,2),myhandles.mds_data(:,3),50,myhandles.mds_colors,'parent',myhandles.MDSPlot_handle);
        %
        %     for i=1:size(myhandles.mds_data,1)
        %         text(myhandles.mds_data(i,1),myhandles.mds_data(i,2),myhandles.mds_data(i,3),myhandles.mds_text{i},...
        %             'BackgroundColor',myhandles.mds_colors(i,:),'parent',myhandles.MDSPlot_handle,...
        %             'FontSize',16);%not always cn
        %     end
         set(handles.show_sb_examples_instructions_text,'Visible','off');
        Plot_MDS(myhandles.mds_data,myhandles.mds_dim,myhandles.mds_text,myhandles.mds_colors,...
            myhandles.chosen_points,handles.MDSPlot,myhandles.show_mds_text,myhandles.labelToDisplay);
        %     set(handles.MDSPlot, 'XTickLabel','');
        %     set(handles.MDSPlot, 'YTickLabel','');
        %     set(handles.MDSPlot, 'ZTickLabel','');
        %zoom  on;
        %dragzoom on;
        %h=zoom;
        %setAllowAxesZoom(h,gca,true);
        %       myhandles.camPos = get(handles.MDSPlot, 'CameraPosition'); % camera position
        %     myhandles.camTgt = get(handles.MDSPlot, 'CameraTarget'); % where the camera is pointing to
        %
        %     myhandles.camUpVect = get(handles.MDSPlot, 'CameraUpVector'); % camera 'up' vector
        %     myhandles.camViewAngle = get(handles.MDSPlot, 'CameraViewAngle');
        %
        %    %  set(handles.MDSPlot, 'CameraViewAngle',myhandles.camViewAngle);
        %      set(handles.MDSPlot, 'CameraPosition',myhandles.camPos);
        %      set(handles.MDSPlot, 'CameraTarget',myhandles.camTgt);
        %      set(handles.MDSPlot, 'CameraUpVector',myhandles.camUpVect);
        
        %
        rotate3d off;
        %    rotate3d(handles.MDSPlot ,'Enable','off');
        myhandles.mds_rotatable=0;
    end
    
    set(handles.MDSPlot,'GridLineStyle','-')
    %grid(handles.MDSPlot ,'Enable','on');
    %set(gca,'ButtonDownFcn', {@MDSPlot_ButtonDownFcn,handles});
    set(myhandles.MDS_gcf,'WindowButtonDownFcn',{@MDSPlot_ButtonDownFcn,handles});
    
    myhandles.axes2_handle=handles.axes2;
    myhandles.axes3_handle=handles.axes3;
    myhandles.axes_chosen=handles.axes2;
    myhandles.bar_axes=handles.BarAxes;
    
    rotate3d off;
    
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
    %set(gcf,'WindowButtonDownFcn',{@MDSPlot_ButtonDownFcn,handles});
    
    
    % UIWAIT makes phenobrowser wait for user response (see UIRESUME)
    % uiwait(handles.phenobrowser);
    
    %Change the button color to black for Mac because of a Matlab Bug
    % if ismac
    %   set(handles.LegendCheckBox,'CData',cat(3,zeros(500),zeros(500),zeros(500)));
    %   set(handles.CalcSB_1_Button,'CData',cat(3,zeros(500),zeros(500),zeros(500)));
    %   set(handles.DiscardFrame1_Pushbutton,'CData',cat(3,zeros(500),zeros(500),zeros(500)));
    %   set(handles.DiscardFrame2_Pushbutton,'CData',cat(3,zeros(500),zeros(500),zeros(500)));
    %   set(handles.PreviousImage1_pushbutton,'CData',cat(3,zeros(500),zeros(500),zeros(500)));
    %   set(handles.PreviousImage2_pushbutton,'CData',cat(3,zeros(500),zeros(500),zeros(500)));
    %   set(handles.NextImage1_pushbotton,'CData',cat(3,zeros(500),zeros(500),zeros(500)));
    %   set(handles.NextImage2_pushbotton,'CData',cat(3,zeros(500),zeros(500),zeros(500)));
    % end
    %generateShowGroupingFieldMenu(handles)
    
    % labelStr = '<html>&#8704;&#946; <b>bold</b> <i><font color="red">label</html>';
    % jLabel = javaObjectEDT('javax.swing.JLabel',labelStr);
    % [hcomponent,hcontainer] = javacomponent(jLabel,[638,365,100,20],handles.phenobrowser);
    
function addMarkerLabel(myhandles,handles)
    if(isfield(myhandles,'markers'))
        markerNr=0;
        blackColor = javaObjectEDT('java.awt.Color', 0);
        font=javaObjectEDT('java.awt.Font','Dialog', 1, 14);
        
        labelStr= '<html><font color="white">Markers : </font> ';
        
        for marker_num=1:size(myhandles.markers,2)
            if(myhandles.markers{marker_num}.isUse)
                markerNr=markerNr+1;
                name = myhandles.markers{marker_num}.name;
                color=myhandles.display_colors{markerNr};
                colorStr=color;
                if strcmpi(color,'cyan')
                    colorStr='#00FFFF';
                elseif strcmpi(color,'magenta')
                    colorStr='#FF00FF';
                end
                labelStr= [labelStr '<font color="' colorStr '">' name '</font><font color="white"> / </font>'];
            end
        end
        labelStr=labelStr(1:end-length('<font color="white"> / </font>'));
        labelStr= [labelStr '</html>'];
        jLabel = javaObjectEDT('javax.swing.JLabel',labelStr);
        setFont(jLabel, font);
        setBackground(jLabel, blackColor);
        javacomponent(jLabel,[650,380,550,20],handles.explorer);
        myhandles=getappdata(0,'myhandles');
        myhandles.jLabel=jLabel;
        setappdata(0,'myhandles',myhandles);
    end
    
    
function generateShowGroupingFieldMenu(handles)
    myhandles=getappdata(0,'myhandles');
    myhandles.Show_Points_Menu_Handles=zeros(length(myhandles.mds_text),1);
    for i=1:length(myhandles.mds_text)
        myhandles.Show_Points_Menu_Handles(i)=...
            uimenu(handles.Show_Point,'Label',myhandles.mds_text{i}{1}, ...
            'Checked','on','Callback', {@show_point_callback,handles,i});
    end
    setappdata(0,'myhandles',myhandles);
    
function show_point_callback(hObject, eventdata, handles,group_num)
    myhandles=getappdata(0,'myhandles');
    
    
    
    
    % --- Outputs from this function are returned to the command line.
function varargout = phenobrowser_OutputFcn(hObject, eventdata, handles)
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Get default command line output from handles structure
    varargout{1} = handles.output;
    myhandles=getappdata(0,'myhandles');
    addMarkerLabel(myhandles,handles);
    %addProgressBarToMyHandle(handles.phenobrowser);
    %myhandles=getappdata(0,'myhandles');
    %set(myhandles.jLabel.getParent(), 'Foreground','black');
    %setBackground(myhandles.jLabel, blackColor);
    
    
    
    % --- Executes on mouse press over axes background.
function MDSPlot_ButtonDownFcn(hObject, eventdata, handles)
    % hObject    handle to MDSPlot (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    myhandles=getappdata(0,'myhandles');
    %disp([num2str(hittest()) ' ' num2str(myhandles.MDS_gca) ' ' num2str(overobj2('type','axes'))]);
    
    %overobj2('type','axes')
    
    % if(handles.MDSPlot==overobj2('type','axes'))
    %   CP=get(handles.MDSPlot,'CurrentPoint');
    point=hittest(handles.explorer);
    point_parent=get(point,'Parent');
    if((handles.MDSPlot==point)||(handles.MDSPlot==point_parent))
        CP=get(handles.MDSPlot,'CurrentPoint');
        %number_of_points=size(myhandles.mds_data,1);
        % sizes=50*ones(number_of_points,1);
        % sizes(point_number)=200;
        % scatter(myhandles.mds_data(:,1),myhandles.mds_data(:,2),sizes,'filled','parent',myhandles.MDSPlot_handle);
        if(myhandles.mds_dim==2)
            dists=pdist2(myhandles.mds_data,CP(1,1:size(myhandles.mds_data,2)));
            [~,point_number]=min(dists);
            if(myhandles.axes_chosen==handles.axes2)
                UpdateMetadata(handles.Point1Info,point_number,1);
                myhandles.chosen_points(2)=point_number;
                myhandles.file_number1=1;
            else
                UpdateMetadata(handles.Point2Info,point_number,1);
                myhandles.chosen_points(1)=point_number;
                myhandles.file_number2=1;
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
            Plot_MDS(myhandles.mds_data,myhandles.mds_dim,myhandles.mds_text,myhandles.mds_colors,...
                myhandles.chosen_points,handles.MDSPlot,myhandles.show_mds_text,myhandles.labelToDisplay);
        else
            
            if(~myhandles.mds_rotatable)
                rotate3d off;
                point = get(handles.MDSPlot, 'CurrentPoint'); % mouse click position
                camPos = get(handles.MDSPlot, 'CameraPosition'); % camera position
                camTgt = get(handles.MDSPlot, 'CameraTarget'); % where the camera is pointing to
                camViewAngle = get(handles.MDSPlot, 'CameraViewAngle');
                camDir = camPos - camTgt; % camera direction
                camUpVect = get(handles.MDSPlot, 'CameraUpVector'); % camera 'up' vector
                
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
                if(myhandles.axes_chosen==handles.axes2)
                    UpdateMetadata(handles.Point1Info,point_number,1);
                    myhandles.chosen_points(2)=point_number;
                    myhandles.file_number1=1;
                else
                    UpdateMetadata(handles.Point2Info,point_number,1);
                    myhandles.chosen_points(1)=point_number;
                    myhandles.file_number2=1;
                end
                
                setappdata(0,'myhandles',myhandles);
                %         scatter3(myhandles.mds_data(:,1),myhandles.mds_data(:,2),myhandles.mds_data(:,3),50,myhandles.mds_colors,'parent',myhandles.MDSPlot_handle);
                %
                %         sizes=16*ones(number_of_points,1);
                %         sizes(point_number)=24;
                %         for i=1:size(myhandles.mds_data,1)
                %             text(myhandles.mds_data(i,1),myhandles.mds_data(i,2),myhandles.mds_data(i,3),myhandles.mds_text{i},...
                %                 'BackgroundColor',myhandles.mds_colors(i,:),'parent',myhandles.MDSPlot_handle,...
                %                 'FontSize',sizes(i));%not always cn
                %         end
                Plot_MDS(myhandles.mds_data,myhandles.mds_dim,myhandles.mds_text,myhandles.mds_colors,...
                    myhandles.chosen_points,handles.MDSPlot,myhandles.show_mds_text,myhandles.labelToDisplay);
                set(handles.MDSPlot,'XTickLabel','','YTickLabel','','ZTickLabel','');
                set(handles.MDSPlot, 'CameraPosition',camPos);
                set(handles.MDSPlot, 'CameraTarget',camTgt);
                set(handles.MDSPlot, 'CameraUpVector',camUpVect);
                %set(gca, 'CameraViewAngle',camViewAngle);
            else
                rotate3d on;
            end
            
        end
        %myhandles.MDS_gca=gca;
        %myhandles.MDS_gcf=handles.phenobrowser;
        if(exist('point_number','var'))
            myhandles.selected_point=point_number;
            
            if(myhandles.axes_chosen==handles.axes2)
                frame_handle=handles.uipanel3;
                other_frame_handle=handles.uipanel7;
                other_axes=handles.axes3;
                other_file_number=myhandles.file_number2;
                other_point_number=myhandles.chosen_points(1);
            else
                frame_handle=handles.uipanel7;
                other_frame_handle=handles.uipanel3;
                other_axes=handles.axes2;
                
                
                other_file_number=myhandles.file_number1;
                other_point_number=myhandles.chosen_points(2);
                
            end
            
            fnames=fieldnames(myhandles.grouped_metadata{point_number});
            panel_text=myhandles.grouped_metadata{point_number}.(fnames{myhandles.chosen_grouping_field});
            if(iscell(panel_text))
                panel_text=panel_text{1};
            end
            if(length(panel_text)>43)
                panel_text=['...' panel_text(end-40:end)];
            end
            
            
            setappdata(0,'myhandles',myhandles);
            
            
            ShowImages(myhandles.grouped_metadata{point_number}.files_in_group,1,...
                myhandles.axes_chosen,myhandles.mds_colors(point_number,:),...
                panel_text,frame_handle);
            if(myhandles.is_sb_in_images_calculated)
                other_panel_text=myhandles.grouped_metadata{other_point_number}.(fnames{myhandles.chosen_grouping_field});
                if(iscell(other_panel_text))
                    other_panel_text=other_panel_text{1};
                end
                if(length(other_panel_text)>43)
                    other_panel_text=['...' panel_text_panel(end-40:end)];
                end
                
                ShowImages(myhandles.grouped_metadata{other_point_number}.files_in_group,...
                    other_file_number,other_axes, myhandles.mds_colors(other_point_number,:),...
                    other_panel_text,other_frame_handle,[]);
            end
            
            
            setappdata(0,'myhandles',myhandles);
            Update_Bar_Plot(handles);
        end
    else
        
        superblock_number=str2double(get(point_parent,'ButtonDownFcn'));
        if(~isempty(superblock_number))
            watchon;
            drawnow;
            try
                if(~myhandles.is_sb_in_images_calculated)
                    Calculate_Superblocks_In_Images();
                end
                Show_SB_In_Image(1,superblock_number,handles);
                Show_SB_In_Image(2,superblock_number,handles);
                
            catch err
                watchoff;
                rethrow(err);
            end;
            watchoff;
        end
    end
    
    
function ShowImages(filenames,file_number,axis_handle,class_color,point_name,frame_handle,boundary_mask)
    
    myhandles=getappdata(0,'myhandles');
    
    
    ff = cell(1,size(filenames,2),size(filenames,3));
    for i=1:size(filenames,2)
        ff{1,i,1}=[myhandles.rootDir filenames{file_number,i,1}];
        ff{1,i,2}=filenames{file_number,i,2};
        %ff{1,i,2}={1,0};
    end
    %filenames=cellfun(@(x) concatenateString(myhandles.rootDir,x),...
    %           filenames(file_number,:,:),'UniformOutput',false);
    file_number=1;
    
    
    
    set(frame_handle,'Title',point_name,'HighlightColor',class_color,...
        'ShadowColor',class_color);
    axis(axis_handle);
    %file_number=1;
    test=imfinfo(ff{1,1});
    xres=test.Height;
    yres=test.Width;
    img=zeros(xres,yres,myhandles.number_of_channels);
    if(myhandles.files_per_image~=myhandles.number_of_channels)
        img=imread2(ff{file_number,1},true,ff(file_number,1,2));
    else
        %USE IMREAD FOR SINGLE CHANNEL ALWAYS
        for channel=1:myhandles.number_of_channels
            img(:,:,channel)=imread2(ff{file_number,channel},false,ff{file_number,channel,2});
        end
    end
    
    %image(img./max(img(:)),'parent',axis_handle);
    if exist('boundary_mask','var')
        display_image_with_boundaries(img,axis_handle,myhandles.marker_scales,myhandles.display_colors,[],boundary_mask);
    else
        if(~myhandles.showOnlyFGPixels)
            display_image(img,axis_handle,myhandles.marker_scales,myhandles.display_colors,[]);
        else
            intensity=CalculateIntensity(img,myhandles.marker_scales);
            cutoff_intensity=myhandles.cutoff_intensity;
            mask=intensity>cutoff_intensity;
            display_image2(img,axis_handle,myhandles.marker_scales,myhandles.display_colors,mask);
        end
    end
    
    set(axis_handle,'XTick',[],'YTick',[]);
    box on;
    axis(axis_handle,'image');
    
    %TODO: FIX THAT BECAUSE img should be between 0 and 1
function intensity=CalculateIntensity(img,marker_scales)
    myhandles=getappdata(0,'myhandles');
    if(~isempty(find(myhandles.foreground_channels==0)))
        j=1;
        for i=1:length(myhandles.foreground_channels)
            if(myhandles.foreground_channels(i))
                img2(:,:,j)=img(:,:,i);
                j=j+1;
            end
        end
        img=double(img2);
    else
        img=double(img);
    end
    number_of_channels=size(img,3);
    for channel=1:number_of_channels
        img(:,:,channel)=min(max(img(:,:,channel)-marker_scales(channel,1),0)/...
            (marker_scales(channel,2)-marker_scales(channel,1)),1)*100;
    end
    intensity=sqrt(sum(img.^2,3)/number_of_channels);
    
    
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
    
function Update_Bar_Plot(handles)
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
        
        
        number_of_reps=5;
        bar_matrix=zeros(2,number_of_reps);
        switch(myhandles.bar_plot_method)
            case 1
                [~,p_indices]=sort(-abs(profile1-profile2));
                important_blocks=important_blocks(p_indices);
                p_indices=p_indices(important_blocks);
                number_of_reps=min(nnz(important_blocks),5);
                bar_matrix=zeros(2,number_of_reps);
                bar_matrix(1,:)=profile1(p_indices(1:number_of_reps));
                bar_matrix(2,:)=profile2(p_indices(1:number_of_reps));
                valdiff=bar_matrix(2,:)-bar_matrix(1,:);
                [~,bar_order]=sort(valdiff);
                
            case 2
                [~,p_indices]=sort(-(profile1+profile2));
                bar_matrix(1,:)=profile1(p_indices(1:number_of_reps));
                bar_matrix(2,:)=profile2(p_indices(1:number_of_reps));
                valdiff=bar_matrix(2,:)+bar_matrix(1,:);
                [~,bar_order]=sort(-valdiff);
            case 3
                [~,p_indices]=sort(-(profile1));
                bar_matrix(1,:)=profile1(p_indices(1:number_of_reps));
                bar_matrix(2,:)=profile2(p_indices(1:number_of_reps));
                valdiff=bar_matrix(1,:);
                [~,bar_order]=sort(-valdiff);
            case 4
                [~,p_indices]=sort(-(profile2));
                bar_matrix(1,:)=profile1(p_indices(1:number_of_reps));
                bar_matrix(2,:)=profile2(p_indices(1:number_of_reps));
                valdiff=bar_matrix(2,:);
                [~,bar_order]=sort(-valdiff);
        end
        
        
        
        bar_colormap=zeros(2,3);
        bar_colormap(1,:)=myhandles.mds_colors(myhandles.chosen_points(2),:);
        bar_colormap(2,:)=myhandles.mds_colors(myhandles.chosen_points(1),:);
        
        myhandles.bar_order=p_indices(bar_order);
        bar(bar_matrix(:,bar_order)','parent',myhandles.bar_axes);
        colormap(myhandles.bar_axes,bar_colormap);
        ylabel('Superblock Fractions','Color','w','parent',myhandles.bar_axes);
        
        fnames=fieldnames(myhandles.grouped_metadata{1});
        point_number=myhandles.chosen_points(2);
        legend_text1=myhandles.grouped_metadata{point_number}.(fnames{myhandles.chosen_grouping_field});
        if(iscell(legend_text1))
            legend_text1=legend_text1{1};
        end
        if(length(legend_text1)>43)
            legend_text1=['...' legend_text1(end-40:end)];
        end
        point_number=myhandles.chosen_points(1);
        legend_text2=myhandles.grouped_metadata{point_number}.(fnames{myhandles.chosen_grouping_field});
        if(iscell(legend_text2))
            legend_text2=legend_text2{1};
        end
        if(length(legend_text2)>43)
            legend_text2=['...' legend_text2(end-40:end)];
        end
        if(all(bar_colormap(1,:)==bar_colormap(2,:)))
            myhandles.bar_legend_axis=legend(myhandles.bar_axes,[legend_text1 ' (Left)'] ,...
                [legend_text2 ' (Right)'],'Location','NorthWest','Interpreter', 'none');
        else
            myhandles.bar_legend_axis=legend(myhandles.bar_axes,{legend_text1,legend_text2},'Location','NorthWest');
        end
        set(myhandles.bar_legend_axis,'Interpreter','none')
        %set(0,'defaulttextinterpreter','none');
        %bar(profiles','parent',myhandles.bar_axes);
        set(myhandles.bar_axes,'Color','k','XColor','w','YColor','w');
        scale_factor=0.9;
        XLims=get(myhandles.bar_axes,'XLim');
        YLims=get(myhandles.bar_axes,'YLim');
        x_positions=linspace(1,number_of_reps,number_of_reps)-scale_factor/2;
        y_positions=-(diff(YLims)/12)*ones(number_of_reps,1);
        h=myhandles.bar_axes;
        %f=gcf;
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
            
            img=double(myhandles.global_data.superblock_representatives{p_indices(bar_order(rep_num)),1});
            %max_col=max(img(:));
            %image(img/max_col);axis equal;axis off;
            block_size=myhandles.global_data.block_size;
            %display_image(img,myhandles.temp_handles(rep_num),myhandles.marker_scales,myhandles.display_colors,[]);
            display_image(img,myhandles.temp_handles(rep_num),100,myhandles.display_colors,[]);
            line([2*block_size,5*block_size],[2*block_size,2*block_size],'Color','y');
            line([2*block_size,2*block_size],[5*block_size,2*block_size],'Color','y');
            line([2*block_size,5*block_size],[5*block_size,5*block_size],'Color','y');
            line([5*block_size,5*block_size],[5*block_size,2*block_size],'Color','y');
            %set(myhandles.temp_handles(rep_num),'Box','on','Color','w');
            %image(representatives{perm2(rep_num)}./max(max(max(representatives{perm2(rep_num)}))));axis equal;axis off;
            axis off;axis equal;
            set( myhandles.temp_handles(rep_num),'ButtonDownFcn',num2str(p_indices(bar_order(rep_num))));
            setappdata(0,'myhandles',myhandles);
        end
        outerpos=get(h,'Position');
        set(handles.show_sb_examples_instructions_text,'Visible','on');
        set(myhandles.bar_legend_axis,'HitTest','off');
        set(myhandles.bar_axes,'HitTest','off');
        setappdata(0,'myhandles',myhandles);
        % set(h,'Position',[outerpos(1) outerpos(2)+0.1 outerpos(3) outerpos(4)-0.1]);
        %set(h,'Position',[outerpos(1) outerpos(2)+0.1 outerpos(3) outerpos(4)-0.1]);
        
        %myhandles.superblock_profiles
        %Should be in MDS
        %B=mean(myhandles.superblock_profiles);
        %myhandles.centroidDistance =  pdist2(myhandles.superblock_profiles,B,'euclidean');
        %Then do that
        pointDistance=pdist2(myhandles.superblock_profiles(myhandles.chosen_points(1),:),myhandles.superblock_profiles(myhandles.chosen_points(2),:),'euclidean');
        dist = pointDistance/(myhandles.maxCentroidDistance*2)*100;
        
        %dist = myhandles.distanceBetweenPoints(myhandles.chosen_points(1),myhandles.chosen_points(2))/max(max(myhandles.distanceBetweenPoints))*100;
        distance = [sprintf('%1.1f',dist) ' %'];
        %distance = [num2str(myhandles.distanceBetweenPoints(myhandles.chosen_points(1),myhandles.chosen_points(2))/max(max(myhandles.distanceBetweenPoints))*100) ' %'];
        disp(['Distance between 2 points: ' distance]);
        
        set(handles.distanceLabel,'String',['Distance: ' distance]);
    else
        set(handles.distanceLabel,'String','')
    end
    
function Plot_MDS(positions,dim,labels,colors,selected_points,axis_handle,show_text,labelToDisplay)
    bool_points=false(length(labels),1);
    bool_points(selected_points(selected_points>0))=true;
    
    default_font_size=12;
    selected_font_size=16;
    font_sizes=default_font_size*ones(size(bool_points));
    font_sizes(bool_points)=selected_font_size;
    
    default_point_size=30;
    selected_point_size=200;
    point_sizes=default_point_size*ones(size(bool_points));
    point_sizes(bool_points)=selected_point_size;
    
    if(dim==2)
        scatter(axis_handle,positions(:,1),positions(:,2),point_sizes,colors,'filled');
        axis(axis_handle,'equal');
        if(show_text)
            for i=1:size(positions,1)
                % text(positions(i,1),positions(i,2),labels{i},...
                %     'BackgroundColor',colors(i,:),'FontSize',font_sizes(i),...
                %     'parent',axis_handle);
                %labels{i}
                if( strcmp('All',labelToDisplay) || strcmp(cell2mat(labels{i}),labelToDisplay))
                    text(positions(i,1),positions(i,2),['  ', cell2mat(labels{i})],...
                        'FontSize',font_sizes(i),...
                        'parent',axis_handle, 'Interpreter','none');
                end
            end
        end
        %       h = figure;
        %       %scatter(positions(:,1),positions(:,2),point_sizes,colors,'filled');
        %       hold on;
        %       for j=1:size(positions,1)
        %        plot(positions(j,1),positions(j,2),'o','MarkerFaceColor',colors(j,:),'MarkerSize',5,...
        %            'MarkerEdgeColor',colors(j,:));
        %       end
        %       hold off;
        %        axis equal;
        %        axis off;
    else
        
        rotate3d off;
        %rotate3d(axis_handle,'Enable','off');
        %         camPos = get(axis_handle, 'CameraPosition'); % camera position
        %         camTgt = get(axis_handle, 'CameraTarget'); % where the camera is pointing to
        %         camUpVect = get(axis_handle, 'CameraUpVector'); % camera 'up' vector
        
        
        scatter3(axis_handle,positions(:,1),positions(:,2),positions(:,3),point_sizes,colors,'filled');
        if(show_text)
            for i=1:size(positions,1)
                %        text(positions(i,1),positions(i,2),positions(i,3),labels{i},...
                %            'BackgroundColor',colors(i,:),'parent',axis_handle,...
                %            'FontSize',font_sizes(i));
                
                
                if( strcmp('All',labelToDisplay) || strcmp(cell2mat(labels{i}),labelToDisplay))
                    text(positions(i,1),positions(i,2),positions(i,3),...
                        ['  ', cell2mat(labels{i})],...
                        'parent',axis_handle, 'FontSize',font_sizes(i), 'Interpreter','none');
                end
            end
        end
        set(axis_handle,'XTickLabel','','YTickLabel','','ZTickLabel','');
        %  set(axis_handle, 'CameraPosition',camPos);
        % set(axis_handle, 'CameraTarget',camTgt);
        % set(axis_handle, 'CameraUpVector',camUpVect);
        %set(axis_handle,'XGrid','off','YGrid','off','ZGrid','off');
        
    end
    myhandles=getappdata(0,'myhandles');
    fnames=fieldnames(myhandles.grouped_metadata{1});
    if(myhandles.chosen_grouping_field~=1)
        grouping_field=fnames{myhandles.chosen_grouping_field};
    else
        grouping_field='Single Multi-Channel Image';
    end
    label_field=fnames{myhandles.label_field_number+1};
    color_field=fnames{myhandles.color_field_number+1};
    panel_string=['Point:' grouping_field...
        ', Color:' color_field];
    if(show_text)
        panel_string =[panel_string ', Label:' label_field];
    end
    set(myhandles.MDS_panel,'Title',panel_string);
    
    
    % --- Executes on button press in LegendCheckBox.
function LegendCheckBox_Callback(hObject, eventdata, handles)
    % hObject    handle to LegendCheckBox (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    myhandles=getappdata(0,'myhandles');
    mylegend=figure;
    set(mylegend, 'Name', 'MDS Plot Legend', 'NumberTitle', 'off',...
        'MenuBar', 'none', 'Resize', 'off', ...
        'Units', 'pixels', 'Position', [20 20 300 640],...
        'Color', [0 0 0]);
    uicontrol(...
        'Style','text', 'Parent', mylegend, ...
        'String', 'Legend', 'FontWeight',...
        'Bold','FontSize', 14, 'Units','pixels', ...
        'Position',[4 610 300 26],...
        'HorizontalAlignment', 'left',...
        'BackgroundColor', [0 0 0],...
        'ForegroundColor', [1 1 1]);
    for i=1:length(myhandles.group_labels)
        addElementToLegend(myhandles.category_colors(i,:), myhandles.group_labels{i}, i, mylegend);
    end
    set(handles.explorer,'WindowButtonDownFcn',{@MDSPlot_ButtonDownFcn,handles});
    
    
    
    % function addElementToLegend(color, string, nr, legendFig)
    % lmarg = 0.02;
    % startY = 0.99;
    % startY=startY-0.1*nr;
    % lightGray=[0.7,0.7,0.7];
    % uicontrol(...
    %     'Style','text', 'Parent', legendFig, ...
    %     'String', string, 'FontWeight',...
    %     'Bold','FontSize', 9, 'Units','normalized', ...
    %     'Position',[lmarg+0.05 startY 0.85 0.1],...
    %     'HorizontalAlignment', 'left',...
    %     'BackgroundColor', lightGray);
    % uicontrol( ...
    %     'Style','frame', 'Parent', legendFig, ...
    %     'Units','normalized',...
    %     'Position',[lmarg startY 0.04 0.08], ...
    %     'BackgroundColor', color);
    
function addElementToLegend(color, string, nr, legendFig)
    lmarg = 6;
    widthElement=20;
    widthText=500;
    heightElement=20;
    startY=600-(widthElement+5)*nr;
    backgroundColor=[0 0 0];
    uicontrol(...
        'Style','text', 'Parent', legendFig, ...
        'String', string, 'FontWeight',...
        'Bold','FontSize', 11, 'Units','pixels', ...
        'Position',[lmarg+widthElement+4 startY-2 widthText heightElement],...
        'HorizontalAlignment', 'left',...
        'BackgroundColor', backgroundColor,...
        'ForegroundColor', [1 1 1]);
    uicontrol( ...
        'Style','frame', 'Parent', legendFig, ...
        'Units','pixels',...
        'Position',[lmarg startY widthElement heightElement], ...
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
        set(handles.Show_MDS_Label, 'Checked', 'off');
    else
        set(gcbo, 'Checked', 'on');
        set(handles.Show_MDS_Label, 'Checked', 'on');
    end
    Plot_MDS(myhandles.mds_data,myhandles.mds_dim,myhandles.mds_text,myhandles.mds_colors,...
        myhandles.chosen_points,handles.MDSPlot,myhandles.show_mds_text,myhandles.labelToDisplay);
    
    
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
    MenuList_Checkmark(group_num,myhandles.Color_Points_By_Menu_Handles);
    UpdatePlotColors();
    myhandles=getappdata(0,'myhandles');
    Plot_MDS(myhandles.mds_data,myhandles.mds_dim,myhandles.mds_text,myhandles.mds_colors,...
        myhandles.chosen_points,handles.MDSPlot,myhandles.show_mds_text,myhandles.labelToDisplay);
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
        Update_Bar_Plot(handles);
    end
    
    
    
    
    %Label Point By
function label_by_callback(hObject, eventdata, handles,group_num)
    myhandles=getappdata(0,'myhandles');
    myhandles.label_field_number=group_num;
    setappdata(0,'myhandles',myhandles);
    MenuList_Checkmark(group_num,myhandles.Label_Points_By_Menu_Handles);
    UpdatePlotColors();
    myhandles=getappdata(0,'myhandles');
    uniqueLabelList=cell(size(myhandles.mds_text,1)+1,1);
    uniqueLabelList{1}='All';
    for i=1:size(myhandles.mds_text,1)
        if(~isempty(myhandles.mds_text{i}))
            uniqueLabelList{i+1}=cell2mat(myhandles.mds_text{i});
        end
    end
    uniqueLabelList=uniqueLabelList(~cellfun('isempty',uniqueLabelList));
    uniqueLabelList=unique(uniqueLabelList);
    uniqueLabelList=sort(uniqueLabelList);
    set(handles.labelCB,'String',uniqueLabelList);
    myhandles.labelToDisplay='All';
    setappdata(0,'myhandles',myhandles);
    %myhandles.mds_dim
    Plot_MDS(myhandles.mds_data, myhandles.mds_dim, myhandles.mds_text,...
        myhandles.mds_colors, myhandles.chosen_points,...
        handles.MDSPlot,myhandles.show_mds_text,myhandles.labelToDisplay);
    for point_number=1:2
        if(myhandles.chosen_points(point_number)~=0)
            
            switch(point_number)
                case 1
                    frame_handle=handles.uipanel7;
                case 2
                    frame_handle=handles.uipanel3;
            end
            fnames=fieldnames(myhandles.grouped_metadata{myhandles.chosen_points(point_number)});
            panel_text=myhandles.grouped_metadata{myhandles.chosen_points(point_number)}.(fnames{myhandles.chosen_grouping_field});
            if(iscell(panel_text))
                panel_text=panel_text{1};
            end
            if(length(panel_text)>43)
                panel_text=['...' panel_text(end-40:end)];
            end
            % class_text=myhandles.mds_text{myhandles.chosen_points(point_number)};
            set(frame_handle,'Title',panel_text);
        end
    end
    
    
    
    
    
    
function UpdatePlotColors()
    myhandles=getappdata(0,'myhandles');
    fnames=fieldnames(myhandles.grouped_metadata{1});
    label_field=fnames{myhandles.label_field_number+1};
    color_field=fnames{myhandles.color_field_number+1};
    group_vals=cell(1,myhandles.number_of_conditions);
    for condition=1:myhandles.number_of_conditions
        if(iscell(myhandles.grouped_metadata{condition}.(color_field)))
            group_vals{condition}=cell2mat(myhandles.grouped_metadata{condition}.(color_field));
        else
            if(isnumeric(myhandles.grouped_metadata{condition}.(color_field)))
                group_vals{condition}=myhandles.grouped_metadata{condition}.(color_field);
            else
                group_vals{condition}='Not Defined';
            end
        end
    end
    is_numeric=all(cellfun(@(x) isnumeric(x),group_vals));
    if(~is_numeric)
        if(all(~isnan(cellfun(@(x) str2double(x),group_vals))))
            is_numeric=true;
            group_vals=num2cell(cellfun(@(x) str2double(x),group_vals));
        end
    end
    myhandles.mds_text=cell(size(myhandles.superblock_profiles,1),1);
    myhandles.mds_colors=zeros(size(myhandles.superblock_profiles,1),3);
    if(~is_numeric)
        [colorsGroup,myhandles.group_labels]=grp2idx(group_vals);
        %colors=colormap(jet(max(colorsGroup)));
        colors=phenoripper_colormap(max(colorsGroup));
        myhandles.category_colors=colors;
        for i=1:myhandles.number_of_conditions
            myhandles.mds_colors(i,:)=colors(colorsGroup(i),:);
        end
    else
        %     valueArray=unique(cell2mat(group_vals));
        %     for i=1:size(group_vals,2)
        %       myhandles.group_labels{i}=num2str(group_vals{i});
        %     end
        vals=cellfun(@(x) x,group_vals);
        [colorsGroup,myhandles.group_labels]=grp2idx(vals);%used for the legend
        scaled_vals=(vals-min(vals))/(max(vals)-min(vals));
        if(any(isnan(scaled_vals)))
            scaled_vals(:)=0;
        end
        cmap=colormap(jet(64));
        color_num=round(scaled_vals*(size(cmap,1)-1))+1;
        myhandles.mds_colors=cmap(color_num,:);
        myhandles.category_colors=cmap(unique(color_num),:);%used for the legend
    end
    undefined_label=false;
    for i=1:myhandles.number_of_conditions
        if(~iscell(myhandles.grouped_metadata{i}.(label_field)))
            if(isnumeric(myhandles.grouped_metadata{i}.(label_field)))
                myhandles.mds_text{i}={num2str(myhandles.grouped_metadata{i}.(label_field))};
            else
                myhandles.mds_text{i}='';
                undefined_label=true;
            end
        else
            myhandles.mds_text{i}=myhandles.grouped_metadata{i}.(label_field);
        end
    end
    % if(undefined_label)
    %     warndlg([label_field ' is not defined for grouping by ' ...
    %         myhandles.grouping_fields{myhandles.chosen_grouping_field-1}]);
    % end
    setappdata(0,'myhandles',myhandles);
    
    
    % --------------------------------------------------------------------
function Data_Processing_Menu_Callback(hObject, eventdata, handles)
    % hObject    handle to Data_Processing_Menu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --------------------------------------------------------------------
function Bar_Plot_Menu_Callback(hObject, eventdata, handles)
    % hObject    handle to Bar_Plot_Menu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --------------------------------------------------------------------
function Group_By_Menu_Callback(hObject, eventdata, handles)
    % hObject    handle to Group_By_Menu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    %Replicate have same
function group_by_callback(hObject, eventdata, handles,group_num)
    
    myhandles=getappdata(0,'myhandles');
    % set(myhandles.statusbarHandlesExplorer.ProgressBar, 'Visible','on', 'Indeterminate','on');
    % myhandles.statusbarHandlesExplorer=statusbar(hObject,'Calculating MDS Result');
    
    if(isempty(find(myhandles.is_file_blacklisted==0,1)))
        myhandles.is_file_blacklisted=(false(size(myhandles.file_matrix,1),1));
    end
    setappdata(0,'myhandles',myhandles);
    %Apply filter if exist
    %otherwise will add a zero vector
    if(strcmp(get(handles.Enable_filter,'Checked'),'on'))
        filterFileList=getFileFilterListed();
        myhandles=getappdata(0,'myhandles');
        is_file_blacklistedBK=myhandles.is_file_blacklisted; %This is used as a backup of the discarded files
        % We then co-opt the blacklisting mechaninism used for discarding
        % files just for grouping based on filter images (and restore the
        % discarded files at the end of the function)
        myhandles.is_file_blacklisted = is_file_blacklistedBK | filterFileList';
        myhandles.filterFileList = filterFileList;
        setappdata(0,'myhandles',myhandles);
    end
    
    myhandles.chosen_grouping_field=group_num;
    MenuList_Checkmark(group_num,myhandles.Group_Points_By_Menu_Handles);
    
    ExplorerPosition = get(handles.explorer,'Position');
    WaitingDialog = waitbar(0,'Calculating Group...','Visible','off');
    set(WaitingDialog,'Units','Pixels','Position',...
        [ExplorerPosition(1)+ExplorerPosition(3)/2-200 (ExplorerPosition(2)+ExplorerPosition(4)/2)-40 400 80],...
        'Visible','on');
    
    [myhandles.grouped_metadata,myhandles.superblock_profiles,~,~,...
        myhandles.metadata_file_indices]=calculate_groups(...
        myhandles.chosen_grouping_field,myhandles.metadata,...
        myhandles.individual_superblock_profiles,...
        myhandles.individual_number_foreground_blocks,myhandles.is_file_blacklisted);
    myhandles.number_of_conditions=length(myhandles.grouped_metadata);
    setappdata(0,'myhandles',myhandles);
    ResetAxes(handles);
    myhandles=getappdata(0,'myhandles');
    waitbar(0.5,WaitingDialog,'Calculating MDS...');
    if(myhandles.number_of_conditions~=1)
        %     superblock_profiles=myhandles.superblock_profiles;
        %     superblock_profiles(isnan(superblock_profiles))=0;
        %     dists=pdist(superblock_profiles);
        %     myhandles.mds_data=mdscale(dists,3);
        myhandles.mds_data=Calculate_MDS(myhandles.superblock_profiles,3);
        B=mean(myhandles.superblock_profiles);
        myhandles.maxCentroidDistance =max(pdist2(myhandles.superblock_profiles,B,'euclidean'));
        %myhandles.distanceBetweenPoints=squareform(pdist(myhandles.superblock_profiles));
        set(handles.distanceLabel,'String','');
    else
        myhandles.mds_data=[0 0 0];
    end
    myhandles.chosen_points=[0 0];
    
    setappdata(0,'myhandles',myhandles);
    UpdatePlotColors();
    myhandles=getappdata(0,'myhandles');
    uniqueLabelList=cell(size(myhandles.mds_text,1)+1,1);
    uniqueLabelList{1}='All';
    for i=1:size(myhandles.mds_text,1)
        if(~isempty(myhandles.mds_text{i}))
            uniqueLabelList{i+1}=cell2mat(myhandles.mds_text{i});
        end
    end
    uniqueLabelList=uniqueLabelList(~cellfun('isempty',uniqueLabelList));
    uniqueLabelList=unique(uniqueLabelList);
    uniqueLabelList=sort(uniqueLabelList);
    set(handles.labelCB,'String',uniqueLabelList);
    myhandles.labelToDisplay='All';
    setappdata(0,'myhandles',myhandles);
    
    
    waitbar(0.75,WaitingDialog,'Ploting MDS...');
    Plot_MDS(myhandles.mds_data,myhandles.mds_dim,myhandles.mds_text,myhandles.mds_colors,...
        myhandles.chosen_points,handles.MDSPlot,myhandles.show_mds_text,myhandles.labelToDisplay);
    setappdata(0,'myhandles',myhandles);
    %set(gcf,'WindowButtonDownFcn',{@MDSPlot_ButtonDownFcn,handles});
    % for point_number=1:2
    %     if(myhandles.chosen_points(point_number)~=0)
    %
    %         switch(point_number)
    %             case 1
    %                 frame_handle=handles.uipanel7;
    %             case 2
    %                 frame_handle=handles.uipanel3;
    %         end
    %
    %         class_text=myhandles.mds_text{myhandles.chosen_points(point_number)};
    %         set(frame_handle,'Title',class_text);
    %     end
    % end
    %If apply filter is set to on
    if(strcmp(get(handles.Enable_filter,'Checked'),'on'))
        myhandles=getappdata(0,'myhandles');
        myhandles.is_file_blacklisted = is_file_blacklistedBK;
        setappdata(0,'myhandles',myhandles);
    end
    myhandles=getappdata(0,'myhandles');
    % set(myhandles.statusbarHandlesExplorer.ProgressBar, 'Visible','on', 'Indeterminate','off');
    % set(myhandles.statusbarHandlesExplorer.ProgressBar, 'Visible','off','StringPainted','off');
    % myhandles.statusbarHandlesExplorer=statusbar(hObject,'Done');
    setappdata(0,'myhandles',myhandles);
    
    close(WaitingDialog);
    
function mds_positions=Calculate_MDS(raw_profiles,dim)
    max_number_of_points_for_mds=450;
    nan_pos=isnan(raw_profiles);
    raw_profiles(nan_pos)=rand(nnz(nan_pos),1)/100;
    if(size(raw_profiles)<max_number_of_points_for_mds)
        try
            
            mds_positions=mdscale(pdist(raw_profiles),dim,'criterion','stress');
            disp('Normal MDS performed');
        catch
            try
                mds_positions=mdscale(pdist(raw_profiles),dim,'criterion','sstress');
                disp('Normal MDS failed:SStress MDS performed');
                
            catch
                [pca_vec pca_scores]=princomp(raw_profiles);
                mds_positions=pca_scores(:,1:dim);
                disp('MDS failed, Using PCA');
            end
        end
    else
        disp('More than 300 points: Using PCA');
        [pca_vec pca_scores]=princomp(raw_profiles);
        mds_positions=pca_scores(:,1:dim);
    end
    
    
    % --- Executes on button press in CalcSB_1_Button
    % Super Block Calculation Buton
function CalcSB_1_Button_Callback(hObject, eventdata, handles)
    % hObject    handle to CalcSB_1_Button (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    myhandles=getappdata(0,'myhandles');
    image_num=myhandles.file_number1;
    %filenames=myhandles.grouped_metadata{myhandles.chosen_points(2)}.files_in_group(image_num,:);
    
    filenames= myhandles.grouped_metadata{myhandles.chosen_points(2)}.files_in_group(image_num,:,1);
    rescale_params= myhandles.grouped_metadata{myhandles.chosen_points(2)}.files_in_group(image_num,:,2);
    filenames=cellfun(@(x) concatenateString(myhandles.rootDir,x),...
        filenames,'UniformOutput',false);
    results=rip_image(filenames,myhandles.global_data,myhandles.marker_scales,...
        myhandles.include_background_superblocks,myhandles.foreground_channels,...
        myhandles.analyze_channels,rescale_params);
    myhandles.image1_in_sb_states=results.image_superblock_states;
    myhandles.distance_to_superblock_centroid1=results.distance_to_superblock_centroid;
    
    image_num=myhandles.file_number2;
    %filenames=myhandles.grouped_metadata{myhandles.chosen_points(1)}.files_in_group(image_num,:);
    filenames= myhandles.grouped_metadata{myhandles.chosen_points(1)}.files_in_group(image_num,:,1);
    filenames=cellfun(@(x) concatenateString(myhandles.rootDir,x),...
        filenames,'UniformOutput',false);
    rescale_params= myhandles.grouped_metadata{myhandles.chosen_points(2)}.files_in_group(image_num,:,2);
    results=rip_image(filenames,myhandles.global_data,myhandles.marker_scales,...
        myhandles.include_background_superblocks,myhandles.foreground_channels,...
        myhandles.analyze_channels,rescale_params);
    myhandles.image2_in_sb_states=results.image_superblock_states;
    myhandles.distance_to_superblock_centroid2=results.distance_to_superblock_centroid;
    number_of_bars=length(myhandles.bar_order);
    popup_string=cell(number_of_bars,1);
    for i=1:number_of_bars
        popup_string{i}=num2str(i);
    end
    myhandles.is_sb_in_images_calculated=true;
    setappdata(0,'myhandles',myhandles);
    
    
function Calculate_Superblocks_In_Images()
    myhandles=getappdata(0,'myhandles');
    image_num=myhandles.file_number1;
    myhandles.image_in_sb_states=cell(2,1);
    %filenames=myhandles.grouped_metadata{myhandles.chosen_points(2)}.files_in_group(image_num,:);
    
    filenames= myhandles.grouped_metadata{myhandles.chosen_points(2)}.files_in_group(image_num,:,1);
    rescale_params= myhandles.grouped_metadata{myhandles.chosen_points(2)}.files_in_group(image_num,:,2);
    filenames=cellfun(@(x) concatenateString(myhandles.rootDir,x),...
        filenames,'UniformOutput',false);
    results=rip_image(filenames,myhandles.global_data,myhandles.marker_scales,...
        myhandles.include_background_superblocks,myhandles.foreground_channels,...
        myhandles.analyze_channels,rescale_params);
    myhandles.image_in_sb_states{1}=results.image_superblock_states;
    myhandles.distance_to_superblock_centroid1=results.distance_to_superblock_centroid;
    
    image_num=myhandles.file_number2;
    %filenames=myhandles.grouped_metadata{myhandles.chosen_points(1)}.files_in_group(image_num,:);
    filenames= myhandles.grouped_metadata{myhandles.chosen_points(1)}.files_in_group(image_num,:,1);
    filenames=cellfun(@(x) concatenateString(myhandles.rootDir,x),...
        filenames,'UniformOutput',false);
    rescale_params= myhandles.grouped_metadata{myhandles.chosen_points(2)}.files_in_group(image_num,:,2);
    results=rip_image(filenames,myhandles.global_data,myhandles.marker_scales,...
        myhandles.include_background_superblocks,myhandles.foreground_channels,...
        myhandles.analyze_channels,rescale_params);
    myhandles.image_in_sb_states{2}=results.image_superblock_states;
    myhandles.distance_to_superblock_centroid2=results.distance_to_superblock_centroid;
    number_of_bars=length(myhandles.bar_order);
    popup_string=cell(number_of_bars,1);
    for i=1:number_of_bars
        popup_string{i}=num2str(i);
    end
    
    myhandles.is_sb_in_images_calculated=true;
    setappdata(0,'myhandles',myhandles);
    
    
function Show_SB_In_Image(img_num,sb_number,handles)
    
    myhandles=getappdata(0,'myhandles');
    mask=(myhandles.image_in_sb_states{img_num}==sb_number);
    point_number=myhandles.chosen_points(3-img_num);
    
    %Image Info
    block_size=myhandles.global_data.block_size;
    filenames=cellfun(@(x) concatenateString(myhandles.rootDir,x),...
        myhandles.grouped_metadata{point_number}.files_in_group(1,:),...
        'UniformOutput',false);
    info=imfinfo(filenames{1});
    xres=info.Height;
    x_offset=floor(rem(xres,block_size)/2)+1;
    
    
    %Display Image
    fnames=fieldnames(myhandles.grouped_metadata{point_number});
    panel_text=myhandles.grouped_metadata{point_number}.(fnames{myhandles.chosen_grouping_field});
    if(iscell(panel_text))
        panel_text=panel_text{1};
    end
    if(length(panel_text)>43)
        panel_text=['...' panel_text(end-40:end)];
    end
    
    [row,col]=find(mask);
    fg_mask=(myhandles.image_in_sb_states{img_num}>0);
    if(img_num==1)
        ShowImages(myhandles.grouped_metadata{point_number}.files_in_group,...
            myhandles.file_number1,handles.axes2, myhandles.mds_colors(point_number,:),...
            panel_text,handles.uipanel3,[]);
        distances=myhandles.distance_to_superblock_centroid1(row,col);
        all_distances=myhandles.distance_to_superblock_centroid1(fg_mask);
        img_handle=handles.axes2;
    else
        ShowImages(myhandles.grouped_metadata{point_number}.files_in_group,...
            myhandles.file_number2,handles.axes3, myhandles.mds_colors(point_number,:),...
            panel_text,handles.uipanel7,[]);
        distances=myhandles.distance_to_superblock_centroid2(row,col);
        all_distances=myhandles.distance_to_superblock_centroid2(fg_mask);
        img_handle=handles.axes3;
    end
    
    %Display Superblocks
    [~,sb_order]=sort(distances);
    
    for i=1:number_to_show(length(row),myhandles.superblocks_shown_choice)
        i1=sb_order(i);
        scale_distance=sum(all_distances>distances(i1))/length(all_distances);
        color=[scale_distance scale_distance scale_distance];
        x1=x_offset+(row(i1)-2)*block_size;
        y1=x_offset+(col(i1)-2)*block_size;
        x2=x1;
        y2=x_offset+(col(i1)+1)*block_size;
        x3=x_offset+(row(i1)+1)*block_size;
        y3=y1;
        x4=x3;
        y4=y2;
        
        line([y1,y2],[x1,x2],'Color',color,'Parent',img_handle);
        line([y2,y4],[x2,x4],'Color',color,'Parent',img_handle);
        line([y3,y4],[x3,x4],'Color',color,'Parent',img_handle);
        line([y1,y3],[x1,x3],'Color',color,'Parent',img_handle);
        
        
        
    end
    
    
    
    % --- Executes on button press in PreviousImage1_pushbutton.
function PreviousImage1_pushbutton_Callback(hObject, eventdata, handles)
    % hObject    handle to PreviousImage1_pushbutton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    myhandles=getappdata(0,'myhandles');
    myhandles.file_number1=max(1,myhandles.file_number1-1);
    point_number=myhandles.chosen_points(2);
    UpdateMetadata(handles.Point1Info,point_number,myhandles.file_number1);
    fnames=fieldnames(myhandles.grouped_metadata{point_number});
    panel_text=myhandles.grouped_metadata{point_number}.(fnames{myhandles.chosen_grouping_field});
    if(iscell(panel_text))
        panel_text=panel_text{1};
    end
    if(length(panel_text)>43)
        panel_text=['...' panel_text(end-40:end)];
    end
    ShowImages(myhandles.grouped_metadata{point_number}.files_in_group,...
        myhandles.file_number1,handles.axes2, myhandles.mds_colors(point_number,:),...
        panel_text,handles.uipanel3,[]);
    myhandles.is_sb_in_images_calculated=false;
    setappdata(0,'myhandles',myhandles);
    
    % --- Executes on button press in PreviousImage2_pushbutton.
function PreviousImage2_pushbutton_Callback(hObject, eventdata, handles)
    % hObject    handle to PreviousImage2_pushbutton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    myhandles=getappdata(0,'myhandles');
    myhandles.file_number2=max(1,myhandles.file_number2-1);
    point_number=myhandles.chosen_points(1);
    UpdateMetadata(handles.Point2Info,point_number,myhandles.file_number2);
    fnames=fieldnames(myhandles.grouped_metadata{point_number});
    panel_text=myhandles.grouped_metadata{point_number}.(fnames{myhandles.chosen_grouping_field});
    if(iscell(panel_text))
        panel_text=panel_text{1};
    end
    if(length(panel_text)>43)
        panel_text=['...' panel_text(end-40:end)];
    end
    ShowImages(myhandles.grouped_metadata{point_number}.files_in_group,...
        myhandles.file_number2,handles.axes3, myhandles.mds_colors(point_number,:),...
        panel_text,handles.uipanel7,[]);
    myhandles.is_sb_in_images_calculated=false;
    setappdata(0,'myhandles',myhandles);
    
    
    % --- Executes on button press in NextImage2_pushbutton.
function NextImage2_pushbutton_Callback(hObject, eventdata, handles)
    % hObject    handle to NextImage2_pushbutton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    myhandles=getappdata(0,'myhandles');
    point_number=myhandles.chosen_points(1);
    number_of_images=size(myhandles.grouped_metadata{point_number}.files_in_group,1);
    myhandles.file_number2=min(number_of_images,myhandles.file_number2+1);
    UpdateMetadata(handles.Point2Info,point_number,myhandles.file_number2);
    fnames=fieldnames(myhandles.grouped_metadata{point_number});
    panel_text=myhandles.grouped_metadata{point_number}.(fnames{myhandles.chosen_grouping_field});
    if(iscell(panel_text))
        panel_text=panel_text{1};
    end
    if(length(panel_text)>43)
        panel_text=['...' panel_text(end-40:end)];
    end
    ShowImages(myhandles.grouped_metadata{point_number}.files_in_group,...
        myhandles.file_number2,handles.axes3, myhandles.mds_colors(point_number,:),...
        panel_text,handles.uipanel7,[]);
    myhandles.is_sb_in_images_calculated=false;
    setappdata(0,'myhandles',myhandles);
    
    
    % --- Executes on button press in NextImage1_pushbotton.
function NextImage1_pushbotton_Callback(hObject, eventdata, handles)
    % hObject    handle to NextImage1_pushbotton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    myhandles=getappdata(0,'myhandles');
    point_number=myhandles.chosen_points(2);
    number_of_images=size(myhandles.grouped_metadata{point_number}.files_in_group,1);
    myhandles.file_number1=min(number_of_images,myhandles.file_number1+1);
    UpdateMetadata(handles.Point1Info,point_number,myhandles.file_number1);
    fnames=fieldnames(myhandles.grouped_metadata{point_number});
    panel_text=myhandles.grouped_metadata{point_number}.(fnames{myhandles.chosen_grouping_field});
    if(iscell(panel_text))
        panel_text=panel_text{1};
    end
    if(length(panel_text)>43)
        panel_text=['...' panel_text(end-40:end)];
    end
    ShowImages(myhandles.grouped_metadata{point_number}.files_in_group,...
        myhandles.file_number1,handles.axes2, myhandles.mds_colors(point_number,:),...
        panel_text,handles.uipanel3,[]);
    myhandles.is_sb_in_images_calculated=false;
    setappdata(0,'myhandles',myhandles);
    
    
function UpdateMetadata(text_handle,point_number,image_number)
    myhandles=getappdata(0,'myhandles');
    
    metadata=myhandles.metadata{myhandles.metadata_file_indices{point_number}(image_number)};
    fnames=fieldnames(metadata);
    metadata_text=cell(length(fnames)-1);
    metadata_text{1}=['File Name =' metadata.(fnames{2})];
    for field=3:length(fnames)
        metadata_text{field-1}=[fnames{field} '=' metadata.(fnames{field})];
    end
    set(text_handle,'String',metadata_text);
    
    
    
    % --------------------------------------------------------------------
function MDS_Dim_Menu_Callback(hObject, eventdata, handles,dim)
    % hObject    handle to MDS_Dim_Menu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    myhandles=getappdata(0,'myhandles');
    myhandles.mds_dim=dim;
    MenuList_Checkmark(myhandles.mds_dim-1,myhandles.MDS_Dim_Menu_Handles);
    myhandles.mds_data=Calculate_MDS(myhandles.superblock_profiles,myhandles.mds_dim);
    %myhandles.distanceBetweenPoints=squareform(pdist(myhandles.superblock_profiles));
    B=mean(myhandles.superblock_profiles);
    %myhandles.centroidDistance =  pdist2(myhandles.superblock_profiles,B,'euclidean');
    myhandles.maxCentroidDistance =max(pdist2(myhandles.superblock_profiles,B,'euclidean'));
    set(handles.distanceLabel,'String','');
    setappdata(0,'myhandles',myhandles);
    set(handles.MDS_Rotatable,'Visible','on');
    Plot_MDS(myhandles.mds_data,myhandles.mds_dim,myhandles.mds_text,myhandles.mds_colors,...
        myhandles.chosen_points,handles.MDSPlot,myhandles.show_mds_text,myhandles.labelToDisplay);
    
    % --------------------------------------------------------------------
function BarPlot_Method_Menu_Callback(hObject, eventdata, handles)
    % hObject    handle to BarPlot_Method_Menu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
function Barplot_Method_Chosen_Callback(hObject, eventdata,handles,method)
    myhandles=getappdata(0,'myhandles');
    myhandles.bar_plot_method=method;
    MenuList_Checkmark(myhandles.bar_plot_method,...
        myhandles.Barplot_Method_Chosen_Handles);
    myhandles.is_sb_in_images_calculated=false;
    setappdata(0,'myhandles',myhandles);
    
    
    point_number=myhandles.chosen_points(2);
    fnames=fieldnames(myhandles.grouped_metadata{point_number});
    panel_text=myhandles.grouped_metadata{point_number}.(fnames{myhandles.chosen_grouping_field});
    if(iscell(panel_text))
        panel_text=panel_text{1};
    end
    if(length(panel_text)>43)
        panel_text=['...' panel_text(end-40:end)];
    end
    ShowImages(myhandles.grouped_metadata{point_number}.files_in_group,...
        myhandles.file_number1,handles.axes2, myhandles.mds_colors(point_number,:),...
        panel_text,handles.uipanel3,[]);
    
    point_number=myhandles.chosen_points(1);
    panel_text=myhandles.grouped_metadata{point_number}.(fnames{myhandles.chosen_grouping_field});
    if(iscell(panel_text))
        panel_text=panel_text{1};
    end
    if(length(panel_text)>43)
        panel_text=['...' panel_text(end-40:end)];
    end
    ShowImages(myhandles.grouped_metadata{point_number}.files_in_group,...
        myhandles.file_number1,handles.axes3, myhandles.mds_colors(point_number,:),...
        panel_text,handles.uipanel7,[]);
    
    
    if(all(myhandles.chosen_points~=0))
        Update_Bar_Plot(handles);
    end
    
    
function DiscardFrame_Callback(hObject, eventdata, panel_number)
    choice = questdlg({'Are you sure you want to discard this frame?';...
        'To see effect you need to run grouping again by clicking on the menu : ';...
        'Data Processing>Replicate have same><Your grouping>'}, ...
        'Discard Frame?','Yes', 'No','No');
    switch choice
        case 'Yes'
            myhandles=getappdata(0,'myhandles');
            if(panel_number==1)
                point_number=myhandles.chosen_points(2);
                file_number=myhandles.metadata_file_indices{point_number}(myhandles.file_number1);
                myhandles.is_file_blacklisted(file_number)=true;
            else
                point_number=myhandles.chosen_points(1);
                file_number=myhandles.metadata_file_indices{point_number}(myhandles.file_number2);
                myhandles.is_file_blacklisted(file_number)=true;
            end
            setappdata(0,'myhandles',myhandles);
    end
    
    
    
function ResetAxes(handles)
    myhandles=getappdata(0,'myhandles');
    cla(handles.axes2);
    set(handles.axes2,'Color',[0 0 0]);
    cla(handles.axes3);
    set(handles.axes3,'Color',[0 0 0]);
    myhandles.is_sb_in_images_calculated=false;
    
    if isfield(handles,'BarAxes')
        cla(handles.BarAxes);
        set(handles.BarAxes,'Color',[0 0 0]);
    end
    
    if isfield(myhandles,'bar_legend_axis')&&ishandle(myhandles.bar_legend_axis)
        cla(myhandles.bar_legend_axis);
        set(myhandles.bar_legend_axis,'Color',[0 0 0]);
    end
    if isfield(myhandles,'temp_handles')
        for i=1:length(myhandles.temp_handles)
            if(ishandle(myhandles.temp_handles(i)))
                delete(myhandles.temp_handles(i));
            end
        end
    end
   set(handles.show_sb_examples_instructions_text,'Visible','off');
    myhandles.temp_handles=[];
    myhandles.is_sb_in_images_calculated=false;
    setappdata(0,'myhandles',myhandles);
    set(handles.Point1Info,'String','');
    set(handles.Point2Info,'String','');
    set(handles.uipanel7,'Title','','HighlightColor',[1 1 1],...
        'ShadowColor',[1 1 1]) ;
    set(handles.uipanel3,'Title','','HighlightColor',[1 1 1],...
        'ShadowColor',[1 1 1]);
    
    
    
    % --------------------------------------------------------------------
function Images_Menu_Callback(hObject, eventdata, handles)
    % hObject    handle to Images_Menu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --------------------------------------------------------------------
function Superblocks_Shown_Menu_Callback(hObject, eventdata, handles)
    % hObject    handle to Superblocks_Shown_Menu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
function superblocks_shown_callback(hObject,eventdata,handles,number_chosen)
    myhandles=getappdata(0,'myhandles');
    myhandles.superblocks_shown_choice=number_chosen;
    MenuList_Checkmark(myhandles.superblocks_shown_choice,myhandles.Superblocks_Shown_Menu_Handles);
    setappdata(0,'myhandles',myhandles);
    
function ns=number_to_show(n,choice)
    switch(choice)
        case 1
            ns=min(5,n);
        case 2
            ns=round(0.3*n);
        case 3
            ns=round(0.6*n);
        case 4
            ns=n;
    end
    
function MenuList_Checkmark(chosen_item,menu_handles_list)
    number_of_items=length(menu_handles_list);
    for i=1:number_of_items
        if(i==chosen_item)
            set(menu_handles_list(i),'Checked','on');
        else
            set(menu_handles_list(i),'Checked','off');
        end
    end
    
function MenuList_Checkmark_By_Handle(chosen_item_handle,menu_handles_list)
    number_of_items=length(menu_handles_list);
    for i=1:number_of_items
        if(menu_handles_list(i)==chosen_item_handle)
            set(menu_handles_list(i),'Checked','on');
        else
            try
                set(menu_handles_list(i),'Checked','off');
            catch
                disp(num2str(menu_handles_list(i)));
            end
        end
    end
    
    % --------------------------------------------------------------------
function Clustergram_Menu_Callback(hObject, eventdata, handles)
    % hObject    handle to Clustergram_Menu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --------------------------------------------------------------------
function Launch_Clustergram_Menu_Callback(hObject, eventdata, handles)
    % hObject    handle to Launch_Clustergram_Menu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    myhandles=getappdata(0,'myhandles');
    switch(myhandles.clustergram_SB_diplayed_method)
        case 1
            preserved_columns=1:size(myhandles.superblock_profiles,2);
        case 2
            preserved_columns=find(max(myhandles.superblock_profiles)>0.05);
            
        case 3
            preserved_columns=find(max(myhandles.superblock_profiles)>0.10);
            
    end
    
    superblock_profiles=myhandles.superblock_profiles(:,preserved_columns);
    superblock_representatives=cell(length(preserved_columns),...
        size(myhandles.global_data.superblock_representatives,2));
    for i=1:length(preserved_columns)
        for j=1: size(myhandles.global_data.superblock_representatives,2)
            superblock_representatives{i,j}=...
                myhandles.global_data.superblock_representatives{preserved_columns(i),j};
        end
    end
    
    
    
    RGB_centroids=myhandles.global_data.RGB_centroids;
    RGB_centroids=[zeros(1,size(RGB_centroids,2));RGB_centroids];
    block_centroids=myhandles.global_data.block_centroids;
    block_centroids=[zeros(1,size(block_centroids,2));block_centroids] ;block_centroids(1,1)=1;
    superblock_centroids=myhandles.global_data.superblock_centroids(preserved_columns,:);
    sb_marker_profiles=superblock_centroids*block_centroids*RGB_centroids;
    display_colors=myhandles.display_colors;
    % markers_shown=true(length(myhandles.display_colors),1);
    % counter=1;
    % for i=1:length(myhandles.display_colors)
    %    switch myhandles.display_colors{i}
    %        case {'','-' ,'None'}, markers_shown(i)=false;
    %    otherwise
    %        display_colors{counter}=myhandles.display_colors{i};
    %        counter=counter+1;
    %    end
    %
    % end
    
    %sb_marker_profiles=zeros(myhandles.number_of_superblocks,length(myhandles.display_colors));
    % for i=1:myhandles.number_of_superblocks
    %     img=myhandles.global_data.superblock_representatives{i};
    %     for j=1:length(myhandles.display_colors)
    %         temp=img(:,:,j);
    %         sb_marker_profiles(i,j)=mean(temp(:));
    %     end
    % end
    for i=1:size(sb_marker_profiles,2)
        sb_marker_profiles(:,i)= sb_marker_profiles(:,i)/max(sb_marker_profiles(:,i));
        %sb_marker_profiles(:,i)= sb_marker_profiles(:,i)/myhandles.marker_scales(i,2);
    end
    
    %sb_marker_profiles=sb_marker_profiles(:,find(markers_shown));
    myhandles.cg_sb_ordering_method_type
    switch(myhandles.cg_sb_ordering_method_type)
        case 1
            sb_ordering_score=[];
            use_sb_dendrogram=true;
        case 2
            sb_ordering_score=sb_marker_profiles(:,myhandles.cg_sb_ordering_method_number);
            use_sb_dendrogram=false;
        case 3
            sb_ordering_score=sb_marker_profiles(:,myhandles.cg_sb_ordering_method_number);
            use_sb_dendrogram=true;
    end
    
    
    
    pheno_cluster(superblock_profiles,superblock_representatives,...
        myhandles.mds_text,myhandles.mds_colors...
        ,myhandles.marker_scales,display_colors,sb_marker_profiles,...
        myhandles.global_data.block_size,sb_ordering_score,use_sb_dendrogram);
    
    
function Clustergram_SB_Displayed_Menu_Handles_Callback(hObject,eventdata,handles,number_chosen)
    myhandles=getappdata(0,'myhandles');
    myhandles.clustergram_SB_diplayed_method=number_chosen;
    MenuList_Checkmark(myhandles.clustergram_SB_diplayed_method,...
        myhandles.Clustergram_SB_Displayed_Menu_Handles);
    setappdata(0,'myhandles',myhandles);
    
    
    % --------------------------------------------------------------------
function Clustergram_SB_Ordering_Menu_Callback(hObject, eventdata, handles)
    % hObject    handle to Clustergram_SB_Ordering_Menu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --------------------------------------------------------------------
function Clustergram_Point_Ordering_Menu_Callback(hObject, eventdata, handles)
    % hObject    handle to Clustergram_Point_Ordering_Menu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --------------------------------------------------------------------
function CG_SB_Optimal_Order_Menu_Callback(hObject, eventdata, handles)
    % hObject    handle to CG_SB_Optimal_Order_Menu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --------------------------------------------------------------------
function CG_SB_Marker_Level_Order_Menu_Callback(hObject, eventdata, handles)
    % hObject    handle to CG_SB_Marker_Level_Order_Menu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
function cg_sb_ordering_callback(hObject,eventdata,handles,method_type,method_number)
    myhandles=getappdata(0,'myhandles');
    myhandles.cg_sb_ordering_method_type=method_type;
    myhandles.cg_sb_ordering_method_number=method_number;
    MenuList_Checkmark_By_Handle(hObject,...
        myhandles.Clustergram_SB_Ordering_Menu_Handles);
    setappdata(0,'myhandles',myhandles);
    
    
    % --------------------------------------------------------------------
function CG_SB_DG_Marker_Level_Order_Menu_Callback(hObject, eventdata, handles)
    % hObject    handle to CG_SB_DG_Marker_Level_Order_Menu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --------------------------------------------------------------------
function Discard_Empty_Frames_Menu_Callback(hObject, eventdata, handles)
    % hObject    handle to Discard_Empty_Frames_Menu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    myhandles=getappdata(0,'myhandles');
    myhandles.is_file_blacklisted(myhandles.individual_number_foreground_blocks<30)=true;
    setappdata(0,'myhandles',myhandles);
    group_by_callback(hObject, eventdata, handles,myhandles.chosen_grouping_field);
    
    
function result=concatenateString(string1,string2)
    if(isstr(string2))
        result=[string1 string2];
    else
        result=string2;
    end
    
    
    % --------------------------------------------------------------------
function Export_menu_Callback(hObject, eventdata, handles)
    % hObject    handle to Export_menu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --------------------------------------------------------------------
function Export_figures_Callback(hObject, eventdata, handles)
    % hObject    handle to Export_figures (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --------------------------------------------------------------------
function Export_data_Callback(hObject, eventdata, handles)
    %fileName='/tmp/test.txt';
    lastPath=load_last_path('save');
    if(~exist(char(lastPath),'dir'))
        [filename,pathname]=uiputfile();
    else
        [filename,pathname]=uiputfile('*.tsv','Save the PhenoRipped data into TSV format', lastPath);
    end
    if(~exist(char(pathname),'dir'))
        filename='';
        warndlg('Invalid Root Directory');
    else
        save_last_path(pathname,'save');
    end
    myhandles=getappdata(0,'myhandles');
    nrGroup=size(myhandles.grouped_metadata,2);
    nrBlockType=size(myhandles.superblock_profiles,2);
    %Open the file
    fid =fopen([pathname filename],'w');
    if(fid<0)
        isSucceed=false;
        return;
    end
    %Write the header
    fieldNames=fieldnames(myhandles.grouped_metadata{1});
    if(strcmpi(fieldNames{myhandles.chosen_grouping_field},'files_in_group'))
        fprintf(fid, '%s\t', ['Grouped by Files']);
    else
        fprintf(fid, '%s\t', ['Grouped by ' fieldNames{myhandles.chosen_grouping_field}]);
    end
    
    for i=2:size(fieldNames,1)
        if(i<size(fieldNames,1))
            fprintf(fid, '%s,', fieldNames{i});
        else
            fprintf(fid, '%s\t', fieldNames{i});
        end
    end
    for i=1:nrBlockType
        fprintf(fid, '%s\t', ['sb' num2str(i)]);
    end
    fprintf(fid, '%s\r\n', '');
    
    %For each group, write the metadata and the superblock values
    for i=1:nrGroup
        %Write the group label
        %If it is a file_name
        if(strcmpi(fieldNames{myhandles.chosen_grouping_field},'files_in_group'))
            filePosition=find(myhandles.analyze_channels==1);
            for j=1:length(filePosition)
                if(j==1)
                    fileNames=myhandles.grouped_metadata{i}.(fieldNames{myhandles.chosen_grouping_field}){filePosition(j)};
                else
                    fileNames=[fileNames ' AND ' myhandles.grouped_metadata{i}.(fieldNames{myhandles.chosen_grouping_field}){filePosition(j)}];
                end
            end
            fprintf(fid, '%s\t', fileNames);
        else
            fprintf(fid, '%s\t', myhandles.grouped_metadata{i}.(...
                fieldNames{myhandles.chosen_grouping_field}){1} );
        end
        %Write the metadata values
        for j=2:size(fieldNames,1)
            if(j<size(fieldNames,1))
                if (isempty(myhandles.grouped_metadata{i}.(fieldNames{j})))
                    fprintf(fid, '%s,', myhandles.grouped_metadata{i}.(fieldNames{j}));
                else
                    fprintf(fid, '%s,', myhandles.grouped_metadata{i}.(fieldNames{j}){1});
                end
            else
                if isnumeric(myhandles.grouped_metadata{i}.(fieldNames{j}))
                    fprintf(fid, '%f\t', myhandles.grouped_metadata{i}.(fieldNames{j}));
                else
                    if (isempty(myhandles.grouped_metadata{i}.(fieldNames{j})))
                        fprintf(fid, '%s,', myhandles.grouped_metadata{i}.(fieldNames{j}));
                    else
                        fprintf(fid, '%s\t', myhandles.grouped_metadata{i}.(fieldNames{j}){1});
                    end
                end
            end
        end
        %Write the superblock values
        for j=1:nrBlockType
            fprintf(fid, '%s\t', num2str(myhandles.superblock_profiles(i,j)));
        end
        %Write a new line
        fprintf(fid, '%s\r\n', '');
    end
    isSucceed=fclose(fid);
    if(~isSucceed)
        msgbox(['Data have been exported into ' pathname filename]);
    else
    end
    
    
    
function Export_mds_Callback(hObject, eventdata, handles)
    exportAxes('Save the MDS plot into PNG',handles.MDSPlot);
    
    
function Export_point1_Callback(hObject, eventdata, handles)
    exportAxes('Save the Point 1 Image into PNG',handles.axes2);
    
    
function Export_point2_Callback(hObject, eventdata, handles)
    exportAxes('Save the Point 2 Image into PNG',handles.axes3);
    
    
function Export_histogram_Callback(hObject, eventdata, handles)
    exportAxes('Save the Histogram into PNG',handles.BarAxes);
    
function exportAxes(title,axis)
    lastPath=load_last_path('save');
    if(~exist(char(lastPath),'dir'))
        [filename,pathname]=uiputfile();
    else
        [filename,pathname]=uiputfile('*.png',title, lastPath);
    end
    if(~exist(char(pathname),'dir'))
        filename='';
        warndlg('Invalid Root Directory');
    else
        save_last_path(pathname,'save');
    end
    fig2 = figure('visible','off');
    % copy axes into the new figure
    newax = copyobj(axis,fig2);
    set(newax, 'units', 'normalized', 'position', [0.13 0.11 0.775 0.815]);
    old_mode = get(fig2, 'PaperPositionMode');
    set(fig2, 'PaperPositionMode', 'auto');
    print(fig2, '-dpng', [pathname filename]);
    set(fig2, 'PaperPositionMode', old_mode);
    close(fig2) % clean up by closing it
    msgbox(['Image as been saved in ' pathname filename]);
    
    
    % --------------------------------------------------------------------
function Show_Point_Callback(hObject, eventdata, handles)
    % hObject    handle to Show_Point (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --------------------------------------------------------------------
function Filter_Callback(hObject, eventdata, handles)
    % hObject    handle to Filter (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --------------------------------------------------------------------
function Enable_filter_Callback(hObject, eventdata, handles)
    % hObject    handle to Enable_filter (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    if(strcmp(get(hObject,'Checked'),'on'))
        set(hObject,'Checked','off');
        myhandles=getappdata(0,'myhandles');
        group_by_callback([], [], handles,myhandles.chosen_grouping_field);
    else
        myhandles=getappdata(0,'myhandles');
        if isfield(myhandles,'filterMatrix')==0
            warndlg('You need to edit the filter in order to use it');
            return;
        else
            set(hObject,'Checked','on');
            %applyFilter(handles);
            group_by_callback([], [], handles,myhandles.chosen_grouping_field);
        end
    end
    
    
    % --------------------------------------------------------------------
function EditFilter_Callback(hObject, eventdata, handles)
    % hObject    handle to EditFilter (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    %Launch the Wizard and wait
    myhandles_BK=getappdata(0,'myhandles');
    filter_gui;
    uiwait;
    drawnow;
    %If wizard has been stopped before the end,
    % restore the previous myhandle and return
    myhandles=getappdata(0,'myhandles');
    % if isfield(myhandles,'filterMatrix')==0
    %   setappdata(0,'myhandles',myhandles_BK);
    %   return;
    % else
    %applyFilter(handles);
    set(handles.Enable_filter,'Checked','on');
    group_by_callback([], [], handles,myhandles.chosen_grouping_field);
    % end
    
    %Generate the filter on the image set and replot the MDS plot
    %See filter matrix format in useFilterCallBack() from filter_gui.m
    %   function applyFilter(handles)
    %     myhandles=getappdata(0,'myhandles');
    %
    %     filterFileList=getFileFilterListed();
    %     is_file_blacklistedBK=myhandles.is_file_blacklisted;
    %     myhandles.is_file_blacklisted = is_file_blacklistedBK | filterFileList';
    %     myhandles.filterFileList = filterFileList;
    %     setappdata(0,'myhandles',myhandles);
    %     group_by_callback([], [], handles,myhandles.chosen_grouping_field);
    %     myhandles=getappdata(0,'myhandles');
    %     myhandles.is_file_blacklisted = is_file_blacklistedBK;
    %     setappdata(0,'myhandles',myhandles);
    
function filterFileList=getFileFilterListed()
    myhandles=getappdata(0,'myhandles');
    groupList = fieldnames(myhandles.grouped_metadata{1});
    groupList = groupList(2:end);
    
    filterFileList=[];
    if ~isfield(myhandles,'filterMatrix')
        filterFileList=myhandles.is_file_blacklisted';
        return;
    end
    %for each filter
    for i=1:size(myhandles.filterMatrix,1);
        filterType=myhandles.filterMatrix(i,1);
        groupField=myhandles.filterMatrix(i,2);
        groupField=groupList{groupField};
        
        %groupValueList=cellfun(@(x) cell2mat(getfield(x,groupField)),...
        % myhandles.grouped_metadata,'UniformOutput',false);
        try
            groupValueList=myhandles.metadata_unique_levels.(groupField);
        catch
            if(~strcmp(groupField,'Number_FG_Blocks'))
                groupValueList=cellfun(@(x) (getfield(x,groupField)),...
                    myhandles.metadata,'UniformOutput',false);
                groupValueList=unique(groupValueList);
            else
                groupValueList=unique(myhandles.individual_number_foreground_blocks);
                groupValueList=mat2cell(groupValueList,ones(length(groupValueList),1),1);
            end
            myhandles.metadata_unique_levels.(groupField)=groupValueList;
            setappdata(0,'myhandles',myhandles);
        end
        
        groupOperator=myhandles.filterMatrix(i,3);
        groupValue=myhandles.filterMatrix(i,4);
        try
            groupValue=groupValueList{groupValue};
        catch
            groupValue=groupValueList(groupValue);
        end
        if(isnumeric(groupValue))
            groupValue=num2str(groupValue);
        end
        if(~strcmp(groupField,'Number_FG_Blocks'))
            matchingMetadata = cellfun(@(x) strcmp(x.(groupField),groupValue),myhandles.metadata,'UniformOutput',false);
            matchingMetadata=cell2mat(matchingMetadata);
        else
            matchingMetadata=(myhandles.individual_number_foreground_blocks==str2double(groupValue))';
        end
        
        switch groupOperator
            case 2   % !=
                matchingMetadata=~matchingMetadata;
                %       case 3 % TODO value <
                %         ;
                %       case 4 % TODO value >
                %         ;
        end
        if i==1
            filterFileList=matchingMetadata;
        else
            if(filterType==2)%AND
                filterFileList=filterFileList & matchingMetadata;
            else%OR - By default, it's OR
                filterFileList=filterFileList | matchingMetadata;
            end
        end
    end
    %Test if everything is filtered
    %If yes, throw a warning
    if(sum((filterFileList==0))==length(filterFileList))
        filterFileList=myhandles.is_file_blacklisted';
        myhandles=rmfield(myhandles, 'filterMatrix');
        setappdata(0,'myhandles',myhandles);
        warndlg({'All the images are going to be dropped due to the filtering conditions.';...
            'It looks you choosed opposite conditions to filter the images.';...
            'Please re-apply the filter. Your previous setting has been cleared.'});
    else
        filterFileList=~filterFileList;
    end
    
function addProgressBarToMyHandle(mainFigure)
    myhandles=getappdata(0,'myhandles');
    myhandles.statusbarHandlesExplorer=statusbar(mainFigure,...
        'Explore your data');
    set(myhandles.statusbarHandlesExplorer.TextPanel, 'Foreground',[1,1,1],...
        'Background','black', 'ToolTipText','Loading...');
    set(myhandles.statusbarHandlesExplorer.ProgressBar, 'Background','white',...
        'Foreground',[0.4,0,0]);
    setappdata(0,'myhandles',myhandles);
    
    
    % --------------------------------------------------------------------
function Clear_Black_List_Callback(hObject, eventdata, handles)
    % hObject    handle to Clear_Black_List (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    myhandles=getappdata(0,'myhandles');
    myhandles.is_file_blacklisted=logical(zeros(size(myhandles.file_matrix,1),1));
    setappdata(0,'myhandles',myhandles);
    group_by_callback(hObject, eventdata, handles,myhandles.chosen_grouping_field);
    
    
    % --------------------------------------------------------------------
function Metadata_Menu_Callback(hObject, eventdata, handles)
    % hObject    handle to Metadata_Menu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    
    % --------------------------------------------------------------------
function View_Metadata_Menu_Callback(hObject, eventdata, handles)
    % hObject    handle to View_Metadata_Menu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    myhandles=getappdata(0,'myhandles');
    [myhandles.grouped_metadata,~,order,groups,~]=...
        calculate_groups(myhandles.chosen_grouping_field,myhandles.metadata,[],[],[]);
    [raw_table_data,colnames]=convert_struct_to_table(myhandles.metadata(order));
    accepted_files=color_table(raw_table_data,groups);
    rejected_files={};
    % Do something about rejected files?
    wizard_sampling_viewer(accepted_files,...
        rejected_files,colnames);
    
    
    
    
    % --------------------------------------------------------------------
function Add_Metadata_Menu_Callback(hObject, eventdata, handles)
    % hObject    handle to Add_Metadata_Menu (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    proceed=add_metadata_instructions;
    if(~proceed)
        
        return;
    end
    [filename,path]=uigetfile('*.csv','Pick Additional Metadata File');
    if(isequal(filename,0))
        return;
    end
    fid=fopen([path filesep filename]);
    %fid=fopen('Test/test_metadata.csv');
    delim=',';
    myhandles=getappdata(0,'myhandles');
    metadata=myhandles.metadata;
    new_metadata=metadata;
    [metadata_table,colnames]=convert_struct_to_table(myhandles.metadata);
    grouping_fields=[{'File Name'} myhandles.grouping_fields{:}];
    
    header_row=textscan(fid,'%s',1,'delimiter','\n');
    header_fields=regexp(header_row{1}{1},delim,'split');
    %Check if first column of header is existing field
    if(~ismember(header_fields{1},grouping_fields))
        error('First Column Header Not Valid Metadata Field.');
    else
        chosen_field_number=find(strcmp(header_fields{1},grouping_fields));
    end
    % Check that other columns of header don't already exist
    for i=2:length(header_fields)
        if(any(strcmp(header_fields{i},grouping_fields)))
            error(['There is already a field called '  header_fields{i}]);
        end
    end
    ismember(header_fields(2:end),grouping_fields)
    
    field_vals=metadata_table(:,chosen_field_number);
    [G,GN]=grp2idx(field_vals);
    
    line_counter=1;
    data=textscan(fid,'%s',1,'delimiter','\n');
    additional_metadata_table=cell(1,length(header_fields));
    while (~feof(fid))
        tokens=regexp(data{1},delim,'split');
        tokens=tokens{1};
        
        for field_num=1:length(header_fields)
            additional_metadata_table{line_counter,field_num}=tokens{field_num};
        end
        line_counter=line_counter+1;
        data=textscan(fid,'%s',1,'delimiter','\n');
    end
    
    % Check if values in first column are valid
    if(any(~ismember(additional_metadata_table(:,1),GN)))
        bad_vals=any(~ismember(additional_metadata_table(:,1),GN));
        error_message='Unrecognized field values in Column 1. ';
        for i=1:length(bad_vals)
            error_message=[error_message additional_metadata_table{bad_vals(i),1}];
            if(i<length(bad_vals))
                error_message=[error_message ','];
            end
        end
        if(length(bad_vals)>1)
            error_message=[error_message ' are not recognized values for ' grouping_fields{chosen_field_number}];
        else
            error_message=[error_message ' is not a recognized value for ' grouping_fields{chosen_field_number}];
        end
        error(error_message);
    end
    % Check to see if values in first column are all different
    [g1,gn1]=grp2idx(additional_metadata_table(:,1));
    error_message='Field values in column 1 must be unique. ';
    throw_error=false;
    for i=1:length(gn1)
        if(nnz(g1==i)>1)
            error_message=[error_message gn1{i} ' '];
            throw_error=true;
        end
    end
    error_message=[error_message ' present more than once'];
    if(throw_error)
        error(error_message);
    end
    % Fill data for matches
    match_list=false(length(G),1);
    for i=1:size(additional_metadata_table,1)
        group_num=find(strcmp(additional_metadata_table(i,1),GN));
        
        matched_files=find(G==group_num);
        match_list(matched_files)=true;
        for file_num=1:length(matched_files)
            for new_field_num=2:length(header_fields)
                new_field_name=header_fields{new_field_num};
                new_metadata{matched_files(file_num)}.(new_field_name)=additional_metadata_table{i,new_field_num};
            end
        end
    end
    % Fill unmatched file metadata with []
    unmatched_files=find(~match_list);
    for file_num=1:length(unmatched_files)
        for new_field_num=2:length(header_fields)
            new_field_name=header_fields{new_field_num};
            new_metadata{unmatched_files(file_num)}.(new_field_name)='';
        end
    end
    
    
    myhandles.grouping_fields=[myhandles.grouping_fields{:} header_fields(2:end)];
    myhandles.metadata=new_metadata;
    setappdata(0,'myhandles',myhandles);
    group_by_callback(hObject, eventdata, handles,myhandles.chosen_grouping_field);
    
    myhandles=getappdata(0,'myhandles');
    grouping_fields=myhandles.grouping_fields;
    
    % Update menus
    
    % First delete old menus
    for i=1:length(myhandles.Color_Points_By_Menu_Handles)
        delete(myhandles.Color_Points_By_Menu_Handles(i))
    end
    for i=1:length(myhandles.Label_Points_By_Menu_Handles)
        delete(myhandles.Label_Points_By_Menu_Handles(i))
    end
    
    for i=2:length(myhandles.Group_Points_By_Menu_Handles)
        delete(myhandles.Group_Points_By_Menu_Handles(i))
    end
    
    % Create New menu items
    myhandles.Color_Points_By_Menu_Handles=zeros(length(grouping_fields),1);
    myhandles.Label_Points_By_Menu_Handles=zeros(length(grouping_fields),1);
    for i=1:length(grouping_fields)
        myhandles.Color_Points_By_Menu_Handles(i)=...
            uimenu(handles.Color_Points_By_Menu,'Label',grouping_fields{i}, ...
            'Callback', {@color_by_callback,handles,i});
        myhandles.Label_Points_By_Menu_Handles(i)=...
            uimenu(handles.Label_Points_By_Menu,'Label',grouping_fields{i}, ...
            'Callback', {@label_by_callback,handles,i});
        
    end
    
    % For group by, we create and destroy simultaneuously
    for i=1:length(grouping_fields)
        
        myhandles.Group_Points_By_Menu_Handles(i+1)=...
            uimenu(handles.Group_By_Menu,'Label',myhandles.grouping_fields{i}, ...
            'Callback', {@group_by_callback,handles,i+1});
    end
    setappdata(0,'myhandles',myhandles);
    
    
    % --- Executes on button press in showFGPixelsCB.
function showFGPixelsCB_Callback(hObject, eventdata, handles)
    % hObject    handle to showFGPixelsCB (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    myhandles=getappdata(0,'myhandles');
    myhandles.showOnlyFGPixels= get(hObject,'Value');
    setappdata(0,'myhandles',myhandles);
    
    %Replot the last images
    if(myhandles.axes_chosen==handles.axes2)
        frame_handle=handles.uipanel3;
    else
        frame_handle=handles.uipanel7;
    end
    fnames=fieldnames(myhandles.grouped_metadata{myhandles.selected_point});
    panel_text=myhandles.grouped_metadata{myhandles.selected_point}.(fnames{myhandles.chosen_grouping_field});
    if(iscell(panel_text))
        panel_text=panel_text{1};
    end
    if(length(panel_text)>43)
        panel_text=['...' panel_text(end-40:end)];
    end
    ShowImages(myhandles.grouped_metadata{myhandles.selected_point}.files_in_group,1,...
        myhandles.axes_chosen,myhandles.mds_colors(myhandles.selected_point,:),...
        panel_text,frame_handle);
    %ShowImages(filenames,file_number,axis_handle,class_color,point_name,frame_handle)
    
    
    % Hint: get(hObject,'Value') returns toggle state of showFGPixelsCB
    
    
    % --------------------------------------------------------------------
function Export_distanceMatrix_Callback(hObject, eventdata, handles)
    % hObject    handle to Export_distanceMatrix (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    lastPath=load_last_path('save');
    if(~exist(char(lastPath),'dir'))
        [filename,pathname]=uiputfile();
    else
        [filename,pathname]=uiputfile('*.tsv','Save the Distance Matrix data into TSV format', lastPath);
    end
    if(~exist(char(pathname),'dir'))
        filename='';
        warndlg('Invalid Root Directory');
    else
        save_last_path(pathname,'save');
    end
    myhandles=getappdata(0,'myhandles');
    
    nrGroup=size(myhandles.grouped_metadata,2);
    nrBlockType=size(myhandles.superblock_profiles,2);
    %Open the file
    fid =fopen([pathname filename],'w');
    if(fid<0)
        isSucceed=false;
        return;
    end
    %Write the header
    fieldNames=fieldnames(myhandles.grouped_metadata{1});
    if(strcmpi(fieldNames{myhandles.chosen_grouping_field},'files_in_group'))
        fprintf(fid, '%s\t', ['Grouped by Files']);
    else
        fprintf(fid, '%s\t', ['Grouped by ' fieldNames{myhandles.chosen_grouping_field}]);
    end
    
    for i=2:size(fieldNames,1)
        if(i<size(fieldNames,1))
            fprintf(fid, '%s,', fieldNames{i});
        else
            fprintf(fid, '%s\t', fieldNames{i});
        end
    end
    %   for i=1:nrBlockType
    %     fprintf(fid, '%s\t', ['sb' num2str(i)]);
    %   end
    %   fprintf(fid, '%s\r\n', '');
    for i=1:nrGroup
        if(strcmpi(fieldNames{myhandles.chosen_grouping_field},'files_in_group'))
            filePosition=find(myhandles.analyze_channels==1);
            for j=1:length(filePosition)
                if(j==1)
                    fileNames=myhandles.grouped_metadata{i}.(fieldNames{myhandles.chosen_grouping_field}){filePosition(j)};
                else
                    fileNames=[fileNames ' AND ' myhandles.grouped_metadata{i}.(fieldNames{myhandles.chosen_grouping_field}){filePosition(j)}];
                end
            end
            fprintf(fid, '%s\t', fileNames);
        else
            fprintf(fid, '%s\t', myhandles.grouped_metadata{i}.(...
                fieldNames{myhandles.chosen_grouping_field}){1} );
        end
    end
    fprintf(fid, '%s\r\n', '');
    
    
    
    %For each group, write the metadata and the superblock values
    for i=1:nrGroup
        %Write the group label
        %If it is a file_name
        if(strcmpi(fieldNames{myhandles.chosen_grouping_field},'files_in_group'))
            filePosition=find(myhandles.analyze_channels==1);
            for j=1:length(filePosition)
                if(j==1)
                    fileNames=myhandles.grouped_metadata{i}.(fieldNames{myhandles.chosen_grouping_field}){filePosition(j)};
                else
                    fileNames=[fileNames ' AND ' myhandles.grouped_metadata{i}.(fieldNames{myhandles.chosen_grouping_field}){filePosition(j)}];
                end
            end
            fprintf(fid, '%s\t', fileNames);
        else
            fprintf(fid, '%s\t', myhandles.grouped_metadata{i}.(...
                fieldNames{myhandles.chosen_grouping_field}){1} );
        end
        %Write the metadata values
        for j=2:size(fieldNames,1)
            if(j<size(fieldNames,1))
                if (isempty(myhandles.grouped_metadata{i}.(fieldNames{j})))
                    fprintf(fid, '%s,', myhandles.grouped_metadata{i}.(fieldNames{j}));
                else
                    fprintf(fid, '%s,', myhandles.grouped_metadata{i}.(fieldNames{j}){1});
                end
            else
                if isnumeric(myhandles.grouped_metadata{i}.(fieldNames{j}))
                    fprintf(fid, '%f\t', myhandles.grouped_metadata{i}.(fieldNames{j}));
                else
                    if (isempty(myhandles.grouped_metadata{i}.(fieldNames{j})))
                        fprintf(fid, '%s,', myhandles.grouped_metadata{i}.(fieldNames{j}));
                    else
                        fprintf(fid, '%s\t', myhandles.grouped_metadata{i}.(fieldNames{j}){1});
                    end
                end
            end
        end
        %Write the superblock values
        %     for j=1:nrGroup
        %       %fprintf(fid, '%s\t', num2str(myhandles.superblock_profiles(i,j)));
        %       fprintf(fid, '%s\t', num2str(myhandles.distanceBetweenPoints(i,j)));
        %     end
        %Write a new line
        fprintf(fid, '%s\r\n', '');
    end
    isSucceed=fclose(fid);
    if(~isSucceed)
        msgbox(['Data have been exported into ' pathname filename]);
    else
    end
    
    
    % --- Executes on selection change in labelCB.
function labelCB_Callback(hObject, eventdata, handles)
    % hObject    handle to labelCB (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: contents = cellstr(get(hObject,'String')) returns labelCB contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from labelCB
    myhandles=getappdata(0,'myhandles');
    val=get(hObject,'Value');
    string_list=get(hObject,'String');
    if(ischar(string_list))
        selectedLabel=string_list;
    else
        selectedLabel = string_list{val};
    end
    myhandles.labelToDisplay=selectedLabel;
    setappdata(0,'myhandles',myhandles);
    if(myhandles.mds_dim==2)
        Plot_MDS(myhandles.mds_data,myhandles.mds_dim,...
            myhandles.mds_text,myhandles.mds_colors,...
            myhandles.chosen_points,handles.MDSPlot,...
            myhandles.show_mds_text,myhandles.labelToDisplay);
    else
        Plot_MDS(myhandles.mds_data,myhandles.mds_dim,...
            myhandles.mds_text,myhandles.mds_colors,...
            myhandles.chosen_points,handles.MDSPlot,...
            myhandles.show_mds_text,myhandles.labelToDisplay);
        rotate3d off;
        myhandles.mds_rotatable=0;
    end
    
    
    % --- Executes during object creation, after setting all properties.
function labelCB_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to labelCB (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
