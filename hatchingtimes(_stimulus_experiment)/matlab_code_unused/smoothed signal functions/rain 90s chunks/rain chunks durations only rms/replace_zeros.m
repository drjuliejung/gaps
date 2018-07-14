function [no_zeros_m] = replace_zeros(m, floor_num)

num_rows = size(m, 1);
num_cols = size(m, 2);

for i = 1:num_rows
    for j = 1:num_cols
        m(i,j) = m(i,j) + floor_num;
    end
    
    s = sum(m(i,:));
    m(i,:) = m(i,:) ./ s;
end

no_zeros_m = m;