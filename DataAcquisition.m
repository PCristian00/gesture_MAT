%% Avvio acquisizione
clear m;
n = 1;

%% RISOLVERE (1 INDICE PER OGNI UTENTE? RACCOGLIERE ULTIMO INDICE PER OGNI UTENTE?)

disp('Aprire MATLAB Mobile sul dispositivo e premere un tasto.');
pause; % Attesa del tasto
disp("Attendere...")
% Connessione allo smartphone
m = mobiledev;
fprintf("Dispositivo %s connesso con successo.\n", m.Device)
% Attivazione sensori
m.AccelerationSensorEnabled = 1;
pause(0.5);
sampling_frequency = 100; % Hz
m.SampleRate = sampling_frequency;
while true % Finche' l'utente vuole fare nuove acquisizioni con lo stesso dispositivo
    time_out = true;

    pic = imread("gestures.png");
    imshow(pic);
    while time_out

        gestures = ["S", "AS", "Z", "AZ"; ...
            "Up", "CW", "CCW", "Down"; ...
            "CW", "CW", "Push", "Pull"; ...
            "Push", "Pull", "CW", "CCW"]; % Set di gesti
        % disp(gestures)


        while true
            user = input("Inserire utente (1-4):");
            if user < 1 || user > 4
                disp("Indice non trovato.")
            else
                % disp(user);
                gesture = gestures(user, :);
                % disp(gesture);
                break;
            end
        end


        gesture = gesture(randperm(length(gesture))); % Randomizzazione ordine gesti
        % disp("Riga randomizzata")
        disp(gesture)

        scelta_r = input("Scegliere metodo di raccolta.\n"+ ...
            "0 - Normale: 1 tasto per avviare, 4 gesti\n"+ ...
            "1 - Guidato: 1 gesto alla volta, con intervalli guidati\n");
        switch (scelta_r)
            case 0
                % disp("DA IMPLEMENTARE");
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
                % VEDERE SE MANCA IL COMPLETAMENTO (vedi riga 106 circa)
                if time <= 20, time_out = false;
                    time_left = 20 - time;
                    fprintf("Rimanere fermo per %.1f secondi.\n", time_left);
                    pause(time_left)
                    break;
                end

                % VEDERE SE SALVA

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

                    time = toc; % Conteggio tempo impiegato
                    time_left = 20 - time; % Calcolo tempo rimanente

                    if time >= 20, break % Se il tempo e' esaurito il ciclo viene interrotto
                    end

                    if i ~= 4
                        disp("Attendere...");
                        pause(1); % Fa una pausa di 1 secondo tra un gesto e l'altro
                        fprintf("Massimo %.1f secondi rimanenti.\n", time_left-1);
                    end
                end
                time = toc;
                fprintf("Gesti eseguiti in %.1f secondi.\n", time);
                if time < 20 % Se il tempo non e' scaduto va avanti
                    time_out = false;
                    fprintf("Rimanere fermo per %.1f secondi.\n", time_left);
                    pause(time_left)

                else, fprintf("Tempo di 20 secondi superati. Riavvio raccolta.\n");
                end
            otherwise, disp("Valore non trovato");
        end


        [a, t] = accellog(m);
        m.Logging = 0; % Disattivazione del logging
        m.discardlogs; % Cancellazione dei log

        samples.user(user).acquisition(n).acc = a; % Salvataggio nella struct

        while true
            scelta_a = input("Premere 0 per uscire dalla raccolta.\nPremi 1 per una nuova acquisizione.\n");
            if scelta_a == 0, disp("CHIUSURA");
                return;
            else
                if scelta_a ~= 1, fprintf("Codice non trovato.\n");
                else, break;
                end
            end
        end
    end
end

filename = "acc.mat";
save(filename, 'a');
fprintf("Dati salvati su %s\n", filename);
n = n + 1;
% end
