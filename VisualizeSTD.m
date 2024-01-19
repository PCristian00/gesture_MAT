%% Caricamento del segnale e calcolo di zero-mean magnitude (CAPIRE COME CAMBIA CON STRUCT)

load('acc.mat')
x = a(:, 1);
y = a(:, 2);
z = a(:, 3);
signal = sqrt(sum(x.^2+y.^2+z.^2, 2));

signal = signal - mean(signal);

%% Calcolo e Plot di Movestd
window_size = 20; % Imposta la dimensione della finestra
movestd_signal = movstd(signal, window_size);

% Definizione soglia per movimento e quiete
threshold = 0.45; % Soglia iniziale = 0.45

% Identifica quiete e movimento in base alla soglia
stillness_indices = find(movestd_signal <= threshold);
movement_indices = find(movestd_signal > threshold);

% Provare a controllare ogni 100 indici? Per scoprire veri gesti 

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

%figure;

% plot(signal); hold on;
% plot(movestd_signal, 'g--', 'LineWidth', 2);
% title('Movestd of Acceleration Signal');
% xlabel('Samples');
% ylabel('Acceleration');
% legend('Acceleration Signal', 'Movestd');


