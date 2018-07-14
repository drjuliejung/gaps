function plotscript4 (data_cell, threshold, num_vals, linespec)
    
set(gca, 'xscale', 'log');
set(gca, 'yscale', 'log');
set(gca, 'ZlimMode', 'manual');
zlim([0,1]);
xlabel('min interval (seconds)');
ylabel('min duration (seconds)');
zlabel('Percent scary events in scariest window');
t = strcat('range = ', num2str(threshold));
title(t);
grid on;
view(3);
hold on;

num_rows = size(data_cell{1}, 1);

if numel(data_cell) > 1
    for i = 2:numel(data_cell)
        assert(size(data_cell{i}, 1) == num_rows, ...
        'Each matrix in cell must have same number of rows.');
    end
end

for j = 1:numel(data_cell)
    for i = 1:num_rows
        if (i < num_rows)
            if (mod(i, num_vals) ~= 0)
                plot3([data_cell{j}(i,2), data_cell{j}(i+1,2)], ...
                    [data_cell{j}(i,3), data_cell{j}(i+1,3)], ...
                    [data_cell{j}(i,4), data_cell{j}(i+1,4)], ...
                    linespec{j});
            end
        end
        
        if (i > num_vals)
            plot3([data_cell{j}(i,2), data_cell{j}(i-num_vals,2)], ...
                  [data_cell{j}(i,3), data_cell{j}(i-num_vals,3)], ...
                  [data_cell{j}(i,4), data_cell{j}(i-num_vals,4)], ...
                  linespec{j});
        end
    end
end

hold off;