%% FSK signal
clear
% f�rst skal der oprettes den �nsket besked:
besked='123 dette er en test: abc';

% Her bliver de forskellige parameter sat op
fstart = 500;
fstop = 16000;
fs=10*fstop
Baudrate=50;
Tsymbol=1/Baudrate

% Her bruger vi FSKgeneratoren til at genere FSK signalet udfra vores
% parameter.
x = FSKgenerator(besked, fstart, fstop, Tsymbol, fs);
N=length(x);
% Kontrollere at signalet lyder rigtigt.
soundsc(x, fs)

% plot af tid og frekvens.

subplot(211), plot([0:N-1]*1/fs,x), xlabel('tid( s )')
subplot(212), plot([0:N-1]*fs/N,abs(fft(x))), xlabel('frekvens( Hz )');

% spectrogram for at give en beder indsigt i hvordan frekvensen �ndre sig
% over tiden.

figure
spectrogram(x, hamming(fs*Tsymbol), 0, fs*Tsymbol, fs) % WINDOW = rectwin(500), NOVERLAP = 0, NFFT = 500 (no zero-padding), Fs = 20000

% gemmer signalet s� det kan sendes til dekoderen.

save('FSKsignal.mat','x', 'fs', 'Baudrate');
