function [i_lengths, d_lengths] = ...
    call_id_finder2 (range, min_interval, min_duration, vibrations, delta_t)

% number of vibrations
num_vibrations = numel(vibrations);

i_lengths = cell(1, num_vibrations);
d_lengths = cell(1, num_vibrations);

% make sure there is at least 1 vibration in vibrations cell
assert(num_vibrations > 0, ...
      'must have at least 1 vibration in vibrations cell');

% for each vibration, call id_finder and count_id_peak_hatching to get the
% number of intervals, durations, and sequences within the input ranges
for i = 1:num_vibrations
    id_finder(range, min_interval/delta_t, min_duration/delta_t, vibrations{i});
    
    i_lengths{i} = double(interval_lengths).*delta_t;
    d_lengths{i} = double(duration_lengths).*delta_t;
end
