clear
clc
close all


fs=48000;
f0=785;
omega=f0/fs*2*pi

z0=1*exp(j*omega)
z1=z0'

p0=0.999*exp(j*omega)
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
semilogx([0:round(length(x)/2)-1]*fs,20*log10(abs(X(1:round(length(x)/2)))))
sound(x, fs);
pause
y=filter(B, A, x);
Y=fft(y);
figure
plot([0:length(x)-1]*1/fs, y)
figure
semilogx([0:round(length(x)/2)-1]*fs,20*log10(abs(Y(1:round(length(x)/2)))))
sound(y, fs);