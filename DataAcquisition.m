clearvars;
% Nomi dei file da caricare e sovrascrivere
filename = "samples.mat";
metafilename = "metadata.csv";

%% Caricamento file di salvataggio
if (isfile(filename)) % Se il file esiste, chiede se deve essere caricato
    while true
        scelta_c = input("Caricare file?\n"+ ...
            "1 - Si\n"+ ...
            "0 - No (Può sovrascrivere il file)\n");
        if (scelta_c == 1)
            load(filename)
            fprintf("File caricato con successo.\n");
            break
        else
            if scelta_c == 0
                newSave(metafilename)
                save_index = zeros(1, 4);
                break
            else
                fprintf("Indice non trovato.\n");
            end
        end
    end
else
    fprintf("File di salvataggio non trovato.\n");
    newSave(metafilename)
    save_index = zeros(1, 4);
end

%% Connessione a dispositivo
disp('Aprire MATLAB Mobile sul dispositivo e premere un tasto.');
pause; % Attesa del tasto
disp("Attendere...")
% Connessione allo smartphone
m = mobiledev;
fprintf("Dispositivo %s connesso con successo.\n", m.Device)

%% Loop di acquisizione
while true % Finche' l'utente vuole fare nuove acquisizioni con lo stesso dispositivo

    %% Attivazione sensori

    while true
        scelta_s = input("Scegliere sensori da attivare:\n"+ ...
            "1 - Accelerometro\n"+ ...
            "2 - Magnetometro\n"+ ...
            "3 - Orientamento\n"+ ...
            "4 - Giroscopio (Velocità angolare)\n"+ ...
            "5 - Tutti\n");
        disp("Attendere...");
        switch (scelta_s)
            case 1
                m.AccelerationSensorEnabled = 1;
                m.MagneticSensorEnabled = 0;
                m.OrientationSensorEnabled = 0;
                m.AngularVelocitySensorEnabled = 0;
                disp("Accelerometro acceso.");
                break
            case 2
                m.AccelerationSensorEnabled = 0;
                m.MagneticSensorEnabled = 1;
                m.OrientationSensorEnabled = 0;
                m.AngularVelocitySensorEnabled = 0;
                disp("Magnetometro acceso.");
                break
            case 3
                m.AccelerationSensorEnabled = 0;
                m.MagneticSensorEnabled = 0;
                m.OrientationSensorEnabled = 1;
                m.AngularVelocitySensorEnabled = 0;
                disp("Sensore orientazione acceso.");
                break
            case 4
                m.AccelerationSensorEnabled = 0;
                m.MagneticSensorEnabled = 0;
                m.OrientationSensorEnabled = 0;
                m.AngularVelocitySensorEnabled = 1;
                disp("Giroscopio acceso.");
                break
            case 5
                m.AccelerationSensorEnabled = 1;
                m.MagneticSensorEnabled = 1;
                m.OrientationSensorEnabled = 1;
                m.AngularVelocitySensorEnabled = 1;
                disp("Tutti i sensori accesi.");
                break
            otherwise, disp("Indice non trovato.");
        end

    end
    pause(0.5);
    sampling_frequency = 100; % Hz
    m.SampleRate = sampling_frequency;

    time_out = true;
    % Viene mostrata un'immagine contenente tutti i gesti
    pic = imread("gestures.png");
    imshow(pic);
    while time_out
        gestures = ["S", "AS", "Z", "AZ"; ...
            "Up", "CW", "CCW", "Down"; ...
            "CW", "CW", "Push", "Pull"; ...
            "Push", "Pull", "CW", "CCW"]; % Set di gesti, ogni riga appartiene a un diverso utente
        % Scelta dell'utente
        while true
            user = input("Inserire utente (1-4):");
            if user < 1 || user > 4
                disp("Indice non trovato.")
            else
                break;
            end
        end
        % Scelta della mano
        while true
            hand = input("Scegliere mano:\n"+ ...
                "0 - Destra\n"+ ...
                "1 - Sinistra\n");
            if hand == 0
                hand = 'right';
                break;
            else
                if hand == 1
                    hand = 'left';
                    break;

                else, fprintf("Indice non trovato.\n");
                end
            end
        end

        gesture = gestures(user, :); % Viene salvato il set di gesti corrispondente all'utente
        gesture = gesture(randperm(length(gesture))); % Randomizzazione ordine gesti
        disp("Gesti da eseguire:");
        disp(gesture)

        % Scelta del metodo di raccolta
        while (true)
            scelta_r = input("Scegliere metodo di raccolta.\n"+ ...
                "0 - Normale: 1 tasto per avviare, 4 gesti\n"+ ...
                "1 - Guidato: 1 gesto alla volta, con intervalli guidati\n");
            switch (scelta_r)
                case 0
                    disp('Premi un tasto per avviare il logging...');
                    pause; % Attesa del tasto
                    disp('Logging avviato.');
                    m.Logging = 1;

                    tic; % Avvio timer

                    fprintf("\nGesti da eseguire, in questo ordine:\n"+ ...
                        "%s %s %s %s\n"+ ...
                        "Fare una pausa di almeno 1 secondo tra un gesto e l'altro.\n"+ ...
                        "Premere un tasto una volta finito.\n", gesture);
                    pause;
                    time = toc;
                    fprintf("Gesti eseguiti in %.1f secondi.\n", time);

                    if time < 20 % Se il tempo non e' scaduto va avanti
                        time_out = false;
                        time_left = 20 - time;
                        fprintf("Rimanere fermo per %.1f secondi.\n", time_left);
                        pause(time_left)
                        break;
                    end

                    break

                case 1
                    disp('Premi un tasto per avviare il logging...');
                    pause; % Attesa del tasto
                    disp('Logging avviato.');

                    m.Logging = 1;

                    tic; % Avvio timer

                    for i = 1:4 % Raccolta dei 4 gesti
                        fprintf("Eseguire gesto %d:\t %s\n", i, gesture(i));
                        % disp(gesti(i))
                        disp('Premi un tasto quando il gesto è completo.');
                        pause; % Attesa del tasto

                        time(i) = toc; % Conteggio tempo impiegato
                        time_left = 20 - time(i); % Calcolo tempo rimanente

                        if time(i) >= 20, break % Se il tempo e' esaurito il ciclo viene interrotto
                        end

                        if i ~= 4
                            disp("Attendere...");
                            pause(1); % Fa una pausa di 1 secondo tra un gesto e l'altro
                            fprintf("Massimo %.1f secondi rimanenti.\n", time_left-1);
                        end
                    end
                    time(i) = toc;
                    fprintf("Gesti eseguiti in %.1f secondi.\n", time(i));
                    if time(i) < 20 % Se il tempo non e' scaduto va avanti
                        time_out = false;
                        fprintf("Rimanere fermo per %.1f secondi.\n", time_left);
                        pause(time_left)

                    else, fprintf("Tempo di 20 secondi superati. Raccolta eliminata.\n");

                    end
                    % disp(time)
                    break


                otherwise, disp("Valore non trovato");
            end
        end

        [a, t1] = accellog(m); % Logging accelerometro
        [mag, t2] = magfieldlog(m); % Logging campo magnetico
        [ang_vel, t3] = angvellog(m); % Logging velocita' angolare
        [orientation, t4] = orientlog(m); % Logging orientamento

        m.Logging = 0; % Disattivazione del logging
        m.discardlogs; % Cancellazione dei log

        if (time_out == false) % Il salvataggio avviene solo se il tempo non è scaduto

            save_index(user) = save_index(user) + 1; % Incrementa le acquisioni fatte dall'utente

            % Salvataggio su csv
            if (scelta_r == 1)
                data = {user, save_index(user), hand, m.device, scelta_s, 0, time(1), gesture(1), time(1) + 1, time(2), gesture(2), time(2) + 1, time(3), gesture(3), time(3) + 1, time(4), gesture(4)};
            else
                data = {user, save_index(user), hand, m.device, scelta_s, "start_A", "end_A", gesture(1), "start_B", "end_B", gesture(2), "start_C", "end_C", gesture(3), "start_D", "end_D", gesture(4)};
            end
            writecell(data, metafilename, 'Delimiter', ';', 'QuoteStrings', 1, 'WriteMode', 'append');

            % Salvataggio nella struct
            samples.user(user).acquisition(save_index(user)).acc = a; % Salvataggio accelerazione
            samples.user(user).acquisition(save_index(user)).mag = mag; % Salvataggio campo magnetico
            samples.user(user).acquisition(save_index(user)).orientation = orientation; % Salvataggio orientamento
            samples.user(user).acquisition(save_index(user)).ang_vel = ang_vel; % Salvataggio velocita' angolare

            save(filename, 'samples', 'save_index'); % Salvataggio campioni e indici di salvataggio
            fprintf("Dati salvati su %s\n", filename);
            fprintf("Metadati salvati su %s\n", metafilename);
        end

        % Riavvio del loop a scelta
        while true
            scelta_a = input("\nPremere 0 per uscire dalla raccolta.\n"+ ...
                "Premi 1 per una nuova acquisizione.\n");
            if scelta_a == 0, disp("Uscita operazione.");
                return;
            else
                if scelta_a ~= 1, fprintf("Codice non trovato.\n");
                else, break;
                end
            end
        end
    end
end

% Funzione che sovrascrive il file dei metadati
function newSave(metafilename)
fprintf("Creazione nuovo file.\n");
% Creazione csv
data = {"ID_Subject", "Idx_Acquisition", "Hand", "Smartphone_model", "Available_Sensors", "Start_GestureA", "End_GestureA", "ID_GestureA", "Start_GestureB", "End_GestureB", "ID_GestureB", "Start_GestureC", "End_GestureC", "ID_GestureC", "Start_GestureD", "End_GestureD", "ID_GestureD"};
writecell(data, metafilename, 'Delimiter', ';', 'WriteMode', 'overwrite');
end