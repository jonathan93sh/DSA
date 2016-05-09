
clear
clc
close all

fs=48000;
f0=785;
omega=f0/fs*2*pi

z0=1*exp(j*omega)
z1=z0'

p0=0.99*exp(j*omega)
p1=p0'

omega_=linspace(-pi, pi, 10000);

B=[1, -(z1+z0), z1*z0]
A=[1, -(p0+p1), p1*p0]

H=((exp(j*omega_)-z0).*(exp(j*omega_)-z1))./((exp(j*omega_)-p0).*(exp(j*omega_)-p1));
figure
plot(omega_*(fs/(2*pi)), 20*log10(abs(H)))

%% test af filter

[x,fs] = audioread('tale_tone_48000.wav');

X=fft(x);
figure
plot([0:length(x)-1]*1/fs, x)
figure
spectrogram(x, hamming(1000), 0, 300, fs)
%semilogx([0:round(length(x)/2)-1]*fs,20*log10(abs(X(1:round(length(x)/2)))))
%sound(x, fs);
%pause
y=filter(B, A, x);
Y=fft(y);
figure
plot([0:length(x)-1]*1/fs, y)
figure
spectrogram(y, hamming(1000), 0, 300, fs)
%semilogx([0:round(length(x)/2)-1]*fs,20*log10(abs(Y(1:round(length(x)/2)))))
%sound(y, fs);

%% Kvantilialisering fejl og implemtering
% antal shift
close all
n=14;

B
A

PC_B_shift=round(B*2^n) % de Værdier der skal ned på 
PC_A_shift=round(A*2^n)

B_new=PC_B_shift*2^-n
A_new=PC_A_shift*2^-n

B_error_Kvant_SNR=20*log10(abs(B)./abs(B-B_new))
A_error_Kvant_SNR=20*log10(abs(A)./abs(A-A_new))

angle(roots(B_new))*fs/(2*pi)
angle(roots(A_new))*fs/(2*pi)

z=roots(B_new)
p=roots(A_new)

H=((exp(j*omega_)-z(1)).*(exp(j*omega_)-z(2)))./((exp(j*omega_)-p(1)).*(exp(j*omega_)-p(2)));
figure
plot(omega_*(fs/(2*pi)), 20*log10(abs(H)))
