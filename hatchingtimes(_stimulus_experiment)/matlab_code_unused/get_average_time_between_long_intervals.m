function [average_time_between_long_intervals, average_num_long_intervals, percent_long_intervals, percent_time_long_intervals, percent_with_long_intervals] = get_average_time_between_long_intervals( ...
    seq_arrays, i_or_d_arrays, long_i_length, max_length)

assert(numel(seq_arrays) == numel(i_or_d_arrays));
num_vibrations = numel(seq_arrays);

times = [];
long_i_counts = [];

num_with_long_i = 0;
total_long_i = 0;
total_i = 0;

total_long_i_time = 0;
total_i_time = 0;

for i = 1:num_vibrations
    [times_between_long_intervals, long_i_time, i_time, long_i_count, i_count] = get_times_between_long_intervals(seq_arrays{i}, i_or_d_arrays{i}, long_i_length);
    
    times = [times, times_between_long_intervals];
    
    if (long_i_count > 0)        
        num_with_long_i = num_with_long_i + 1;
    end
    
    total_long_i = total_long_i + long_i_count;
    total_i = total_i + i_count;

    total_long_i_time = total_long_i_time + long_i_time;
    total_i_time = total_i_time + i_time;
    
    long_i_counts(i) = long_i_count;
end

if (max_length ~= -1)
    times = times(find(times <= max_length));
end

%hist(times, 20);
%figure;
%hist(long_i_counts, 20);

percent_with_long_intervals = num_with_long_i/num_vibrations;
percent_long_intervals = total_long_i/total_i;
percent_time_long_intervals = total_long_i_time/total_i_time;
average_num_long_intervals = mean(long_i_counts);

average_time_between_long_intervals = 0;

if numel(times) > 0
    average_time_between_long_intervals = mean(times);
end
