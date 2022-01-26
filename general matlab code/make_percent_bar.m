function h = make_percent_bar (percent_hatched, groups, significance, names, t)

num_stimuli = numel(percent_hatched);

assert(num_stimuli == numel(names));

mean_percents = zeros(1, num_stimuli);
se_percents = zeros(1, num_stimuli);

for i=1:num_stimuli
    mean_percents(i) = mean(percent_hatched{i});
    se_percents(i) = std(percent_hatched{i})/sqrt(numel(percent_hatched{i}));
end

h = barwitherr(se_percents, mean_percents);
%sigstar(groups,significance);

set(gca,'XTickLabel',names);
xlabel('Stimulus');
ylim([0, 1]);
ylabel('Proportion Hatched');
title(t);