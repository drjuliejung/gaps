function [heavy1_rain_intervals, heavy1_rain_durations, ...
    heavy2_rain_intervals, heavy2_rain_durations] = i_d_from_files2(num_files, name_prefix, name_suffix, range, min_interval, min_duration, delta_t)

heavy1_rain_intervals = cell(num_files, 1);
heavy1_rain_durations =  cell(num_files, 1);

heavy2_rain_intervals = cell(num_files, 1);
heavy2_rain_durations =  cell(num_files, 1);

for i=1:num_files
    filename = sprintf('%s%d_heavy1_%s', name_prefix, i, name_suffix);
    s = load(filename);
    
    s_names = fieldnames(s);
    field = getfield(s, s_names{1});
    
    num_vibrations = numel(field);
    
    for j=1:num_vibrations    
        id_finder(range, min_interval/delta_t, min_duration/delta_t, field{j});
        
        heavy1_rain_intervals{i} = [heavy1_rain_intervals{i}; double(interval_lengths)*double(delta_t)];
        heavy1_rain_durations{i} = [heavy1_rain_durations{i}; double(duration_lengths)*double(delta_t)];
    end

    clear s;
    clear field;
    
    filename = sprintf('%s%d_heavy2_%s', name_prefix, i, name_suffix);
    s = load(filename);
    
    s_names = fieldnames(s);
    field = getfield(s, s_names{1});
    
    num_vibrations = numel(field);
    
    for j=1:num_vibrations    
        id_finder(range, min_interval/delta_t, min_duration/delta_t, field{j});
        
        heavy2_rain_intervals{i} = [heavy2_rain_intervals{i}; double(interval_lengths)*double(delta_t)];
        heavy2_rain_durations{i} = [heavy2_rain_durations{i}; double(duration_lengths)*double(delta_t)];
    end

    clear s;
    clear field
end