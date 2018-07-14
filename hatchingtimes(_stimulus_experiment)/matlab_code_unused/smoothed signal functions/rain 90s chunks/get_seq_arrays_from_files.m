function [seq_arrays, i_or_d_arrays] = get_seq_arrays_from_files(num_files, name_prefix, name_suffix, range, min_i, min_d, delta_t)

seq_arrays = {};
i_or_d_arrays = {};
count = 0;

for i=1:num_files
    filename = sprintf('%s%d%s', name_prefix, i, name_suffix);
    s = load(filename);
    
    s_names = fieldnames(s);
    field = getfield(s, s_names{1});

    [cur_seq_arrays, cur_i_or_d_arrays] = get_sequence_arrays(range, min_i, min_d, field, delta_t);
        
    num_arrays = numel(cur_seq_arrays);
    
    for j=1:num_arrays
        count = count + 1;
        seq_arrays{count} = cur_seq_arrays{j};
        i_or_d_arrays{count} = cur_i_or_d_arrays{j};
    end

    clear s;
    clear field;
end


