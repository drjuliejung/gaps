figure

%%% truncate(hatching_times, truncate_start, truncate_len)
truncated_hatching_times_27 = truncate(hatching_times_27, 6:34.5:316.5, 28.5); %stim E
truncated_hatching_times_28 = truncate(hatching_times_28, 20:48.5:311, 28.5); %stim F

subplot(5,1,1)       % add first plot in 7 x 1 grid (stim C)
make_hatching_plot(hatching_times_16_2, num_hatching_competent_16_2, stimulus_length_16, 10) %s3
axis([0 450 0 1])
hold on;
line([ForAnnotations{2,2} ForAnnotations{2,2}], ylim);
line([ForAnnotations{2,3} ForAnnotations{2,3}], ylim);
line([ForAnnotations{2,4} ForAnnotations{2,4}], ylim);

subplot(5,1,2)       % add second plot in 5 x 1 grid (stim E, real time)
make_hatching_plot(hatching_times_27, num_hatching_competent_27, stimulus_27_length, 10) %s5
axis([0 450 0 1])
hold on;
line([ForAnnotations{7,2} ForAnnotations{7,2}], ylim);
line([ForAnnotations{7,3} ForAnnotations{7,3}], ylim);
line([ForAnnotations{7,4} ForAnnotations{7,4}], ylim);

subplot(5,1,3)       % add third plot in 5 x 1 grid (stim F, real time)
make_hatching_plot(hatching_times_28, num_hatching_competent_28, stimulus_28_length, 10) %s6
axis([0 450 0 1])
hold on;
line([ForAnnotations{9,2} ForAnnotations{9,2}], ylim);
line([ForAnnotations{9,3} ForAnnotations{9,3}], ylim);
line([ForAnnotations{9,4} ForAnnotations{9,4}], ylim);

subplot(5,1,4)       % add fourth plot in 5 x 1 grid (stim E, no gaps)
make_hatching_plot(truncated_hatching_times_27, num_hatching_competent_27, 60, 10) 
axis([0 450 0 1])
hold on;
line([ForAnnotations{8,2} ForAnnotations{8,2}], ylim);
line([ForAnnotations{8,3} ForAnnotations{8,3}], ylim);
line([ForAnnotations{8,4} ForAnnotations{8,4}], ylim);

subplot(5,1,5)       % add fifth plot in 5 x 1 grid (stim F, no gaps)
make_hatching_plot(truncated_hatching_times_28, num_hatching_competent_28, 140, 10) 
axis([0 450 0 1])
hold on;
line([ForAnnotations{10,2} ForAnnotations{10,2}], ylim);
line([ForAnnotations{10,3} ForAnnotations{10,3}], ylim);
line([ForAnnotations{10,4} ForAnnotations{10,4}], ylim);

