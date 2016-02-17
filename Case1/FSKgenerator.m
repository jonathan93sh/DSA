function x = FSKgenerator(mysymbolseq, fstart, fstop, Tsymbol, fs)
% 
% mysymbolseq is string of chars - e.g. 'hello world'
% fs is sampling frequency
% fstart = transmission band frequency start
% fend = transmission band frequency end
% Tsymbol = symbol duration in seconds
% function x = FSKgenerator(mysymbolseq, fstart, fend, Tsymbol, fs)

%  fstart = 1000; % transmission band frequency start
%  fend = 2000; % transmission band frequency end
%  Tsymbol = 0.5; % symbol duration in seconds
%  fs = 20000; % sampling frequency
 
farray = linspace(fstart, fstop, 256); % 256 frequencies spread out in band
A = 1; % amplitude
n = 0:(round(Tsymbol*fs)-1);

myids = double(mysymbolseq); % convert 'abcd' to [97 98 99 100].. ie. 256 possible values

x = []; %empty array
for i=1:length(myids),
    myfreq = farray(myids(i)); % choose freq for current char
    sig = A*cos(2*pi*n*myfreq/fs); % create signal
    x = [x sig]; % add to full signal
end
