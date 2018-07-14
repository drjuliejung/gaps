function [tone] = ...
    generate_pure_tone (sampling_rate, tone_frequency, duration)

n = sampling_rate * duration;
tone = (1:n) / sampling_rate;
tone = sin(2 * pi * tone_frequency * tone); 

