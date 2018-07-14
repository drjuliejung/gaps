function [intervals, durations] = i_d_from_variable(vibrations, range, min_interval, min_duration, delta_t)

num_vibrations = numel(vibrations);

intervals = cell(num_vibrations, 1);
durations = cell(num_vibrations, 1);

for j=1:num_vibrations    
    id_finder(range, min_interval/delta_t, min_duration/delta_t, vibrations{j});

    intervals{j} = double(interval_lengths)*double(delta_t);
    durations{j} = double(duration_lengths)*double(delta_t);
end