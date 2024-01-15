%% Caricamento del segnale e calcolo di zero-mean magnitude

load('acc.mat')
x = a(:, 1);
y = a(:, 2);
z = a(:, 3);
signal = sqrt(sum(x.^2+y.^2+z.^2, 2));

signal = signal - mean(signal);

%% Calcolo e Plot di Movestd
window_size = 20; % Imposta la dimensione della finestra
movestd_signal = movstd(signal, window_size);

%figure;

% plot(signal); hold on;
% plot(movestd_signal, 'g--', 'LineWidth', 2);
% title('Movestd of Acceleration Signal');
% xlabel('Samples');
% ylabel('Acceleration');
% legend('Acceleration Signal', 'Movestd');

% Definizione soglia per movimento e quiete
threshold = 0.45; % Adjust threshold as needed

% Identifica quiete e movimento in base alla soglia
stillness_indices = find(movestd_signal <= threshold);
movement_indices = find(movestd_signal > threshold);

% Plot del segnale originale
figure;
plot(signal);

% Evidenzia quiete in blu
hold on; % scatter(X, Y) draws markers at the locations specified by X and Y
scatter(stillness_indices, signal(stillness_indices), 'b', 'filled');

% Evidenzia movimento in rosso
scatter(movement_indices, signal(movement_indices), 'r', 'filled');

title('Segmentazione approssimata di Quiete e Movimento usando Movestd');
xlabel('Campioni');
ylabel('Accelerazione');
legend('Segnale Accelerazione', 'Quiete', 'Movimento');
