function [lengths] = get_lengths_seconds(snake_cell)

num_in_cell = numel(snake_cell);
lengths = [];

for i=1:num_in_cell
    lengths(i) = sum(snake_cell{i});
end
