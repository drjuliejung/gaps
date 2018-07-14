function [smoothed_signals] = smooth_all_signals(signals, window_seconds, delta_t)

num_signals = numel(signals);
smoothed_signals = cell(num_signals, 1);

for i=1:num_signals
    smoothSignal(signals{i}, window_seconds, delta_t);
    
    smoothed_signals{i} = smoothed_signal;
end
