function id_finder_result_graphs (range, min_interval, min_duration, vibrations, delta_t, i_range, d_range)

% number of vibrations
num_vibrations = numel(vibrations);

% make sure there is at least 1 vibration in vibrations cell
assert(num_vibrations > 0, ...
      'must have at least 1 vibration in vibrations cell');
  
% for each vibration, call id_finder and count_id_peak_hatching to get the
% number of intervals, durations, and sequences within the input ranges
for i = 1:num_vibrations
    id_finder(range, min_interval, min_duration, vibrations{i});
    
    M = [];
    
    if (duration_first)
		if duration_lengths(1) >= uint32(d_range(1)/delta_t) && duration_lengths(1) <= uint32(d_range(2)/delta_t)
			M = ones(1,duration_lengths(1)) * 0.66;
		else
			M = ones(1,duration_lengths(1));
		end			
        
        for j = 1:num_intervals
			if interval_lengths(j) >= uint32(i_range(1)/delta_t) && interval_lengths(j) <= uint32(i_range(2)/delta_t)
				M = [M, ones(1,interval_lengths(j)) * 0.33];
            else
				M = [M, zeros(1,interval_lengths(j))];
			end

			if (j+1) <= num_durations
				if duration_lengths(j+1) >= uint32(d_range(1)/delta_t) && duration_lengths(j+1) <= uint32(d_range(2)/delta_t)
					M = [M, ones(1,duration_lengths(j+1)) * 0.66];
				else
					M = [M, ones(1,duration_lengths(j+1))];
				end
			end
        end
    else
		if interval_lengths(1) >= uint32(i_range(1)/delta_t) && interval_lengths(1) <= uint32(i_range(2)/delta_t)
			M = ones(1,interval_lengths(1)) * 0.33;
		else
			M = zeros(1,interval_lengths(1));
		end		
        
        for j = 1:num_durations
			if duration_lengths(j) >= uint32(d_range(1)/delta_t) && duration_lengths(j) <= uint32(d_range(2)/delta_t)
				M = [M, ones(1,duration_lengths(j)) * 0.66];
			else
				M = [M, ones(1,duration_lengths(j))];
			end

			if (j+1) <= num_intervals
				if interval_lengths(j+1) >= uint32(i_range(1)/delta_t) && interval_lengths(j+1) <= uint32(i_range(2)/delta_t)
					M = [M, ones(1,interval_lengths(j+1)) * 0.33];
				else
					M = [M, zeros(1,interval_lengths(j+1))];
				end
			end
        end
    end
    
    M = [M, 0, 0.33, 0.66, 1];
    
    figure;
    colormap([0,0,0;0,0,1;0,1,0;1,1,1]);
    N = size(M,2);
    t = (1:N)*delta_t;
    imagesc(t,1,M);
end
