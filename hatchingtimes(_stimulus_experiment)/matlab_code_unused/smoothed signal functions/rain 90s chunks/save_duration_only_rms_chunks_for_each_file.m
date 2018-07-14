function save_duration_only_rms_chunks_for_each_file(num_files, name_prefix, name_suffix, first_rms_split, second_rms_split, max_val, range, min_interval, min_duration, delta_t)

for i=1:num_files
    filename = sprintf('%s%d%s', name_prefix, i, name_suffix);
    s = load(filename);
    
    s_names = fieldnames(s);
    field = getfield(s, s_names{1});

    [light_90s, medium_90s, heavy_90s] = separate_chunks_into_duration_only_rms_ranges(field, first_rms_split, second_rms_split, max_val, range, min_interval, min_duration, delta_t);
    
    save_filename = sprintf('%s%d_light_90s.mat', name_prefix, i);    
    save(save_filename, varname(light_90s));
    
    save_filename = sprintf('%s%d_medium_90s.mat', name_prefix, i);    
    save(save_filename, varname(medium_90s));
    
    save_filename = sprintf('%s%d_heavy_90s.mat', name_prefix, i);    
    save(save_filename, varname(heavy_90s));

    clear s;
    clear field;
end


