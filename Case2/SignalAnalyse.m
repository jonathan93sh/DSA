%Case 1 opg 1 - Analyse af signal
clear
clc
close all

[x,fs] = audioread('tale_tone_48000.wav');

plot(abs(fft(x)))
%fft_plot(X,fs,'Analyse af signal',10,10);


spectrogram(x,hamming(1024),0,length(x),fs);