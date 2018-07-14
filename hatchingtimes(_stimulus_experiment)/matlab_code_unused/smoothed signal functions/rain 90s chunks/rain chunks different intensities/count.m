function [sum] = count(num_files, name_prefix, name_suffix)

sum = 0;

for i=1:num_files
    filename = sprintf('%s%d%s', name_prefix, i, name_suffix);
    s = load(filename);
    
    s_names = fieldnames(s);
    field = getfield(s, s_names{1});
    
    num_vibrations = numel(field);
    
    sum = sum + num_vibrations;
end