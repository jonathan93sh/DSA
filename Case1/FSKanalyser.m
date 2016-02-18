function [ frekvens_seq, SNRdB_seq ] = FSKanalyser( x, fs, Baudrate, fstart, fstop, SNRdB, timeout, splits, fast, N_min_mul )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% clear
% N_min_mul = 2;
% fstart = 500;
% fstop = 10000;
fast=1;
% Baudrate=2;
% SNRdB=10;
% timeout=5;
% 
% splits=5;

% load('record.mat')
% 
% x=x';


%sound(x, fs)

fstep=(fstop-fstart)/256;

N_min=round(fs/fstep)*N_min_mul;%antal samples der skal være før frekvens opløsningen er stor nok.

N=length(x);

Nsymbol = round(fs/Baudrate); % antal sampels par symbol

% hvor mange dele den vil splitte signal op i før den køre DFT. grund til 
% at den får 5 gange så mange signaler er for at undgå overlapping af 
% signal og fjerne de cuts som har overlapping i sig.
cut=round((N/Nsymbol)*splits); 

Ncut=round(Nsymbol/splits);
figure
spectrogram(x, hamming(Ncut), 0, N_min, fs)


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
        Spektro(n,:)=mDFT(hamming(N_min)'.*x(Ncut*(n-1)+1:(Ncut*(n-1))+N_min));
    else
        Spektro(n,:)=mDFT(hamming(Ncut)'.*x(Ncut*(n-1)+1:Ncut*n));
    end
end

frekvenser=zeros(cut, 3);


for n = [1:cut]
    if(fast)
        [frekvenser(n,1), frekvenser(n,2)]=max(Spektro(n,:));
        if(frekvenser(n,2)~=1)&&(frekvenser(n,2)~=N_min)
            %frekvenser(n,3)=10*log10(max(Spektro(n,:).^2)/(sum(Spektro(n,:).^2)-max(Spektro(n,:).^2)))
            frekvenser(n,3)=10*log10(sum(Spektro(n,frekvenser(n,2)-1:frekvenser(n,2)+1).^2)/(sum(Spektro(n,:).^2)-sum(Spektro(n,frekvenser(n,2)-1:frekvenser(n,2)+1).^2)));
        else
            frekvenser(n,3)=nan;
        end
        frekvenser(n,2)=frekvenser(n,2)*fs/N_min;
    end
end


n_start=0; % find start punkt for signalet.

for n = [1:cut-splits]
    temp_count=1;
    if(frekvenser(n,3)>=SNRdB)
        for m=[1:splits-1]
            if(frekvenser(n,2)==frekvenser(n+m,2))&&(frekvenser(n+m,3)>=SNRdB)
                temp_count = temp_count+1;
            else
                break;
            end
        end
        if(temp_count>=splits-2)
            n_start=n;
            break;
        end
    end
end

frekvens_seq=0;
SNRdB_seq=0;
point=1;
timeouts=0;
for n = [n_start:splits:cut-splits]
    
    temp_count=0;
    [ans,temp_n]=max(frekvenser(n:n+splits-1,3));
    temp_n=temp_n+n-1;
    
    if(frekvenser(temp_n,3)>=SNRdB)
        for m=[0:splits-1]
            if(frekvenser(temp_n,2)==frekvenser(n+m,2))&&(frekvenser(n+m,3)>=SNRdB)
                temp_count = temp_count+1;
            end
        end
        if(temp_count>=splits-2)
            frekvens_seq(point)=frekvenser(n,2);
            SNRdB_seq(point)=frekvenser(n,3);
        else
            timeouts=timeouts+1;
            frekvens_seq(point)=-1;
            SNRdB_seq(point)=frekvenser(n,3);
        end
    else
        timeouts=timeouts+1;
        frekvens_seq(point)=-1;
        SNRdB_seq(point)=frekvenser(n,3);
    end
%     if(timeouts == timeout)
%         break;
%     end
    point = point + 1;
    
end
    
    
    
end

