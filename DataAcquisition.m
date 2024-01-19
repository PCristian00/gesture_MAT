%% Avvio acquisizione
clear m;
clearvars;
% n = 1; % Rimuovere (DA RICAVARE DALLA STRUCT!)
% acc = 0;

save_index = zeros(1, 4); % Contatore acquisizioni, salvare su file!!!
disp(save_index)

%% FUNZIONAVA MA METTE IL CAMPO ACC = 0 come prima acquisizione che non viene sovrascritto
% acquisition = struct('acc', {0});
% samples = struct();
% 
% for i = 1:4
%     samples.user(i).acquisition = acquisition;
%     %
%     %     % samples.user(user).acquisition(n).acc = a;
% end

%% RISOLVERE (1 INDICE PER OGNI UTENTE? RACCOGLIERE ULTIMO INDICE PER OGNI UTENTE?)



%% save_index VA SALVATO SU UN FILE E CARICATO AD OGNI ESECUZIONE
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
                break;
            end
        end

        gesture = gestures(user, :);
        gesture = gesture(randperm(length(gesture))); % Randomizzazione ordine gesti
        % disp("Riga randomizzata")
        disp(gesture)

        disp("Acquisizioni")
        disp(save_index)

        % for i = 1:numel(fieldnames(samples.user(user).acquisition))
        %     disp("a");
        % end

        %% PARTE CHE NON FUNZIONA
        % acq=samples.user(user);
        % disp(samples.user(user));
        % n = numel(fieldnames(samples.user(user).acquisition));
        % numel(fieldnames(Structure))
        % disp(n);
        % disp(samples.user(use))

        while (true)
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

                    if time <= 20, time_out = false;
                        time_left = 20 - time;
                        fprintf("Rimanere fermo per %.1f secondi.\n", time_left);
                        % TOLTO PER TEST RAPIDI, RIMETTERE PAUSA
                        % pause(time_left)
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
                    break

                otherwise, disp("Valore non trovato");
            end
        end

        [a, t] = accellog(m);
        m.Logging = 0; % Disattivazione del logging
        m.discardlogs; % Cancellazione dei log

        save_index(user) = save_index(user) + 1;
            samples.user(user).acquisition(save_index(user)).acc = a; % Salvataggio nella struct


        % if (save_index(user) <= 1)
        %     disp("n min o uguale a 1")
        % 
        %     % n = n + 1;
        % else
        %     disp("n maggiore di 1")
        %     save_index(user) = save_index(user) + 1;
        %     samples.user(user).acquisition(save_index(user)).acc = a; % Salvataggio nella struct
        % end

        filename = "acc.mat";
        save(filename, 'a'); % Dovrebbe salvare samples, modificare in seguito
        fprintf("Dati salvati su %s\n", filename);

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