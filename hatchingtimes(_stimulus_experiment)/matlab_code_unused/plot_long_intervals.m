function plot_long_intervals(seq_array, i_or_d, long_i_length, delta_t)

M = [];

for i = 1:numel(seq_array)    
    if (i_or_d(i) == false)
		if (seq_array(i) > long_i_length)
            M = [M, zeros(1, floor(seq_array(i)/delta_t))];
        else
            M = [M, ones(1, floor(seq_array(i)/delta_t)) * 0.5];
        end
    else
        M = [M, ones(1, floor(seq_array(i)/delta_t))];
    end
end


M = [M, 0, 0.5, 1];

figure;
colormap([0,0,0;0,0,1;1,1,1]);
N = size(M,2);
t = (1:N)*delta_t;
imagesc(t,1,M);
