%Connessione allo smartphone
close all; clear m; m = mobiledev;


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


