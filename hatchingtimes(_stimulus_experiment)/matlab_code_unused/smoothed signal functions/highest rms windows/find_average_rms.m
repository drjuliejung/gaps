function [average_rms] = find_average_rms (cell)

num_in_cells = numel(cell);
sum = 0;
weight_sum = 0;

for i=1:num_in_cells
    numel_in_cell = numel(cell{i});
    sum = sum + (numel_in_cell * rms(cell{i}));
    weight_sum = weight_sum + numel_in_cell;
end

average_rms = sum/weight_sum;