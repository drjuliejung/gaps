function [sum] = sum_all(var)

sum = 0;

for i=1:numel(var)
    sum = sum + numel(var{i});
end