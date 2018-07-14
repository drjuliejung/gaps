function [smoothed_signal] = smooth_signal(signal, window_seconds, delta_t)

size = numel(signal);
window_size = window_seconds/delta_t;

assert(window_size <= size, 'window must be greater than 0');

if (window_size > size)
    window_size = size;
end

window_start_index = 1;
window_end_index = int32(window_size);

smoothed_signal = zeros(int32(size - window_size + 1), 1);
index = 1;

window = signal(window_start_index:window_end_index);
window_sum = sum(window);

smoothed_signal(index) = window_sum/window_size;

index = index + 1;
window_start_index = window_start_index + 1;
window_end_index = window_end_index + 1;

while (window_end_index <= size)
    window_sum = window_sum - signal(window_start_index - 1);
    window_sum = window_sum + signal(window_end_index); 
    
    smoothed_signal(index) = window_sum/window_size;
    
    index = index + 1;
    window_start_index = window_start_index + 1;
    window_end_index = window_end_index + 1;
end