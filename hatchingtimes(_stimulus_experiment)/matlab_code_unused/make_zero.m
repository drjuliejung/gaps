function [data] = make_zero(data)

for i=1:numel(data) 
    if (isnan(data(i))) 
        data(i) = 0;
    end
    
    if (data(i) == 9.980000000000000e-04)
        data(i) = 0.001;
    end
end