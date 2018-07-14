function [transposed] = transpose_cell_contents(data)

num_data = numel(data);
transposed = cell(num_data,1);

for i=1:num_data
    transposed{i} = data{i}';
end
    