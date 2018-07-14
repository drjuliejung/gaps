function plot_signals (signals, delta)

t = delta*(0:1:numel(signals{1})-1);

hold on;

for i = 1:numel(signals)
    plot(t, signals{i});
end

xlabel('Seconds');
ylabel('Acceleration (m/s^2)');