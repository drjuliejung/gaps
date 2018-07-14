function [seq_probabilities] = get_sequence_probabilities(i_d_pairs, esemis, estrans, min_i_val, max_i_val, min_d_val, max_d_val, num_bins_i, num_bins_d)

seqs = get_seq(i_d_pairs, min_i_val, max_i_val, min_d_val, max_d_val, num_bins_i, num_bins_d);
seqs = transpose_cell_contents(seqs);

num_files = numel(i_d_pairs);

seq_probabilities = cell(num_files, 1);

for i = 1:num_files
    num_in_seq = numel(seqs{i});
    seq_probabilities{i} = zeros(num_in_seq, 1);
    
    for j = 1:num_in_seq        
        [~, logpseq] = hmmdecode(seqs{i}(1:j), estrans, esemis);
        
        seq_probabilities{i}(j) = logpseq;
    end
end

