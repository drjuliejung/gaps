function fft_example(S, sampling_rate)

% number of points
N = numel(S);

% define time vector
delta = 1/sampling_rate;
t = delta*(0:1:(N-1));

% plot signal
%figure
%plot(t, S)

% take fft
S_fft = fftshift(fft(S))/N;

% define frequency vector
n = (-N/2):1:((N/2)-1);
f_n = n/(N*delta);

% plot fft
figure
plot(f_n,  abs(S_fft));


