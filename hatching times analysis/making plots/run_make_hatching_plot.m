%make_histogram(hatching_times_16_1, hatching_times_16_2)
%fft_example(Y1, 22050)

%inport "ForAnnotations"
%add labels to plot for 25%, 50%, and 75% of clutch hatched

%The subplot function takes three inputs. 
%The first two inputs, m and n, divide the current figure into an m by n grid. 
%The third input specifies the position in the grid where the new axes are created. 
%The grid position specified by the third input is a row-based index.

% figure
% subplot(4,1,1)       % add first plot in 4 x 1 grid
% make_hatching_plot(hatching_times_21_1, num_hatching_competent_21_1, stimulus_21_length, 10) %s1
% axis([0 450 0 1])
% 
% subplot(4,1,2)       % add second plot in 4 x 1 grid
% make_hatching_plot(hatching_times_17_1, num_hatching_competent_17_1, stimulus_17_length, 10) %s2
% axis([0 450 0 1])
% 
% subplot(4,1,3)       % add third plot in 4 x 1 grid
% make_hatching_plot(hatching_times_16_1, num_hatching_competent_16_1, stimulus_length_16, 10) %s3 
% axis([0 450 0 1])
% hold on;
% line([ForAnnotations{1,2} ForAnnotations{1,2}], ylim);
% line([ForAnnotations{1,3} ForAnnotations{1,3}], ylim);
% line([ForAnnotations{1,4} ForAnnotations{1,4}], ylim);
% 
% subplot(4,1,4)       % add fourth plot in 4 x 1 grid
% make_hatching_plot(hatching_times_22, num_hatching_competent_22, stimulus_length_22, 10) %s4
% axis([0 450 0 1])
% hold on;
% line([ForAnnotations{4,2} ForAnnotations{4,2}], ylim);
% line([ForAnnotations{4,3} ForAnnotations{4,3}], ylim);
% line([ForAnnotations{4,4} ForAnnotations{4,4}], ylim);

% 
% figure
% subplot(5,1,1)       % add first plot in 5 x 1 grid
% make_hatching_plot(hatching_times_21_2, num_hatching_competent_21_2, stimulus_21_length, 10) %s1
% axis([0 450 0 1])
% 
% subplot(5,1,2)       % add second plot in 5 x 1 grid
% make_hatching_plot(hatching_times_17_2, num_hatching_competent_17_2, stimulus_17_length, 10) %s2
% axis([0 450 0 1])
% 
% subplot(5,1,3)       % add third plot in 5 x 1 grid
% make_hatching_plot(hatching_times_16_2, num_hatching_competent_16_2, stimulus_length_16, 10) %s3 
% axis([0 450 0 1])
% hold on;
% line([ForAnnotations{2,2} ForAnnotations{2,2}], ylim);
% line([ForAnnotations{2,3} ForAnnotations{2,3}], ylim);
% line([ForAnnotations{2,4} ForAnnotations{2,4}], ylim);
% 
% subplot(5,1,4)       % add fourth plot in 5 x 1 grid
% make_hatching_plot(hatching_times_27, num_hatching_competent_27, stimulus_27_length, 10) %s5
% axis([0 450 0 1])
% hold on;
% line([ForAnnotations{7,2} ForAnnotations{7,2}], ylim);
% line([ForAnnotations{7,3} ForAnnotations{7,3}], ylim);
% line([ForAnnotations{7,4} ForAnnotations{7,4}], ylim);
% 
% subplot(5,1,5)       % add fifth plot in 5 x 1 grid
% make_hatching_plot(hatching_times_28, num_hatching_competent_28, stimulus_28_length, 10) %s6
% axis([0 450 0 1])
% hold on;
% line([ForAnnotations{9,2} ForAnnotations{9,2}], ylim);
% line([ForAnnotations{9,3} ForAnnotations{9,3}], ylim);
% line([ForAnnotations{9,4} ForAnnotations{9,4}], ylim);
% 
% figure
% subplot(4,1,1)       % add first plot in 4 x 1 grid
% make_hatching_plot(hatching_times_16_3, num_hatching_competent_16_3, stimulus_length_16, 10) %s3
% axis([0 450 0 1])
% hold on;
% line([ForAnnotations{3,2} ForAnnotations{3,2}], ylim);
% line([ForAnnotations{3,3} ForAnnotations{3,3}], ylim);
% line([ForAnnotations{3,4} ForAnnotations{3,4}], ylim);
% 
% subplot(4,1,2)       % add second plot in 4 x 1 grid
% make_hatching_plot(hatching_times_30, num_hatching_competent_30, stimulus_30_length, 10) %s7
% axis([0 450 0 1])
% hold on;
% line([ForAnnotations{11,2} ForAnnotations{11,2}], ylim);
% line([ForAnnotations{11,3} ForAnnotations{11,3}], ylim);
% line([ForAnnotations{11,4} ForAnnotations{11,4}], ylim);
% 
% subplot(4,1,3)       % add third plot in 4 x 1 grid
% make_hatching_plot(hatching_times_31, num_hatching_competent_31, stimulus_31_length, 10) %s8
% axis([0 450 0 1])
% hold on;
% line([ForAnnotations{14,2} ForAnnotations{14,2}], ylim);
% line([ForAnnotations{14,3} ForAnnotations{14,3}], ylim);
% line([ForAnnotations{14,4} ForAnnotations{14,4}], ylim);
% 
% subplot(4,1,4)       % add fourth plot in 4 x 1 grid
% make_hatching_plot(hatching_times_32, num_hatching_competent_32, stimulus_32_length, 10) %s9
% axis([0 450 0 1])
% hold on;
% line([ForAnnotations{16,2} ForAnnotations{16,2}], ylim);
% line([ForAnnotations{16,3} ForAnnotations{16,3}], ylim);
% line([ForAnnotations{16,4} ForAnnotations{16,4}], ylim);

figure

%%% truncate(hatching_times, truncate_start, truncate_len)
truncated_hatching_times_27 = truncate(hatching_times_27, 6:34.5:316.5, 28.5);
truncated_hatching_times_28 = truncate(hatching_times_28, 20:48.5:311, 28.5); 

subplot(3,1,1)       % add first plot in 3 x 1 grid
make_hatching_plot(hatching_times_16_2, num_hatching_competent_16_2, stimulus_length_16, 10) %s3
axis([0 450 0 1])
hold on;
line([ForAnnotations{2,2} ForAnnotations{2,2}], ylim);
line([ForAnnotations{2,3} ForAnnotations{2,3}], ylim);
line([ForAnnotations{2,4} ForAnnotations{2,4}], ylim);

subplot(3,1,2)       % add second plot in 3 x 1 grid
make_hatching_plot(truncated_hatching_times_27, num_hatching_competent_27, 60, 10) %s5
axis([0 450 0 1])
hold on;
line([ForAnnotations{8,2} ForAnnotations{8,2}], ylim);
line([ForAnnotations{8,3} ForAnnotations{8,3}], ylim);
line([ForAnnotations{8,4} ForAnnotations{8,4}], ylim);

subplot(3,1,3)       % add third plot in 3 x 1 grid
make_hatching_plot(truncated_hatching_times_28, num_hatching_competent_28, 140, 10) %s6
axis([0 450 0 1])
hold on;
line([ForAnnotations{10,2} ForAnnotations{10,2}], ylim);
line([ForAnnotations{10,3} ForAnnotations{10,3}], ylim);
line([ForAnnotations{10,4} ForAnnotations{10,4}], ylim);

