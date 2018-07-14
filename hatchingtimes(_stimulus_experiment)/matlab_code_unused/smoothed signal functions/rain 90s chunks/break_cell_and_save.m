function break_cell_and_save(save_prefix, save_suffix, cell, num_sections)

num_in_cell = numel(cell);
num_per_section = ceil(num_in_cell/num_sections);

section_count = 0;
count = 0;

cell_section = {};

for i=1:num_in_cell
    
    if (count == 0)
        cell_section = {};
    end
    
    count = count + 1;
    cell_section{count} = cell{i};
    
    if (count == num_per_section)    
        section_count = section_count + 1;
        save_filename = sprintf('%s%d%s', save_prefix, section_count, save_suffix);    
        save(save_filename, varname(cell_section));
        
        count = 0;
    end
end
