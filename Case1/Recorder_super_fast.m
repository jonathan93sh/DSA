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
fstart=800;
fstop=10000;
SNRdB=10;
timeout=1;
splits=5;

[frekvenser,SNRdB_seq]=FSKanalyser(x',fs,Baudrate,fstart,fstop,SNRdB,timeout,splits,2,2);

besked=FSKdekoder( frekvenser, fstart, fstop );

figure
plot(SNRdB_seq)
title('SNR i dB');
xlabel('#tegn');
ylabel('dB');


disp(besked);

SNRdB_avg=0;
SNRdB_max=SNRdB_seq(1);
SNRdB_min=SNRdB_seq(1);
count=0;
for n=1:length(SNRdB_seq)
    if(frekvenser(n)~=-1)
        SNRdB_avg=SNRdB_avg+SNRdB_seq(n);
        if(SNRdB_seq(n)>SNRdB_max)
            SNRdB_max=SNRdB_seq(n);
        elseif(SNRdB_seq(n)<SNRdB_min)
            SNRdB_min=SNRdB_seq(n);
        end
        count=count+1;
    end
end

SNRdB_avg=SNRdB_avg/count;

disp(['SNRdB: avg= ' num2str(SNRdB_avg) 'dB max= ' num2str(SNRdB_max) 'dB min= ' num2str(SNRdB_min) 'dB']);

%%
clear
fs=48000;

Signal = audiorecorder(48000, 16, 1);
pause
record(Signal);
pause

stop(Signal);

%play(Signal);

x = getaudiodata(Signal);
N=length(x);


plot([0:N-1]*1/48000, x)


save('data/record_20.mat','x','fs','N');

%% 
clc
clear
close all

Baudrate=2;
fstart=800;
fstop=10000;
SNRdB_min=7;
timeout=1;
splits=3;

plot_x=10; 
plot_y=10;

besked_sender='123 Dette er en test: abc';

list=[1 2 3 4 5 7 10 15 20];

SNRdB=zeros(4,length(list));
count_2=1;
for n=list
    close all;
    SNRdB(1,count_2)=n;
    load(['data/record_' num2str(n) '.mat'])
    
    figure
    [frekvenser,SNRdB_seq]=FSKanalyser_fast(x',fs,Baudrate,fstart,fstop,splits,2,2);
    title(['spectrogram - ' num2str(n) 'm']);
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 plot_x plot_y]);
    print(['foto/spectrogram - ' num2str(n) 'm'],'-dpng');
    
    
    besked=FSKdekoder( frekvenser, fstart, fstop );
    
    tegn=0;
    
    for n2=1:length(besked_sender)
        if(length(besked)>=n2)
            if(besked(n2)==besked_sender(n2))
                tegn=tegn+1;
            end
        end
    end
    
    procent=(tegn/length(besked_sender))*100;
    
    
    
    figure
    plot(SNRdB_seq)
    title(['SNR i dB - ' num2str(n) 'm - ' num2str(procent) '% - ' besked] );
    xlabel('#tegn');
    ylabel('dB');
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 plot_x plot_y]);
    print(['foto/SNR - ' num2str(n) 'm'],'-dpng');

    disp([num2str(n) 'm : procent ' num2str(procent) '%']);

    SNRdB_avg=0;
    SNRdB_max=SNRdB_seq(1);
    SNRdB_min=SNRdB_seq(1);
    count=0;
    for n_2=1:length(SNRdB_seq)
        if(frekvenser(n_2)~=-1)
            SNRdB_avg=SNRdB_avg+SNRdB_seq(n_2);
            if(SNRdB_seq(n_2)>SNRdB_max)
                SNRdB_max=SNRdB_seq(n_2);
            elseif(SNRdB_seq(n_2)<SNRdB_min)
                SNRdB_min=SNRdB_seq(n_2);
            end
            count=count+1;
        end
    end

    SNRdB_avg=SNRdB_avg/count;
    SNRdB(2,count_2)=SNRdB_avg;
    SNRdB(3,count_2)=SNRdB_max;
    SNRdB(4,count_2)=SNRdB_min;
    disp([num2str(n) 'm : SNRdB: avg= ' num2str(SNRdB_avg) 'dB max= ' num2str(SNRdB_max) 'dB min= ' num2str(SNRdB_min) 'dB']);

    count_2=count_2+1;
end

close all;
figure
plot(list, SNRdB(2,:));
hold on
plot(list, SNRdB(3,:));
plot(list, SNRdB(4,:));
title('SNR og afstand');
xlabel('m');
ylabel('dB');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 plot_x plot_y]);
print(['foto/SNR og afstand'],'-dpng');
