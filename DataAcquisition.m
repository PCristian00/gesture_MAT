close all; clear m;
l = true; % Mantiene il programma attivo finche' non viene scelto di uscire dal menu
while (l)
    pause(1); % Pausa aggiunta per stile

    fprintf("\nSCEGLIERE OPERAZIONE\n")
    fprintf("1 - Nuovo Utente\n") % Forse togliere?
    fprintf("2 - Avvio\n") % Avvia la raccolta
    fprintf("3 - Processa e Visualizza\n") % Esegue i restanti script
    fprintf("0 - Esci\n"); % Interrompe l'esecuzione del programma
    fprintf("----------------\n");

    scelta = input(""); % Selezione del menu
    close all;
    % disp(scelta);

    switch (scelta)

        %% Implementare?
        case 1 % Nuovo Utente
            fprintf("NON IMPLEMENTATO\n");

        case 2 % Avvio
            clear m;
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
            time_out = true;

            pic = imread("gestures.png");
            imshow(pic);
            while time_out
                disp('Premi un tasto per avviare il logging...');
                pause; % Attesa del tasto
                disp('Logging avviato.');

                m.Logging = 1;

                tic; % Avvio timer

                gesti = ["S", "AS", "Z", "AZ"]; % Set di gesti
                % disp(gesti)

                gesti = gesti(randperm(length(gesti))); % Randomizzazione ordine gesti
                % disp(gesti)

                for i = 1:4 % Raccolta dei 4 gesti
                    fprintf("Eseguire gesto %d:\t %s\n", i, gesti(i));
                    % disp(gesti(i))
                    disp('Premi un tasto quando tornato in posizione di partenza.');
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
            end

            [a, t] = accellog(m);
            m.Logging = 0; % Disattivazione del logging
            m.discardlogs; % Cancellazione dei log

            %% Scoprire come concatenare più log e se sia necessario

            % Salvataggio dei dati in un file mat
            save('acc.mat', 'a');
            disp(['Dati salvati su ', 'acc.mat.']);

        case 3 % Processa e Visualizza
            DataProcessing;
            VisualizeSTD;

        case 0 % Esci
            fprintf("CHIUSURA PROGRAMMA\n");
            l = false; % Interrompe il ciclo

        otherwise, fprintf("Indice non trovato.\n"); % L'utente torna al menu
    end
end