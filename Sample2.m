global X_3;
global x2;
global rsong2;

%% Sample2 (TWICE-Fancy)
[song1,songfs1] = audioread('fancy.mp3');
x = song1;
xFs = songfs1;
y = x2;

minvoice = min(length(x),length(y));
x = x(1:minvoice);
y = y(1:minvoice);
x = interp1(1:length(x) , x , 1:length(y));
z = x*5 + y;
audiowrite('sample2.wav',z,xFs);
[x3,fs3] = audioread('sample2.wav');

%필터_1 정의(BAND-STOP FILTER)
f1Fs = 44100;  
f1N    = 90;       
f1Fc1  = 3000;     
f1Fc2  = 5000;
win = hamming(f1N+1);
filter_1  = fir1(f1N, [f1Fc1 f1Fc2]/(f1Fs/2), 'stop', win);

%FILTERING_1
result1 = conv(x3,filter_1);

f2Fs = 44100;  
f2N    = 90;      
f2Fc   = 1000;     
win2 = hamming(f2N+1);
filter_2  = fir1(f2N, f2Fc/(f2Fs/2), 'low', win2);

%FILTERING2
result2 = conv(result1, filter_2);

%필터3 정의(BAND-PASS FILTER)
f3Fs = 44100; 
f3N  = 150;       
f3Fc1  = 10;       
f3Fc2  = 900;      
win3 = hamming(f3N+1);
filter_3  = fir1(f3N, [f3Fc1 f3Fc2]/(f3Fs/2), 'bandpass', win3);

%FILTERING_3
result3 = conv(result2, filter_3);
S1_3 = fftshift(fft(result3));

minLen1 = min(length(S1_3), length(X_3));
Song1_compose = S1_3(1:minLen1);
X3_compose1 = X_3(1:minLen1);
rsong2 = max(abs(xcov(abs(Song1_compose),abs(X3_compose1),'coeff')))*100;