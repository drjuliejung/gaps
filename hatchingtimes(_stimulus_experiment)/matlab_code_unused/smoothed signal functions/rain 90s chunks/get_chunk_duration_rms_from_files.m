function [rms_array] = get_chunk_duration_rms_from_files(num_files, name_prefix, name_suffix, range, min_interval, min_duration, delta_t)

rms_array = [];
count = 0;

for i=1:num_files
    filename = sprintf('%s%d%s', name_prefix, i, name_suffix);
    s = load(filename);
    
    s_names = fieldnames(s);
    field = getfield(s, s_names{1});

    [seq_arrays, i_or_d_arrays] = get_sequence_arrays_not_seconds(range, min_interval, min_duration, field, delta_t);

    num_chunks = numel(seq_arrays);

    for j=1:num_chunks
        num_in_seq = numel(seq_arrays{j});
        cur_index = 1;

        for k=1:num_in_seq
            if (i_or_d_arrays{j}(k) == false)
                field{j}(cur_index:cur_index+seq_arrays{j}(k)-1) = 0;
            end

            cur_index = cur_index + seq_arrays{j}(k);
        end

        count = count + 1;
        rms_array(count) = rms(field{j});
    end

    clear s;
    clear field;
end


