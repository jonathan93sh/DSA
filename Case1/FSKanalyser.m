%function [ besked ] = FSKanalyser( x, fs, Baudrate )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
clear
fstart = 500;
fstop = 10000;
fast=1;
Baudrate=2;
fstep=(fstop-fstart)/256

load('record.mat')

x=x';

sound(x, fs)

N_min=round(fs/fstep);%antal samples der skal være før frekvens opløsningen er stor nok.

N=length(x);

Nsymbol = round(fs/Baudrate); % antal sampels par symbol

% hvor mange dele den vil splitte signal op i før den køre DFT. grund til 
% at den får 5 gange så mange signaler er for at undgå overlapping af 
% signal og fjerne de cuts som har overlapping i sig.
cut=round((N/Nsymbol)*5); 

Ncut=round(Nsymbol/5);

if(Ncut<N_min)
    disp('Ncut er for lille, skal bruge zero padding !!!');
    return;
end

if(fast)
    Spektro=zeros(cut, round(N_min/2));
else
    Spektro=zeros(cut, round(Ncut/2));
end
    
for n = [1:cut]
    if(Ncut*n>N)
        break;
    end
    %Spektro(n,:)=
    disp(n);
    if(fast)
        Spektro(n,:)=mDFT(hamming(N_min).*x(Ncut*(n-1)+1:(Ncut*(n-1))+N_min));
    else
        Spektro(n,:)=mDFT(hamming(Ncut).*x(Ncut*(n-1)+1:Ncut*n));
    end
end

frekvenser=zeros(cut, 3);


for n = [1:cut]
    if(fast)
        [frekvenser(n,1), frekvenser(n,2)]=max(Spektro(n,:));
        frekvenser(n,3)=10*log10(max(Spektro(n,:).^2)/(sum(Spektro(n,:).^2)-max(Spektro(n,:).^2)))
    end
end
%end

