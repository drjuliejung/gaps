function make_histogram(hatching_times1, hatching_times2)

xvalues = 5:10:345;
bincounts = zeros(numel(hatching_times1)+numel(hatching_times2), numel(xvalues));

for i=1:numel(hatching_times1)
    s = sum(hist(hatching_times1{i}));
    bincounts(i,:) = (histc(hatching_times1{i},xvalues) ./ s)';
end

for i=1:numel(hatching_times2)
    s = sum(hist(hatching_times2{i}));
    bincounts(i,:) = (histc(hatching_times2{i},xvalues) ./ s)';
end

mean_bincounts = mean(bincounts,1);
serror = std(bincounts,1)./sqrt(numel(hatching_times1)+numel(hatching_times2));

figure;
barwitherr(serror, xvalues, mean_bincounts);
xlabel('10-second bins from start of playback');
ylabel('Mean proportion hatched for each bin across trials');