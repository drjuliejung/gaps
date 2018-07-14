function [bincounts] = emis_matrix_to_bincounts(emis, min_i_val, max_i_val, min_d_val, max_d_val, num_bins_i, num_bins_d)

num_bincounts = size(emis, 1);
bincounts = cell(num_bincounts, 1);

for i = 1:num_bincounts
    bincounts{i} = reshape(emis(i,:), num_bins_i+2, num_bins_d+2);
    
    figure;
    
    i_log_bins = logspace(log10(min_i_val), log10(max_i_val), num_bins_i+1);
    d_log_bins = logspace(log10(min_d_val), log10(max_d_val), num_bins_d+1);
    
    t = uitable;
    set(t,'Data', bincounts{i});
    set(t,'Position',[1,100,1100,250]);

    cnames = cell(num_bins_d+2, 1);
    cnames{1} = sprintf('<%.2f', d_log_bins(1));

    for i = 1:num_bins_d
        cnames{i+1} = sprintf('%.2f - %.2f', d_log_bins(i), d_log_bins(i+1));
    end

    cnames{num_bins_d+2} = sprintf('>%.2f', d_log_bins(num_bins_d+1));

    rnames = cell(num_bins_i+2, 1);
    rnames{1} = sprintf('<%.2f', i_log_bins(1));

    for i = 1:num_bins_i
        rnames{i+1} = sprintf('%.2f - %.2f', i_log_bins(i), i_log_bins(i+1));
    end

    rnames{num_bins_i+2} = sprintf('>%.2f', i_log_bins(num_bins_i+1));

    set(t, 'ColumnName', cnames);
    set(t, 'RowName', rnames);
end
