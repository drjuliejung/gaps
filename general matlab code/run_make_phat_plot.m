% figure
%
% subplot(2,1,1)       % add first plot in 2 x 1 grid
% CategoricalScatterplot(hatching_times_16_2, num_hatching_competent_16_2, stimulus_length_16, 10) %s3
% axis([0 450 0 1])
% hold on;
% line([ForAnnotations{2,2} ForAnnotations{2,2}], ylim);
% line([ForAnnotations{2,3} ForAnnotations{2,3}], ylim);
% line([ForAnnotations{2,4} ForAnnotations{2,4}], ylim);
%
% subplot(2,1,2)       % add second plot in 2 x 1 grid
% make_hatching_plot(truncated_hatching_times_27, num_hatching_competent_27, 60, 10) %s5
% axis([0 450 0 1])
% hold on;
% line([ForAnnotations{8,2} ForAnnotations{8,2}], ylim);
% line([ForAnnotations{8,3} ForAnnotations{8,3}], ylim);
% line([ForAnnotations{8,4} ForAnnotations{8,4}], ylim);

%% start

clear all
close all

read_data = table2array(readtable('raw_data.xlsx'));

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
