function [m, sd, max_length, min_length] = get_mean_sd_max_min_length(num_files, name_prefix, name_suffix, delta_t)

lens = zeros(num_files, 1);
max_length = 0.0;
min_length = realmax;

for i=1:num_files
    filename = sprintf('%s%d%s', name_prefix, i, name_suffix);
    s = load(filename);
    
    s_names = fieldnames(s);
    field = getfield(s, s_names{1});

    cur_len = numel(field) * delta_t;
    
    if (cur_len > max_length)
        max_length = cur_len;
    end
    
    if (cur_len < min_length)
        min_length = cur_len;
    end
    
    lens(i) = cur_len;

    clear s;
    clear field;
end

m = mean(lens);
sd = std(lens);
