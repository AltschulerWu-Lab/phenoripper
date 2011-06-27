function varargout = Explainer(varargin)
% EXPLAINER M-file for Explainer.fig
%      EXPLAINER, by itself, creates a new EXPLAINER or raises the existing
%      singleton*.
%
%      H = EXPLAINER returns the handle to a new EXPLAINER or the handle to
%      the existing singleton*.
%
%      EXPLAINER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EXPLAINER.M with the given input arguments.
%
%      EXPLAINER('Property','Value',...) creates a new EXPLAINER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Explainer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Explainer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Explainer

% Last Modified by GUIDE v2.5 15-Mar-2011 14:58:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Explainer_OpeningFcn, ...
                   'gui_OutputFcn',  @Explainer_OutputFcn, ...
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


% --- Executes just before Explainer is made visible.
function Explainer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Explainer (see VARARGIN)

% Choose default command line output for Explainer
handles.output = hObject;
myhandles=getappdata(0,'myhandles');
set(handles.listbox1,'String',myhandles.grouping_fields);
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Explainer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Explainer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
myhandles=getappdata(0,'myhandles');
contents = cellstr(get(hObject,'String'));     
grouping_field=contents{get(hObject,'Value')};
group_vals=cell(1,myhandles.number_of_conditions);
for condition=1:myhandles.number_of_conditions
   group_vals{condition}=cell2mat(myhandles.grouped_metadata{condition}.(grouping_field)); 
end
[group_numbers,field_names]=grp2idx(group_vals);
set(handles.popupmenu1,'String',field_names);
set(handles.popupmenu2,'String',field_names);

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)\
myhandles=getappdata(0,'myhandles');
contents = cellstr(get(handles.listbox1,'String'));     
grouping_field=contents{get(handles.listbox1,'Value')};
for condition=1:myhandles.number_of_conditions
   group_vals{condition}=cell2mat(myhandles.grouped_metadata{condition}.(grouping_field)); 
end
[group_numbers,field_names]=grp2idx(group_vals);
colors=ColorBrewer(max(group_numbers));

group1=get(handles.popupmenu1,'Value');
group2=get(handles.popupmenu2,'Value');
first_group=find(group_numbers==group1);
second_group=find(group_numbers==group2);

data=[myhandles.superblock_profiles(first_group,:);myhandles.superblock_profiles(second_group,:)];
categories=group_numbers([first_group;second_group]);

%svm_struct=svmtrain(data,categories);%,'AutoScale',false);
%svm_function(svm_struct,myhandles.superblock_profiles(7,:))
fraction_cutoff=0.05;


if(length(first_group)>1 & length(second_group)>1)
    cutoff=0.05;
    p_vals=zeros(1,myhandles.number_of_superblocks);
    for i=1:myhandles.number_of_superblocks
        %[~,p_vals(i)]=ttest2(myhandles.superblock_profiles(first_group,i),myhandles.superblock_profiles(second_group,i),[],'both','unequal');
        p_vals(i)=ranksum(myhandles.superblock_profiles(first_group,i),myhandles.superblock_profiles(second_group,i));
    end 
    important_blocks=(mean(myhandles.superblock_profiles(first_group,:))>fraction_cutoff)|...
        (mean(myhandles.superblock_profiles(second_group,:))>fraction_cutoff);
    number_of_reps=min(nnz((p_vals<cutoff)&important_blocks),5);
    [~,p_indices]=sort(p_vals);
    important_blocks=important_blocks(p_indices);
    p_indices=p_indices(important_blocks);
    bar_matrix=zeros(2,number_of_reps);
    for i=1:number_of_reps
        bar_matrix(1,i)=(mean(myhandles.superblock_profiles(first_group,p_indices(i))));
        bar_matrix(2,i)=(mean(myhandles.superblock_profiles(second_group,p_indices(i))));
    end
else
    % This can be made more sophisticated by calculating variation over random
    % vectors to arrive at p-values for component wise differences.
    if(length(first_group)==1)
        profile1=myhandles.superblock_profiles(first_group,:);
    else
        profile1=mean(myhandles.superblock_profiles(first_group,:));
    end
    if(length(first_group)==1)
        profile2=myhandles.superblock_profiles(second_group,:);
    else
        profile2=mean(myhandles.superblock_profiles(second_group,:));
    end
    important_blocks=(profile1>fraction_cutoff|profile2>fraction_cutoff);
    [~,p_indices]=sort(-abs(profile1-profile2));    
    number_of_reps=min(nnz(important_blocks),5);
    important_blocks=important_blocks(p_indices);
    p_indices=p_indices(important_blocks);
    bar_matrix=zeros(2,number_of_reps);
    bar_matrix(1,:)=profile1(p_indices(1:number_of_reps));
    bar_matrix(2,:)=profile2(p_indices(1:number_of_reps));
end

valdiff=bar_matrix(2,:)-bar_matrix(1,:);
[~,bar_order]=sort(valdiff);
figure;
bar_colormap=zeros(2,3);
bar_colormap(1,:)=colors(group1,:);
bar_colormap(2,:)=colors(group2,:);
bar(bar_matrix(:,bar_order)');
ylabel('Superblock Fraction');
colormap(bar_colormap);

contents = cellstr(get(handles.listbox1,'String')); 
class1_name=contents{get(handles.listbox1,'Value')};
contents = cellstr(get(handles.popupmenu1,'String')); 
group1_name=contents{get(handles.popupmenu1,'Value')};
contents = cellstr(get(handles.popupmenu2,'String')); 
group2_name=contents{get(handles.popupmenu2,'Value')};

legend([class1_name ':' group1_name],[class1_name ':' group2_name],'Location','Best');
scale_factor=0.9;
XLims=get(gca,'XLim');
YLims=get(gca,'YLim');
x_positions=linspace(1,number_of_reps,number_of_reps)-scale_factor/2;
y_positions=-(diff(YLims)/12)*ones(number_of_reps,1);
normalized_size=1/number_of_reps;%(YLims(2)-YLims(1))/number_of_representatives;
number_of_data_points=1;
h=gca;
f=gcf;
positions=zeros(number_of_reps,4);
  units=get(gca,'Units');
for rep_num=1:number_of_reps
 

 % set(gca,'Units','normalized');
   positions(rep_num,:)=dsxy2figxy(h,[x_positions(rep_num),y_positions(rep_num),scale_factor*diff(XLims)/number_of_reps,scale_factor*diff(YLims)/5]);
   axes('position', positions(rep_num,:),'parent',f);
   img=double(myhandles.global_data.superblock_representatives{p_indices(bar_order(rep_num)),1}(:,:,1:3));
   max_col=max(img(:));
   image(img/max_col);axis equal;axis off;
   %image(representatives{perm2(rep_num)}./max(max(max(representatives{perm2(rep_num)}))));axis equal;axis off;
   %axis off;axis equal;
end

set(gca,'Units',units);
%XLims=get(gca,'XLim');
%YLims=get(gca,'YLim');
outerpos=get(h,'Position');
set(h,'Position',[outerpos(1) outerpos(2)+0.1 outerpos(3) outerpos(4)-0.1]);
%set(h,'YLim',YLims*2.5);
% positions
%figure;
%bar(bar_matrix);

% greater_in_first=false(number_of_reps,1);
% greater_in_second=false(number_of_reps,1);
% for i=1:number_of_reps
%     greater_in_first(i)= (mean(myhandles.superblock_profiles(first_group,p_indices(i)))...
%         >mean(myhandles.superblock_profiles(second_group,p_indices(i))))&...
%         (mean(myhandles.superblock_profiles(first_group,p_indices(i)))...
%         >1/(5*myhandles.number_of_superblocks));
%     greater_in_second(i)= (mean(myhandles.superblock_profiles(first_group,p_indices(i)))...
%         <mean(myhandles.superblock_profiles(second_group,p_indices(i))))&...
%         (mean(myhandles.superblock_profiles(second_group,p_indices(i)))...
%         >1/(5*myhandles.number_of_superblocks));
% end
% 
% first_superblocks=find(greater_in_first);
% second_superblocks=find(greater_in_second);
% 
% figure;
% for i=1:length(first_superblocks)
%     subplot(1,length(first_superblocks),i);
%     img=double(myhandles.global_data.superblock_representatives{p_indices(first_superblocks(i)),1}(:,:,1:3));
%    max_col=max(img(:));
%    image(img/max_col);axis equal;axis off;
%    
% end
% title('1');
% figure;
% for i=1:length(second_superblocks)
%     subplot(1,length(second_superblocks),i);
%     img=double(myhandles.global_data.superblock_representatives{p_indices(second_superblocks(i)),1}(:,:,1:3));
%    max_col=max(img(:));
%    image(img/max_col);axis equal;axis off;
% end
% figure;
% for i=1:number_of_reps
%    subplot(1,number_of_reps,i);
%    img=double(myhandles.global_data.superblock_representatives{p_indices(i),1}(:,:,1:3));
%    max_col=max(img(:));
%    image(img/max_col);axis equal;axis off;
% end
%disp('meow');
% axis
% good_blocks=find(p_vals<0.005);
% subplot(length(good_blocks)+1,3,2);
% text('Class 1');
% subplot(length(good_blocks)+1,3,2);
% text('Class 2');
% svm_struct=svmtrain(data,categories,'AutoScale',false);





