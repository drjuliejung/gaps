function [chunks_with_long_intervals] = find_chunks_with_long_intervals(num_files, name_prefix, name_suffix, long_interval_length, range, min_interval, min_duration, delta_t)

chunks_with_long_intervals = {};
count = 0;

for i=1:num_files
    filename = sprintf('%s%d%s', name_prefix, i, name_suffix);
    s = load(filename);
    
    s_names = fieldnames(s);
    field = getfield(s, s_names{1});
    
    num_vibrations = numel(field);
    
    for j=1:num_vibrations    
        id_finder(range, min_interval/delta_t, min_duration/delta_t, field{j});
        
        if (numel(interval_lengths(find(double(interval_lengths)*double(delta_t) >= long_interval_length))) > 0)
            count = count + 1;
            chunks_with_long_intervals{count} = field{j};
        end
    end

    clear s;
    clear field;
end
