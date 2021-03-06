%% Opgave 1)
clear
close all
clc

%% indstillinger for Sonar

fs=44100;
M_down = 2;
fs_down=fs/M_down
v_sound=340;
hukommelse=10000;
signal_navn='3 lyde.mat';


% bygger signal

f0 = 10000;
f1 = 5000;
f2 = 1200;
T_step=0.005;
t=[0:fs*T_step]/fs;
Signal = chirp(t,10000,T_step,5000).*blackman(length(t))';% + chirp(t,f1,T_step,f2);

%Signal=[sin(fo*2*pi*t(1:round(end/4))).*blackman(length(t(1:round(end/4))))'  sin(f2*2*pi*t(1:round(end/2))).*blackman(length(t(1:round(end/2))))' sin(f1*2*pi*t(1:round(end/3))).*blackman(length(t(1:round(end/3))))']

%Signal=[chirp(t(1:round(end/4)),f0,0.01/4,f0-500).*blackman(length(t(1:round(end/4))))' chirp(t(1:round(end/4)),f2,0.01/4,f2-500).*blackman(length(t(1:round(end/4))))' chirp(t(1:round(end/4)),f1,0.01/4,f1-500).*blackman(length(t(1:round(end/4))))']


figure
%spectrogram(Signal,256,200,256,fs,'yaxis')

figure
plot([0:length(Signal)-1]/fs,Signal)

sound(Signal, fs)

%% minimum og maximum afstand. tollerance

T_signal=length(Signal)/fs

afstand_min=v_sound*T_signal/2

afstand_max=v_sound*2500/((fs/M_down)*2)

afstand_tol=v_sound/((fs/M_down)*2)



%% design decimering- og interpolation-filter

%ADC_N=16;
%ADC_SNRdB=6.02*ADC_N + 1.76

h=fir1(50,(1/M_down));

Signal_deci=conv(h,Signal);
freqz(h)

Signal_down=downsample(Signal_deci,M_down);
fs_down=fs/M_down;
%sound(y, fs)
figure
spectrogram(Signal_down,20,5,50,fs_down,'yaxis')

figure
plot([0:length(Signal_down)-1]/fs_down, Signal_down);

Signal_resample=conv(conv(upsample(Signal_down,M_down),ones(1,M_down)*M_down),ones(1,M_down));

figure
plot([0:length(Signal_resample)-1]/fs,Signal_resample);

Signal_kendt=downsample(conv(Signal_resample,h),M_down);

save(signal_navn,'Signal_kendt');

figure
plot([0:length(Signal_kendt)-1]/fs_down,Signal_kendt);
%% lav falsk eko signal

falsk_eko=[Signal_kendt zeros(1,length(Signal_kendt)*5) Signal_kendt*0.2 zeros(1,length(Signal_kendt))]+randn(1,length(Signal_kendt)*8)*2;

figure
plot([0:length(falsk_eko)-1]/fs_down,falsk_eko);

save('falsk_eko.mat','falsk_eko');

%% g�re data klar til blackfin.

blackfin_data=int16((y/2)*(2^(16-1)-1));
plot([0:length(blackfin_data)-1]/fs_down,blackfin_data)
soundsc(double(blackfin_data),fs_down)

bit=16;
max_h=max([max(h) abs(min(h))])

shift_max=floor((1/max_h)/2)+(bit-1)

blackfin_filter=int16(h*2^(shift_max))

%max(double(blackfin_filter)*2^-shift_max)



%% gemmer data i fil


fileID=fopen('AudioNotchFilter/src/blackfin_signal.h','w');

fprintf(fileID, '#define M %d\n', length(blackfin_filter));
fprintf(fileID, '#define M_SHIFT %d\n', shift_max);
fprintf(fileID, '#define UP_M %d\n', M_down);
fprintf(fileID, '#define UP_M_SHIFT %d\n', round(log2(M_down));
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

%% fake blackfin test

Signal = audiorecorder(fs_down, 16, 1);
pause(5)
record(Signal);
pause(1)
soundsc(Signal_kendt,fs_down)
pause(1)
stop(Signal);

play(Signal);

falsk_eko = getaudiodata(Signal);
falsk_eko=falsk_eko((1.2)*fs_down:end)'
N=length(falsk_eko);
figure
plot([0:N-1]/fs_down,falsk_eko)

save('falsk_eko.mat','falsk_eko');


%% Afl�ser resultat fra blackfin
load(signal_navn,'Signal_kendt');

%t=load('falsk_eko.mat');

load('falsk_eko.mat');
t=falsk_eko;

sound(t, fs_down);
pause(3);
sound(Signal_kendt, fs_down);

%sound(t(1:end)-mean(t),fs_down)
figure
plot([0:length(t)-1]/fs_down, t);
figure
plot([0:length(Signal_kendt)-1]/fs_down,Signal_kendt);
%spectrogram(t(2218:end)-mean(t(2218:end)),256,200,256,fs_down,'yaxis')
[c, lags]=xcorr(t-mean(t),Signal_kendt);

%[c, lags]=xcorr([zeros(1,length(Signal_kendt)), t(length(Signal_kendt)+1:end)]-mean(t(length(Signal_kendt):end)),Signal_kendt);
figure
plot((lags/fs_down)*v_sound/2,c)


[c, lags]=xcorr(Signal_kendt-mean(Signal_kendt));
figure
plot((lags/fs_down)*v_sound/2,c)