function plot_i_d (range, min_interval, min_duration, vibration, delta_t)

[seq_arrays, i_or_d_arrays] = get_sequence_arrays_not_seconds(range, min_interval, min_duration, {vibration}, delta_t);

num_in_seq = numel(seq_arrays{1});

%figure;
hold on;

t = delta_t*(0:1:numel(vibration)-1);
plot(t, vibration, 'b');

t_count = 1;

for i=1:num_in_seq
    if (i_or_d_arrays{1}(i) == true)
        cur_t = delta_t*(t_count:1:t_count+seq_arrays{1}(i)-1);
        vib_section = vibration(t_count:t_count+seq_arrays{1}(i)-1);        
        
        plot(cur_t, vib_section, 'r');
    end
    
    t_count = t_count + seq_arrays{1}(i)-1;
end

%set(gca,'xtick',[])
xlabel('Seconds');
ylabel('Acceleration (m/s^2)');