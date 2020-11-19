function varargout = untitled(varargin)
% UNTITLED MATLAB code for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled

% Last Modified by GUIDE v2.5 04-Dec-2019 13:41:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
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


% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled (see VARARGIN)
bg2 = axes('unit', 'normalized', 'position', [0 0 1 1]); 
% import the background image and show it on the axes
bg = imread('back.png'); imagesc(bg);
% prevent plotting over the background and turn the axis off
set(bg2,'handlevisibility','off','visible','off')
% making sure the background is behind all the other uicontrols
uistack(bg2, 'bottom');
% Choose default command line output for untitled
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled wait for user response (see UIRESUME)
% uiwait(handles.Filtering);


% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in filter1.
function filter1_Callback(hObject, eventdata, handles)
% hObject    handle to filter1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x3;
global fs3;
global X_1;
global result1;

global x_play;
global fs_play;
%% 필터_1 정의(BAND-STOP FILTER)
f1Fs = 44100;  
f1N    = 90;       
f1Fc1  = 3000;     
f1Fc2  = 5000;
win = hamming(f1N+1);
filter_1  = fir1(f1N, [f1Fc1 f1Fc2]/(f1Fs/2), 'stop', win);

%FILTERING_1
result1 = conv(x3,filter_1);
X_1 = fftshift(fft(result1));
N1 = (-length(result1)/2 : length(result1)/2 -1)*fs3/length(result1) /1000;
plot(handles.axes2,N1,abs(X_1));   %서브 플롯 해주기
xlabel(handles.axes2,'Frequency(kHz)');
ylabel(handles.axes2,'Magnitude');
audiowrite('result_1.wav',result1 , fs3); %노이즈 1차 제거된사운드

x_play = result1;
fs_play = fs3;


% --- Executes on button press in filter2.
function filter2_Callback(hObject, eventdata, handles)
% hObject    handle to filter2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fs3;
global X_2;
global result1;
global result2;

global x_play;
global fs_play;

%% 필터2 정의(LOW-PASS FILTER)
f2Fs = 44100;  
f2N    = 90;      
f2Fc   = 1000;     
win2 = hamming(f2N+1);
filter_2  = fir1(f2N, f2Fc/(f2Fs/2), 'low', win2);

%FILTERING2
result2 = conv(result1, filter_2);
X_2 = fftshift(fft(result2));
N2 = (-length(result2)/2 : length(result2)/2 -1)*fs3 /length(result2)/1000;
plot(handles.axes3,N2 , abs(X_2));
xlabel(handles.axes3,'Frequency(kHz)');
ylabel(handles.axes3,'Magnitude');
audiowrite('result_2.wav',result2 , fs3); %노이즈 2차 제거된사운드

x_play = result2;
fs_play = fs3;


% --- Executes on button press in filter3.
function filter3_Callback(hObject, eventdata, handles)
% hObject    handle to filter3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global fs3;
global result2;
global filter_3;
global X_3;
global N3;

global x_play;
global fs_play;

%% 필터3 정의(BAND-PASS FILTER)
f3Fs = 44100; 
f3N  = 150;       
f3Fc1  = 10;       
f3Fc2  = 900;      
win3 = hamming(f3N+1);
filter_3  = fir1(f3N, [f3Fc1 f3Fc2]/(f3Fs/2), 'bandpass', win3);

%FILTERING_3
result3 = conv(result2, filter_3);
X_3 = fftshift(fft(result3));
N3 = (-length(result3)/2 : length(result3)/2 -1)*fs3 /length(result3)/1000;
plot(handles.axes4,N3 , abs(X_3));
xlabel(handles.axes4,'Frequency(kHz)');
ylabel(handles.axes4,'Magnitude');
audiowrite('result_3.wav',result3 , fs3); %노이즈 3차 제거된사운드

x_play = result3;
fs_play = fs3;


% --- Executes on button press in originalstart.
function originalstart_Callback(hObject, eventdata, handles)
% hObject    handle to originalstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x1;
global fs1;
global sound1;
sound1 = audioplayer(x1,fs1);
play(sound1)


% --- Executes on button press in originalstop.
function originalstop_Callback(hObject, eventdata, handles)
% hObject    handle to originalstop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sound1;
stop(sound1);


% --- Executes on button press in original.
function original_Callback(hObject, eventdata, handles)
% hObject    handle to original (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x1;
global fs1;
global x2;
global fs2;
global x3;
global fs3;
global filename1;
global X;
global N;
global x_play;
global fs_play;

singp=imread('singp.png');
axes(handles.axes5);
imshow(singp);

[filename1, path1] = uigetfile( '*.mp3');
[x1,fs1] = audioread([path1 '\' filename1]);
X = fftshift(fft(x1(:, 1)));
N = (-length(X)/2 : length(X)/2 - 1)*fs1 / length(X)/1000;
plot(handles.axes1,N,abs(X));
title(handles.axes1,filename1);
xlabel(handles.axes1,'Frequency(kHz)');
ylabel(handles.axes1,'Magnitude');

[x2, fs2] = audioread('A.MP3');

x = x1;
xFs = fs1;
y = x2;

minvoice = min(length(x),length(y));

x = x(1:minvoice);
y = y(1:minvoice);

x = interp1(1:length(x) , x , 1:length(y));

z = x*5 + y;

audiowrite('plussound.wav',z,xFs);


[x3,fs3] = audioread('plussound.wav');
X = fftshift(fft(x3));

N = (-length(X)/2 : length(X)/2 - 1)*fs3 / length(X)/1000;

x_play = x3;
fs_play = fs3;


% --- Executes on button press in filter1start.
function filter1start_Callback(hObject, eventdata, handles)
% hObject    handle to filter1start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x_play;
global fs_play;
global sound_play;

sound_play = audioplayer(x_play,fs_play);
play(sound_play);


% --- Executes on button press in filter1stop.
function filter1stop_Callback(hObject, eventdata, handles)
% hObject    handle to filter1stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sound_play;
stop(sound_play)


% --- Executes on button press in filter2start.
function filter2start_Callback(hObject, eventdata, handles)
% hObject    handle to filter2start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x_play;
global fs_play;
global sound_play;

sound_play = audioplayer(x_play,fs_play);
play(sound_play);


% --- Executes on button press in filter2stop.
function filter2stop_Callback(hObject, eventdata, handles)
% hObject    handle to filter2stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sound_play;
stop(sound_play)


% --- Executes on button press in filter3start.
function filter3start_Callback(hObject, eventdata, handles)
% hObject    handle to filter3start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global x_play;
global fs_play;
global sound_play;

sound_play = audioplayer(x_play,fs_play);
play(sound_play);


% --- Executes on button press in filter3stop.
function filter3stop_Callback(hObject, eventdata, handles)
% hObject    handle to filter3stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global sound_play;
stop(sound_play)


% --- Executes on button press in Home.
function Home_Callback(hObject, eventdata, handles)
% hObject    handle to Home (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all;
close;
run('Firstpage.m');


function resultedit_Callback(hObject, eventdata, handles)
% hObject    handle to resultedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of resultedit as text
%        str2double(get(hObject,'String')) returns contents of resultedit as a double


% --- Executes during object creation, after setting all properties.
function resultedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to resultedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in result.
function result_Callback(hObject, eventdata, handles)
% hObject    handle to result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global MN;
run('Findmusic.m');
set(handles.resultedit,'String', MN);


% --- Executes on button press in Exit.
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all;
close;


% --- Executes on button press in MRcheck.
function MRcheck_Callback(hObject, eventdata, handles)
close;
run('MRpage');
% hObject    handle to MRcheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
