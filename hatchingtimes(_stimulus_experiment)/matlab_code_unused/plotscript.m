function plotscript (data_subset, threshold)

set(gca, 'xscale', 'log');
set(gca, 'yscale', 'log');
set(gca, 'ZlimMode', 'manual');
zlim([0,1]);
xlabel('min interval (seconds)');
ylabel('min duration (seconds)');
zlabel('percent');
t = strcat('range = ', num2str(threshold));
title(t);
grid on;
view(3);
hold on;
scatter3(data_subset(:,2), data_subset(:,3), data_subset(:,4), 'markeredgecolor', [1 0 0], 'markerfacecolor', [1 0 0]);
scatter3(data_subset(:,2), data_subset(:,3), data_subset(:,5), 'markeredgecolor', [0 1 0], 'markerfacecolor', [0 1 0]);
scatter3(data_subset(:,2), data_subset(:,3), data_subset(:,6), 'markeredgecolor', [0 0 1], 'markerfacecolor', [0 0 1]);
hold off;