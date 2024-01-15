%Connessione allo smartphone
close all; clear m;
l = true; % Mantiene il programma attivo finche' non viene scelto di uscire dal menu
while (l)
    close all;
    pause(1); % Pausa aggiunta per stile
    fprintf("SCEGLIERE OPERAZIONE\n")
    fprintf("1 - Nuovo Utente\n") % Forse togliere?
    fprintf("2 - Avvio\n") % Avvia la raccolta
    fprintf("3 - Processa e Visualizza\n") % Esegue i restanti script
    fprintf("0 - Esci\n"); % Interrompe l'esecuzione del programma
    fprintf("----------------\n");
    scelta = input(""); % Selezione del menu
    % disp(scelta);

    switch (scelta)
        case 1 % Nuovo Utente
            fprintf("NON IMPLEMENTATO\n");
        case 2 % Avvio
            disp('Aprire MATLAB Mobile sul dispositivo e premere un tasto');
            pause; % Attesa del tasto
            m = mobiledev;
            fprintf("Dispositivo %s connesso con successo.\n", m.Device)
            % Attivazione sensori
            m.AccelerationSensorEnabled = 1;
            pause(0.5);
            sampling_frequency = 100; % Hz
            m.SampleRate = sampling_frequency;
            disp('Premi un tasto per avviare il logging...');
            pause; % Attesa del tasto
            disp('Logging avviato.');

            m.Logging = 1;

            disp('Press un tasto per fermare il logging...');
            pause; % Attesa del tasto
            disp('Logging fermato.');

            [a, t] = accellog(m);
            m.Logging = 0; % Disattivazione del logging
            m.discardlogs; % Cancellazione dei log

            % Salvataggio dei dati in un file mat
            save('acc.mat', 'a');
            disp(['Dati salvati su ', 'acc.mat.']);
        case 3
            % VERIFICARE CHIUSURA FIGURE CORRETTA
            pause(1);
            DataProcessing;
            pause(1);
            VisualizeSTD;

        case 0 % Esci
            % VERIFICARE PERCHé RIAPRE IL PROGRAMMA DOPO CASE 3
            fprintf("CHIUSURA PROGRAMMA\n");
            l = false; % Interrompe il ciclo
        otherwise, fprintf("Menu non trovato\n"); % L'utente torna al menu
    end
end