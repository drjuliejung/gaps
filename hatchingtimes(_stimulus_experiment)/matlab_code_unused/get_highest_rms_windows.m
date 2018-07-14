function [windows] = get_highest_rms_windows(signals, window_size_seconds, delta_t, step_seconds)

num_signals = numel(signals);
windows = cell(num_signals, 1);

for i=1:num_signals
    [highest_rms_window, highest_rms_window_start_index] = find_highest_rms_window(signals{i}, window_size_seconds, delta_t, step_seconds);
    
    windows{i} = highest_rms_window;
end
