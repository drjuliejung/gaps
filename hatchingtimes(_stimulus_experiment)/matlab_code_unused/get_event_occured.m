function event_occured_vector = get_event_occured(hatching_times, num_hatching_competent, t_vector)

event_occured_vector = zeros(1, numel(t_vector));

for i = 1:numel(t_vector)
    num_hatched = 0;
    
    for j = 1:numel(hatching_times)
        if (hatching_times(j) < t_vector(i))
            num_hatched = num_hatched + 1;
        end
    end
    
    event_occured_vector(i) = num_hatched/num_hatching_competent;
    
    if event_occured_vector(i) > 1
        event_occured_vector(i) = 1;
    end
end

