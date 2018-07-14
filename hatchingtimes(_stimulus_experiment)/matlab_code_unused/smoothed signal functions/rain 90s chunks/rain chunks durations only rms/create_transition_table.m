function create_transition_table(trans)

table_size = size(trans, 1);

figure;

t = uitable;
set(t,'Data', trans);
set(t,'Position',[1,200,500,100]);

cnames = cell(table_size, 1);

for i = 1:table_size
    cnames{i} = sprintf('to level %d', i);
end

rnames = cell(table_size, 1);

for i = 1:table_size
    rnames{i} = sprintf('from level %d', i);
end

set(t, 'ColumnName', cnames);
set(t, 'RowName', rnames);