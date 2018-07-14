function [lengths] = combine(lengths_cell)

cell_length = numel(lengths_cell);

lengths = [];

for i = 1:cell_length
    lengths = [lengths; lengths_cell{i}];
end