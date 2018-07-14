function [estran, esemis] = run_hmm_training(i_d_pairs_levels, i_d_pairs_all, min_i_val, max_i_val, min_d_val, max_d_val, num_bins_i, num_bins_d, trans)

emis = get_emission_matrix(i_d_pairs_levels, min_i_val, max_i_val, min_d_val, max_d_val, num_bins_i, num_bins_d);

emis = replace_zeros(emis, realmin);
trans = replace_zeros(trans, realmin);

seqs = get_seq(i_d_pairs_all, min_i_val, max_i_val, min_d_val, max_d_val, num_bins_i, num_bins_d);
seqs = transpose_cell_contents(seqs);

[estran, esemis] = hmmtrain(seqs, trans, emis,'Verbose', false, 'Maxiterations', 1000);