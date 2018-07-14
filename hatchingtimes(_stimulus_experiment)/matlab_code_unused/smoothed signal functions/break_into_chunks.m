function [chunks] = break_into_chunks(data, chunk_length_seconds, delta_t)

chunk_length = chunk_length_seconds/delta_t;
num_in_data = numel(data);

chunks = cell(floor(num_in_data/chunk_length), 1);
chunk_count = 0;

start_index = 1;
end_index = start_index + chunk_length - 1;

while (end_index <= num_in_data)
    chunk_count = chunk_count + 1;
    chunks{chunk_count} = data(start_index:end_index);
    
    start_index = end_index + 1;
    end_index = start_index + chunk_length - 1;
end