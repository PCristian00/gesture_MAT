% Permette di scegliere un'acquisizione salvata sul file e di studiarne il segnale mediante grafici.
% Il segnale viene mostrato sia al suo stato naturale che in uno stato
% segmentato approssimativamente in periodi di quiete e movimento.

clearvars;
close all;
% Nomi dei file da leggere
filename = "samples.mat";
metafilename = "metadata.csv";
th = [0.6, 0.45, 0.3, 0.25]; % Valori di threshold per ogni sensore
% (in ordine acc, mag, orientation, ang_vel)

% Caricamento del file
if (isfile(filename))
    load(filename)
else
    disp("File non trovato.")
    return
end

%% Menu
% Scelta utente
while true
    user = input("Inserire ID utente (1-4):\n");
    if user < 1 || user > 4
        disp("Indice non trovato.")
    else
        break;
    end
end

n = save_index(user);

% Scelta dell'acquisizione da mostrare
if (n == 1), scelta_a = 1;
else
    if n == 0, fprintf("Nessuna acquisizione per l'utente %d.\n", user)
        return
    else
        while true
            fprintf("Ci sono %d acquisizioni per l'utente %d.\n"+ ...
                "Inserire ID acquisizione (1-%d):\n", n, user, n);
            scelta_a = input("");
            if (scelta_a > 0 && scelta_a <= n)
                break
            else, disp("Indice non trovato");
            end
        end
    end
end

% Carica i metadati in una matrice
M = readmatrix(metafilename);
for i = 1:size(M)
    % Prende ogni riga della matrice singolarmente e la analizza
    r = M(i, :);
    % Confronta gli ID nei metadati con le scelte dell'utente per trovare
    % il campo Available_Sensors (5)
    if r(1) == user && r(2) == scelta_a
        scelta_s = r(5);
        break
    end
end

% SIGPLOT per gesti va sempre fatto su acc
% Riaggiungere successivamente in modo migliore queste due righe
% FORSE SEPARARE SIGPLOT e raccolta / studio delle diff

% acc = samples.user(user).acquisition(scelta_a).acc;
% sigPlot(acc, 'X', 'Y', 'Z', 'Accelerazione (m/s^2)', 'Accelerazione', th(1));

%% Scelta del sensore automatica
% Avviene in automatico in base ai metadati (campo Available_Sensors)
switch (scelta_s)
    case 1
        % Accelerazione
        acc = samples.user(user).acquisition(scelta_a).acc;
        sigPlot(acc, 'X', 'Y', 'Z', 'Accelerazione (m/s^2)', 'Accelerazione', th(1));

    case 2
        % Campo magnetico
        mag = samples.user(user).acquisition(scelta_a).mag;
        sigPlot(mag, 'X', 'Y', 'Z', 'Campo magnetico (uT)', 'Campo Magnetico', th(2));

    case 3
        % Orientamento
        orientation = samples.user(user).acquisition(scelta_a).orientation;
        sigPlot(orientation, 'Azimut', 'Beccheggio', 'Rollio', 'Orientamento (deg)', 'Orientamento', th(3));

    case 4
        % Velocità angolare
        ang_vel = samples.user(user).acquisition(scelta_a).ang_vel;
        sigPlot(ang_vel, 'X', 'Y', 'Z', 'Velocità angolare (rad/s)', 'Velocità angolare', th(4));

    case 5
        % Tutti i sensori
        % Se l'acquisizione contiene tutti i sensori, si apre un sottomenu
        % che permette di scegliere quali visualizzare

        %% Scelta del sensore (acquisizioni multiple)
        while true
            scelta_s = input("Scegliere sensori da visualizzare:\n"+ ...
                "1 - Accelerometro\n"+ ...
                "2 - Magnetometro\n"+ ...
                "3 - Orientamento\n"+ ...
                "4 - Giroscopio (Velocità angolare)\n"+ ...
                "5 - Tutti\n");
            switch (scelta_s)
                case 1
                    % Accelerazione
                    acc = samples.user(user).acquisition(scelta_a).acc;
                    sigPlot(acc, 'X', 'Y', 'Z', 'Accelerazione (m/s^2)', 'Accelerazione', th(1));
                    break
                case 2
                    % Campo magnetico
                    mag = samples.user(user).acquisition(scelta_a).mag;
                    sigPlot(mag, 'X', 'Y', 'Z', 'Campo magnetico (uT)', 'Campo Magnetico', th(2));
                    break
                case 3
                    % Orientamento
                    orientation = samples.user(user).acquisition(scelta_a).orientation;
                    sigPlot(orientation, 'Azimut', 'Beccheggio', 'Rollio', 'Orientamento (deg)', 'Orientamento', th(3));
                    break
                case 4
                    % Velocità angolare
                    ang_vel = samples.user(user).acquisition(scelta_a).ang_vel;
                    sigPlot(ang_vel, 'X', 'Y', 'Z', 'Velocità angolare (rad/s)', 'Velocità angolare', th(4));
                    break
                case 5
                    % Tutti i sensori
                    % Vengono mostrati i grafici per ogni sensore.
                    % Per passare al prossimo sensore va premuto un tasto
                    % qualsiasi.
                    acc = samples.user(user).acquisition(scelta_a).acc;
                    sigPlot(acc, 'X', 'Y', 'Z', 'Accelerazione (m/s^2)', 'Accelerazione', th(1));
                    disp("Accelerazione")
                    disp("Premi un tasto qualsiasi per il prossimo sensore.")
                    pause();

                    mag = samples.user(user).acquisition(scelta_a).mag;
                    sigPlot(mag, 'X', 'Y', 'Z', 'Campo magnetico (uT)', 'Campo Magnetico', th(2));
                    disp("Campo magnetico")
                    disp("Premi un tasto qualsiasi per il prossimo sensore.")
                    pause();

                    orientation = samples.user(user).acquisition(scelta_a).orientation;
                    sigPlot(orientation, 'Azimut', 'Beccheggio', 'Rollio', 'Orientamento (deg)', 'Orientamento', th(3));
                    disp("Orientamento")
                    disp("Premi un tasto qualsiasi per il prossimo sensore.")
                    pause();

                    ang_vel = samples.user(user).acquisition(scelta_a).ang_vel;
                    sigPlot(ang_vel, 'X', 'Y', 'Z', 'Velocità angolare (rad/s)', 'Velocità angolare', th(4));
                    disp("Giroscopio (Velocità Angolare)")
                    disp("Premi un tasto qualsiasi per terminare la visualizzazione.")
                    pause();
                    disp("Fine visualizzazione.");
                    close all; % Chiude tutte le schede aperte
                    break

                otherwise, disp("Indice non trovato.");
            end
        end
    otherwise, disp("Indice non trovato.");
end
%RIMUOVERE
disp("FINE")
load('movementAccelerazione_.mat')

% sigPlot permette di mostrare il segnale desiderato sia al suo stato
% naturale che in uno stato segmentato approssimativamente in periodi di
% quiete e movimento.
% La soglia (threshold) e le didascalie sono passate come argomento in modo
% da rendere la funzione versatile.
function sigPlot(s, xl, yl, zl, ylab, name, th)

% Se il campione supera i 20 secondi viene ritagliato
if (size(s, 1) > 2000)
    s = s(1:2000, :);
end

%% Plot del segnale originale
figure("Name", name);
plot(s);
legend(xl, yl, zl);
xlabel('Campioni');
ylabel(ylab);

%% Processing
% Calcolo della grandezza (magnitude) del segnale e trasformazione in
% segnale a media zero (zero-mean signal)
x = s(:, 1);
y = s(:, 2);
z = s(:, 3);
s = sqrt(sum(x.^2+y.^2+z.^2, 2));
s = s - mean(s);

window_size = 20; % Imposta la dimensione della finestra
% Calcolo della deviazione di movimento standard (Moving Standard
% Deviation) per studiare le variazioni del segnale
movestd_signal = movstd(s, window_size);

% Definizione soglia per movimento e quiete
threshold = th;

% Identifica quiete e movimento in base alla soglia
stillness_indices = find(movestd_signal <= threshold);
movement_indices = find(movestd_signal > threshold);
% whos

%% Plot del segnale con segmentazione
figure("Name", name);
plot(s);

% Evidenzia quiete in blu
hold on;
scatter(stillness_indices, s(stillness_indices), 'b', 'filled');

% Evidenzia movimento in rosso
scatter(movement_indices, s(movement_indices), 'r', 'filled');

title('Segmentazione approssimata di Quiete e Movimento usando Movestd');
xlabel('Campioni');
ylabel(ylab);

legend(name, 'Quiete', 'Movimento');

% CAMBIARE NOME FILE
filename = "movement" + name + "_.mat";

% CALCOLO DEI DIFF : OK
% PROVARE METODO CON CONFRONTO INCROCIATO
% USARE 150 come distanza tra rossi e blu
a = 2;
mov_diff(1) = movement_indices(1);

% Ricerca e filtraggio delle differenze maggiori di 1
for i = 1:(size(movement_indices) - 1)
    if (movement_indices(i+1) ~= movement_indices(i) + 1)
        mov_diff(a) = movement_indices(i+1);
        a = a + 1;
    end
end

a = 2;
still_diff(1) = stillness_indices(1);

% Ricerca e filtraggio delle differenze maggiori di 1
for i = 1:(size(stillness_indices) - 1)
    if (stillness_indices(i+1) ~= stillness_indices(i) + 1)
        still_diff(a) = stillness_indices(i+1);
        a = a + 1;
    end
end

%% PARTE CRITICA
% Array con indici di inizio e fine gesti
a = 1;

% DA  MIGLIORARE
% gest(1)=mov_diff(1,1);

% Inizializza gest ad array vuoto di interi
%gest=double.empty;
% disp("QUO");
for i = 1:(size(mov_diff, 2))
    % disp("QUI!");
    for j = 1:(size(still_diff, 2))
        % disp("QUE")
        if ((still_diff(j)-mov_diff(i))>20)
           % fprintf("fase 1: BLU > ROSSO\n")
           fprintf(still_diff(j)+">"+mov_diff(i)+"\n")
            for k = i:(size(mov_diff, 2))
            %    disp("INIZIO FASE 2")
                if (mov_diff(k) > still_diff(j))
                %    fprintf("fase 2: ROSSO > BLU\n")
                    fprintf(mov_diff(k)+">"+still_diff(j)+"\n")
                  %  disp("INIZIO FASE 3")
                    if (mov_diff(k) - 1 - still_diff(j) > 100)
                        fprintf("Indice "+mov_diff(k)+" Differenza : "+(mov_diff(k) - 1 - still_diff(j))+">100 (SALVATO)\n")
                        gest(a)=still_diff(j)-1;
                        a = a+1;
                        gest(a) = mov_diff(k);
                        a = a + 1;
                        
                        break;
                    else, fprintf("Indice "+mov_diff(k)+" Differenza : "+(mov_diff(k) - 1 - still_diff(j))+"<100\n")
                    end
                    break
                % else, fprintf(mov_diff(k)+"<"+still_diff(j)+"\n")
                end                
            end
            break
        end
    end
end

% DA MIGLIORARE
% gest(8)=still_diff(size(still_diff,2))-1;

    % disp(gest)

    % SCARTO DEI FALSI POSITIVI: PRIMO METODO PROVATO
    % NON FUNZIONANTE AL 100%
    % Per ogni elemento dell'array delle differenze, si confronta il successivo
    % e l'elemento scartato in precedenza per vedere se sia un falso positivo
    % (cambio quiete-movimento in un lasso di tempo inferiore ai 150 punti??)

    % CAPIRE SE RIUTILIZZABILE ANCHE PER STILLNESS
    % q = 0;
    % for i = 1:((size(mov_diff, 2) - 1))
    %     % fprintf("Diff (%d) = %d\n", i, mov_diff(i));
    %     if (mov_diff(i+1) < (mov_diff(i) + 200))
    %         % fprintf("Diff (%d+1) = %d\n", i, mov_diff(i+1));
    %         % fprintf("Minore di diff %d\n", i);
    %         q = mov_diff(i+1);
    %         mov_diff(i+1) = 0;
    %     else if (mov_diff(i+1) < q + 200)
    %             q = mov_diff(i+1);
    %             mov_diff(i+1) = 0;
    %     end
    %     end
    % end
    %
    % % Stillness
    % q=0;
    % for i = 1:((size(still_diff, 2) - 1))
    %     % fprintf("Diff (%d) = %d\n", i, mov_diff(i));
    %     if (still_diff(i+1) < (still_diff(i) + 200))
    %         % fprintf("Diff (%d+1) = %d\n", i, mov_diff(i+1));
    %         % fprintf("Minore di diff %d\n", i);
    %         q = still_diff(i+1);
    %         still_diff(i+1) = 0;
    %     else if (still_diff(i+1) < q + 200)
    %             q = still_diff(i+1);
    %             still_diff(i+1) = 0;
    %     end
    %     end
    % end

    % Rimuove gli elementi uguali a 0 da diff
    mov_diff = mov_diff(mov_diff ~= 0);
    still_diff = still_diff(still_diff ~= 0);

    % mov_diff = filterData(movement_indices, 150);
    %
    % % CAPIRE SE filterData RIUTILIZZABILE (CAMBIARE OFFSET?)
    % still_diff = filterData(stillness_indices, 0);

    % Salvataggio delle diff (AGGIORNARE CSV CON I VALORI OTTENUTI)
    save(filename, "mov_diff", "still_diff", "movement_indices", "stillness_indices", "gest");

end

% % FORSE RIMUOVERE
% function diff = filterData(data, offset)
% a = 2;
% diff(1) = data(1);
% 
% % Ricerca e filtraggio delle differenze maggiori di 1
% for i = 1:(size(data) - 1)
%     if (data(i+1) ~= data(i) + 1)
%         diff(a) = data(i+1);
%         a = a + 1;
%         %end
%     end
% end
% q = 0;
% % Per ogni elemento dell'array delle differenze, si confronta il successivo
% % e l'elemento scartato in precedenza per vedere se sia un falso positivo
% % (cambio quiete-movimento in un lasso di tempo inferiore ai 150 punti??)
% 
% % CAPIRE SE RIUTILIZZABILE ANCHE PER STILLNESS
% for i = 1:((size(diff, 2) - 1))
%     fprintf("Diff (%d) = %d\n", i, diff(i));
%     if (diff(i+1) < (diff(i) + offset))
%         fprintf("Diff (%d+1) = %d\n", i, diff(i+1));
%         fprintf("Minore di diff %d\n", i);
%         q = diff(i+1);
%         diff(i+1) = 0;
%     else if (diff(i+1) < q + offset)
%             q = diff(i+1);
%             diff(i+1) = 0;
%     end
%     end
% end
% % Rimuove gli elementi uguali a 0 da diff
% diff = diff(diff ~= 0);
% end