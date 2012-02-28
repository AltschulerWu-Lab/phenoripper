function varargout = wizardAcceptView(varargin)
% WIZARDACCEPTVIEW MATLAB code for wizardAcceptView.fig
%      WIZARDACCEPTVIEW, by itself, creates a new WIZARDACCEPTVIEW or raises the existing
%      singleton*.
%
%      H = WIZARDACCEPTVIEW returns the handle to a new WIZARDACCEPTVIEW or the handle to
%      the existing singleton*.
%
%      WIZARDACCEPTVIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WIZARDACCEPTVIEW.M with the given input arguments.
%
%      WIZARDACCEPTVIEW('Property','Value',...) creates a new WIZARDACCEPTVIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before wizardAcceptView_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to wizardAcceptView_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wizardAcceptView

% Last Modified by GUIDE v2.5 28-Feb-2012 15:58:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @wizardAcceptView_OpeningFcn, ...
                   'gui_OutputFcn',  @wizardAcceptView_OutputFcn, ...
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


% --- Executes just before wizardAcceptView is made visible.
function wizardAcceptView_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to wizardAcceptView (see VARARGIN)

% Choose default command line output for wizardAcceptView

handles.output = hObject;
% Update handles structure
guidata(hObject, handles);  
axis(handles.header);
setappdata(0,'handles',handles);
img=imread('wizard.png');
image(img,'parent',handles.header);
axis(handles.header,'off');

acceptedFiles=varargin{1};
rejectedFiles=varargin{2};
colNames=varargin{3};
set(handles.accepted_table,'Data',acceptedFiles,'ColumnName',colNames);
set(handles.rejected_table,'Data',rejectedFiles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes wizardAcceptView wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = wizardAcceptView_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in closeButton.
function closeButton_Callback(hObject, eventdata, handles)
% hObject    handle to closeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.figure1);
