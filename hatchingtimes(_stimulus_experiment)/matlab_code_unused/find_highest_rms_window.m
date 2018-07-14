function [highest_rms_window, highest_rms_window_start_index] = find_highest_rms_window(signal, window_size_seconds, delta_t, step_seconds)

size = numel(signal);
window_size = window_size_seconds/delta_t;
step = step_seconds/delta_t;

assert(window_size > 0, 'window size must be greater than 0 and less than length of signal');

if (window_size > size)
    window_size = size;
end

window_start_index = 1;
window_end_index = window_size;

highest_rms = -1;
highest_rms_window = [];
highest_rms_window_start_index = window_start_index;

while (window_end_index <= size)
    window = signal(window_start_index:window_end_index);    
    root_mean_square = rms(window);
    
    if (root_mean_square > highest_rms)
        highest_rms = root_mean_square;
        highest_rms_window = window;
        highest_rms_window_start_index = window_start_index;
    end
    
    window_start_index = window_start_index + step;
    window_end_index = window_end_index + step;
end



