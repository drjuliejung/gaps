figure

%%% truncate(hatching_times, truncate_start, truncate_len)
truncated_hatching_times_30 = truncate(hatching_times_30, 6, 28.5); %stim D
truncated_hatching_times_31 = truncate(hatching_times_31, 34, 28.5); %stim G
truncated_hatching_times_32 = truncate(hatching_times_32, 86, 28.5); %stim H

subplot(7,1,1)       % add 1st plot in 7 x 1 grid (stim C)
make_hatching_plot(hatching_times_16_3, num_hatching_competent_16_3, stimulus_length_16, 10)
axis([0 450 0 1])
hold on;
line([ForAnnotations{3,2} ForAnnotations{3,2}], ylim);
line([ForAnnotations{3,3} ForAnnotations{3,3}], ylim);
line([ForAnnotations{3,4} ForAnnotations{3,4}], ylim);

subplot(7,1,2)       % add 2nd plot in 7 x 1 grid (stim D, real time)
make_hatching_plot(hatching_times_30, num_hatching_competent_30, stimulus_30_length, 10)
axis([0 450 0 1])
hold on;
line([ForAnnotations{11,2} ForAnnotations{11,2}], ylim);
line([ForAnnotations{11,3} ForAnnotations{11,3}], ylim);
line([ForAnnotations{11,4} ForAnnotations{11,4}], ylim);

subplot(7,1,3)       % add 3rd plot in 5 x 1 grid (stim G, real time)
make_hatching_plot(hatching_times_31, num_hatching_competent_31, stimulus_31_length, 10)
axis([0 450 0 1])
hold on;
line([ForAnnotations{14,2} ForAnnotations{14,2}], ylim);
line([ForAnnotations{14,3} ForAnnotations{14,3}], ylim);
line([ForAnnotations{14,4} ForAnnotations{14,4}], ylim);

subplot(7,1,4)       % add 4th plot in 5 x 1 grid (stim H, real time)
make_hatching_plot(hatching_times_32, num_hatching_competent_32, stimulus_32_length, 10) 
axis([0 450 0 1])
hold on;
line([ForAnnotations{16,2} ForAnnotations{16,2}], ylim);
line([ForAnnotations{16,3} ForAnnotations{16,3}], ylim);
line([ForAnnotations{16,4} ForAnnotations{16,4}], ylim);

subplot(7,1,5)       % add 5th plot in 5 x 1 grid (stim D, no gaps)
make_hatching_plot(truncated_hatching_times_30, num_hatching_competent_30, stimulus_30_length-30, 10) 
axis([0 450 0 1])
hold on;
line([ForAnnotations{13,2} ForAnnotations{13,2}], ylim);
line([ForAnnotations{13,3} ForAnnotations{13,3}], ylim);
line([ForAnnotations{13,4} ForAnnotations{13,4}], ylim);

subplot(7,1,6)       % add 6th plot in 5 x 1 grid (stim G, no gaps)
make_hatching_plot(truncated_hatching_times_31, num_hatching_competent_31, stimulus_31_length-30, 10) 
axis([0 450 0 1])
hold on;
line([ForAnnotations{15,2} ForAnnotations{15,2}], ylim);
line([ForAnnotations{15,3} ForAnnotations{15,3}], ylim);
line([ForAnnotations{15,4} ForAnnotations{15,4}], ylim);

subplot(7,1,7)       % add 7th plot in 5 x 1 grid (stim H, no gaps)
make_hatching_plot(truncated_hatching_times_32, num_hatching_competent_32, stimulus_32_length-30, 10) 
axis([0 450 0 1])
hold on;
line([ForAnnotations{17,2} ForAnnotations{17,2}], ylim);
line([ForAnnotations{17,3} ForAnnotations{17,3}], ylim);
line([ForAnnotations{17,4} ForAnnotations{17,4}], ylim);

