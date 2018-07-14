function [low_rms_chunks, medium_rms_chunks, high_rms_chunks] = separate_chunks_into_rms_ranges(chunks, first_rms_split, second_rms_split, max_val)

low_rms_chunks = {};
low_rms_count = 0;
medium_rms_chunks = {};
medium_rms_count = 0;
high_rms_chunks = {};
high_rms_count = 0;

num_chunks = numel(chunks);
    
for i=1:num_chunks
    if (max(abs(chunks{i})) > max_val)
        continue;
    end
    
    cur_rms = rms(chunks{i});

    if (cur_rms <= first_rms_split)
        low_rms_count = low_rms_count + 1;
        low_rms_chunks{low_rms_count} = chunks{i};
    elseif (cur_rms > first_rms_split && cur_rms <= second_rms_split)
        medium_rms_count = medium_rms_count + 1;
        medium_rms_chunks{medium_rms_count} = chunks{i};
    else
        high_rms_count = high_rms_count + 1;
        high_rms_chunks{high_rms_count} = chunks{i};
    end
end

