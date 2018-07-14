function data = get_snake_data_subset (snake_percent, rain_percent, data_snake, data_rain)

indices_i_d_greater_percent_snake = find(data_snake(:,4) > snake_percent & data_snake(:,5) > snake_percent);
indices_i_d_greater_percent_rain = find(data_rain(:,4) > rain_percent & data_rain(:,5) > rain_percent);

in_both = ismember(indices_i_d_greater_percent_snake, indices_i_d_greater_percent_rain);
indices_i_d_greater_percent_snake_not_rain = indices_i_d_greater_percent_snake(find(in_both == 0));

data = data_snake(indices_i_d_greater_percent_snake_not_rain,:);
