% GestureMain Permette di avviare tramite un menu testuale le operazioni contenute in DataAcquisition e DataProcessing.

close all; clear m;

while true % Mantiene il programma attivo finche' non viene scelto di uscire dal menu
    scelta = input("\nSCEGLIERE OPERAZIONE\n"+ ...
        "1 - Avvio\n"+ ...
        "2 - Processa e Visualizza\n"+ ...
        "0 - Esci\n"+ ...
        "----------------\n"); % Selezione del menu
    close all;

    switch (scelta)

        case 1

            %% Acquisizione dati
            DataAcquisition;

        case 2

            %% Processing e Visualizzazione
            DataProcessing;

        case 0

            %% Uscita
            fprintf("Chiusura programma.\n");
            break; % Interrompe il ciclo

        otherwise, fprintf("Indice non trovato.\n"); % L'utente torna al menu
    end
end