function generate_plots3 (data_cell, num_plots, num_vals, linespec)

for i = 0:num_plots-1
    figure;
    
    cur_thresh_data{1,1} = [];
    
    for j = 1:numel(data_cell)
        cur_thresh_data{1, j} = data_cell{j}((i*num_vals*num_vals)+1:(i+1)*num_vals*num_vals,:);
    end
    
    %plotscript2(data((i*num_x_vals*num_y_vals)+1:(i+1)*num_x_vals*num_y_vals,:), data((i*num_x_vals*num_y_vals)+1,1));
    plotscript3(cur_thresh_data, cur_thresh_data{1}(1), num_vals, linespec);
    %plotscript4(cur_thresh_data, cur_thresh_data{1}(1), num_vals, linespec);
end