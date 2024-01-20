clearvars;
close all;

if (isfile("samples.mat"))
    load("samples.mat")
else
    disp("File non trovato.")
    return
end

while true
    user = input("Inserire utente (1-4):");
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
                "Inserire un numero da 1 a %d:\n", n, user, n);
            scelta_a = input("");
            if (scelta_a < n || scelta_a > 0)
                break
            else, disp("Indice non trovato");
            end
        end
    end
end

scelta_s = samples.user(user).acquisition(scelta_a).sensors;


switch (scelta_s)
    case 1
        acc = samples.user(user).acquisition(scelta_a).acc;
        sigplot(acc, 'X', 'Y', 'Z', 'Accelerazione (m/s^2)', 'Accelerazione');

    case 2
        mag = samples.user(user).acquisition(scelta_a).mag;
        sigplot(mag, 'X', 'Y', 'Z', 'Campo magnetico (uT)', 'Campo Magnetico');

    case 3
        orientation = samples.user(user).acquisition(scelta_a).orientation;
        sigplot(orientation, 'Azimut', 'Beccheggio', 'Rollio', 'Orientamento (deg)', 'Orientamento');

    case 4
        ang_vel = samples.user(user).acquisition(scelta_a).ang_vel;
        sigplot(ang_vel, 'X', 'Y', 'Z', 'Velocità angolare (rad/s)', 'Velocità angolare');

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
                    sigplot(acc, 'X', 'Y', 'Z', 'Accelerazione (m/s^2)', 'Accelerazione');
                    break
                case 2
                    mag = samples.user(user).acquisition(scelta_a).mag;
                    sigplot(mag, 'X', 'Y', 'Z', 'Campo magnetico (uT)', 'Campo Magnetico');
                    break
                case 3
                    orientation = samples.user(user).acquisition(scelta_a).orientation;
                    sigplot(orientation, 'Azimut', 'Beccheggio', 'Rollio', 'Orientamento (deg)', 'Orientamento');
                    break
                case 4
                    ang_vel = samples.user(user).acquisition(scelta_a).ang_vel;
                    sigplot(ang_vel, 'X', 'Y', 'Z', 'Velocità angolare (rad/s)', 'Velocità angolare');
                    break
                case 5
                    acc = samples.user(user).acquisition(scelta_a).acc;
                    sigplot(acc, 'X', 'Y', 'Z', 'Accelerazione (m/s^2)', 'Accelerazione');
                    disp("Accelerazione")
                    disp("Premi un tasto qualsiasi per il prossimo sensore.")
                    pause();

                    mag = samples.user(user).acquisition(scelta_a).mag;
                    sigplot(mag, 'X', 'Y', 'Z', 'Campo magnetico (uT)', 'Campo Magnetico');
                    disp("Campo magnetico")
                    disp("Premi un tasto qualsiasi per il prossimo sensore.")
                    pause();

                    orientation = samples.user(user).acquisition(scelta_a).orientation;
                    sigplot(orientation, 'Azimut', 'Beccheggio', 'Rollio', 'Orientamento (deg)', 'Orientamento');
                    disp("Orientamento")
                    disp("Premi un tasto qualsiasi per il prossimo sensore.")
                    pause();

                    ang_vel = samples.user(user).acquisition(scelta_a).ang_vel;
                    sigplot(ang_vel, 'X', 'Y', 'Z', 'Velocità angolare (rad/s)', 'Velocità angolare');
                    disp("Giroscopio (Velocità Angolare)")
                    disp("Premi un tasto qualsiasi per il prossimo sensore.")
                    pause();
                    break

                otherwise, disp("Indice non trovato.");
            end
        end

    otherwise, disp("Indice non trovato.");
end

function sigplot(s, xl, yl, zl, ylab, name)
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
threshold = 0.45; % Soglia iniziale = 0.45

% Identifica quiete e movimento in base alla soglia
stillness_indices = find(movestd_signal <= threshold);
movement_indices = find(movestd_signal > threshold);

% Provare a controllare ogni 100 indici? Per scoprire veri gesti

% Plot del segnale originale
figure("Name", name);
plot(s);

% Evidenzia quiete in blu
hold on; % scatter(X, Y) draws markers at the locations specified by X and Y
scatter(stillness_indices, s(stillness_indices), 'b', 'filled');

% Evidenzia movimento in rosso
scatter(movement_indices, s(movement_indices), 'r', 'filled');

title('Segmentazione approssimata di Quiete e Movimento usando Movestd');
xlabel('Campioni');
ylabel(ylab);

legend(name, 'Quiete', 'Movimento');
end