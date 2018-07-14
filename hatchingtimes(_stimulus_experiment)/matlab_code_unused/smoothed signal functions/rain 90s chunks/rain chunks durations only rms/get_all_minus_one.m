function [c_minus_one] = get_all_minus_one(c, exclude_index)

num_in_cell = numel(c);
c_minus_one = cell(num_in_cell-1, 1);
index = 0;

for i = 1:num_in_cell
    if (i ~= exclude_index)
        index = index+1;
        c_minus_one{index} = c{i};
    end
end
