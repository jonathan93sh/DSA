clear;

fs=48000;
%% Input signal
load('Signal_1.mat');
in1 = Signal_kendt;
clear Signal_kendt;

load('Signal_2.mat');
in2 = Signal_kendt;
clear Signal_kendt;

% Signal 1 fra blackfin - load - 2 chirp
load('maale_data_1m.dat');
data1 = maale_data_1m;
clear maale_data_1m;

load('maale_data_2m.dat');
data2 = maale_data_2m;
clear maale_data_2m;

load('maale_data_3m.dat');
data3 = maale_data_3m;
clear maale_data_3m;

load('maale_data_4m.dat');
data4 = maale_data_4m;
clear maale_data_4m;

% Signal 2 fra blackfin - load - 1 chirp frek. sweep
load('maale_data_signal_2_1m.dat');
datas1 = maale_data_signal_2_1m;
clear maale_data_signal_2_1m;

load('maale_data_signal_2_2m.dat');
datas2 = maale_data_signal_2_2m;
clear maale_data_signal_2_2m;

load('maale_data_signal_2_3m.dat');
datas3 = maale_data_signal_2_3m;
clear maale_data_signal_2_3m;
%% plots

figure
plot(in1);

Nfft=round(length(fft(data4))/2);
ts=fs/length(fft(data4));

figure, subplot(211);
plot((data1));
title('Plot af data1');
subplot(212);
semilogx([0:Nfft-1]*ts, 20*log10(abs(fft(data1(1:Nfft)))));
grid on
title('FFT plot af data1');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 10])

figure, subplot(211);
plot((in1));
title('Plot af data4');
subplot(212);
semilogx([0:Nfft-1]*ts, 20*log10(abs(fft(in1(1:Nfft)))));
grid on
title('FFT plot af data4');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 10])

% Signal 1
figure, subplot(211);
plot([0:length(data1)-1]/fs,data1);
title('Plot af optaget lyd - 1m');
subplot(212);
plot([0:length(data1)-1]/fs,data1);
title('Plot af optaget lyd - 1m (ZOOM)');

figure
plot([0:length(data1)-1]/fs,data1);

figure
plot([0:length(data2)-1]/fs,data2);

figure
plot([0:length(data3)-1]/fs,data3);

figure, subplot(211);
plot([0:length(data4)-1]/fs,data4);
title('Plot af optaget lyd - 4m');
subplot(212);
plot([0:length(data4)-1]/fs,data4);
title('Plot af optaget lyd - 4m (ZOOM)');

% Signal 2
figure
plot([0:length(datas1)-1]/fs,datas1);

figure
plot([0:length(datas3)-1]/fs,datas3);

% Spektograms
figure
spectrogram(datas1,256,200,256,fs,'yaxis')

figure
spectrogram(data2,256,200,256,fs,'yaxis')

figure
spectrogram(data3,256,200,256,fs,'yaxis')

figure
spectrogram(data4,256,200,256,fs,'yaxis')

%% test 3
clear;
n=length(data1);
x1 = zeros(1,n);
x1(1:1, 1:length(in1)) = in1;
length(x1)
x2=data1;
xc=zeros(2*n-1,1);
for i=1:2*n-1
    if(i>n)
        j1=1;
        k1=2*n-i;
        j2=i-n+1;
        k2=n;
    else
        j1=n-i+1;
        k1=n;
        j2=1;
        k2=i;
    end
    xc(i)=sum(conj(x1(j1:k1))*x2(j2:k2));
end
%xc=flipud(xc); 

figure, subplot(211);
plot(xc);
title('Plot af krydskorrelationen - selvlavet');
subplot(212);
plot(x);
title('Plot af krydskorrelationen - matlab tool');

figure
plot(x);

figure
plot(xc);

% Her laves krydskorrelation af signalerne
[x,d] = xcorr(data1,in1);

%Tidsforskellen findes
%Peak værdi for signalet findes
[~,I] = max(abs(x));

%Delay findes
delay = d(I)  %50 samples
tidD = delay/fs   %0.001 sek. = 1 ms.

%Tiden er beregnet, nu kan afstanden findes

afstand = tidD*v_lys   %0,34 m.

[c, lags]=xcorr(in1-mean(data1));
figure
plot((lags/fs_down)*v_sound/2,c)
    
    



