function varargout = threshold_channels()
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



myhandles=getappdata(0,'myhandles');

number_of_markers=size(myhandles.img,3);

color_order=myhandles.color_order;
colors=myhandles.foreground_channels;

gui_width=600;
gui_height=700;
background_color='black';
foreground_color='white';
panel_width=0.9;
panel_height=0.1;

done_button_x=0.4;
done_button_y=0.05;
done_button_width=0.2;
done_button_height=0.05;

show_marker_checkbox_x=0.0;
show_marker_checkbox_y=0.35;
show_marker_checkbox_height=0.60;
show_marker_checkbox_width=0.2;


handles.fig=figure('position',[0,0,gui_width,gui_height],'Color',background_color,...
    'MenuBar','none');
handles.close_button=uicontrol('Style', 'pushbutton','String','Done','Units','normalized',...
            'position', [done_button_x,done_button_y,done_button_width,done_button_height],...
            'Callback', {@done_callback},'parent',handles.fig);
myhandles=getappdata(0,'myhandles');
myhandles.scale_figure=handles.fig;
setappdata(0,'myhandles',myhandles);
%set_myhandle_values();


if(isfield(myhandles,'markers'))
  markerNr=0;
  for marker_num=1:size(myhandles.markers,2)
    if(myhandles.markers{marker_num}.isUse)
      markerNr=markerNr+1;
      ischecked=1;
      markerValue=marker_num;
      try
        ischecked=myhandles.foreground_channels(marker_num);
      catch
      end
      add_marker(markerNr,0.9-1.25*panel_height*(markerNr-1),myhandles.markers{marker_num}.name,ischecked);
    end
  end
else
  for marker_num=1:number_of_markers    
      ischecked=1;
      try
        ischecked=myhandles.foreground_channels(marker_num);
      catch
      end
      add_marker(marker_num,0.9-1.25*panel_height*(marker_num-1),[],ischecked);
  end
end


   function set_myhandle_values()
        myhandles=getappdata(0,'myhandles');     
        axis(myhandles.h,'image');
        
        axis off
        set(myhandles.h,'XTickLabel',[]);
        set(myhandles.h,'YTickLabel',[]);
        set(myhandles.h,'XGrid','off');
        set(myhandles.h,'YGrid','off');
        set(myhandles.h,'LineWidth',1);
       
      %  setappdata(0,'myhandles',myhandles);
    end

    function done_callback(hObject,eventdata)
%         myhandles=getappdata(0,'myhandles');
%         display_image(myhandles.img,axis_handle,color_scale,colors,mask);
%         myhandles.marker_scales=color_scale;
         setappdata(0,'myhandles',myhandles);
  %      set_myhandle_values();
        delete(handles.fig);
    end

 

    function marker_handles=add_marker(marker_number,position,name,ischecked)
        
        %Panel
        if(~isempty(name))
          marker_handles.marker_panel=uipanel('Title',name,'BackgroundColor',background_color,...
            'ForegroundColor',foreground_color,'Units','normalized','position',[0.05,position,panel_width,panel_height],...
            'parent',handles.fig);
          
        else
          marker_handles.marker_panel=uipanel('Title','Marker Number ','BackgroundColor',background_color,...
            'ForegroundColor',foreground_color,'Units','normalized','position',[0.05,position,panel_width,panel_height],...
            'parent',handles.fig);
        end
        % Show marker checkbox
        marker_handles.show_marker_checkbox=uicontrol('Style', 'checkbox',...
            'String','Use Marker','Units','normalized','Value',ischecked,...
            'position', [show_marker_checkbox_x,show_marker_checkbox_y,show_marker_checkbox_width,show_marker_checkbox_height],...
            'Callback', {@checkbox_callback,marker_number},'parent',marker_handles.marker_panel,...
            'BackgroundColor',[0 0 0],'ForegroundColor',[1 1 1]);

          
          
        
        function checkbox_callback(hObject,eventdata,marker_number) 
          myhandles=getappdata(0,'myhandles');
          value=get(hObject,'Value');
          if(value)
              myhandles.foreground_channels(marker_number)=1;

          else
              myhandles.foreground_channels(marker_number)=0;
          end
          setappdata(0,'myhandles',myhandles);
        end
    end

        
end

