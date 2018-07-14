function [emis] = get_emission_matrix(i_d_pairs_levels, min_i_val, max_i_val, min_d_val, max_d_val, num_bins_i, num_bins_d)

num_levels = numel(i_d_pairs_levels);
num_observations = (num_bins_i+2) * (num_bins_d+2);

emis = zeros(num_levels, num_observations);

for i = 1:num_levels
    bincounts = get_bincounts(i_d_pairs_levels(i), min_i_val, max_i_val, min_d_val, max_d_val, num_bins_i, num_bins_d);
    bincounts = reshape(bincounts, 1, num_observations);
    emis(i,:) = bincounts;
end
