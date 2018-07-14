function [intervals, durations] = hist_i_d_from_files(num_files, name_prefix, name_suffix, range, min_interval, min_duration, delta_t)

intervals = [];
durations = [];

for i=1:num_files
    filename = sprintf('%s%d%s', name_prefix, i, name_suffix);
    s = load(filename);
    
    s_names = fieldnames(s);
    field = getfield(s, s_names{1});
    
    num_vibrations = numel(field);
    
    for j=1:num_vibrations    
        id_finder(range, min_interval/delta_t, min_duration/delta_t, field{j});
        
        display(i*j);
        
        intervals = [intervals; double(interval_lengths)*double(delta_t)];
        durations = [durations; double(duration_lengths)*double(delta_t)];
    end

    clear s;
    clear field;
end

%hist(intervals);
%title('intervals');
%figure;
%hist(durations);
%title('durations');