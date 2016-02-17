%function [ besked ] = FSKanalyser( x, fs, Baudrate )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

fstart = 500;
fstop = 10000;
fast=1;

fstep=(fstop-fstart)/256

load('record.mat')

x=x';

N_min=round(fs/fstep);%antal samples der skal v�re f�r frekvens opl�sningen er stor nok.

N=length(x);

Nsymbol = round(fs/Baudrate); % antal sampels par symbol

% hvor mange dele den vil splitte signal op i f�r den k�re DFT. grund til 
% at den f�r 5 gange s� mange signaler er for at undg� overlapping af 
% signal og fjerne de cuts som har overlapping i sig.
cut=round((N/Nsymbol)*5); 

Ncut=round(Nsymbol/5);

if(Ncut<N_min)
    disp('Ncut er for lille, skal bruge zero padding !!!');
    return;
end

if(fast)
    Spektro=zeros(cut, N_min);
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
        Spektro(n,:)=mDFT(x(Ncut*(n-1)+1:(Ncut*(n-1))+N_min*n));
    else
        Spektro(n,:)=mDFT(x(Ncut*(n-1)+1:Ncut*n));
    end
    test = 
end



%end
