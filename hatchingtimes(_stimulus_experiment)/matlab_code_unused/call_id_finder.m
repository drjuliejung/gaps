% Function: call_id_finder
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
function [mean_i_peak_percent, mean_d_peak_percent, mean_seq_peak_percent, sd_i_peak_percent, sd_d_peak_percent, sd_seq_peak_percent] = ...
    call_id_finder (range, min_interval, min_duration, vibrations, delta_t, i_range, d_range)

% sum variables for each percentage to calculate the mean of
sum_i_peak_percent = 0;
sum_d_peak_percent = 0;
sum_seq_peak_percent = 0;

% square sum variable for each percentage to calculate the SD of
sq_sum_i_peak_percent = 0;
sq_sum_d_peak_percent = 0;
sq_sum_seq_peak_percent = 0;

% number of vibrations
num_vibrations = numel(vibrations);

% make sure there is at least 1 vibration in vibrations cell
assert(num_vibrations > 0, ...
      'must have at least 1 vibration in vibrations cell');

% for each vibration, call id_finder and count_id_peak_hatching to get the
% number of intervals, durations, and sequences within the input ranges
for i = 1:num_vibrations
    id_finder(range, min_interval, min_duration, vibrations{i});
    
    [num_i_peak, num_d_peak, num_seq_peak] = ...
        count_id_peak_hatching(interval_lengths, duration_lengths, duration_first, delta_t, i_range, d_range);

    num_intervals = numel(interval_lengths);
    num_durations = numel(duration_lengths);
    
    % Get the percent of the number of I/D/seq within input range over the
    % total number of I/D/seq, because each vibration is of differing
    % lengths. Also, if there are no intervals or durations found at all,
    % set the percent to 0, because otherwise 0/0 gives NaN, which screws 
    % up later calculations
    if (num_intervals > 0)
        i_peak_percent = num_i_peak / num_intervals;
    else
        i_peak_percent = 0;
    end
    
    if (num_durations > 0)
        d_peak_percent = num_d_peak / num_durations;
    else
        d_peak_percent = 0;
    end
        
    if (num_intervals > 0 && num_durations > 0)
        seq_peak_percent = num_seq_peak / (numel(interval_lengths) + numel(duration_lengths) - 1);
    else
        seq_peak_percent = 0;
    end
    
    % update the sum and square sum of the percentages
    sum_i_peak_percent = sum_i_peak_percent + i_peak_percent;
    sum_d_peak_percent = sum_d_peak_percent + d_peak_percent;
    sum_seq_peak_percent = sum_seq_peak_percent + seq_peak_percent;
    
    sq_sum_i_peak_percent = sq_sum_i_peak_percent + (i_peak_percent * i_peak_percent);
    sq_sum_d_peak_percent = sq_sum_d_peak_percent + (d_peak_percent * d_peak_percent);
    sq_sum_seq_peak_percent = sq_sum_seq_peak_percent + (seq_peak_percent * seq_peak_percent);
end

% calculate the mean and SD of the percentages for I/D/seq
mean_i_peak_percent = sum_i_peak_percent / num_vibrations;
mean_d_peak_percent = sum_d_peak_percent / num_vibrations;
mean_seq_peak_percent = sum_seq_peak_percent / num_vibrations;

sd_i_peak_percent = sqrt((sq_sum_i_peak_percent / num_vibrations) - ...
    (mean_i_peak_percent * mean_i_peak_percent));
sd_d_peak_percent = sqrt((sq_sum_d_peak_percent / num_vibrations) - ...
    (mean_d_peak_percent * mean_d_peak_percent));
sd_seq_peak_percent = sqrt((sq_sum_seq_peak_percent / num_vibrations) - ...
    (mean_seq_peak_percent * mean_seq_peak_percent));
