clearvars;
close all;
% Nomi dei file da leggere
filename = "samples.mat";
metafilename = "metadata.csv";
th = [0.45, 0.45, 0.3, 0.25]; % Valori di threshold per ogni sensore
% (in ordine acc, mag, orientation, ang_vel)

if (isfile(filename))
    load(filename)
else
    disp("File non trovato.")
    return
end

while true
    user = input("Inserire ID utente (1-4):\n");
    if user < 1 || user > 4
        disp("Indice non trovato.")
    else
        break;
    end
end

n = save_index(user);

if (n == 1), scelta_a = 1;
else
    if n == 0, fprintf("Nessuna acquisizione per l'utente %d.\n", user)
        return
    else
        while true
            fprintf("Ci sono %d acquisizioni per l'utente %d.\n"+ ...
                "Inserire ID acquisizione (1-%d):\n", n, user, n);
            scelta_a = input("");
            if (scelta_a > 0 && scelta_a <= n)
                break
            else, disp("Indice non trovato");
            end
        end
    end
end
% Carica i metadati in una matrice
M = readmatrix(metafilename);
for i = 1:size(M)
    % Prende ogni riga della matrice singolarmente e la analizza
    r = M(i, :);
    % Confronta gli ID nei metadati con le scelte dell'utente per trovare
    % il campo Available_Sensors (5)
    if r(1) == user && r(2) == scelta_a
        scelta_s = r(5);
        break
    end

end

switch (scelta_s)
    case 1
        acc = samples.user(user).acquisition(scelta_a).acc;
        sigplot(acc, 'X', 'Y', 'Z', 'Accelerazione (m/s^2)', 'Accelerazione', th(1));

    case 2
        mag = samples.user(user).acquisition(scelta_a).mag;
        sigplot(mag, 'X', 'Y', 'Z', 'Campo magnetico (uT)', 'Campo Magnetico', th(2));

    case 3
        orientation = samples.user(user).acquisition(scelta_a).orientation;
        sigplot(orientation, 'Azimut', 'Beccheggio', 'Rollio', 'Orientamento (deg)', 'Orientamento', th(3));

    case 4
        ang_vel = samples.user(user).acquisition(scelta_a).ang_vel;
        sigplot(ang_vel, 'X', 'Y', 'Z', 'Velocità angolare (rad/s)', 'Velocità angolare', th(4));

    case 5
        while true
            scelta_s = input("Scegliere sensori da visualizzare:\n"+ ...
                "1 - Accelerometro\n"+ ...
                "2 - Magnetometro\n"+ ...
                "3 - Orientamento\n"+ ...
                "4 - Giroscopio (Velocità angolare)\n"+ ...
                "5 - Tutti\n");
            switch (scelta_s)
                case 1
                    acc = samples.user(user).acquisition(scelta_a).acc;
                    sigplot(acc, 'X', 'Y', 'Z', 'Accelerazione (m/s^2)', 'Accelerazione', th(1));
                    break
                case 2
                    mag = samples.user(user).acquisition(scelta_a).mag;
                    sigplot(mag, 'X', 'Y', 'Z', 'Campo magnetico (uT)', 'Campo Magnetico', th(2));
                    break
                case 3
                    orientation = samples.user(user).acquisition(scelta_a).orientation;
                    sigplot(orientation, 'Azimut', 'Beccheggio', 'Rollio', 'Orientamento (deg)', 'Orientamento', th(3));
                    break
                case 4
                    ang_vel = samples.user(user).acquisition(scelta_a).ang_vel;
                    sigplot(ang_vel, 'X', 'Y', 'Z', 'Velocità angolare (rad/s)', 'Velocità angolare', th(4));
                    break
                case 5
                    acc = samples.user(user).acquisition(scelta_a).acc;
                    sigplot(acc, 'X', 'Y', 'Z', 'Accelerazione (m/s^2)', 'Accelerazione', th(1));
                    disp("Accelerazione")
                    disp("Premi un tasto qualsiasi per il prossimo sensore.")
                    pause();

                    mag = samples.user(user).acquisition(scelta_a).mag;
                    sigplot(mag, 'X', 'Y', 'Z', 'Campo magnetico (uT)', 'Campo Magnetico', th(2));
                    disp("Campo magnetico")
                    disp("Premi un tasto qualsiasi per il prossimo sensore.")
                    pause();

                    orientation = samples.user(user).acquisition(scelta_a).orientation;
                    sigplot(orientation, 'Azimut', 'Beccheggio', 'Rollio', 'Orientamento (deg)', 'Orientamento', th(3));
                    disp("Orientamento")
                    disp("Premi un tasto qualsiasi per il prossimo sensore.")
                    pause();

                    ang_vel = samples.user(user).acquisition(scelta_a).ang_vel;
                    sigplot(ang_vel, 'X', 'Y', 'Z', 'Velocità angolare (rad/s)', 'Velocità angolare', th(4));
                    disp("Giroscopio (Velocità Angolare)")
                    disp("Premi un tasto qualsiasi per terminare la visualizzazione.")
                    pause();
                    disp("Fine visualizzazione.");
                    close all;
                    break

                otherwise, disp("Indice non trovato.");
            end
        end

    otherwise, disp("Indice non trovato.");
end

function sigplot(s, xl, yl, zl, ylab, name, th)
% Se il campione supera i 20 secondi viene ritagliato
if (size(s, 1) > 2000)
    s = s(1:2000, :);
end

figure("Name", name);
plot(s);
legend(xl, yl, zl);
xlabel('Campioni');
ylabel(ylab);
x = s(:, 1);
y = s(:, 2);
z = s(:, 3);
s = sqrt(sum(x.^2+y.^2+z.^2, 2));

s = s - mean(s);

window_size = 20; % Imposta la dimensione della finestra
movestd_signal = movstd(s, window_size);

% Definizione soglia per movimento e quiete
threshold = th;

% Identifica quiete e movimento in base alla soglia
stillness_indices = find(movestd_signal <= threshold);
movement_indices = find(movestd_signal > threshold);

% Plot del segnale originale
figure("Name", name);
plot(s);

% Evidenzia quiete in blu
hold on;
scatter(stillness_indices, s(stillness_indices), 'b', 'filled');

% Evidenzia movimento in rosso
scatter(movement_indices, s(movement_indices), 'r', 'filled');

title('Segmentazione approssimata di Quiete e Movimento usando Movestd');
xlabel('Campioni');
ylabel(ylab);

legend(name, 'Quiete', 'Movimento');
end