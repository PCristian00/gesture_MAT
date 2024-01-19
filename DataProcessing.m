clearvars;

if (isfile("samples.mat"))
    load("samples.mat")
else
    disp("File non trovato.")
    return
end

while true
            user = input("Inserire utente (1-4):");
            if user < 1 || user > 4
                disp("Indice non trovato.")
            else
                break;
            end
end

n = save_index(user);

while true
fprintf("Ci sono %d acquisizioni per l'utente %d.\n" + ...
    "Inserire un numero da 1 a %d:\n",n,user,n);
scelta_a=input("");
if(scelta_a<n || scelta_a>0)
    break
else, disp("Indice non trovato");
end
end

scelta_s=samples.user(user).acquisition(scelta_a).sensors;

while true
        % scelta_s = input("Scegliere sensori da mostrare:\n"+ ...
           % "1 - Accelerometro\n"+ ...
            %"2 - Magnetometro\n"+ ...
            % "3 - Orientazione\n"+ ...
            % "4 - Velocità angolare\n"+ ...
            % "5 - Tutti\n");
        switch (scelta_s)
            case 1
                acc=samples.user(user).acquisition(scelta_a).acc;
                plot(acc);
                legend('X', 'Y', 'Z');
                xlabel('Campioni');
                ylabel('Accelerazione (m/s^2)');   
                x = acc(:, 1);
                y = acc(:, 2);
                z = acc(:, 3);
                acc = sqrt(sum(x.^2+y.^2+z.^2, 2));
                break
            case 2
                mag=samples.user(user).acquisition(scelta_a).mag;
                plot(mag);
                legend('X', 'Y', 'Z');
                xlabel('Campioni');
                ylabel('Campo magnetico (uT)');   
                x = mag(:, 1);
                y = mag(:, 2);
                z = mag(:, 3);
                mag = sqrt(sum(x.^2+y.^2+z.^2, 2));
                break
            case 3
                orientation=samples.user(user).acquisition(scelta_a).orientation;
                plot(orientation);
                legend('Azimut', 'Beccheggio', 'Rollio');
                xlabel('Campioni');
                ylabel('Orientamento (deg)');   
                x = orientation(:, 1);
                y = orientation(:, 2);
                z = orientation(:, 3);
                mag = sqrt(sum(x.^2+y.^2+z.^2, 2));
                break
            case 4
                ang_vel=samples.user(user).acquisition(scelta_a).ang_vel;
                plot(ang_vel);
                legend('X', 'Y', 'Z');
                xlabel('Campioni');
                ylabel('Velocità angolare (rad/s)');   
                x = ang_vel(:, 1);
                y = ang_vel(:, 2);
                z = ang_vel(:, 3);
                mag = sqrt(sum(x.^2+y.^2+z.^2, 2));
                break
            case 5
                disp("DA CAPIRE")
                break
            otherwise, disp("Indice non trovato.");
        end
end