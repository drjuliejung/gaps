function [grid] = getPVal(hatching_times, num_hatching_competent, stimuli_lengths, clutch_numbers, sets, treatments, use_set)

assert(numel(hatching_times) == numel(num_hatching_competent) && ...
    numel(hatching_times) == numel(stimuli_lengths) && ...
    numel(hatching_times) == numel(clutch_numbers) && ...
    numel(hatching_times) == numel(sets) && ...
    numel(hatching_times) == numel(treatments));

num_treatments = numel(hatching_times);

grid = zeros(num_treatments, num_treatments);

for i=1:num_treatments
    [observations1, clutch_predictors1, set_predictors1, treatment_predictors1, censor1] = ...
        make_cox_parameters(hatching_times{i}, ...
        num_hatching_competent{i}, ...
        clutch_numbers{i}, ...
        sets{i}, ...
        treatments{i}, ...
        stimuli_lengths{i});
    
    for j=1:num_treatments        
        [observations2, clutch_predictors2, set_predictors2, treatment_predictors2, censor2] = ...
            make_cox_parameters(hatching_times{j}, ...
            num_hatching_competent{j}, ...
            clutch_numbers{j}, ...
            sets{j}, ...
            treatments{j}, ...
            stimuli_lengths{j});        
        
        observations = [observations1, observations2];
        censor = [censor1, censor2];
        clutch_predictors = [clutch_predictors1, clutch_predictors2];
        
        predictors = [];
        
        if (use_set == 1)
            predictors = [set_predictors1, set_predictors2];
        else
            predictors = [treatment_predictors1, treatment_predictors2];
        end
        
        predictors = [predictors; clutch_predictors];
        
        observations = observations';
        censor = censor';
        predictors = predictors';
        
        [b, logL, H, stats] = coxphfit(predictors, observations, 'censoring', censor);
        
        grid(i,j) = stats.p(1);
    end
end


