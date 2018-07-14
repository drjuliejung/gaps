function [i_d_pairs_heavy1, i_d_pairs_heavy2, i_d_pairs_heavy, i_d_pairs_medium, i_d_pairs_light] = ...
    get_i_d_pairs_rain_levels_from_files(num_files, name_prefix, name_suffix, range, min_interval, min_duration, delta_t)

i_d_pairs_heavy1 = zeros(100000,2);
num_heavy1 = 1;
i_d_pairs_heavy2 = zeros(100000,2);
num_heavy2 = 1;
i_d_pairs_heavy = zeros(100000,2);
num_heavy = 1;
i_d_pairs_medium = zeros(100000,2);
num_medium = 1;
i_d_pairs_light = zeros(100000,2);
num_light = 1;

for i=1:num_files
    filename = sprintf('%s%d_heavy1_%s', name_prefix, i, name_suffix);
    s = load(filename);
    
    s_names = fieldnames(s);
    field = getfield(s, s_names{1});

    [seq_arrays, i_or_d_arrays] = get_sequence_arrays(range, min_interval, min_duration, field, delta_t);

    num_chunks = numel(field);
    
    for j = 1:num_chunks
        first_index = 2;
        
        if i_or_d_arrays{j}(first_index) == 0
            first_index = first_index + 1;
        end
        
        last_index = numel(i_or_d_arrays{j}) - 1;
        
        if i_or_d_arrays{j}(last_index) == 1
            last_index = last_index - 1;
        end
        
        num_i_d_pairs = floor((last_index - first_index)/2) + 1;
        i_d_array = zeros(num_i_d_pairs, 2);
        
        for k = 1:num_i_d_pairs
            i_d_array(k,1) = seq_arrays{j}((k-1)*2 + first_index);
            i_d_array(k,2) = seq_arrays{j}((k-1)*2 + 1 + first_index);
        end
        
        i_d_pairs_heavy1(num_heavy1:num_heavy1+num_i_d_pairs-1,:) = i_d_array;
        num_heavy1 = num_heavy1+num_i_d_pairs;
    end

    clear s;
    clear field;
end

i_d_pairs_heavy1 = i_d_pairs_heavy1(1:num_heavy1-1,:);

for i=1:num_files
    filename = sprintf('%s%d_heavy2_%s', name_prefix, i, name_suffix);
    s = load(filename);
    
    s_names = fieldnames(s);
    field = getfield(s, s_names{1});

    [seq_arrays, i_or_d_arrays] = get_sequence_arrays(range, min_interval, min_duration, field, delta_t);

    num_chunks = numel(field);
    
    for j = 1:num_chunks
        first_index = 2;
        
        if i_or_d_arrays{j}(first_index) == 0
            first_index = first_index + 1;
        end
        
        last_index = numel(i_or_d_arrays{j}) - 1;
        
        if i_or_d_arrays{j}(last_index) == 1
            last_index = last_index - 1;
        end
        
        num_i_d_pairs = floor((last_index - first_index)/2) + 1;
        i_d_array = zeros(num_i_d_pairs, 2);
        
        for k = 1:num_i_d_pairs
            i_d_array(k,1) = seq_arrays{j}((k-1)*2 + first_index);
            i_d_array(k,2) = seq_arrays{j}((k-1)*2 + 1 + first_index);
        end
        
        i_d_pairs_heavy2(num_heavy2:num_heavy2+num_i_d_pairs-1,:) = i_d_array;
        num_heavy2 = num_heavy2+num_i_d_pairs;
    end

    clear s;
    clear field;
end

i_d_pairs_heavy2 = i_d_pairs_heavy2(1:num_heavy2-1,:);

for i=1:num_files
    filename = sprintf('%s%d_medium_%s', name_prefix, i, name_suffix);
    s = load(filename);
    
    s_names = fieldnames(s);
    field = getfield(s, s_names{1});

    [seq_arrays, i_or_d_arrays] = get_sequence_arrays(range, min_interval, min_duration, field, delta_t);

    num_chunks = numel(field);
    
    for j = 1:num_chunks
        first_index = 2;
        
        if i_or_d_arrays{j}(first_index) == 0
            first_index = first_index + 1;
        end
        
        last_index = numel(i_or_d_arrays{j}) - 1;
        
        if i_or_d_arrays{j}(last_index) == 1
            last_index = last_index - 1;
        end
        
        num_i_d_pairs = floor((last_index - first_index)/2) + 1;
        i_d_array = zeros(num_i_d_pairs, 2);
        
        for k = 1:num_i_d_pairs
            i_d_array(k,1) = seq_arrays{j}((k-1)*2 + first_index);
            i_d_array(k,2) = seq_arrays{j}((k-1)*2 + 1 + first_index);
        end
        
        i_d_pairs_medium(num_medium:num_medium+num_i_d_pairs-1,:) = i_d_array;
        num_medium = num_medium+num_i_d_pairs;
    end

    clear s;
    clear field;
end

i_d_pairs_medium = i_d_pairs_medium(1:num_medium-1,:);

for i=1:num_files
    filename = sprintf('%s%d_light_%s', name_prefix, i, name_suffix);
    s = load(filename);
    
    s_names = fieldnames(s);
    field = getfield(s, s_names{1});

    [seq_arrays, i_or_d_arrays] = get_sequence_arrays(range, min_interval, min_duration, field, delta_t);

    num_chunks = numel(field);
    
    for j = 1:num_chunks
        first_index = 2;
        
        if i_or_d_arrays{j}(first_index) == 0
            first_index = first_index + 1;
        end
        
        last_index = numel(i_or_d_arrays{j}) - 1;
        
        if i_or_d_arrays{j}(last_index) == 1
            last_index = last_index - 1;
        end
        
        num_i_d_pairs = floor((last_index - first_index)/2) + 1;
        i_d_array = zeros(num_i_d_pairs, 2);
        
        for k = 1:num_i_d_pairs
            i_d_array(k,1) = seq_arrays{j}((k-1)*2 + first_index);
            i_d_array(k,2) = seq_arrays{j}((k-1)*2 + 1 + first_index);
        end
        
        i_d_pairs_light(num_light:num_light+num_i_d_pairs-1,:) = i_d_array;
        num_light = num_light+num_i_d_pairs;
    end

    clear s;
    clear field;
end

i_d_pairs_light = i_d_pairs_light(1:num_light-1,:);

for i=1:num_files
    filename = sprintf('%s%d_heavy_%s', name_prefix, i, name_suffix);
    s = load(filename);
    
    s_names = fieldnames(s);
    field = getfield(s, s_names{1});

    [seq_arrays, i_or_d_arrays] = get_sequence_arrays(range, min_interval, min_duration, field, delta_t);

    num_chunks = numel(field);
    
    for j = 1:num_chunks
        first_index = 2;
        
        if i_or_d_arrays{j}(first_index) == 0
            first_index = first_index + 1;
        end
        
        last_index = numel(i_or_d_arrays{j}) - 1;
        
        if i_or_d_arrays{j}(last_index) == 1
            last_index = last_index - 1;
        end
        
        num_i_d_pairs = floor((last_index - first_index)/2) + 1;
        i_d_array = zeros(num_i_d_pairs, 2);
        
        for k = 1:num_i_d_pairs
            i_d_array(k,1) = seq_arrays{j}((k-1)*2 + first_index);
            i_d_array(k,2) = seq_arrays{j}((k-1)*2 + 1 + first_index);
        end
        
        i_d_pairs_heavy(num_heavy:num_heavy+num_i_d_pairs-1,:) = i_d_array;
        num_heavy = num_heavy+num_i_d_pairs;
    end

    clear s;
    clear field;
end

i_d_pairs_heavy = i_d_pairs_heavy(1:num_heavy-1,:);

