function varargout = wizard_sampling(varargin)
    % WIZARD_SAMPLING MATLAB code for wizard_sampling.fig
    %      WIZARD_SAMPLING, by itself, creates a new WIZARD_SAMPLING or raises the existing
    %      singleton*.
    %
    %      H = WIZARD_SAMPLING returns the handle to a new WIZARD_SAMPLING or the handle to
    %      the existing singleton*.
    %
    %      WIZARD_SAMPLING('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in WIZARD_SAMPLING.M with the given input arguments.
    %
    %      WIZARD_SAMPLING('Property','Value',...) creates a new WIZARD_SAMPLING or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before wizard_sampling_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to wizard_sampling_OpeningFcn via varargin.
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
    
    
    
    
    % Edit the above text to modify the response to help wizard_sampling
    
    % Last Modified by GUIDE v2.5 25-Jun-2012 12:11:01
    
    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
        'gui_Singleton',  gui_Singleton, ...
        'gui_OpeningFcn', @wizard_sampling_OpeningFcn, ...
        'gui_OutputFcn',  @wizard_sampling_OutputFcn, ...
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
    
    
    % --- Executes just before wizard_sampling is made visible.
function wizard_sampling_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to wizard_sampling (see VARARGIN)
    
    % Choose default command line output for wizard_sampling
    parsingMsgDlg = msgbox('Extracting Metadata information, Please wait...');
    %Trick to show off the OK button
    hc=get(parsingMsgDlg,'Children');
    set(hc(2),'Visible','off');
    drawnow;
    pause(0.01);
    
    wizard_samplingHandles.acceptedFiles=[];
    wizard_samplingHandles.rejectedFiles=[];
    setappdata(0,'wizard_samplingHandles',wizard_samplingHandles);
    %try
    handles.output = hObject;
    % Update handles structure
    guidata(hObject, handles);
    axis(handles.header);
    setappdata(0,'handles',handles);
    img=imread('wizard.png');
    image(img,'parent',handles.header);
    axis(handles.header,'off');
    
    myhandles=getappdata(0,'myhandles');
    [table_data,field_names]=convert_struct_to_table(myhandles.metadata);
    % Added to store the possible values of different data fields to avoid
    % recalculating in the filter gui later
    try
        unique_levels=struct;
        for i=2:length(field_names)
            unique_levels.(field_names{i})=unique((table_data(:,i)));
            
        end
        myhandles.metadata_unique_levels=unique_levels;
        setappdata(0,'myhandles',myhandles);
    catch
        warning('Automatic Calculation Of Metadata Levels Failed');
    end
    
    groupNameList=field_names;
    groupNameList{1}=['Random (don''','t know)'];
    set(handles.grouppopupmenu1,'String',groupNameList);
    
    
    wizard_samplingHandles=getappdata(0,'wizard_samplingHandles');
    wizard_samplingHandles.acceptedFiles=table_data;
    %set(handles.accepted_table,'Data',table_data);
    if(~myhandles.use_metadata)
        wizard_samplingHandles.rejectedFiles=myhandles.allfiles(~myhandles.matched_files);
        %set(handles.rejected_table,'Data',myhandles.all_files(~myhandles.matched_files));
    end
    setappdata(0,'wizard_samplingHandles',wizard_samplingHandles);
    grouppopupmenu1_Callback(hObject, eventdata, handles)
    
    
    description=['Choose a strategy for sampling a representative subset '...
        'of your data.%sIf you expect groups of images to be similar '...
        '(e.g. images from same wells, replicate experiments, similar perturbations),'...
        ' please select this group. Otherwise PhenoRipper will sample randomly.'];
    description=strrep(description, '%s', char(10));
    %description=strrep(description, '%x', num2str(length(groupNameList)));
    set(handles.description,'String',description);
    
    
    
    % Update handles structure
    guidata(hObject, handles);
    close(parsingMsgDlg);
    
    
    
    
    %catch
    %close(parsingMsgDlg);
    %end
    
    
    
    
    
    % --- Outputs from this function are returned to the command line.
function varargout = wizard_sampling_OutputFcn(hObject, eventdata, handles)
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Get default command line output from handles structure
    varargout{1} = handles.output;
    
    
    % --- Executes on selection change in grouppopupmenu1.
function grouppopupmenu1_Callback(hObject, eventdata, handles)
    % hObject    handle to grouppopupmenu1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    
    % Hints: contents = cellstr(get(hObject,'String')) returns grouppopupmenu1 contents as cell array
    %        contents{get(hObject,'Value')} returns selected item from grouppopupmenu1
    myhandles=getappdata(0,'myhandles');
    number_of_files=length(myhandles.metadata);
    try
        group_index=get(hObject,'Value');
    catch
        group_index=1;
    end
    
    myhandles.chosen_grouping_field=group_index;
    [myhandles.grouped_metadata,~,order,groups,~]=...
        calculate_groups(group_index,myhandles.metadata,[],[],[]);
    ordered_data=myhandles.metadata(order);
    [raw_table_data,colnames]=convert_struct_to_table(ordered_data);
    temp=color_table(raw_table_data,groups);
    wizard_samplingHandles=getappdata(0,'wizard_samplingHandles');
    wizard_samplingHandles.acceptedFiles=temp;
    wizard_samplingHandles.colNames=colnames;
    setappdata(0,'wizard_samplingHandles',wizard_samplingHandles);
    % set(handles.accepted_table,'Data',temp,'ColumnName',colnames);
    myhandles.grouping_fields=colnames(2:end);
    setappdata(0,'myhandles',myhandles);
    
    
    % --- Executes during object creation, after setting all properties.
function grouppopupmenu1_CreateFcn(hObject, eventdata, handles)
    % hObject    handle to grouppopupmenu1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    empty - handles not created until after all CreateFcns called
    
    % Hint: popupmenu controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
    
    
    % --- Executes on button press in inspectGroupingButton.
function inspectGroupingButton_Callback(hObject, eventdata, handles)
    % hObject    handle to inspectGroupingButton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    wizard_samplingHandles=getappdata(0,'wizard_samplingHandles');
    wizard_sampling_viewer(wizard_samplingHandles.acceptedFiles,...
        wizard_samplingHandles.rejectedFiles,wizard_samplingHandles.colNames);
    
    % --- Executes on button press in okButton.
function okButton_Callback(hObject, eventdata, handles)
    % hObject    handle to okButton (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    myhandles=getappdata(0,'myhandles');
    if isfield(myhandles,'wizard_handle')
        delete(myhandles.wizard_handle);
    end
    if isfield(myhandles,'wizardMetaData_handle')
        try
            delete(myhandles.wizardMetaData_handle);
        catch
        end
    end
    delete(gcf);
