function [t] = get_average_time_n_percent_hatched(n, hatching_times)

num_trials = numel(hatching_times);
timepoints = zeros(num_trials, 1);

for i=1:num_trials
    timepoints(i) = prctile(hatching_times{i}, n);
end

t = mean(timepoints);