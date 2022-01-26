%make_histogram(hatching_times_16_1, hatching_times_16_2)
%fft_example(Y1, 22050)

%inport "ForAnnotations"
%add labels to plot for 25%, 50%, and 75% of clutch hatched

%The subplot function takes three inputs. 
%The first two inputs, m and n, divide the current figure into an m by n grid. 
%The third input specifies the position in the grid where the new axes are created. 
%The grid position specified by the third input is a row-based index.

figure
subplot(6,1,1)       % add first plot in 5 x 1 grid
make_hatching_plot(hatching_times_21_1, num_hatching_competent_21_1, stimulus_21_length, 10) %s1
axis([0 450 0 1])

subplot(6,1,2)       % add second plot in 5 x 1 grid
make_hatching_plot(hatching_times_17_1, num_hatching_competent_17_1, stimulus_17_length, 10) %s2
axis([0 450 0 1])

subplot(6,1,3)       % add third plot in 5 x 1 grid
make_hatching_plot(hatching_times_16_1, num_hatching_competent_16_1, stimulus_length_16, 10) %s3 
axis([0 450 0 1])
hold on;
line([ForAnnotations{1,2} ForAnnotations{1,2}], ylim);
line([ForAnnotations{1,3} ForAnnotations{1,3}], ylim);
line([ForAnnotations{1,4} ForAnnotations{1,4}], ylim);

subplot(6,1,4)       % add fourth plot in 5 x 1 grid
make_hatching_plot(hatching_times_22, num_hatching_competent_22, stimulus_length_22, 10) %s4
axis([0 450 0 1])
hold on;
line([ForAnnotations{4,2} ForAnnotations{4,2}], ylim);
line([ForAnnotations{4,3} ForAnnotations{4,3}], ylim);
line([ForAnnotations{4,4} ForAnnotations{4,4}], ylim);


%%% truncate(hatching_times, truncate_start, truncate_len)
truncated_hatching_times_17_1 = truncate(hatching_times_17_1, 2:30.5:276.5, 28.5);
truncated_hatching_times_22 = truncate(hatching_times_22, 6, 28.5); 


subplot(5,1,5)       % add fifth plot in 5 x 1 grid
make_hatching_plot(truncated_hatching_times_22, num_hatching_competent_22, stimulus_length_22-28.5, 10) %s6
axis([0 450 0 1])
hold on;
line([ForAnnotations{5,2} ForAnnotations{5,2}], ylim);
line([ForAnnotations{5,3} ForAnnotations{5,3}], ylim);
line([ForAnnotations{5,4} ForAnnotations{5,4}], ylim);
