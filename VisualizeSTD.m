%% load the signal and compute zero-mean magnitude

load('acc.mat')
x = a(:,1);
y = a(:,2);
z = a(:,3);
signal = sqrt(sum(x.^2 + y.^2 + z.^2, 2));

signal = signal - mean(signal);

%% Calculate and Plot Movestd
window_size = 20;  % Adjust window size as needed
movestd_signal = movstd(signal, window_size);

%figure;

% plot(signal); hold on;
% plot(movestd_signal, 'g--', 'LineWidth', 2);
% title('Movestd of Acceleration Signal');
% xlabel('Samples');
% ylabel('Acceleration');
% legend('Acceleration Signal', 'Movestd');

% Define a threshold for stillness/movement
threshold = 0.45;  % Adjust threshold as needed

% Identify stillness and movement based on the threshold
stillness_indices = find(movestd_signal <= threshold); % find(condition) returns the indexes where the signal satisfies a conditio
movement_indices = find(movestd_signal > threshold);

% Plot the original signal
figure;
plot(signal);

% Highlight stillness in blue
hold on; % scatter(X, Y) draws markers at the locations specified by X and Y
scatter(stillness_indices, signal(stillness_indices), 'b', 'filled');

% Highlight movement in red
scatter(movement_indices, signal(movement_indices), 'r', 'filled');

title('Rough Segmentation of Stillness and Movement using Movestd');
xlabel('Samples');
ylabel('Acceleration');
legend('Acceleration Signal', 'Stillness', 'Movement');

