function [ ] = fft_plot( fft, fs, name, plot_x, plot_y )
%FFT_PLOT Summary of this function goes here
%   Detailed explanation goes here

N=round(length(fft)/2);
ts=fs/(length(fft));

figure
semilogx([0:N-1]*ts, 20*log10(abs(fft(1:N))));
grid on
xlabel('Hz')
ylabel('dB')
title(['amplitude (dB) - ' name])

set(gcf,'PaperUnits','inches','PaperPosition',[0 0 plot_x plot_y])
print(['foto/fasespektrum ' name],'-dpng')

end

