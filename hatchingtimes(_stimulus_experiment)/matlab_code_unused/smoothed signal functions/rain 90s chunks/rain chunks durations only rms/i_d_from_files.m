function [heavy_rain_intervals, heavy_rain_durations, ...
    medium_rain_intervals, medium_rain_durations, ...
    light_rain_intervals, light_rain_durations] = i_d_from_files(num_files, name_prefix, name_suffix, range, min_interval, min_duration, delta_t)

heavy_rain_intervals = cell(num_files, 1);
heavy_rain_durations =  cell(num_files, 1);

medium_rain_intervals = cell(num_files, 1);
medium_rain_durations = cell(num_files, 1);

light_rain_intervals = cell(num_files, 1);
light_rain_durations = cell(num_files, 1);

for i=1:num_files
    filename = sprintf('%s%d_heavy_%s', name_prefix, i, name_suffix);
    s = load(filename);
    
    s_names = fieldnames(s);
    field = getfield(s, s_names{1});
    
    num_vibrations = numel(field);
    
    for j=1:num_vibrations    
        id_finder(range, min_interval/delta_t, min_duration/delta_t, field{j});
        
        heavy_rain_intervals{i} = [heavy_rain_intervals{i}; double(interval_lengths)*double(delta_t)];
        heavy_rain_durations{i} = [heavy_rain_durations{i}; double(duration_lengths)*double(delta_t)];
    end

    clear s;
    clear field;
    
    filename = sprintf('%s%d_medium_%s', name_prefix, i, name_suffix);
    s = load(filename);
    
    s_names = fieldnames(s);
    field = getfield(s, s_names{1});
    
    num_vibrations = numel(field);
    
    for j=1:num_vibrations    
        id_finder(range, min_interval/delta_t, min_duration/delta_t, field{j});
        
        medium_rain_intervals{i} = [medium_rain_intervals{i}; double(interval_lengths)*double(delta_t)];
        medium_rain_durations{i} = [medium_rain_durations{i}; double(duration_lengths)*double(delta_t)];
    end

    clear s;
    clear field
    
        filename = sprintf('%s%d_light_%s', name_prefix, i, name_suffix);
    s = load(filename);
    
    s_names = fieldnames(s);
    field = getfield(s, s_names{1});
    
    num_vibrations = numel(field);
    
    for j=1:num_vibrations    
        id_finder(range, min_interval/delta_t, min_duration/delta_t, field{j});
        
        light_rain_intervals{i} = [light_rain_intervals{i}; double(interval_lengths)*double(delta_t)];
        light_rain_durations{i} = [light_rain_durations{i}; double(duration_lengths)*double(delta_t)];
    end

    clear s;
    clear field;
end