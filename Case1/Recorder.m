fs=48000;

Signal = audiorecorder(48000, 16, 1);
pause
record(Signal);
pause

stop(Signal);

play(Signal);

x = getaudiodata(Signal);
N=length(x);


plot([0:N-1]*1/48000, x)


save('record.mat','x','fs','N');
pause
%%

Baudrate=2;
fstart=500;
fstop=10000;
SNRdB=10;
timeout=1;
splits=5;

[frekvenser,SNRdB_seq]=FSKanalyser(x',fs,Baudrate,fstart,fstop,SNRdB,timeout,splits,1,2);

besked=FSKdekoder( frekvenser, fstart, fstop );
title('SNR i dB');
xlabel('');
ylabel('');

figure
plot(SNRdB_seq)


disp(besked);
