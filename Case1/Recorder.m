

Signal = audiorecorder(48000, 16, 1);

record(Signal);
pause(5);

stop(Signal);

play(Signal);

x = getaudiodata(Signal);
N=length(x);


plot([0:N-1]*1/48000, x)
