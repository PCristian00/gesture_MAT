% Permette di scegliere un'acquisizione salvata sul file e di studiarne il segnale mediante grafici.
% Il segnale viene mostrato sia al suo stato naturale che in uno stato
% segmentato approssimativamente in periodi di quiete e movimento. Inoltre,
% se il segnale è abbastanza leggibile, vengono raccolti gli 8 punti
% fondamentali per la segmentazione e salvati sul .csv.

clearvars;
close all;
% Nomi dei file da leggere
filename = "samples.mat";
metafilename = "metadata.csv";
th = [0.8, 0.45, 0.3, 0.25]; % Valori di threshold per ogni sensore
% (in ordine acc, mag, orientation, ang_vel)
desc.acc = {'X', 'Y', 'Z', 'Accelerazione (m/s^2)', 'Accelerazione'};
desc.mag = {'X', 'Y', 'Z', 'Campo magnetico (uT)', 'Campo Magnetico'};
desc.orientation = {'Azimut', 'Beccheggio', 'Rollio', 'Orientamento (deg)', 'Orientamento'};
desc.ang_vel = {'X', 'Y', 'Z', 'Velocità angolare (rad/s)', 'Velocità angolare'};

% Caricamento del file
if (isfile(filename))
    load(filename)
else
    fprintf("File %s non trovato.\n", filename)
    return
end

if (~isfile(metafilename))
    fprintf("File %s non trovato.\n", metafilename)
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

% Carica l'array contenente i contatori delle acquisizioni
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

% Carica i metadati in una tabella

opts = detectImportOptions(metafilename);
M = readtable(metafilename, opts);

for i = 1:size(M)
    % Prende ogni riga della tabella singolarmente e la analizza
    r = M(i, :);
    % Confronta gli ID nei metadati con le scelte dell'utente per trovare
    % il campo Available_Sensors
    if r.ID_Subject == user && r.Idx_Acquisition == scelta_a
        scelta_s = r.Available_Sensors;
        % Salva l'indice della riga
        row = i;
        break
    end
end

%% Salvataggio dei punti dei gesti
% Per il salvataggio dei punti dei gesti lo script utilizza esclusivamente
% il segnale dell'accelerometro
acc = samples.user(user).acquisition(scelta_a).acc;
% Raccoglie i punti di interesse dei 4 gesti (se ultimo campo == true
% visualizza anche i grafici)
gest = sigPlot(acc, desc.acc, th(1), false);

% Se la segmentazione fallisce con la soglia scelta dall'utente, il
% programma esegue vari tentativi finché non si trovano gli 8 punti
% necessari
thn = 0.4;
new_th = false;
while (size(gest, 2) ~= 8)
    gest = sigPlot(acc, desc.acc, thn, false);
    if (size(gest, 2) ~= 8 && thn < th(1))
        thn = thn + 0.05;
    else
        gest = sigPlot(acc, desc.acc, thn, true);
        % Indica che è stato usato un treshold diverso da quello
        % inizialmente previsto (permette di evitare che vengano
        % visualizzate doppie finestre per lo stesso segnale di
        % accelerazione)
        new_th = true;
        fprintf("Segmentazione OK con th = "+thn+"\n");
        break;
    end
end


if (size(gest, 2) ~= 8)
    fprintf("Utente %d Acquisizione %d : Segmentazione automatica fallita.\n", user, scelta_a);
else
    % Riempie i campi start e end di tutti i gesti sulla riga del csv
    j = 1;
    for i = 6:16
        if (i ~= 8 && i ~= 11 && i ~= 14)
            r.(i) = gest(j);
            j = j + 1;
        end
    end

    % Aggiorna la riga modificata nel file .csv
    M(row, :) = r;
    writetable(M, metafilename);
end

%% Scelta del sensore automatica
% Avviene in automatico in base ai metadati (campo Available_Sensors)
switch (scelta_s)
    case 1
        % Accelerazione
        if (new_th == false)
            acc = samples.user(user).acquisition(scelta_a).acc;
            sigPlot(acc, desc.acc, th(1), true);
        end

    case 2
        % Campo magnetico
        mag = samples.user(user).acquisition(scelta_a).mag;
        sigPlot(mag, desc.mag, th(2), true);

    case 3
        % Orientamento
        orientation = samples.user(user).acquisition(scelta_a).orientation;
        sigPlot(orientation, desc.orientation, th(3), true);

    case 4
        % Velocità angolare
        ang_vel = samples.user(user).acquisition(scelta_a).ang_vel;
        sigPlot(ang_vel, desc.ang_vel, th(4), true);

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
                    if (new_th == false)
                        sigPlot(acc, desc.acc, th(1), true);
                    end
                    break
                case 2
                    % Campo magnetico
                    mag = samples.user(user).acquisition(scelta_a).mag;
                    sigPlot(mag, desc.mag, th(2), true);
                    break
                case 3
                    % Orientamento
                    orientation = samples.user(user).acquisition(scelta_a).orientation;
                    sigPlot(orientation, desc.orientation, th(3), true);
                    break
                case 4
                    % Velocità angolare
                    ang_vel = samples.user(user).acquisition(scelta_a).ang_vel;
                    sigPlot(ang_vel, desc.ang_vel, th(4), true);
                    break
                case 5
                    % Tutti i sensori
                    % Vengono mostrati i grafici per ogni sensore.
                    % Per passare al prossimo sensore va premuto un tasto
                    % qualsiasi.
                    acc = samples.user(user).acquisition(scelta_a).acc;
                    if (new_th == true)
                        sigPlot(acc, desc.acc, thn, true);
                    else
                        sigPlot(acc, desc.acc, th(1), true);
                    end
                    disp("Accelerazione")
                    disp("Premi un tasto qualsiasi per il prossimo sensore.")
                    pause();

                    mag = samples.user(user).acquisition(scelta_a).mag;
                    sigPlot(mag, desc.mag, th(2), true);
                    disp("Campo magnetico")
                    disp("Premi un tasto qualsiasi per il prossimo sensore.")
                    pause();

                    orientation = samples.user(user).acquisition(scelta_a).orientation;
                    sigPlot(orientation, desc.orientation, th(3), true);
                    disp("Orientamento")
                    disp("Premi un tasto qualsiasi per il prossimo sensore.")
                    pause();

                    ang_vel = samples.user(user).acquisition(scelta_a).ang_vel;
                    sigPlot(ang_vel, desc.ang_vel, th(4), true);
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

% sigPlot permette di mostrare il segnale desiderato sia al suo stato
% naturale che in uno stato segmentato approssimativamente in periodi di
% quiete e movimento.
% La soglia (threshold) e le didascalie sono passate come argomento in modo
% da rendere la funzione versatile.
function gest = sigPlot(s, desc, th, view)

xl = desc{1};
yl = desc{2};
zl = desc{3};
ylab = desc{4};
name = desc{5} + " (th = " + th + ")";

% Se il campione supera i 20 secondi viene ritagliato
if (size(s, 1) > 2000)
    s = s(1:2000, :);
end

%% Plot del segnale originale
% I grafici vengono mostrati solo se sigPlot ha view==true come argomento
if (view)
    figure("Name", name);
    plot(s);
    legend(xl, yl, zl);
    xlabel('Campioni');
    ylabel(ylab);
end

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

%% Plot del segnale con segmentazione
% I grafici vengono mostrati solo se sigPlot ha view==true come argomento
if (view)
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
end

%% Segmentazione gesti
% Vengono selezionati solo i probabili punti di interesse
mov_diff = filterData(movement_indices);
still_diff = filterData(stillness_indices);

% Array con indici di inizio e fine gesti
a = 1;

% Inizializza gest ad array vuoto di interi
% Gest conterrà gli 8 punti di interesse (inizio e partenza di ognuno dei 4
% gesti)
gest = double.empty;

% Per ogni probabile punto di interesse di movimento
for i = 1:(size(mov_diff, 2))
    % Viene fatto il confronto con tutti i punti di quiete
    for j = 1:(size(still_diff, 2))
        if still_diff(j) > mov_diff(i)
            if (a == 1)
                % Salva il primo punto di movimento
                gest(a) = mov_diff(i);
                a = a + 1;
            end
            % Se il punto di quiete attuale è superiore a quello di
            % movimento analizzato, il punto viene confrontato con tutti
            % i punti di movimento successivi
            for k = i:(size(mov_diff, 2))
                if mov_diff(k) > still_diff(j)
                    if (mov_diff(k) - 1 - still_diff(j) > 100)
                        % Rimozione dei falsi positivi
                        % Se il punto di movimento è maggiore di quello di
                        % quiete e c'è una differenza abbastanza grande tra
                        % i due punti, vengono salvati entrambi
                        gest(a) = still_diff(j) - 1;
                        a = a + 1;
                        gest(a) = mov_diff(k);
                        a = a + 1;
                        break;
                    else
                        if k == size(mov_diff, 2)
                            % Salvataggio dell'ultimo punto
                            gest(a) = still_diff(j+1) - 1;
                        end
                    end
                    break
                end
            end
            break
        end
    end
end

% Rimuove i campi di gest inferiori di 200 (falsi positivi della pausa
% iniziale di due secondi)
gest = gest(gest > 200);
end

% Ricerca e filtraggio delle differenze maggiori di 1 tra gli indici
% raccolti per evidenziare i probabili punti di interesse
function diff = filterData(data)
diff = double.empty;
a = 2;
diff(1) = data(1);
for i = 1:(size(data) - 1)
    if (data(i+1) ~= data(i) + 1)
        diff(a) = data(i+1);
        a = a + 1;
    end
end
end