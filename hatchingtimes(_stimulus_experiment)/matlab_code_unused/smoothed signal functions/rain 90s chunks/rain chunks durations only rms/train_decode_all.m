function [rain_seq_probs, snake_seq_probs, all_estran, all_esemis] = ...
    train_decode_all (i_d_pairs_levels, i_d_pairs_rain, i_d_pairs_snakes, min_i_val, max_i_val, min_d_val, max_d_val, num_bins_i, num_bins_d, trans)

num_rain = numel(i_d_pairs_rain);

rain_seq_probs = cell(num_rain, 1);
snake_seq_probs = cell(num_rain, 1);
all_estran = cell(num_rain, 1);
all_esemis = cell(num_rain, 1);

for i = 1:num_rain 
    [seq_prob_rain, seq_prob_snakes, estran, esemis] = ...
        train_and_decode(i_d_pairs_levels, get_all_minus_one(i_d_pairs_rain, i), {i_d_pairs_rain{i}}, i_d_pairs_snakes, min_i_val, max_i_val, min_d_val, max_d_val, num_bins_i, num_bins_d, trans);

    display(sprintf('File %d finished.', i));
    
    rain_seq_probs{i} = seq_prob_rain{1};
    snake_seq_probs{i} = seq_prob_snakes;
    all_estran{i} = estran;
    all_esemis{i} = esemis;
end

num_snakes = numel(i_d_pairs_snakes);
temp = cell(num_snakes, 1);

for i = 1:num_snakes    
    num_in_seq = numel(snake_seq_probs{1}{i});
    temp{i} = zeros(num_in_seq, 1);
    
    for j = 1:num_in_seq
        s = 0;
        
        for k = 1:num_rain
            s = s + snake_seq_probs{k}{i}(j);
        end
        
        temp{i}(j) = s / num_rain;
    end
end

snake_seq_probs = temp;