%Connessione allo smartphone
close all; clear m;
l=true;
while(l)
    fprintf("SCEGLIERE OPERAZIONE\n")
    fprintf("0 - Nuovo Utente\n") % Forse togliere?
    fprintf("1 - Avvio\n")
    fprintf("2 - Esci\n");
    fprintf("----------------\n");
    scelta=input("");
    % disp(scelta);
    
    switch(scelta)
        case 0
            fprintf("NON IMPLEMENTATO\n");
        case 1
            m = mobiledev;
            fprintf("Dispositivo %s connesso con successo.\n",m.Device)
            % Attivazione sensori 
            m.AccelerationSensorEnabled = 1;
            pause(0.5);
            sampling_frequency = 100; % Hz
            m.SampleRate = sampling_frequency;
            disp('Premi un tasto per avviare il logging...');
            pause;  % Attesa del tasto
            disp('Logging avviato.');
            
            m.Logging = 1;
            
            disp('Press un tasto per fermare il logging...');
            pause;  % Attesa del tasto
            disp('Logging fermato.');
            
            [a, t] = accellog(m);
            m.Logging = 0; % Disattivazione del logging
            m.discardlogs; % Cancellazione dei log
            
            % Salvataggio dei dati in un file mat
            save('acc.mat', 'a');
            disp(['Dati salvati su ', 'acc.mat.']);
        case 2
            fprintf("CHIUSURA PROGRAMMA\n");
            l=false;
        otherwise, fprintf("Menu non trovato\n");
    end
end