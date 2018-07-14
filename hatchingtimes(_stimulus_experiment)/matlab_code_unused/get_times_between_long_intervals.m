function [times_between_long_intervals, long_interval_total_time, interval_total_time, num_long_intervals, num_intervals] = get_times_between_long_intervals(seq_array, i_or_d, long_i_length)

num_in_seq = numel(seq_array);

prev_long_i_index = -1;

times_between_long_intervals = [];
time_count = 0;
times_index = 0;

long_i_count = 0;
i_count = 0;

interval_total_time = 0;
long_interval_total_time = 0;

% we go from the second index to the second-to-last index, because if the
% first and last elements of the sequence are intervals, we don't care
% about them because they might be cut off
for i=2:num_in_seq-1
    if (i_or_d(i) == false)
        i_count = i_count + 1;
        interval_total_time = interval_total_time + seq_array(i);
        
        if (seq_array(i) >= long_i_length)
            if (prev_long_i_index ~= -1)
                times_index = times_index + 1;
                times_between_long_intervals(times_index) = time_count;
            end
            
            prev_long_i_index = i;
            time_count = 0; 
            
            long_i_count = long_i_count + 1;
            long_interval_total_time = long_interval_total_time + seq_array(i);
        else
            time_count = time_count + seq_array(i);
        end
    else
        time_count = time_count + seq_array(i);
    end
end

num_intervals = i_count;
num_long_intervals = long_i_count;
