clear all
close all

read_data = table2array(readtable('ambiguity_ffts.xlsx'));

figure

%%first panel
%subplot(311)

ix = read_data(:,1) <= 500;

hp = plot(...
    read_data(ix,1), read_data(ix,3), 'k',...
    read_data(ix,1), read_data(ix,5), 'r',...
    read_data(ix,1), read_data(ix,6), 'b'...
    );
xlim([0 500]);
ylim([50 110]);
legend({'Low', 'Med', 'High'});

set(gca,'Visible','off')

axes('Position',get(gca,'Position'),...
    'XAxisLocation','bottom',...
    'YAxisLocation','left',...
    'Color','none',...
    'XTickLabel',get(gca,'XTickLabel'),...
    'YTickLabel',get(gca,'YTickLabel'),...
    'XColor','k','YColor','k',...
    'LineWidth',2,...
    'TickDir','out');

format_plot(hp)
xlim([0 500]);
ylim([50 110]);

xlabel('Frequency (Hz)')
ylabel('Relative Amplitude (dB)')
legend off

print -depsc make_plots.eps
print -dpdf make_plots.pdf
print -djpeg -r600 make_plots.jpg