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
x_avg_mlod = mean(data_mlod);
std_mlod = std(data_mlod);
var_mlod = var(data_mlod);

x_avg_ulod = mean(data_ulod);
std_ulod = std(data_ulod);
var_ulod = var(data_ulod);

%% Histogram plots
figure
histfit(data_mlod)
title('Histogram for data med lod');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 10])
print('foto/histogram_mlod','-dpng')

figure
histfit(data_ulod)
title('Histogram for data uden lod');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 10])
print('foto/histogram_ulod','-dpng')

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
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 10])
print('foto/effekt_fft_mlod','-dpng')

%plots uden lod
figure, subplot(211);
plot((data_ulod).^2);
title('Effekt plot uden lod');
subplot(212);
semilogx([0:Nfft-1]*ts, 20*log10(abs(fft(data_ulod(1:Nfft)))));
grid on
title('FFT plot uden lod');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 10])
print('foto/effekt_fft_ulod','-dpng')

figure
spectrogram(data_mlod,hamming(50),0,5000,fs);
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 20 10])

figure
spectrogram(data_ulod,hamming(50),0,5000,fs);
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 20 10])

%% bit værdi

LSB = 1000/(x_avg_ulod-x_avg_mlod); %3.3534
