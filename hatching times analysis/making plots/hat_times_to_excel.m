data=load('hatching_times_17_1.mat');
fn=fieldnames(data); %get all variable names
assert(numel(fn)==1); %assert there is only one variable in your mat, otherwise raise error
firstdiff=data.(fn{1}); %get the first variable
xlswrite('hatching_times_17_1.xlsx', firstdiff); %write it