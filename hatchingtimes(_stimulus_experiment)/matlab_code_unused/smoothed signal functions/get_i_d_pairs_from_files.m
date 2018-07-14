function [i_d_arrays] = get_i_d_pairs_from_files(num_files, name_prefix, name_suffix, range, min_interval, min_duration, delta_t)

i_d_arrays = cell(num_files, 1);

for i=1:num_files
    filename = sprintf('%s%d%s', name_prefix, i, name_suffix);
    s = load(filename);
    
    s_names = fieldnames(s);
    field = getfield(s, s_names{1});

    [seq_arrays, i_or_d_arrays] = get_sequence_arrays(range, min_interval, min_duration, {field}, delta_t);

    first_index = 2;
    
    if i_or_d_arrays{1}(first_index) == 0
        first_index = first_index + 1;
    end
    
    last_index = numel(i_or_d_arrays{1}) - 1;
    
    if i_or_d_arrays{1}(last_index) == 1
        last_index = last_index - 1;
    end
    
    num_i_d_pairs = floor((last_index - first_index)/2) + 1;
    i_d_array = zeros(num_i_d_pairs, 2);
    
    for j = 1:num_i_d_pairs
        i_d_array(j,1) = seq_arrays{1}((j-1)*2 + first_index);
        i_d_array(j,2) = seq_arrays{1}((j-1)*2 + 1 + first_index);
    end
    
    i_d_arrays{i} = i_d_array;

    clear s;
    clear field;
end


