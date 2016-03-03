%Case 1 opg 1 - Analyse af signal
clear
clc
close all

[x,fs] = audioread('tale_tone_48000.wav');

plot(x)
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 10])
print('foto/tidssignal FØR filtrering opg1' ,'-dpng')

fft_plot(fft(x),fs,'Analyse af tone',10,10);
%ud fra billederne kan man danne sig en idé om at tonen ligger ved 785Hz

figure
spectrogram(x,hamming(4000),0,4000,fs);
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 20 10])
print('foto/spektrogram analyse opg1' ,'-dpng')