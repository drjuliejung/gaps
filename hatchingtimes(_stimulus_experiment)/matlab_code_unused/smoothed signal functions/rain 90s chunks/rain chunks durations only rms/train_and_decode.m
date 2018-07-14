function [seq_probabilities_rain, seq_probabilities_snakes, estran, esemis] = ...
    train_and_decode(i_d_pairs_levels, i_d_pairs_train, i_d_pairs_decode_rain, i_d_pairs_decode_snakes, min_i_val, max_i_val, min_d_val, max_d_val, num_bins_i, num_bins_d, trans)

[estran, esemis] = run_hmm_training(i_d_pairs_levels, i_d_pairs_train, min_i_val, max_i_val, min_d_val, max_d_val, num_bins_i, num_bins_d, trans);

esemis_fix_zeros = replace_zeros(esemis, realmin);
estran_fix_zeros = replace_zeros(estran, realmin);

seq_probabilities_rain = get_sequence_probabilities(i_d_pairs_decode_rain, esemis_fix_zeros, estran_fix_zeros, min_i_val, max_i_val, min_d_val, max_d_val, num_bins_i, num_bins_d);
seq_probabilities_snakes = get_sequence_probabilities(i_d_pairs_decode_snakes, esemis_fix_zeros, estran_fix_zeros, min_i_val, max_i_val, min_d_val, max_d_val, num_bins_i, num_bins_d);
