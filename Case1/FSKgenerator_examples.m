% Spectrogram example
clear

fstart = 1000; % transmission band frequency start
fend = 2000; % transmission band frequency end
Tsymbol = 0.5; % symbol duration in seconds
fs = 20000; % sampling frequency

x = FSKgenerator('hasta la vista!', fstart, fend, Tsymbol, fs);

soundsc(x, fs)

subplot(211), plot(x)
subplot(212), plot(abs(fft(x)))

figure
spectrogram(x, rectwin(500), 0, 500, fs) % WINDOW = rectwin(500), NOVERLAP = 0, NFFT = 500 (no zero-padding), Fs = 20000


% Shorter duration and wider band
fstart = 500; % transmission band frequency start
fend = 5000; % transmission band frequency end
Tsymbol = 0.005; % symbol duration in seconds
x = FSKgenerator('hasta la vista!', fstart, fend, Tsymbol, fs);
soundsc(x, fs)
figure
spectrogram(x, hamming(100), 0, 100, fs)

% adding noise - SNR = 20 dB
P_sig = var(x);
P_noise = P_sig / (10^(20/10));    % P_noise = P_sig / SNR = P_sig / 10^(SNR_dB / 10)
e = randn(size(x))*sqrt(P_noise);  % white noise with P_noise
xnoisy = x + e;
figure
spectrogram(xnoisy, hamming(100), 0, 100, fs)


% adding noise - SNR = -10 dB
P_sig = var(x);
P_noise = P_sig / (10^(-10/10));    % P_noise = P_sig / SNR = P_sig / 10^(SNR_dB / 10)
e = randn(size(x))*sqrt(P_noise);  % white noise with P_noise
xnoisy = x + e;
figure
spectrogram(xnoisy, hamming(100), 0, 100, fs)


% "Ordinary" DFT analysis
Nsamples = Tsymbol*fs;
subplot(211), plot(abs(fft(x(1:Nsamples), 20000)))
subplot(212), plot(abs(fft(x(Nsamples + 1:2*Nsamples), 20000)))
% "Ordinary" DFT analysis - noisy
Nsamples = Tsymbol*fs;
subplot(211), plot(abs(fft(xnoisy(1:Nsamples), 20000)))
subplot(212), plot(abs(fft(xnoisy(Nsamples + 1:2*Nsamples), 20000)))
