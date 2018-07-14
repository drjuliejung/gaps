function [seq_arrays, i_or_d_arrays] = get_sequence_arrays_not_seconds(range, min_interval, min_duration, vibrations, delta_t)

num_vibrations = numel(vibrations);

seq_arrays = cell(1, num_vibrations);
i_or_d_arrays = cell(1, num_vibrations);

for j = 1:num_vibrations
    id_finder(range, min_interval/delta_t, min_duration/delta_t, vibrations{j});
    
    % merge the interval and duration arrays into a single sequence array that
    % alternates between intervals and durations, and starts with a duration if
    % duration_first is true, interval if false
    first = interval_lengths;
    second = duration_lengths;
    
    if duration_first
        first = duration_lengths;
        second = interval_lengths;
    end
    
    num_first = numel(first);
    num_second = numel(second);
    
    seq_arrays{j} = zeros(num_first*2, 1);
    i_or_d_arrays{j} = false(num_first*2, 1);
    
    if num_first > num_second
        seq_arrays{j} = zeros(num_first*2 - 1, 1);
        i_or_d_arrays{j} = false(num_first*2 - 1, 1);
    end
    
    for i = 1:numel(seq_arrays{j})
        if mod(i, 2) == 1
            seq_arrays{j}(i) = first(uint32(i/2));
            
            if duration_first
                i_or_d_arrays{j}(i) = true;
            end
        else
            seq_arrays{j}(i) = second(uint32(i/2));
            
            if ~duration_first
                i_or_d_arrays{j}(i) = true;
            end
        end
    end
end