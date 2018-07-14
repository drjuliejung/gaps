function make_log_hist(data, min_val, max_val, t)

log_bins = logspace(log10(min_val), log10(max_val),10);

data_within_range = data(find(data >= min_val & data <= max_val));

s = sum(hist(data_within_range));

bar(log_bins, histc(data_within_range, log_bins) ./ s, 'histc');

set(gca, 'XScale', 'log');
set(gca,'XLim',[log_bins(1), log_bins(10)]);
set(gca,'XTick',log_bins);
set(gca,'XTickLabel', round(log_bins * 100)/100);

ylim([0 1]);

title(t);
xlabel('seconds');
ylabel('proportion of data in bin');

percent_higher = double(numel(data(find(data > max_val))))/double(numel(data));
percent_lower = double(numel(data(find(data < min_val))))/double(numel(data));
str1 = sprintf('%g %% percent of data is greater than %g second(s)', percent_higher*100, max_val);
str2 = sprintf('%g %% percent of data is less than %g second(s)', percent_lower*100, min_val);


h = gca;

xPos = log_bins(5);
yPos = ylim(h);
txt1 = text(xPos, yPos(2)-0.05, str1);
txt2 = text(xPos, yPos(2)-0.1, str2);
set(txt1, 'HorizontalAlignment', 'center');
set(txt2, 'HorizontalAlignment', 'center');