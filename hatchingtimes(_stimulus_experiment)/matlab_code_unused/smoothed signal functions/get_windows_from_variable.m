function [windows] = get_windows_from_variable(cell, min_rms, window_length, delta_t, step, overlap)

windows = {};
windows_count = 0;

num_in_cell = numel(cell);

for i=1:num_in_cell
    if overlap == 0
        cur_windows = find_steady_rate_periods(cell{i}, min_rms, window_length, delta_t, step);
    else
        cur_windows = find_steady_rate_periods_with_overlap(cell{i}, min_rms, window_length, delta_t, step);
    end
    
    num_in_window = numel(cur_windows);
    
    for j=1:num_in_window
        windows_count = windows_count + 1;
        windows{windows_count} = cur_windows{j};
    end
end
