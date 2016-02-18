%% FSK signal
clear
% først skal der oprettes den ønsket besked:
besked='123 Dette er en test: abc';

% Her bliver de forskellige parameter sat op
fstart = 800;
fstop = 10000;
fs=10*fstop;
Baudrate=2;
Tsymbol=1/Baudrate;

% Her bruger vi FSKgeneratoren til at genere FSK signalet udfra vores
% parameter.
x = FSKgenerator(besked, fstart, fstop, Tsymbol, fs);
N=length(x);
% afspiller signalet overhøjtaleren.
soundsc(x, fs)

% plot af tid og frekvens.

subplot(211), plot([0:N-1]*1/fs,x), xlabel('tid( s )')
subplot(212), plot([0:N-1]*fs/N,abs(fft(x))), xlabel('frekvens( Hz )');

% spectrogram for at give en beder indsigt i hvordan frekvensen ændre sig
% over tiden.

figure
spectrogram(x, hamming(round(fs*Tsymbol)), 0, round(fs*Tsymbol), fs) % WINDOW = rectwin(500), NOVERLAP = 0, NFFT = 500 (no zero-padding), Fs = 20000

% gemmer signalet så det kan sendes til dekoderen.

save('FSKsignal.mat','x', 'fs', 'Baudrate');
