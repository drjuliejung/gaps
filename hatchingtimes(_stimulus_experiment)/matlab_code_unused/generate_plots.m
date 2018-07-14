function generate_plots (data, num_plots)

for i = 0:num_plots-1
    figure;
    plotscript2(data((i*100)+1:(i+1)*100,:), data((i*100)+1,1));
end