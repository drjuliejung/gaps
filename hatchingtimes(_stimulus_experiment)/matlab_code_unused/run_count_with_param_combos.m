% Function: run_count_with_param_combos
% 
% Description: Takes vectors for threshold values, min interval values, and
%              min duration values and runs call_id_finder on every
%              combination of these three parameters. Returns the results
%              in a data matrix.
%
% Parameters:
%     thresholds: vector containing the threshold values
%     min intervals: vector containing the min intervals (in seconds)
%     min durations: vector containing the min durations (in seconds)
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
%     data: a <total number of parameter combinations> by 6 matrix, in
%         which the first column is the threshold parameter value, the 
%         second column is the min interval parameter value, the third 
%         column, is the min duration parameter vlue, the fourth column is
%         the mean percentage of intervals within i_range for the 
%         vibrations given the parameter combination, the fifth column is 
%         the mean percentage of durations within d_range for the
%         vibrations given the parameter combination, and the sixth column
%         is the mean percentage of sequences within i_range and d_range
%         for the vibrations given the parameter combination.
%
% Author: Ming Guo
% Created: 1/23/13
function data = ...
    run_count_with_param_combos (thresholds, min_intervals, min_durations, vibrations, delta_t, i_range, d_range)

num_thresholds = numel(thresholds);
num_min_intervals = numel(min_intervals);
num_min_durations = numel(min_durations);

data = [];

% for each parameter combination, run call_id_finder
for i = 1:num_thresholds
    for j = 1:num_min_intervals
        for k = 1:num_min_durations
            cur_threshold = thresholds(i);
            cur_min_interval = min_intervals(j);
            cur_min_duration = min_durations(k);
            
            [mean_i_peak_rate, mean_d_peak_rate, mean_seq_peak_rate, sd_i_peak_rate, sd_d_peak_rate, sd_seq_peak_rate] = ...
            call_id_finder_rate (cur_threshold, cur_min_interval/delta_t, cur_min_duration/delta_t, vibrations, delta_t, i_range, d_range, 60);

            % make a new row containing the results for the current
            % parameter combination and append it to the return data matrix
            new_row = [cur_threshold, cur_min_interval, cur_min_duration, mean_i_peak_rate, mean_d_peak_rate, mean_seq_peak_rate];
            data = [data;new_row];
        end
    end
end
