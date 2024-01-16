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
            disp('Aprire MATLAB Mobile sul dispositivo e premere un tasto');
            pause; % Attesa del tasto
            disp("Attendere...")
            %Connessione allo smartphone
            m = mobiledev;
            fprintf("Dispositivo %s connesso con successo.\n", m.Device)
            % Attivazione sensori
            m.AccelerationSensorEnabled = 1;
            pause(0.5);
            sampling_frequency = 100; % Hz
            m.SampleRate = sampling_frequency;
            time_out = true;
            while time_out
                disp('Premi un tasto per avviare il logging...');
                pause; % Attesa del tasto
                disp('Logging avviato.');

                m.Logging = 1;

                tic;

                gesti=["S", "AS", "Z", "AZ"];
                disp(gesti)

                gesti=gesti(randperm(length(gesti)));
                disp(gesti)

                for i = 1:4
                    %% Inserire istruzioni gesti e randomizzazione
                    fprintf("Eseguire gesto %d\n", i);
                    disp(gesti(i))
                    disp('Premi un tasto quando tornato in posizione di partenza');
                    pause; % Attesa del tasto
                    disp("Attendere...");
                    time = toc;
                    time_left = 20 - time;
                    fprintf("Massimo %.1f secondi rimanenti.\n", time_left);
                    if time >= 20, break
                    end
                    pause(1);
                end
                time = toc;
                fprintf("Gesti eseguiti in %.1f secondi!\n", time);
                if time < 20
                    time_out = false;
                    time_left = 20 - time;
                    % disp(time_left)
                    fprintf("Rimanere fermo per %.1f secondi\n", time_left);
                    pause(time_left)

                else, fprintf("Tempo di 20 secondi superati. Riavvio raccolta.\n");
                end
            end

            % disp('Premi un tasto per fermare il logging...');
            % pause; % Attesa del tasto
            % disp('Logging fermato.');

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

        otherwise, fprintf("Menu non trovato\n"); % L'utente torna al menu
    end
end