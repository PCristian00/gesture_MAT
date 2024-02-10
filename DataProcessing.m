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
desc.acc = {'X', 'Y', 'Z', 'Accelerazione (m/s^2)', 'Accelerazione'};
desc.mag = {'X', 'Y', 'Z', 'Campo magnetico (uT)', 'Campo Magnetico'};
desc.orientation = {'Azimut', 'Beccheggio', 'Rollio', 'Orientamento (deg)', 'Orientamento'};
desc.ang_vel = {'X', 'Y', 'Z', 'Velocità angolare (rad/s)', 'Velocità angolare'};
% disp(desc)
% save("test.mat","desc")


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
% METTERE A FALSE ULTIMO CAMPO PER NON VISUALIZZARE
gest = sigPlot(acc, desc.acc, th(1), true);
% disp(size(gest))
if (size(gest, 2) ~= 8)
    disp("Segmentazione fallita.")
    return
end

% Riempie i campi start e end di tutti i gesti sulla riga del csv
j = 1;
for i = 6:16
    if (i ~= 8 && i ~= 11 && i ~= 14)
        r.(i) = gest(j);
        j = j + 1;
    end
end

% disp(r);

M(row, :) = r;
writetable(M, metafilename);

%% Scelta del sensore automatica
% Avviene in automatico in base ai metadati (campo Available_Sensors)
switch (scelta_s)
    case 1
        % Accelerazione
        acc = samples.user(user).acquisition(scelta_a).acc;
        sigPlot(acc, desc.acc, th(1), true);

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
                    sigPlot(acc, desc.acc, th(1), true);
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
                    sigPlot(acc, desc.acc, th(1), true);
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
name = desc{5};

% Se il campione supera i 20 secondi viene ritagliato
if (size(s, 1) > 2000)
    s = s(1:2000, :);
end

%% Plot del segnale originale
% fprintf("View = "+view+"\n");
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
% whos

%% Plot del segnale con segmentazione
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
mov_diff = filterData(movement_indices);
still_diff = filterData(stillness_indices);

% Array con indici di inizio e fine gesti
a = 1;

% Inizializza gest ad array vuoto di interi
gest = double.empty;

for i = 1:(size(mov_diff, 2))
    for j = 1:(size(still_diff, 2))
        if still_diff(j) > mov_diff(i)
            if (a == 1)
                gest(a) = mov_diff(i);
                a = a + 1;
            end
            for k = i:(size(mov_diff, 2))
                if mov_diff(k) > still_diff(j)
                    if (mov_diff(k) - 1 - still_diff(j) > 100)
                        gest(a) = still_diff(j) - 1;
                        a = a + 1;
                        gest(a) = mov_diff(k);
                        a = a + 1;
                        break;
                    else
                        if k == size(mov_diff, 2)
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