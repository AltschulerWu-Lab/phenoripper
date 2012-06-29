function varargout = wizard_sampling_viewer(varargin)
% WIZARD_SAMPLING_VIEWER MATLAB code for wizard_sampling_viewer.fig
%      WIZARD_SAMPLING_VIEWER, by itself, creates a new WIZARD_SAMPLING_VIEWER or raises the existing
%      singleton*.
%
%      H = WIZARD_SAMPLING_VIEWER returns the handle to a new WIZARD_SAMPLING_VIEWER or the handle to
%      the existing singleton*.
%
%      WIZARD_SAMPLING_VIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WIZARD_SAMPLING_VIEWER.M with the given input arguments.
%
%      WIZARD_SAMPLING_VIEWER('Property','Value',...) creates a new WIZARD_SAMPLING_VIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before wizard_sampling_viewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to wizard_sampling_viewer_OpeningFcn via varargin.
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




% Edit the above text to modify the response to help wizard_sampling_viewer

% Last Modified by GUIDE v2.5 25-Jun-2012 12:18:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @wizard_sampling_viewer_OpeningFcn, ...
                   'gui_OutputFcn',  @wizard_sampling_viewer_OutputFcn, ...
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


% --- Executes just before wizard_sampling_viewer is made visible.
function wizard_sampling_viewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to wizard_sampling_viewer (see VARARGIN)

% Choose default command line output for wizard_sampling_viewer

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

% UIWAIT makes wizard_sampling_viewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = wizard_sampling_viewer_OutputFcn(hObject, eventdata, handles) 
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
