function [bincounts] = get_bincounts(i_d_pairs, min_i_val, max_i_val, min_d_val, max_d_val, num_bins_i, num_bins_d)

i_log_bins = logspace(log10(min_i_val), log10(max_i_val), num_bins_i+1);
d_log_bins = logspace(log10(min_d_val), log10(max_d_val), num_bins_d+1);
num_files = numel(i_d_pairs);

bincounts = zeros(num_bins_i+2, num_bins_d+2);

for i=1:num_files
    num_pairs = size(i_d_pairs{i},1);
    
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
        
        bincounts(i_index, d_index) = bincounts(i_index, d_index) + 1;       
    end
end

s = sum(sum(bincounts));
bincounts = bincounts ./ s;

%t = uitable;
%set(t,'Data', bincounts);
%set(t,'Position',[1,100,1100,250]);

%cnames = cell(num_bins_d+2, 1);
%cnames{1} = sprintf('<%.2f', d_log_bins(1));

%for i = 1:num_bins_d
%    cnames{i+1} = sprintf('%.2f - %.2f', d_log_bins(i), d_log_bins(i+1));
%end

%cnames{num_bins_d+2} = sprintf('>%.2f', d_log_bins(num_bins_d+1));

%rnames = cell(num_bins_i+2, 1);
%rnames{1} = sprintf('<%.2f', i_log_bins(1));

%for i = 1:num_bins_i
%    rnames{i+1} = sprintf('%.2f - %.2f', i_log_bins(i), i_log_bins(i+1));
%end

%rnames{num_bins_i+2} = sprintf('>%.2f', i_log_bins(num_bins_i+1));

%set(t, 'ColumnName', cnames);
%set(t, 'RowName', rnames);
