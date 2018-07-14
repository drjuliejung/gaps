function [rms_range_chunks] = get_chunks_of_rms_range(num_files, name_prefix, name_suffix, min_rms, max_rms)

count = 0;
rms_range_chunks = {};

for i=1:num_files
    filename = sprintf('%s%d%s', name_prefix, i, name_suffix);
    s = load(filename);
    
    s_names = fieldnames(s);
    field = getfield(s, s_names{1});
    
    num_chunks = numel(field);
    
    for j=1:num_chunks
        cur_rms = rms(field{j});
        
        min_rms_met = 0;
        max_rms_met = 0;
        
        if (min_rms < 0 || (min_rms >= 0 && cur_rms > min_rms))
            min_rms_met = 1;            
        end
        
        if (max_rms < 0 || (max_rms >= 0 && cur_rms <= max_rms))
            max_rms_met = 1;
        end
        
        if (max_rms_met && min_rms_met)
            count = count + 1;
            rms_range_chunks{count} = field{j};
        end
    end
    
    clear s;
    clear field;
end
