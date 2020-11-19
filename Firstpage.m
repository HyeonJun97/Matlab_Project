function varargout = Firstpage(varargin)
% FIRSTPAGE MATLAB code for Firstpage.fig
%      FIRSTPAGE, by itself, creates a new FIRSTPAGE or raises the existing
%      singleton*.
%
%      H = FIRSTPAGE returns the handle to a new FIRSTPAGE or the handle to
%      the existing singleton*.
%
%      FIRSTPAGE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIRSTPAGE.M with the given input arguments.
%
%      FIRSTPAGE('Property','Value',...) creates a new FIRSTPAGE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Firstpage_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Firstpage_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Firstpage

% Last Modified by GUIDE v2.5 06-Dec-2019 10:04:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Firstpage_OpeningFcn, ...
                   'gui_OutputFcn',  @Firstpage_OutputFcn, ...
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


% --- Executes just before Firstpage is made visible.
function Firstpage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Firstpage (see VARARGIN)
bg1 = axes('unit', 'normalized', 'position', [0 0 1 1]); 
% import the background image and show it on the axes
bg = imread('Kakao1.jpg'); imagesc(bg);
% prevent plotting over the background and turn the axis off
set(bg1,'handlevisibility','off','visible','off')
% making sure the background is behind all the other uicontrols
uistack(bg1, 'bottom');

% Choose default command line output for Firstpage
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Firstpage wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Firstpage_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start.
function startButton_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
close Firstpage
run('Secondpage.m')
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in melody.
function melody_Callback(hObject, eventdata, handles)
% hObject    handle to melody (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close Firstpage
run('MRpage')
