function get_even_chunks_from_files(num_files, name_prefix, name_suffix, save_prefix, save_suffix, chunk_length_seconds, delta_t)

for i=1:num_files
    filename = sprintf('%s%d%s', name_prefix, i, name_suffix);
    s = load(filename);
    
    s_names = fieldnames(s);
    field = getfield(s, s_names{1});
    
    cur_chunks = break_into_chunks(field, chunk_length_seconds, delta_t);
    
    save_filename = sprintf('%s%d%s', save_prefix, i, save_suffix);
    
    save(save_filename, varname(cur_chunks));
    
    clear s;
    clear field;
end
