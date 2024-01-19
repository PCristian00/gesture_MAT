close all; clear m;

while true % Mantiene il programma attivo finche' non viene scelto di uscire dal menu
    pause(1); % Pausa aggiunta per stile

    fprintf("\nSCEGLIERE OPERAZIONE\n"+ ...
        "1 - Nuovo Utente\n"+ ...
        "2 - Avvio\n"+ ...
        "3 - Processa e Visualizza\n"+ ...
        "0 - Esci\n"+ ...
        "----------------\n");

    scelta = input(""); % Selezione del menu
    close all;

    switch (scelta)

        case 1

            %% Inserire nuovo utente (da implementare)s
            fprintf("NON IMPLEMENTATO\n");

        case 2

            %% Acquisizione dati
            DataAcquisition;

        case 3

            %% Processing e Visualizzazione
            DataProcessing;
            % VisualizeSTD;

        case 0

            %% Uscita
            fprintf("CHIUSURA PROGRAMMA\n");
            break; % Interrompe il ciclo

        otherwise, fprintf("Indice non trovato.\n"); % L'utente torna al menu
    end
end