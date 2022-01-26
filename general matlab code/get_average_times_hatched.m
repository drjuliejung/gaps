function [mat] = get_average_times_hatched(percents, hatching_times_all)

num_stimuli = numel(hatching_times_all);
num_percents = numel(percents);

mat = zeros(num_stimuli, num_percents);

for i=1:num_stimuli
    for j=1:num_percents
        mat(i,j) = get_average_time_n_percent_hatched(percents(j), {hatching_times_all{i}});
    end
end

figure;

t = uitable;
set(t,'Data', mat);
set(t,'Position',[1,100,800,250]);

cnames = cell(num_percents, 1);

cnames{1} = 'First hatched (s)';

for i = 2:num_percents-1
    cnames{i} = sprintf('%d%% hatched (s)', percents(i));
end

cnames{num_percents} = 'Last hatched (s)';

rnames = cell(num_stimuli, 1);

rnames{1} = 'First hatched (s)';

for i = 1:num_stimuli
    rnames{i} = sprintf('trial %d', i);
end

set(t, 'ColumnName', cnames);
set(t, 'RowName', rnames);

