%100 ordens filter - Antal cifre, display?
clear;
load('vejecelle_data.mat')

data=vejecelle_data;
clear vejecelle_data;
data_mlod = data(100:900);
data_ulod = data(1500:2300);

%Filter coefficient
h100=ones(1,100)/100;

%Filter på data
data_ulod_100=conv(h100,data_ulod);

%plot
figure
hold on
plot(data_ulod)
plot(data_ulod_100)
ylim([1300,1500])
xlabel('sekunder (s)')
ylabel('bit')
title('Plot af data med og uden filter.')
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 10 10])
print(['foto/med_uden_filter_10_50_100'],'-dpng')

%Beregning af varians
rms_meas=[std(data_ulod), std(data_ulod_100(101:end-101))]
var_meas=rms_meas.^2
var_calc=var_meas(1)./[1:100];

%Spredning af støj

noise_spred=sqrt(var_meas)
















