function [max, min, average] = find_max_min_average (cell)

max = -1;
min = intmax;
num_in_cells = numel(cell);

sum = 0;

for i=1:num_in_cells  
    num = numel(cell{i});
    
    if num > max
        max = num;
    end
    
    if num < min
        min = num;
    end
    
    sum = sum + num;
end

average = int32(sum/num_in_cells);