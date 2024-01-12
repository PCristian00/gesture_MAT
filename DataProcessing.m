%% Data Loading
load('acc.mat')

plot(a);
legend('X', 'Y', 'Z');
xlabel('Samples');
ylabel('Acceleration (m/s^2)');

%% Pre-processing
% Compute magnitude

x = a(:,1);
y = a(:,2);
z = a(:,3);
mag = sqrt(sum(x.^2 + y.^2 + z.^2, 2));

% figure; plot(mag);
% xlabel('Samples');
% ylabel('Acceleration (m/s^2)'); % it is not zero-mean ->
% 
% % -> remove offset from the magnitude (due to gravity)
% magNoG = mag - mean(mag);

% plot(magNoG);
% xlabel('Time (s)');
% ylabel('Acceleration (m/s^2)');