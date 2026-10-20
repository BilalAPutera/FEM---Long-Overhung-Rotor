close all
clear
clc
%% Load Parameters and Files

load("NoBushing_RPM_2000.mat")  % Load Parameters
nt = 31;                        % Total number of elements
n_q = 4*(nt+1);                 % Number of DOF

%% for exact node - NN
n = 22;                         % Node of measurement point

dof_yn = 2*n - 1; 
dof_xn = n_q/2 + 2*n - 1;
dof_dyn = dof_yn + n_q; 
dof_dxn = dof_xn + n_q;
dof_ddyn = dof_dyn + n_q; 
dof_ddxn = dof_dxn + n_q;

%% Response Visualization over time

t_Start = 48.9;                   % Time range - start
t_Stop = 49;                    % Time range - end

idx_Start = min(find(t_ss>=t_Start));
idx_Stop = max(find(t_ss<=t_Stop));
idx_Mid = (idx_Start+idx_Stop)/2;
%%

% Res_OVT
% Res_Orbit
% Res_FFT
% Campbell
% Res_OBOVR


