function [observations, set_predictors, treatment_predictors, censor] = make_cox_parameters(hatching_times, num_hatching_competent, set, treatment, observation_length)

assert(numel(hatching_times) == numel(num_hatching_competent));

num_trials = numel(hatching_times);
num_observations = sum(num_hatching_competent);

set_predictors = set * ones(1, num_observations);
treatment_predictors = treatment * ones(1, num_observations);

censor = zeros(1, num_observations);
observations = zeros(1, num_observations);

cur_index = 1;

for i = 1:num_trials
    end_index = cur_index + numel(hatching_times{i}) - 1;
    
    observations(cur_index:end_index) = hatching_times{i};
    
    num_not_hatched = num_hatching_competent(i) - numel(hatching_times{i});
    
    cur_index = end_index + 1;
    end_index = cur_index + num_not_hatched - 1;
    
    observations(cur_index:end_index) = observation_length * ones(1, num_not_hatched);
    censor(cur_index:end_index) = ones(1, num_not_hatched);
    
    cur_index = end_index + 1;
end

