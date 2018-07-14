function [low_rms_chunks, medium_rms_chunks, high_rms_chunks] = separate_chunks_into_duration_only_rms_ranges(chunks, first_rms_split, second_rms_split, max_val, range, min_interval, min_duration, delta_t)

low_rms_chunks = {};
low_rms_count = 0;
medium_rms_chunks = {};
medium_rms_count = 0;
high_rms_chunks = {};
high_rms_count = 0;

[seq_arrays, i_or_d_arrays] = get_sequence_arrays_not_seconds(range, min_interval, min_duration, chunks, delta_t);

num_chunks = numel(chunks);
    
for i=1:num_chunks
    if (max(abs(chunks{i})) > max_val)
        continue;
    end
    
    num_in_seq = numel(seq_arrays{i});
    cur_index = 1;

    for j=1:num_in_seq
        if (i_or_d_arrays{i}(j) == false)
            chunks{i}(cur_index:cur_index+seq_arrays{i}(j)-1) = 0;
        end

        cur_index = cur_index + seq_arrays{i}(j);
    end

    cur_rms = rms(chunks{i});

    if (cur_rms > 0 && cur_rms <= first_rms_split)
        low_rms_count = low_rms_count + 1;
        low_rms_chunks{low_rms_count} = chunks{i};
    end
    
    if (cur_rms > first_rms_split && cur_rms <= second_rms_split)
        medium_rms_count = medium_rms_count + 1;
        medium_rms_chunks{medium_rms_count} = chunks{i};
    end
    
    if (cur_rms > second_rms_split)
        high_rms_count = high_rms_count + 1;
        high_rms_chunks{high_rms_count} = chunks{i};
    end
end

