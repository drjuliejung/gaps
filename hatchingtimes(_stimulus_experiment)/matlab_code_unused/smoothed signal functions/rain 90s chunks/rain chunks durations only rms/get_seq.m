function [seq] = get_seq(i_d_pairs, min_i_val, max_i_val, min_d_val, max_d_val, num_bins_i, num_bins_d)

i_log_bins = logspace(log10(min_i_val), log10(max_i_val), num_bins_i+1);
d_log_bins = logspace(log10(min_d_val), log10(max_d_val), num_bins_d+1);

num_files = numel(i_d_pairs);
seq = cell(num_files, 1);

for i=1:num_files
    num_pairs = size(i_d_pairs{i},1);
    
    cur_seq = zeros(num_pairs, 1);
    
    for j=1:num_pairs
        cur_i_len = i_d_pairs{i}(j,2);
        cur_d_len = i_d_pairs{i}(j,1);
        
        i_index = 1;
        d_index = 1;
        
        if (cur_i_len < min_i_val)
            i_index = 1;
        elseif (cur_i_len >= max_i_val)
            i_index = num_bins_i+2;
        else
            for k=1:num_bins_i
                if (cur_i_len >= i_log_bins(k) && cur_i_len < i_log_bins(k+1))
                    i_index = k+1;
                    break;
                end
            end
        end
        
        if (cur_d_len < min_d_val)
            d_index = 1;
        elseif (cur_d_len >= max_d_val)
            d_index = num_bins_d+2;
        else
            for k=1:num_bins_d
                if (cur_d_len >= d_log_bins(k) && cur_d_len < d_log_bins(k+1))
                    d_index = k+1;
                    break;
                end
            end
        end
        
        cur_seq(j) = (d_index-1)*(num_bins_i+2) + i_index;        
    end
    
    seq{i} = cur_seq;
end


