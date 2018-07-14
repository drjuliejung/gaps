function [all_windows] = find_steady_rate_periods_with_overlap(signal, min_rms, min_window_seconds, delta_t, step_seconds)

size = numel(signal);
min_window = min_window_seconds/delta_t;

step = step_seconds/delta_t;

assert(min_window > 0, 'min_window must be greater than 0');

if (min_window > size)
    min_window = size;
end

window_start_index = 1;
window_end_index = min_window;

all_windows = {};
windows_count = 0;

while (window_end_index <= size)
    window = signal(window_start_index:window_end_index);    
    root_mean_square = rms(window);
    
    if (root_mean_square < min_rms)
        window_start_index = window_start_index + step;
        window_end_index = window_start_index + min_window - 1;
    else
        best_window_start_index = window_start_index;
        best_window_end_index = window_end_index;
        best_root_mean_square = root_mean_square;
        
        window_end_index2 = window_end_index + step;
        
        if (window_end_index2 > size)
            window_end_index2 = size;
        end
        
        window2 = signal(window_start_index:window_end_index2);
        root_mean_square2 = rms(window2);
        
        while (root_mean_square2 > best_root_mean_square && window_end_index2 <= size)
            best_window_end_index = window_end_index2;
            best_root_mean_square = root_mean_square2;
            
            window_end_index2 = window_end_index + step;
            
            if (window_end_index2 > size)
                window_end_index2 = size;
            end
            
            window2 = signal(window_start_index:window_end_index2);
            root_mean_square2 = rms(window2);
        end
        
        window_start_index2 = window_start_index + step;
        window2 = signal(window_start_index2:best_window_end_index);
        root_mean_square2 = rms(window2);
        
        while (root_mean_square2 > best_root_mean_square && best_window_end_index - window_start_index2 >= min_window - 1)
            best_window_start_index = window_start_index2;
            best_root_mean_square = root_mean_square2;
            
            window_start_index2 = window_start_index + step;
            window2 = signal(window_start_index2:best_window_end_index);
            root_mean_square2 = rms(window2);
        end
        
        windows_count = windows_count + 1;
        best_window = signal(best_window_start_index:best_window_end_index);
        
        all_windows{windows_count} = best_window;
        
        window_end_index = best_window_end_index + step;
        window_start_index = window_end_index - min_window + 1;
    end
end



