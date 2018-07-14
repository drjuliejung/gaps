function [average_rms] = get_average_rms_from_files(num_files, name_prefix, name_suffix)

sum = 0;
weight_sum = 0;

for i=1:num_files
    filename = sprintf('%s%d%s', name_prefix, i, name_suffix);
    s = load(filename);
    
    s_names = fieldnames(s);
    field = getfield(s, s_names{1});

    numel_in_array = numel(field);
    sum = sum + (numel_in_array * rms(field));
    weight_sum = weight_sum + numel_in_array;

    clear s;
    clear field;
end

average_rms = sum/weight_sum;

