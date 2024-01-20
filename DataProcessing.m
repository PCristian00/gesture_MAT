clearvars;

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

    scelta_s = samples.user(user).acquisition(scelta_a).sensors;

    
    switch (scelta_s)
        case 1
            acc = samples.user(user).acquisition(scelta_a).acc;
            sigplot(acc);

        case 2
            mag = samples.user(user).acquisition(scelta_a).mag;
            plot(mag);
            legend('X', 'Y', 'Z');
            xlabel('Campioni');
            ylabel('Campo magnetico (uT)');
            x = mag(:, 1);
            y = mag(:, 2);
            z = mag(:, 3);
            mag = sqrt(sum(x.^2+y.^2+z.^2, 2));

            mag = mag - mean(mag);

            window_size = 20; % Imposta la dimensione della finestra
            movestd_signal = movstd(mag, window_size);
            
            % Definizione soglia per movimento e quiete
            threshold = 0.45; % Soglia iniziale = 0.45
            
            % Identifica quiete e movimento in base alla soglia
            stillness_indices = find(movestd_signal <= threshold);
            movement_indices = find(movestd_signal > threshold);
            
            % Provare a controllare ogni 100 indici? Per scoprire veri gesti 
            
            % Plot del segnale originale
            figure;
            plot(mag);
            
            % Evidenzia quiete in blu
            hold on; % scatter(X, Y) draws markers at the locations specified by X and Y
            scatter(stillness_indices, mag(stillness_indices), 'b', 'filled');
            
            % Evidenzia movimento in rosso
            scatter(movement_indices, mag(movement_indices), 'r', 'filled');
            
            title('Segmentazione approssimata di Quiete e Movimento usando Movestd');
            xlabel('Campioni');
            ylabel('Campo Magnetico');
            legend('Segnale C. Magnetico', 'Quiete', 'Movimento');
        case 3 || 5
            orientation = samples.user(user).acquisition(scelta_a).orientation;
            plot(orientation);
            legend('Azimut', 'Beccheggio', 'Rollio');
            xlabel('Campioni');
            ylabel('Orientamento (deg)');
            x = orientation(:, 1);
            y = orientation(:, 2);
            z = orientation(:, 3);
            orientation = sqrt(sum(x.^2+y.^2+z.^2, 2));

            orientation = orientation - mean(orientation);

            window_size = 20; % Imposta la dimensione della finestra
            movestd_signal = movstd(orientation, window_size);
            
            % Definizione soglia per movimento e quiete
            threshold = 0.45; % Soglia iniziale = 0.45
            
            % Identifica quiete e movimento in base alla soglia
            stillness_indices = find(movestd_signal <= threshold);
            movement_indices = find(movestd_signal > threshold);
            
            % Provare a controllare ogni 100 indici? Per scoprire veri gesti 
            
            % Plot del segnale originale
            figure;
            plot(orientation);
            
            % Evidenzia quiete in blu
            hold on; % scatter(X, Y) draws markers at the locations specified by X and Y
            scatter(stillness_indices, orientation(stillness_indices), 'b', 'filled');
            
            % Evidenzia movimento in rosso
            scatter(movement_indices, orientation(movement_indices), 'r', 'filled');
            
            title('Segmentazione approssimata di Quiete e Movimento usando Movestd');
            xlabel('Campioni');
            ylabel('Orientamento');
            legend('Segnale Orientamento', 'Quiete', 'Movimento');
        case 4 || 5
            ang_vel = samples.user(user).acquisition(scelta_a).ang_vel;
            plot(ang_vel);
            legend('X', 'Y', 'Z');
            xlabel('Campioni');
            ylabel('Velocità angolare (rad/s)');
            x = ang_vel(:, 1);
            y = ang_vel(:, 2);
            z = ang_vel(:, 3);
            ang_vel = sqrt(sum(x.^2+y.^2+z.^2, 2));

            ang_vel = ang_vel - mean(ang_vel);

            window_size = 20; % Imposta la dimensione della finestra
            movestd_signal = movstd(ang_vel, window_size);
            
            % Definizione soglia per movimento e quiete
            threshold = 0.45; % Soglia iniziale = 0.45
            
            % Identifica quiete e movimento in base alla soglia
            stillness_indices = find(movestd_signal <= threshold);
            movement_indices = find(movestd_signal > threshold);
            
            % Provare a controllare ogni 100 indici? Per scoprire veri gesti 
            
            % Plot del segnale originale
            figure;
            plot(ang_vel);
            
            % Evidenzia quiete in blu
            hold on; % scatter(X, Y) draws markers at the locations specified by X and Y
            scatter(stillness_indices, ang_vel(stillness_indices), 'b', 'filled');
            
            % Evidenzia movimento in rosso
            scatter(movement_indices, ang_vel(movement_indices), 'r', 'filled');
            
            title('Segmentazione approssimata di Quiete e Movimento usando Movestd');
            xlabel('Campioni');
            ylabel('Velocità Angolare');
            legend('Segnale Velocità Angolare', 'Quiete', 'Movimento');
        case 5
            disp("DA CAPIRE")
            sigplot
            % FORSE VEDERE FUSIONE DEI LOG
            % acc = samples.user(user).acquisition(scelta_a).acc;
            % mag = samples.user(user).acquisition(scelta_a).mag;
            % orientation = samples.user(user).acquisition(scelta_a).orientation;
            % ang_vel = samples.user(user).acquisition(scelta_a).ang_vel;           
        otherwise, disp("Indice non trovato.");
    end

    function sigplot(s)
    plot(s);
            legend('X', 'Y', 'Z');
            xlabel('Campioni');
            ylabel('Accelerazione (m/s^2)');
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
            figure;
            plot(s);
            
            % Evidenzia quiete in blu
            hold on; % scatter(X, Y) draws markers at the locations specified by X and Y
            scatter(stillness_indices, s(stillness_indices), 'b', 'filled');
            
            % Evidenzia movimento in rosso
            scatter(movement_indices, s(movement_indices), 'r', 'filled');
            
            title('Segmentazione approssimata di Quiete e Movimento usando Movestd');
            xlabel('Campioni');
            ylabel('Accelerazione');
            legend('Segnale Accelerazione', 'Quiete', 'Movimento');
disp("Test")
end