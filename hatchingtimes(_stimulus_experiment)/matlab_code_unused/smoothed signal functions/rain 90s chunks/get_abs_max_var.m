function [maximums] = get_abs_max_var(cell)

maximums = zeros(numel(cell), 1);

for i=1:numel(cell)
    max(abs(cell{i}));
end


