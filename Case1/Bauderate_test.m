%% Test af Bauderate
close all
clear
clc

bauderate=[1:2:26];
besked_sender='123 Dip';

fstart = 1500;
fstop = 7500;
fs=48000;


%% Signal og optagelse på samme pc, med ekstern mic, som er sat en meter fra

Signal = audiorecorder(48000, 16, 1);

for br=bauderate
    disp(['Bauderate = ' num2str(br)]);
    record(Signal); % record.
    pause(0.5);
    Tsymbol=1/br;
    x_out = FSKgenerator(besked_sender, fstart, fstop, Tsymbol, fs);
    soundsc(x_out, fs)
    pause(Tsymbol*length(besked_sender)+0.5);
    stop(Signal); % test færdig og record done.
    
    x = getaudiodata(Signal);
    
    save(['data_test_bauderate/record_' num2str(round(br)) '.mat'],'x','fs');
end

%% Analyse
clc
close all

timeout=1;
splits=3;

plot_x=10; 
plot_y=10;


SNRdB=zeros(4,length(bauderate));
Procent_trans=zeros(1,length(bauderate));
count_2=1;
for br=bauderate
    close all;
    SNRdB(1,count_2)=br;
    load(['data_test_bauderate/record_' num2str(round(br)) '.mat'])
    
    figure
    [frekvenser,SNRdB_seq]=FSKanalyser_fast(x',fs,br,fstart,fstop,splits,4,1);
    title(['spectrogram - ' num2str(br) ' Bauderate']);
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 plot_x plot_y]);
    print(['data_test_bauderate/spectrogram - ' num2str(round(br)) ' Bauderate'],'-dpng');
    
    
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
    Procent_trans(count_2)=procent;
    
    
    figure
    plot(SNRdB_seq)
    title(['SNR i dB - ' num2str(round(br)) ' Bauderate - ' num2str(procent) '% - ' besked] );
    xlabel('#tegn');
    ylabel('dB');
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 plot_x plot_y]);
    print(['data_test_bauderate/SNR - ' num2str(round(br)) ' Bauderate'],'-dpng');

    disp([num2str(round(br)) ' Bauderate : procent ' num2str(procent) '%']);

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
    disp([num2str(round(br)) ' Bauderate : SNRdB: avg= ' num2str(SNRdB_avg) 'dB max= ' num2str(SNRdB_max) 'dB min= ' num2str(SNRdB_min) 'dB']);

    count_2=count_2+1;
end

close all;
figure
plot(bauderate, SNRdB(2,:));
hold on
plot(bauderate, SNRdB(3,:));
plot(bauderate, SNRdB(4,:));
title('SNR og Bauderate');
xlabel('Bauderate');
ylabel('dB');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 plot_x plot_y]);
print(['data_test_bauderate/SNR og bauderate'],'-dpng');

close all;
figure
plot(bauderate, Procent_trans);
title('Procent og Bauderate');
xlabel('Bauderate');
ylabel('Procent %');
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 plot_x plot_y]);
print(['data_test_bauderate/Procent og bauderate'],'-dpng');

