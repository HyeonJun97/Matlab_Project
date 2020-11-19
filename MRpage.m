function varargout = test(varargin)
% TEST MATLAB code for test.fig
%      TEST, by itself, creates a new TEST or raises the existing
%      singleton*.
%
%      H = TEST returns the handle to a new TEST or the handle to
%      the existing singleton*.
%
%      TEST('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST.M with the given input arguments.
%
%      TEST('Property','Value',...) creates a new TEST or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test

% Last Modified by GUIDE v2.5 06-Dec-2019 10:16:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_OpeningFcn, ...
                   'gui_OutputFcn',  @test_OutputFcn, ...
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


% --- Executes just before test is made visible.
function test_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test (see VARARGIN)
bg2 = axes('unit', 'normalized', 'position', [0 0 1 1]); 
% import the background image and show it on the axes
bg = imread('back.png'); imagesc(bg);
% prevent plotting over the background and turn the axis off
set(bg2,'handlevisibility','off','visible','off')
% making sure the background is behind all the other uicontrols
uistack(bg2, 'bottom');
% Choose default command line output for test
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes test wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = test_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1

% --- Executes on button press in MRC.
function MRC_Callback(hObject, eventdata, handles)
% hObject    handle to MRC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global melodysound;
%% 오선지 로드
akbo=imread('osun.png');
axes(handles.axes7);
imshow(akbo);

%% PCM 파일 로드
[fname, ppath] = uigetfile( '*.mp3');
[data,fs] = audioread([ppath '\' fname]);
melodysound = audioplayer(data,fs);
%% MR 생성
mr = data(:,1)-data(:,2);
mrs = [mr mr.*(-1)];    % MR Stereo 형식으로 저장

%% Adaptive filter 를 이용해 목소리만 강조
h = adaptfilt.lms(32,0.000008);
[mr_left,vocal_left] = filter(h,mrs(:,1),data(:,1));
[mr_right,vocal_right] = filter(h,mrs(:,2),data(:,2));

booster_vocal(:,1) = vocal_left;    % Stereo 형식으로 저장
booster_vocal(:,2) = vocal_right;

bv = (booster_vocal(:,1)+booster_vocal(:,2))/2; % STFT 를 위한 좌우 평균값
    
%% STFT를 통한 음계 그래프 그리기
    R = 10000;               % R: window length
    window = hamming(R);   % hamming window, length R
    N = 2^16;              % N: FFT resolution
    L = ceil(R*0.5);       % L: number of non-overlap samples
    overlap = R - L;       % Overlap = 50% of window length

    [s,f,t] = spectrogram(bv,window,overlap,N,44100,'yaxis');

    s2 = s(745:1487,:); % 500 ~ 1kHz 영역의 신호만 뽑아옴
    
    [X,Y] = meshgrid(t,f(745:1487));    % Meshgrid 생성
    
    Z = abs(s2);
    
contour(handles.axes1,X,Y,Z);
xlabel(handles.axes1,'Time');
ylabel(handles.axes1,'Frequency(kHz)');

axes7.Xaxis=X;
axes7.Yaxis=Y;

function melody1_Callback(hObject, eventdata, handles)
% hObject    handle to melody1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of melody1 as text
%        str2double(get(hObject,'String')) returns contents of melody1 as a double


% --- Executes during object creation, after setting all properties.
function melody1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to melody1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in melody.
function melody_Callback(hObject, eventdata, handles)
% hObject    handle to melody (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% 그래프에서 좌표 받아오기
button=1;
while button==1
[pointx,pointy,button]=ginput(1);
if button~=1
    break;
end
c=strcat(int2str(pointy));
%%c=strcat(int2str(pointx));
text(pointx,pointy-5,c);
b=pointy;
d='#';
if b>1109
    c='HIGH!';
else if b>1047
    c='3옥타브 도';
    pointy=103;
else if b>988
    c='2옥타브 시';
    pointy=103;
else if b>932
    c='2옥타브 라#';
    pointy=103;
else if b>880
    c='2옥타브 라';
    pointy=103;
else if b>831
    c='2옥타브 솔#';
    pointy=103;
else if b>784
    c='2옥타브 솔';
    pointy=103;
else if b>740
    c='2옥타브 파#';
    pointy=137;
else if b>698
    c='2옥타브 파';
    pointy=137;
else if b>659
    c='2옥타브 미';
    pointy=161;
else if b>622
    c='2옥타브 레#';
    pointy=193;
else if b>587
    c='2옥타브 레';
    pointy=193;
else if b>554
    c='2옥타브 도#';
    pointy=219;
else if b>524
    c='2옥타브 도';
    pointy=219;
else if b>494        
    c='1옥타브 시';
    pointy=242;
else if b>466
    c='1옥타브 라#';
    pointy=272;
else if b>440
    c='1옥타브 라';
    pointy=272;
else if b>415
    c='1옥타브 솔#';
    pointy=297;
else if b>392
    c='1옥타브 솔';
    pointy=297;
else if b>370
    c='1옥타브 파#';
    pointy=322;
else if b>349
    c='1옥타브 파';
    pointy=322;
else if b>330
    c='1옥타브 미';
    pointy=347;
else if b>311
    c='1옥타브 레#';
    pointy=382;
else if b>294
    c='1옥타브 레';
    pointy=382;
else if b>277
    c='1옥타브 도#';
    pointy=382;
else if b>261
    c='1옥타브 도';
    pointy=382;
else 
    c='LOW!'
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end
end    
end
end
end
end
end
end
end
end
end
end

if pointx<2
    pointx=180;
else if pointx<4
    pointx=310;
else if pointx<6
    pointx=440;
else if pointx<8
    pointx=570;
else if pointx<10
    pointx=700;
else if pointx<12
    pointx=830;
else if pointx<14
    pointx=960;
else pointx>14
    pointx=1080;
end;
end;
end;
end;
end;
end;
end;


set(handles.melody1,'String', c);

axes(handles.axes7);
hold on;
center=[pointx pointy];                
r=20;                              
N=100;            
theta=linspace(0,2*pi,N);  
x=r*cos(theta)+center(1);  
y=r*sin(theta)+center(2);   
plot(x,y,'k','Linewidth',3); 
if strcmp(c,'1옥타브 도#') || strcmp(c,'1옥타브 레#') || strcmp(c,'1옥타브 파#') || strcmp(c,'1옥타브 솔#') || strcmp(c,'1옥타브 라#') || strcmp(c,'2옥타브 도#') || strcmp(c,'2옥타브 레#') || strcmp(c,'2옥타브 파#') || strcmp(c,'2옥타브 솔#') || strcmp(c,'2옥타브 라#');  
text(pointx+10,pointy-40,d, 'fontweight','bold');
end

end

% --- Executes on button press in Home1.
function Home1_Callback(hObject, eventdata, handles)
% hObject    handle to Home1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all;
close;
run('Firstpage.m');


% --- Executes on button press in Exit1.
function Exit1_Callback(hObject, eventdata, handles)
% hObject    handle to Exit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear all;
close;


% --- Executes during object creation, after setting all properties.
function axes7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes7


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
akbo=imread('osun.png');
axes(handles.axes7);
imshow(akbo);


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global melodysound;
play(melodysound);

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global melodysound;
stop(melodysound);
