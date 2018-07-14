function [first_hatched_times, n_percent_hatched_times] = get_first_n_percent_hatching_times(hatching_times, n)

num_trials = numel(hatching_times);

first_hatched_times = zeros(1, num_trials);
n_percent_hatched_times = zeros(1, num_trials);

count = 1;

for i = 1:num_trials;
    if numel(hatching_times{i}) > 0
        first_hatched_times(count) = hatching_times{i}(1);
        
        num_hatched = numel(hatching_times{i});
        
        for j = 1:num_hatched
            if j/num_hatched >= n
                n_percent_hatched_times(count) = hatching_times{i}(j);
                break;
            end
        end
        
        count = count + 1;
    end
    
    
end

if count > 1
    first_hatched_times = first_hatched_times(1:count-1);
    n_percent_hatched_times = n_percent_hatched_times(1:count-1);
else
    first_hatched_times = [];
    n_percent_hatched_times = [];
end


