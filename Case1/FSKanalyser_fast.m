function [ frekvens_seq, SNRdB_seq ] = FSKanalyser_fast( x, fs, Baudrate, fstart, fstop, splits, workers, N_min_mul )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

fast=1;

fstep=(fstop-fstart)/256;

N_min=round(fs/fstep)*N_min_mul;%antal samples der skal være før frekvens opløsningen er stor nok.

N=length(x);

Nsymbol = round(fs/Baudrate); % antal sampels par symbol

% hvor mange dele den vil splitte signal op i før den køre DFT. grund til 
% at den får 5 gange så mange signaler er for at undgå overlapping af 
% signal og fjerne de cuts som har overlapping i sig.
cut=round((N/Nsymbol)*splits); 

Ncut=round(Nsymbol/splits);

spectrogram(x, hamming(Ncut), 0, N_min, fs)

zeropad=0;
if(Ncut<N_min)
    disp('Ncut er for lille, bruger zero padding !!!');
    zeropad=1;
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
    %disp((n/cut)*100);
    if(fast)
        if(zeropad)
            Spektro(n,:)=mDFT_fast(hamming(N_min)'.*[x(Ncut*(n-1)+1:Ncut*n), zeros(1, N_min-Ncut)], fstart, fstop, fs, workers, 1);
        else
            Spektro(n,:)=mDFT_fast(hamming(N_min)'.*x(Ncut*(n-1)+1:(Ncut*(n-1))+N_min), fstart, fstop, fs, workers, 1);
        end
    else
        Spektro(n,:)=mDFT(hamming(Ncut)'.*x(Ncut*(n-1)+1:Ncut*n));
    end
end

frekvenser=zeros(cut, 3);

save('test.mat','Spektro');

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
SNRdB_min_value=min(frekvenser(:,3));
SNRdB_min=(min(frekvenser(:,3))+max(frekvenser(:,3)))/3;

n_start=1; % find start punkt for signalet.

for n = [1:cut-splits]
    temp_count=1;
    if(frekvenser(n,3)>=SNRdB_min)
        for m=[1:splits-1]
            if(frekvenser(n,2)==frekvenser(n+m,2))&&(frekvenser(n+m,3)>=SNRdB_min)
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
disp(n_start);
frekvens_seq=0;
SNRdB_seq=0;
point=1;

for n = [n_start:splits:cut-splits]
    
    frq=zeros(4, splits);
    
    for n2 = 1:splits
        frq(3,:)=SNRdB_min_value; 
    end
    
    for n2 = 1:splits
        for n3 = 1:splits
            if(frq(1,n3)==0)||(frq(1,n3)==frekvenser(n+n2,2))
                if(frekvenser(n+n2,3)>frq(3,n3))
                    frq(3,n3)=frekvenser(n+n2,3);
                end
                frq(1,n3)=frekvenser(n+n2,2);
                frq(2,n3)=frq(2,n3)+frekvenser(n+n2,3);
                frq(4,n3)=frq(4,n3)+1;
                break;
            end
        end
    end
    [ans, temp_n]=max(frq(2,:));
    if(frq(4,temp_n)>=splits-2)&&(frq(3, temp_n)>SNRdB_min)
        frekvens_seq(point)=frq(1, temp_n);
        SNRdB_seq(point)=frq(3, temp_n);
        point = point + 1;
    end
end
    
    
    
end

