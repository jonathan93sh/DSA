%%dsa case 3 opg 1
close all
clear
clc
load('vejecelle_data.mat'); % 1kg under 1020 -- uden lod over 1020
data=vejecelle_data;
clear vejecelle_data;
data_mlod = data(100:900);
data_ulod = data(1500:2300);

N = length(data_mlod);

%% varians og standard afvigelse
x_avg_mlod = mean(data_mlod); %1108.4
Svar_mlod = std(data_mlod); % 24.9647
var_mlod = Svar_mlod^2; %623.2354

x_avg_ulod = mean(data_ulod); %1404.9
Svar_ulod = std(data_ulod); %32.2977
var_ulod = Svar_ulod^2; %1043.1

%% Histogram plots
figure
histfit(data_mlod)
title('Histogram for data med lod');

figure
histfit(data_ulod)
title('Histogram for data uden lod');

% de er tilnærmelsesvist normalt fordelete. Da de næsten følger
% normalfordelings kurven. 
% og spredningen passer nogenlunde med hitogrammet.

%% Effekspektrumsstrøj
Nfft=round(length(fft(data_mlod))/2);
ts=fs/length(fft(data_mlod));

%plots med lod
figure, subplot(211);
plot((data_mlod).^2);
title('Effekt plot med lod');
subplot(212);
semilogx([0:Nfft-1]*ts, 20*log10(abs(fft(data_mlod(1:Nfft)))));
grid on
title('FFT plot med lod');

%plots uden lod
figure, subplot(211);
plot((data_ulod).^2);
title('Effekt plot uden lod');
subplot(212);
semilogx([0:Nfft-1]*ts, 20*log10(abs(fft(data_ulod(1:Nfft)))));
grid on
title('FFT plot uden lod');

figure
spectrogram(data_mlod,hamming(50),0,5000,fs);
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 20 10])

figure
spectrogram(data_ulod,hamming(50),0,5000,fs);
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 20 10])

%eftersom amplituden ikke varierer meget over frekvensspektrummet kan det
%siges, at der er hvid støj, da hvid støj per definition er at:
%Hvid støj dækker alle frekvenser lige kraftigt => der inden for det synlige
%spektrum er der lige meget energi i en given båndbredde uanset hvor den båndbredde ligger.  

%% bit værdi

LSB = 1000/(x_avg_ulod-x_avg_mlod); %3.3534
