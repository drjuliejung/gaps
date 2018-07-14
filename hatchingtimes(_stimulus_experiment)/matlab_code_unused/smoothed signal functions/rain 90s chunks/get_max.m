function [maximums] = get_abs_max(num_files, name_prefix, name_suffix)

maximums = [];
count = 0;

for i=1:num_files
    filename = sprintf('%s%d%s', name_prefix, i, name_suffix);
    s = load(filename);
    
    s_names = fieldnames(s);
    field = getfield(s, s_names{1});

    num_chunks = numel(field);
    
    for j=1:num_chunks
        count = count + 1;
        maximums(count) = max(abs(field{j}));
    end

    clear s;
    clear field;
end


