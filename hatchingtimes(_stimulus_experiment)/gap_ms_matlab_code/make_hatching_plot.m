function make_hatching_plot(hatching_times, num_hatching_competent, stimuli_length, step)

% This is for figure 2.6 in GuoThesis-v1.docx
% should first import "hatching_times"

num_trials = numel(hatching_times);

assert(num_trials == numel(num_hatching_competent));

plot_points = zeros(1, int32(stimuli_length/step));
se_above = zeros(1, int32(stimuli_length/step));
se_below = zeros(1, int32(stimuli_length/step));
timesteps = 0:step:stimuli_length;

index = 1;

for i=0:step:stimuli_length
    percent_hatched = zeros(1, num_trials);
    
    for j=1:num_trials
        num_hatched = 0;
        while (num_hatched+1 <= numel(hatching_times{j})) && (hatching_times{j}(num_hatched+1) < i)
            num_hatched = num_hatched + 1;
        end
        
        percent_hatched(j) = num_hatched/num_hatching_competent(j);
        
        if percent_hatched(j) > 1
            percent_hatched(j) = 1;
        end
    end
    
    mean_percent_hatched = mean(percent_hatched);    
    se_percent_hatched =std(percent_hatched)/sqrt(num_trials);
    
    plot_points(index) = mean_percent_hatched;
    se_above(index) = mean_percent_hatched + se_percent_hatched;
    se_below(index) = mean_percent_hatched - se_percent_hatched;
    
    index = index + 1;
end

plot(timesteps, plot_points);
hold on;
plot(timesteps, se_above, 'r');
plot(timesteps, se_below, 'r');
xlabel('Seconds');
ylabel('Proportion hatched');

