function [signal] = ...
    generate_bandpass_filtered_white_noise_id (sampling_rate, cutoff1, cutoff2, num_cycles, i_length, d_length)

length = (i_length + d_length) * num_cycles * sampling_rate;

rng('shuffle');
x = randn(length,1);

hf = design(fdesign.bandpass('N,F3dB1,F3dB2', 10, cutoff1, cutoff2, sampling_rate));

result = filter(hf,x);
result = result';

deltaT = 1/sampling_rate;
t = 0:deltaT:(numel(result)-1)*deltaT;

signal = playback(t,result,1);

count = d_length;

for i = 1:num_cycles
    signal(count*sampling_rate+1 : (count + i_length)*sampling_rate) = 0.0;    
    count = count + i_length + d_length;
end

signal = signal/max(abs(signal));