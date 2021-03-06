%% Opgave 1)
clear
close all
clc

%% Signal generation og indstillinger for SONAR
close all
fs=48000;
M_down = 4;
fs_down=fs/4;
v_sound=340;
hukommelse=10000;
signal_navn='Signal 2.mat';

% Signal generation
%V�lg hvilken type af signal der vil benyttes, sig=1 => 2 frekvenssweep lige efter hinanden.
%P� test resultaterne ses signal 1 som "maale_data..."
%sig = 2 => blot 1 frekvenssweep. P� test resultaterne ses det som "maale_data_signal_2..."

sig=2; 

%Valg af frekvenser, f0 = start frekvens for f�rste sweep i signal 1, hvor
%f1 er start frekvens for det andet sweep i signal 1. Begge frekvens sweep
%slutter hhv. f0-500 og f1-500, dvs. ved 2500Hz og 700hz.
f0 = 3000;
f1 = 1200;

%Chip1 = 3000-2500Hz, Chirp 2 = 1200-700Hz.
%Hvis sig=2 => Chirp = 1200-600Hz.
if(sig==1)
    T_step=0.02;
    t=[0:fs*T_step]/fs;

    Signal=[chirp(t(1:round(end/4)),f0,0.01/4,f0-500).*blackman(length(t(1:round(end/4)))).^0.2' chirp(t(1:round(end/4)),f1,0.01/4,f1-500).*blackman(length(t(1:round(end/4)))).^0.2'];

elseif(sig==2)
    T_step=0.01;
    t=[0:fs*T_step]/fs;
    
    Signal = chirp(t,1200,T_step,600).*blackman(length(t)).^0.2';
end

figure
spectrogram(Signal,hamming(256),200,256,fs,'yaxis');
str = sprintf('Spectrogram af Signal %d',sig);
title([str]);
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 20 10])
print(['foto/' str],'-dpng')

figure
plot([0:length(Signal)-1]/fs,Signal)
str = sprintf('Tidsdom�neplot af Signal %d',sig);
title([str]);
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 10])
print(['foto/' str],'-dpng')

sound(Signal, fs)

% Minimum,maximum afstand samt tollerance for signalet

T_signal=length(Signal)/fs

afstand_min=v_sound*T_signal/2

afstand_max=v_sound*2500/((fs/M_down)*2)

afstand_tol=v_sound/((fs/M_down)*2)

%% design decimation
% der bruges matlab egen hj�lpe funktion til hurtigt at generer h-
% koefficienterne 
h=fir1(50,(1/M_down));

%% design interpolation 

% det er et middlings filter hvor der er lige s� mange M koefficienterne
% som signalet bliver upsamplet med.

%% Downsample signalet f�r det kommer over p� blackfin.
% f�rst kommer signalet igennem filteret.
Signal_deci=conv(h,Signal); 
% hvorefter det bliver downsamplet. Det er ogs� dette data blackfin f�r.
Signal_down=downsample(Signal_deci,M_down); 
% udregning af den nye frekvens.
fs_down=fs/M_down 
% vi resampler vores signal tilbage igen, s� vi har en ide p� hvordan
% signalet kommer til at se ud efter at v�re kommet igennem begge filter.
Signal_resample=conv(conv(upsample(Signal_down,M_down),ones(1,M_down)*M_down),ones(1,M_down));
% Til sidst downsample signalet s� det kommer til at passe sammen med det
% der bliver samplet p� blackfin. Dette er ogs� vores kendte signal, og er
% det signal der vil blive ledt efter n�r der skal laves en afstand m�ling.
Signal_kendt=downsample(conv(Signal_resample,h),M_down);

save(signal_navn,'Signal_kendt', 'fs_down', 'h');

%% Plots

figure
freqz(h)

figure
spectrogram(Signal_down,20,5,50,fs_down,'yaxis')

figure
plot([0:length(Signal_down)-1]/fs_down, Signal_down);

figure
plot([0:length(Signal_resample)-1]/fs,Signal_resample);

figure
plot([0:length(Signal_kendt)-1]/fs_down,Signal_kendt);

%% g�re data klar til blackfin.
% finder den st�rste v�rdi i signalet, s� signalet kan blive skaleret bedst
max_signal=max(abs(Signal_kendt));
% skalere signalet og laver det om til short (int16).
blackfin_data=int16((Signal_kendt/max_signal)*(2^(16-1)-1));
plot([0:length(blackfin_data)-1]/fs_down,blackfin_data)
soundsc(double(blackfin_data),fs_down)

% shifter h koefficienterne, s� meget som muligt for at give s� pr�cist
% resultat som muligt.
bit=16;
max_h=max(abs(h))

shift_max=floor((1/max_h)/2)+(bit-1)

blackfin_filter=int16(h*2^(shift_max))

%% gemmer data i header fil

fileID=fopen('AudioNotchFilter/src/blackfin_signal.h','w');

fprintf(fileID, '#define M %d\n', length(blackfin_filter));
fprintf(fileID, '#define M_SHIFT %d\n', shift_max);
fprintf(fileID, '#define UP_M %d\n', M_down);
fprintf(fileID, '#define UP_M_SHIFT %d\n', round(log2(M_down)));
fprintf(fileID,'#define SIGNAL_SIZE %d\n',length(blackfin_data));

fprintf(fileID,'short h[M] = {\n%d', blackfin_filter(1));
for i=2:length(h)
    fprintf(fileID,', %d', blackfin_filter(i));
end
fprintf(fileID,'\n};\n');


fprintf(fileID,'short SIGNAL[SIGNAL_SIZE] = {\n');
fprintf(fileID,'%d', blackfin_data(1));
for i=2:length(blackfin_data)
    fprintf(fileID,', %d', blackfin_data(i));
end
fprintf(fileID,'\n};\n');
fclose(fileID);
%% Afl�ser resultat fra blackfin
close all
load(signal_navn,'Signal_kendt');

t=load('maale_data_signal_2_3m.dat');

%load('falsk_eko.mat');
%t=falsk_eko;

sound(t-mean(t), fs_down);

figure
plot([0:length(t)-1]/fs_down, t-mean(t));
figure
plot([0:length(Signal_kendt)-1]/fs_down,Signal_kendt);

[c, lags]=xcorr5000(t'-mean(t),Signal_kendt);

figure
plot((lags/fs_down)*v_sound/2,c)

