function plot_log_likelihoods_over_time(seq_probs1, seq_probs2, i_d_times1, i_d_times2, t)

num_seqs1 = numel(seq_probs1);
num_seqs2 = numel(seq_probs2);

figure;
hold on;

for i = 1:num_seqs1
    num_pairs = numel(seq_probs1{i});
    
    %if (num_pairs < 100)
    %    continue;
    %end
    
    times = zeros(num_pairs+1, 1);
    times(1) = 0;
    
    for j = 1:num_pairs        
        times(j+1) = times(j) + i_d_times1{i}(j,1) + i_d_times1{i}(j,2);
    end
    
    plot(times(2:end), seq_probs1{i}, 'b');
end

for i = 1:num_seqs2
    num_pairs = numel(seq_probs2{i});
    
    %if (num_pairs < 100)
    %    continue;
    %end
    
    times = zeros(num_pairs+1, 1);
    times(1) = 0;
    
    for j = 1:num_pairs        
        times(j+1) = times(j) + i_d_times2{i}(j,1) + i_d_times2{i}(j,2);
    end
    
    plot(times(2:end), seq_probs2{i}, 'r');
end

hold off;

xlabel('seconds');
ylabel('log likelihood');
title(t);