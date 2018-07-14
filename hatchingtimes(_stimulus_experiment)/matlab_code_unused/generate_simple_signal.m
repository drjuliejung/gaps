function [signal] = generate_simple_signal (sampling_rate, num_cycles, i_length, d_length)

length = int32((i_length + d_length) * num_cycles * sampling_rate);

signal = zeros(length,1);

count = 0;

for i = 1:num_cycles-1
    s = 1;
    
    for j = int32(count*sampling_rate+1) : int32((count + i_length)*sampling_rate)        
        if (s == 1)
            signal(j) = 1.0;
            s = 0;
        else
            signal(j) = -1.0;
            s = 1;
        end
    end
    count = count + i_length + d_length;
end

signal = signal(1:int32(count*sampling_rate));