function [bincounts] = make_log_hist_errbar(data_cell, min_val, max_val, num_bins, t)

log_bins = logspace(log10(min_val), log10(max_val), num_bins+1);
num_cells = numel(data_cell);

bincounts = zeros(num_cells, num_bins+1);
cells_within_range_count = 0;

percent_below_min_val = zeros(num_cells, 1);
percent_above_max_val = zeros(num_cells, 1);
non_empty_cells_count = 0;

for i=1:num_cells
    if (~isempty(data_cell{i}))
        data_within_range = data_cell{i}(find(data_cell{i} >= min_val & data_cell{i} <= max_val));
        
        if (~isempty(data_within_range))
            cells_within_range_count = cells_within_range_count + 1;
            s = sum(hist(data_within_range));
    
            bincounts(cells_within_range_count,:) = (histc(data_within_range, log_bins) ./ s)';
        end
        
        non_empty_cells_count = non_empty_cells_count + 1;
        percent_below_min_val(non_empty_cells_count) = double(numel(data_cell{i}(find(data_cell{i} < min_val))))/double(numel(data_cell{i}));
        percent_above_max_val(non_empty_cells_count) = double(numel(data_cell{i}(find(data_cell{i} > max_val))))/double(numel(data_cell{i}));
    end
end

bincounts = bincounts(1:cells_within_range_count, :);
se_err = std(bincounts)/sqrt(cells_within_range_count);

bar(log_bins, mean(bincounts), 'histc');
hold on;

barsx = zeros(num_bins+1,1);

for i=1:num_bins
    barsx(i) = geomean([log_bins(i), log_bins(i+1)]);
end

errorbar(barsx, mean(bincounts), se_err, 'rx');

set(gca, 'XScale', 'log');
set(gca,'XLim',[log_bins(1), log_bins(num_bins+1)]);
set(gca,'XTick',log_bins);
set(gca,'XTickLabel', round(log_bins * 100)/100);

ylim([0 1]);

title(t);
xlabel('seconds');
ylabel('proportion of data in bin');

sh = findall(gcf,'marker','*');
delete(sh);

percent_above_max_val = percent_above_max_val(1:non_empty_cells_count);
percent_below_min_val = percent_below_min_val(1:non_empty_cells_count);

str1 = sprintf('%g %% percent of data is greater than %g second(s) on average, with SD %g', ...
    round(mean(percent_above_max_val)*100), max_val, round(std(percent_above_max_val) * 100)/100);
str2 = sprintf('%g %% percent of data is less than %g second(s) on average, with SD %g', ...
    round(mean(percent_below_min_val)*100), min_val, round(std(percent_below_min_val) * 100)/100);

h = gca;

if (mod(num_bins, 2) == 0)
    xPos = log_bins(ceil((num_bins+1)/2));
else
    xPos = geomean([log_bins(floor((num_bins+1)/2)), log_bins(floor((num_bins+1)/2) + 1)]);
end

yPos = ylim(h);
txt1 = text(xPos, yPos(2)-0.05, str1);
txt2 = text(xPos, yPos(2)-0.1, str2);
set(txt1, 'HorizontalAlignment', 'center');
set(txt2, 'HorizontalAlignment', 'center');

hold off;

