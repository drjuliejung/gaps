% Function: call_id_finder_rate
% 
% Description: Takes the parameters for calling id_finder function and
%     calls id_finder on each vibration data from an input cell using those
%     parameters. It then calls count_id_peak_hatching for each vibration 
%     data, using the outputs of id_finder and input interval and duration 
%     ranges. With the output of count_id_peak_hatching, the function 
%     calculates the percent intervals, durations, and I/D sequences within
%     the input range. At the end, it finds the mean and SD for this 
%     percentage in all the vibrations in input cell.
%
% Parameters:
%     range: The threshold parameter to be passed to id_finder
%     min_interval: The min interval parameter to be passed to id_finder
%     min_duration: The min duration parameter to be passed to id_finder
%     vibrations: A cell containing the vectors of vibration data
%     delta_t: sampling rate of the data
%     i_range: a 2-element vector, in which the first element is the lower
%         bound of the interval range and the second element is the upper
%         bound of the interval range
%     d_range: a 2-element vector, in which the first element is the lower
%         bound of the duration range and the second element is the upper
%         bound of the duration range
%
% Returns:
%     mean_i_peak_percent: The percent of the intervals that are within the 
%         input interval range for a given vibration, averaged over all the 
%         input vibration data in the vibrations cell
%     mean_d_peak_percent: The percent of the durations that are within the 
%         input duration range for a given vibration, averaged over all the 
%         input vibration data in the vibrations cell
%     mean_seq_peak_percent: The percent of the sequences that are within
%         the interval and duration ranges for a given vibration, averaged
%         over all the input vibration data in the vibrations cell
%     sd_i_peak_percent: The standard deviation of the percentages of the 
%         intervals that are within the input interval range for all the 
%         vibration data in the vibration cell
%     sd_d_peak_percent: The standard deviation of the percentages of the 
%         durations that are within the input duration range for all the 
%         vibration data in the vibration cell
%     sd_seq_peak_percent: The standard deviation of the percentages of the 
%         sequences that are within the input interval and duration ranges 
%         for all the vibration data in the vibration cell
%
% Author: Ming Guo
% Created: 1/2/13
function [mean_i_peak_rate, mean_d_peak_rate, mean_seq_peak_rate, sd_i_peak_rate, sd_d_peak_rate, sd_seq_peak_rate] = ...
    call_id_finder_rate (range, min_interval, min_duration, vibrations, delta_t, i_range, d_range, rate_in_seconds)

% sum variables for each percentage to calculate the mean of
sum_i_peak_rate = 0;
sum_d_peak_rate = 0;
sum_seq_peak_rate = 0;

% square sum variable for each percentage to calculate the SD of
sq_sum_i_peak_rate = 0;
sq_sum_d_peak_rate = 0;
sq_sum_seq_peak_rate = 0;

% number of vibrations
num_vibrations = numel(vibrations);

% make sure there is at least 1 vibration in vibrations cell
assert(num_vibrations > 0, ...
      'must have at least 1 vibration in vibrations cell');
  
rate = rate_in_seconds/delta_t;

% for each vibration, call id_finder and count_id_peak_hatching to get the
% number of intervals, durations, and sequences within the input ranges
for i = 1:num_vibrations
    id_finder(range, min_interval, min_duration, vibrations{i});
    
    [num_i_peak, num_d_peak, num_seq_peak] = ...
        count_id_peak_hatching(interval_lengths, duration_lengths, duration_first, delta_t, i_range, d_range);

    i_peak_rate = rate * (num_i_peak/numel(vibrations{i}));
    d_peak_rate = rate * (num_d_peak/numel(vibrations{i}));
    seq_peak_rate = rate * (num_seq_peak/numel(vibrations{i}));
    
    % update the sum and square sum of the percentages
    sum_i_peak_rate = sum_i_peak_rate + i_peak_rate;
    sum_d_peak_rate = sum_d_peak_rate + d_peak_rate;
    sum_seq_peak_rate = sum_seq_peak_rate + seq_peak_rate;
    
    sq_sum_i_peak_rate = sq_sum_i_peak_rate + (i_peak_rate * i_peak_rate);
    sq_sum_d_peak_rate = sq_sum_d_peak_rate + (d_peak_rate * d_peak_rate);
    sq_sum_seq_peak_rate = sq_sum_seq_peak_rate + (seq_peak_rate * seq_peak_rate);
end

% calculate the mean and SD of the percentages for I/D/seq
mean_i_peak_rate = sum_i_peak_rate / num_vibrations;
mean_d_peak_rate = sum_d_peak_rate / num_vibrations;
mean_seq_peak_rate = sum_seq_peak_rate / num_vibrations;

sd_i_peak_rate = sqrt((sq_sum_i_peak_rate / num_vibrations) - ...
    (mean_i_peak_rate * mean_i_peak_rate));
sd_d_peak_rate = sqrt((sq_sum_d_peak_rate / num_vibrations) - ...
    (mean_d_peak_rate * mean_d_peak_rate));
sd_seq_peak_rate = sqrt((sq_sum_seq_peak_rate / num_vibrations) - ...
    (mean_seq_peak_rate * mean_seq_peak_rate));