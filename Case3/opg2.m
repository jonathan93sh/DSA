%% Design af midlingsfilter.
close all
clear
clc
load('vejecelle_data.mat'); % 1kg under 1020 -- uden lod over 1020
data=vejecelle_data;
clear vejecelle_data;
data_mlod = data(100:900);
data_ulod = data(1500:2300);
%Laver koefficienter til vores midlingsfilter
h10=ones(1,10)/10;
h50=ones(1,50)/50;
h100=ones(1,100)/100;

%Test midlingsfilter p� data.
data_ulod_10=conv(h10,data_ulod);
data_ulod_50=conv(h50,data_ulod);
data_ulod_100=conv(h100,data_ulod);
% plot af histogram
figure
histfit(data_ulod)
title('histogram uden filter')
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 3 3])
print(['foto/histogram_uden'],'-dpng')
figure
histfit(data_ulod_10(10:end-10))
title('histogram 10 ordens')
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 3 3])
print(['foto/histogram_10'],'-dpng')
figure
histfit(data_ulod_50(50:end-50))
title('histogram 50 ordens')
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 3 3])
print(['foto/histogram_50'],'-dpng')
figure
histfit(data_ulod_100(100:end-100))
title('histogram 100 ordens')
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 3 3])
print(['foto/histogram_100'],'-dpng')

%Plot af data med og uden filter.
figure
hold on
plot(data_ulod)
plot(data_ulod_10)
plot(data_ulod_50)
plot(data_ulod_100)
ylim([1300,1500])
xlabel('sekunder (s)')
ylabel('bit')
title('Plot af data med og uden filter.')
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5])
print(['foto/med_uden_filter_10_50_100'],'-dpng')

% m�ling af avg, rms og var. 
avg_meas=[mean(data_ulod), mean(data_ulod_10(11:end-11)), mean(data_ulod_50(51:end-51)), mean(data_ulod_100(101:end-101))];
rms_meas=[std(data_ulod), std(data_ulod_10(11:end-11)), std(data_ulod_50(51:end-51)), std(data_ulod_100(101:end-101))];
var_meas=rms_meas.^2;

% udregning af den forventet varians.
var_calc=var_meas(1)./[1:100];

% plot af den teoretisk deltaSNRdB
figure
plot([1:100],10*log10([1:100]))
xlabel('orden (M)')
ylabel('dSNR(dB)')
title('teoretisk deltaSNRdB')
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 3 3])
print(['foto/deltaSNRdB'],'-dpng')

% plot af varians
figure
semilogy([1:100],var_calc)
hold on
grid on
stem([1 10 50 100], var_meas)
xlabel('Orden (M)')
ylabel('varians')
title('plot af varians')
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5])
print(['foto/plot af varians'],'-dpng')


%% Krav max indsvingningstid 100ms

Ts=fs^-1

M=floor(0.1/Ts) % runder ned da ellers vil kravet ikke v�re opfyldt, dog
                % g�r tallet lige op s� det er ikke noget problem, men for 
                % god ordens skyld bruges floor alligevel.

h_M=ones(1,M)/M;

data_ulod_M=conv(data_ulod,h_M); % tester filter

mean_M=mean(data_ulod_M(M:end-M)) % m�lt avg

var_calc_M=var_meas(1)/M % forventet varians
rms_calc_M=sqrt(var_calc_M) % forventet rms

rms_M=std(data_ulod_M(M:end-M)) % m�lt rms
var_M=rms_M^2 % m�lt varians
% plot af m�lt og uregnet rms. og filtret data
figure
plot([0:length(data_ulod_M)-M*2]*Ts, data_ulod_M(M:end-M))
hold on
grid on
plot([0:length(data_ulod_M)-M*2]*Ts, (rms_calc_M+mean_M)*ones(1,length(data_ulod_M)-M*2+1));
plot([0:length(data_ulod_M)-M*2]*Ts, (rms_M+mean_M)*ones(1,length(data_ulod_M)-M*2+1));
plot([0:length(data_ulod_M)-M*2]*Ts, (mean_M)*ones(1,length(data_ulod_M)-M*2+1));
xlabel('sekunder (s)')
ylabel('bits')
title('plot af m�lt og uregnet rms. og filtret data')
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5])
print(['foto/100ms_rms_plot'],'-dpng')
%% Step test for at se om det opfylder kravet.

step_M=conv(h_M, ones(1, M));

figure
plot([1:length(step_M)-M+1]*Ts,step_M(1:end-M+1)) % kravet er opfyldt.
xlabel('sekunder (s)')
title('plot af step af designet filter 100ms')
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5])
print(['foto/100ms_step_plot'],'-dpng')
%% Eksponentielt midlingsfilter.

% test v�rdier af alfa.

x=ones(1,M);
figure
hold on
grid on
for a=[0:0.05:1]
   [b, a]=ExpMean(a);
   y=filter(b,a, x);
   plot([0:length(y)-1]*Ts, y);
    
end
xlabel('sekunder (s)')
title('plot af eksponentielt midlingsfilter. (step)')
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5])
print(['foto/eksponentielt midlingsfilter step'],'-dpng')


x=data;
indsving=[930:1300];
figure
hold on
grid on
for a=[0.05:0.05:0.2]
   [b, a]=ExpMean(a);
   y=filter(b,a, x);
   plot([0:length(y(indsving))-1]*Ts, y(indsving));
end
ylabel('bits')
xlabel('sekunder (s)')
title('plot af eksponentielt midlingsfilter. (data)')
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5])
print(['foto/eksponentielt midlingsfilter data'],'-dpng')
 
% udfra dette kan det ses at alfa nok skal v�re omkrin 0.2.

% udregn hvad alfa skal v�re hvis den skal have samme d�mpning som vores
% 100 ordens filter. ay^2=(a/(2-a))*ax^2

a=(2*var_calc(100))/(var_meas(1)+var_calc(100))
[b, a]=ExpMean(a);
figure
hold on
grid on
y=filter(b,a, x);
plot([0:length(y(indsving))-1]*Ts, y(indsving));
% m�lt rms og varians
rms_exp=std(y(1500:2300))
var_exp=rms_exp^2
% forventet rms og varians
var_calc(100)
rms_calc_100=sqrt(var_calc(100))

data_100=conv(h100,data);
plot([0:length(data_100(indsving))-1]*Ts, data_100(indsving));
ylabel('bits')
xlabel('sekunder (s)')
title('plot af eksponentielt midlingsfilter og 100ordens midlingsfilter. (data)')
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5])
print(['foto/eksponentielt midlingsfilter og 100 ordens data'],'-dpng')



% det kan ses at Eksponentielt midlingsfilter reagere hurtigere end det 100
% ordens filter, dog har den en l�ngere indsvingningstid.

%% ekstra opgave h�ndtering af korrupt data. med median filter

data_korrupt=data;
% �del�gger 0.1% af data'et
for i=1:length(data_korrupt);
    
    if(rand >= 0.999)
        data_korrupt(i)=round((2^24)*rand);
    end
end

figure
hold on
plot(data_korrupt)
plot(filter(b,a,data_korrupt))
ylim([1000,2500])
ylabel('bits')
xlabel('sekunder (s)')
title('korrupt data uden median og med eksponentielt midlingsfilter')
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5])
print(['foto/korrupt_uden'],'-dpng')

y=medfilt1(data_korrupt, 3);
figure
hold on
plot(y)
plot(filter(b,a,y))
ylim([1000,2500])
ylabel('bits')
xlabel('sekunder (s)')
title('korrupt data med median og eksponentielt midlingsfilter')
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 5 5])
print(['foto/korrupt'],'-dpng')

eksempel=median([1 2 2 2 inf 1 1 1])
