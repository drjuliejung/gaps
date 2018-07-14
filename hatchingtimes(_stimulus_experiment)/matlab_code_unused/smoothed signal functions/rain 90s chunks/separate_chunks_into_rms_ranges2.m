function [high_rms_chunks, very_high_rms_chunks] = separate_chunks_into_rms_ranges2(chunks, first_rms_split, second_rms_split, max_val)

high_rms_chunks = {};
high_rms_count = 0;
very_high_rms_chunks = {};
very_high_rms_count = 0;

num_chunks = numel(chunks);
    
for i=1:num_chunks
    if (max(abs(chunks{i})) > max_val)
        continue;
    end
    
    cur_rms = rms(chunks{i});

    if (cur_rms >= first_rms_split && cur_rms < second_rms_split)
        high_rms_count = high_rms_count + 1;
        high_rms_chunks{high_rms_count} = chunks{i};
    end
    
    if (cur_rms >= second_rms_split)
        very_high_rms_count = very_high_rms_count + 1;
        very_high_rms_chunks{very_high_rms_count} = chunks{i};
    end
end

