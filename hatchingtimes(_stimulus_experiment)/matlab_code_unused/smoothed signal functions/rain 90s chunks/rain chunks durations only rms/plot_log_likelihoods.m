function plot_log_likelihoods(seq_probs1, seq_probs2, t)

num_seqs1 = numel(seq_probs1);
num_seqs2 = numel(seq_probs2);

figure;
hold on;

for i = 1:num_seqs1
    num_pairs = numel(seq_probs1{i});    
    plot(1:num_pairs, seq_probs1{i}, 'b');
end

for i = 1:num_seqs2
    num_pairs = numel(seq_probs2{i});    
    plot(1:num_pairs, seq_probs2{i}, 'r');
end

hold off;

xlabel('pairs');
ylabel('log likelihood');
title(t);