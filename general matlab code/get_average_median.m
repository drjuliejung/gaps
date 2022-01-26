function [med] = get_average_median(hatching_times)

num_trials = numel(hatching_times);
medians = zeros(num_trials, 1);

for i=1:num_trials
    medians(i) = median(hatching_times{i});
end

med = mean(medians);