fs=48000;

Signal = audiorecorder(48000, 16, 1);

record(Signal);
pause;

stop(Signal);

play(Signal);

x = getaudiodata(Signal);
N=length(x);


plot([0:N-1]*1/48000, x)


save('record.mat','x','fs','N');
 
figure
spectrogram(x, rectwin(fs/10), 0, fs/10, fs)