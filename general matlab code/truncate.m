function [truncated] = truncate(hatching_times, truncate_start, truncate_len)

num_trials = numel(hatching_times);
num_starts = numel(truncate_start);

truncated = cell(1, num_trials);

for i=1:num_trials
    num_hatched = numel(hatching_times{i});
    truncated{i} = zeros(1, num_hatched);
    
    truncate_start_index = 1;
    cur_truncate_start = truncate_start(truncate_start_index);
    cummulative_gap_len = 0;
    
    flag = false;
    
    j = 1;
    
    while (j <= num_hatched)
        cur_time = hatching_times{i}(j);
        
        if (cur_time < cur_truncate_start)
            truncated{i}(j) = cur_time - cummulative_gap_len;
            j = j + 1;
        elseif (cur_time >= cur_truncate_start && cur_time <= cur_truncate_start + truncate_len)
            truncated{i}(j) = cur_truncate_start - cummulative_gap_len;
            j = j + 1;
        else
            if (flag == false)
                cummulative_gap_len = cummulative_gap_len + truncate_len;
                flag = true;
            end
            
            if (truncate_start_index < num_starts)
                truncate_start_index = truncate_start_index + 1;
                cur_truncate_start = truncate_start(truncate_start_index);
                
                flag = false;
            else                    
                truncated{i}(j) = cur_time - cummulative_gap_len;
                j = j + 1;
            end
        end
    end
    
end



