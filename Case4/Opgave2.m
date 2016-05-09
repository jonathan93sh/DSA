load('signal.mat');
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
