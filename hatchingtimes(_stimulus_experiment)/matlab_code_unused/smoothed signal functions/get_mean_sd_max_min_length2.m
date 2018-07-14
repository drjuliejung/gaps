function [m, sd, max_length, min_length] = get_mean_sd_max_min_length2(vibrations, delta_t)

num_vibrations = numel(vibrations);

lens = zeros(num_vibrations, 1);
max_length = 0.0;
min_length = realmax;

for i=1:num_vibrations
    cur_len = numel(vibrations{i}) * delta_t;
    
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
