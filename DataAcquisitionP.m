%Connect to the phone
close all; clear m; m = mobiledev;

% Turn on sensors 
m.AccelerationSensorEnabled = 1;

pause(0.5);

sampling_frequency = 100; % Hz ("high" sps according to MATLAB documentation) 
m.SampleRate = sampling_frequency;

disp('Press a key to start logging...');
pause;  % Wait for a key press to start logging
disp('Logging started.');

m.Logging = 1;

disp('Press a key to stop logging...');
pause;  % Wait for a key press to start logging
disp('Logging stopped.');

[a, t] = accellog(m);
m.Logging = 0; %Disable logging
m.discardlogs; % Erase the logs 
% (this is important otherwise if you do a new acquisition you will also
% get all the previous logs)

% Save the data to a mat file

% In this case, we only need acceleration data.
save('acc.mat', 'a');
disp(['Data saved to ', 'acc.mat.']);


