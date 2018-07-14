function [windows] = get_windows_from_files(num_files, name_prefix, name_suffix, min_rms, window_length, delta_t, step, overlap)

windows = {};
windows_count = 0;

for i=1:num_files
    filename = sprintf('%s%d%s', name_prefix, i, name_suffix);
    s = load(filename);
    
    s_names = fieldnames(s);
    field = getfield(s, s_names{1});
    
    if overlap == 0
        cur_windows = find_steady_rate_periods(field, min_rms, window_length, delta_t, step);
    else
        cur_windows = find_steady_rate_periods_with_overlap(field, min_rms, window_length, delta_t, step);
    end
    
    num_in_window = numel(cur_windows);
    
    for j=1:num_in_window
        windows_count = windows_count + 1;
        windows{windows_count} = cur_windows{j};
    end
    
    clear s;
    clear field;
end
