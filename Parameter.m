%% Rotor Geometry and Material Properties

%[SHAFT] properties
rs = 0.012/2;           % Shaft radius, m 
L_a  = 0.06;            % Distance first housing to motor coupling, m
L_b  = 0.11;            % Distance between both housing, m
L_total = 1.165;        % Total overhung length, m
L_o1 = 0.7868;          % 1st Bushing position, m
L_o2 = 0.3332;          % 2nd Bushing position, m
L_o3 = L_total-L_o1-L_o2;% The remaining of overhung Length, m

E  = 191.599e9;         % Modulus young, Pa
rho= 7850;              % shaft density, kg/m^3

A  = pi*rs^2;           % Shaft Cross-area, m^2
I  = pi/4*rs^4;         % Polar Inertia, m^4
ms = L_total*pi*rs^2*rho; % Shaft mass (overhung part), kg


%[DISK] properties
vd = 0.006;             % Disk Thickness, m
rd = 0.1629/2;          % Radius Disk, m
md = 0.3948;            % Disk Mass, kg
Jd = 0.5*md*rd^2;       % Disk mass inertia, kgm^2

%[UNBALANCE] properties
mu = 0.01;             % Unbalance Mass, kg
e  = 0.1;           % Location of unbalance mass, m
U = mu*e;               % Unbalance, kgm
Ju = mu*e^2;            % Inertia Unbalance, kgm^2
meff = 3/1.875^4*ms+md+mu; % Effective mass, kg


%[ADDITIONAL] properties
% Support Stiffness
ksx = 1e10;             % Support stiffness in x axis, N/m
ksy = ksx;              % Support stiffness in y axis, N/m

% Contact Parameters
kb1 = 2.25e5;           % 1st Bushing Stiffness, N/m
kb2 = kb1;              % 2nd Bushing Stiffness, N/m
kM = 1e0;               % multipier
tM = 0.001;             % thickness limit

cb1 = 5e2;              % 1st Bushing damping coefficient, Ns/m
cb2 = cb1;              % 2nd Bushing damping coefficient, Ns/m
c1 = 0.001;             % clearance Bushing 1
c2 = 0.01;             % clearance Bushing 2

mu_f = 0.3;             % Friction coefficient

% Rotor-Stator Misalignment
mis_x1 = 0.00;          % Offset of 1st bushing on x axis, m
mis_y1 = 0.00;          % Offset of 1st bushing on y axis, m
mis_x2 = 0.00;          % Offset of 2nd bushing on x axis, m
mis_y2 = 0.00;          % Offset of 2nd bushing on y axis, m

% Structural Damping Coefficient - AM + BK = C
alpha_d = 0.2974;       % Coefficient Alpha (Multiplier of Mass Matrix)
beta_d  = 0.0003;       % Coefficient Beta (Multiplier of Stiffness Matrix)

%% Element distribution

na = 3;                 % Number of elements for La
nb = 3;                 % Number of elements for Lb
n1 = 16;                % Number of elements for L_o1
n2 = 7;                 % Number of elements for L_o2
no = 2;                 % Number of elements for L_o3
nt = na+nb+no+n1+n2;    % Total Elements
n_q = 4*(nt+1);             % Number of DOF

La = L_a/na;            % element length for La
Lb = L_b/nb;            % element length for Lb
L1 = L_o1/n1;           % element length for L_o1
L2 = L_o2/n2;           % element length for L_o2
Lo = L_o3/no;           % element length for L_o3

%% Simulation Time Parameters and Measurement 

h_step = 1e-4;          % Sampling Period / Step time, s
RPM_fin = 2000;         % Final speed, RPM
te = 50;                % Total simulation time, s
t = 0:h_step:te;        % Time matrix variable, s   
t_fin   = 0;            % Time at which RPM_fin is reached, s
t_start = 0;            % Time at which steady-state condition is being considered, s
n = 2;                  % Measurement position
q0 = zeros(n_q*3, 1);   % Initial Conditions [Disp;Velo;Acce]'


%Newmark Integration Coefficient
gam = 0.5;              
bet = 0.25;

%% INDEXING

% DOF Indexing for Bushings and Tip
NB1 = 1+na+nb+n1;       % Node of 1st Bushing  
NB2 = 1+na+nb+n1+n2;    % Node of 2nd Bushing
NN = 1+na+nb+n;         % Node of measurement point

dof_y1 = 2*NB1 - 1; dof_x1 = n_q/2 + 2*NB1 - 1;
dof_y2 = 2*NB2 - 1; dof_x2 = n_q/2 + 2*NB2 - 1;
dof_ytip = n_q/2 - 1; dof_xtip = n_q - 1;
dof_yn = 2*NN - 1; dof_xn = n_q/2 + 2*NN - 1;

