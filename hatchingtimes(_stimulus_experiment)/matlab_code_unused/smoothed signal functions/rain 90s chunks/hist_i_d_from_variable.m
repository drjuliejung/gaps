function [intervals, durations] = hist_i_d_from_variable(vibrations, range, min_interval, min_duration, delta_t)

intervals = [];
durations = [];

num_vibrations = numel(vibrations);
    
for j=1:num_vibrations    
    id_finder(range, min_interval/delta_t, min_duration/delta_t, vibrations{j});

    intervals = [intervals; double(interval_lengths)*double(delta_t)];
    durations = [durations; double(duration_lengths)*double(delta_t)];
end