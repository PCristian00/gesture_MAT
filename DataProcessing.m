% Permette di scegliere un'acquisizione salvata sul file e di studiarne il segnale mediante grafici.
% Il segnale viene mostrato sia al suo stato naturale che in uno stato
% segmentato approssimativamente in periodi di quiete e movimento.

clearvars;
close all;
% Nomi dei file da leggere
filename = "samples.mat";
metafilename = "metadata.csv";
th = [0.8, 0.45, 0.3, 0.25]; % Valori di threshold per ogni sensore
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

% SIGPLOT per gesti va sempre fatto su acc
% Riaggiungere successivamente in modo migliore queste due righe
% FORSE SEPARARE SIGPLOT e raccolta / studio delle diff

acc = samples.user(user).acquisition(scelta_a).acc;
gest = sigPlot(acc, 'X', 'Y', 'Z', 'Accelerazione (m/s^2)', 'Accelerazione', th(1));

% Riempie i campi start e end di tutti i gesti sulla riga del csv
j = 1;
for i = 6:16
    if (i ~= 8 && i ~= 11 && i ~= 14)
        r.(i) = gest(j);
        j = j + 1;
    end
end

disp(r);

M(row, :) = r;
writetable(M, metafilename);

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
load('movementAccelerazione_.mat')

% sigPlot permette di mostrare il segnale desiderato sia al suo stato
% naturale che in uno stato segmentato approssimativamente in periodi di
% quiete e movimento.
% La soglia (threshold) e le didascalie sono passate come argomento in modo
% da rendere la funzione versatile.
function gest = sigPlot(s, xl, yl, zl, ylab, name, th)

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

mov_diff = filterData(movement_indices);
still_diff = filterData(stillness_indices);

% Array con indici di inizio e fine gesti
a = 1;

% Inizializza gest ad array vuoto di interi
gest = double.empty;
% disp("QUO");
for i = 1:(size(mov_diff, 2))
    % disp("QUI!");
    for j = 1:(size(still_diff, 2))
        % disp("QUE")
        if still_diff(j) > mov_diff(i)
            % fprintf("fase 1: BLU > ROSSO\n")
            % fprintf(still_diff(j)+">"+mov_diff(i)+"\n")
            if (a == 1), gest(a) = mov_diff(i);
                a = a + 1;
            end
            for k = i:(size(mov_diff, 2))
                % disp("INIZIO FASE 2")
                if (mov_diff(k) > still_diff(j))
                    %    fprintf("fase 2: ROSSO > BLU\n")
                    % fprintf(mov_diff(k)+">"+still_diff(j)+"\n")
                    %  disp("INIZIO FASE 3")
                    if (mov_diff(k) - 1 - still_diff(j) > 100)
                        %  fprintf("Indice "+mov_diff(k)+" Differenza : "+(mov_diff(k) - 1 - still_diff(j))+">100 (SALVATO)\n")
                        gest(a) = still_diff(j) - 1;
                        a = a + 1;
                        gest(a) = mov_diff(k);
                        a = a + 1;
                        break;
                    else
                        if k == size(mov_diff, 2), gest(a) = still_diff(j+1) - 1;
                            % else, fprintf("Indice "+mov_diff(k)+" Differenza : "+(mov_diff(k) - 1 - still_diff(j))+"<100\n")
                        end
                    end
                    break
                    % else, fprintf(mov_diff(k)+"<"+still_diff(j)+"\n")
                end
            end
            break
        end
    end
end

% Salvataggio delle diff (AGGIORNARE CSV CON I VALORI OTTENUTI)
save(filename, "mov_diff", "still_diff", "movement_indices", "stillness_indices", "gest");
end

% Ricerca e filtraggio delle differenze maggiori di 1
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