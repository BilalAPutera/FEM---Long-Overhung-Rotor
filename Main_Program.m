%       Clean up before running the program
close all
clear
clc

%%      Load the model (inputting parameter and building the matrix)

Parameter
Matrix_Prep

%%      Run the simulation

Run_up

%%      Saving the data

% Saving options
Tr  = 10;               % Time record from end, s
dec = 1;                % Sampling of the simulation, integer

%%

idx_ss = t >= (t(end)-Tr);

% Steady-state response
t_s = t(idx_ss);
q_nb_s = q_nb(:,idx_ss);        
FB1_s = FB1(idx_ss);
FB2_s = FB2(idx_ss);

% Sampled Steady-state response
q_nb_ss = q_nb_s(:,1:dec:end);  
FB1_ss  = FB1_s(1:dec:end);
FB2_ss  = FB2_s(1:dec:end);
t_ss    = t_s(1:dec:end);

%% Save results

filename = sprintf('NoBushing_RPM_%g.mat',RPM_fin);

save(filename,...
        't_ss',...
        'q_nb_ss',...
        'FB1_ss',...
        'FB2_ss');
    
fprintf('Saved %s\n',filename);

disp('Simulations completed.')