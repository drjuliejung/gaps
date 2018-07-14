function [newsig] = make_simple_signal(signal)

num = numel(signal);
s = 1;

newsig = zeros(num,1);

for i = 1:num
    if (signal(i) ~= 0)
        if (s == 1)
            newsig(i) = 1;
            s = 0;
        else
            newsig(i) = -1;
            s = 1;
        end
    else
        newsig(i) = 0;
    end 
end