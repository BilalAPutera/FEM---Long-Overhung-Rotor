%% Element Matrix Definitions
% Shaft Element - Part A
Ka =(E*I/La^3) * [12 6*La -12 6*La; 6*La 4*La^2 -6*La 2*La^2; -12 -6*La 12 -6*La; 6*La 2*La^2 -6*La 4*La^2];
Ma =(rho*A*La/420) * [156 22*La 54 -13*La; 22*La 4*La^2 13*La -3*La^2; 54 13*La 156 -22*La; -13*La -3*La^2 -22*La 4*La^2];

% Shaft Element - Part B
Kb =(E*I/Lb^3) * [12 6*Lb -12 6*Lb; 6*Lb 4*Lb^2 -6*Lb 2*Lb^2; -12 -6*Lb 12 -6*Lb; 6*Lb 2*Lb^2 -6*Lb 4*Lb^2];
Mb =(rho*A*Lb/420) * [156 22*Lb 54 -13*Lb; 22*Lb 4*Lb^2 13*Lb -3*Lb^2; 54 13*Lb 156 -22*Lb; -13*Lb -3*Lb^2 -22*Lb 4*Lb^2];

% Shaft Element - Part O1
Ko_1 =(E*I/L1^3) * [12 6*L1 -12 6*L1; 6*L1 4*L1^2 -6*L1 2*L1^2; -12 -6*L1 12 -6*L1; 6*L1 2*L1^2 -6*L1 4*L1^2];
Mo_1 =(rho*A*L1/420) * [156 22*L1 54 -13*L1; 22*L1 4*L1^2 13*L1 -3*L1^2; 54 13*L1 156 -22*L1; -13*L1 -3*L1^2 -22*L1 4*L1^2];

% Shaft Element - Part O2
Ko_2 =(E*I/L2^3) * [12 6*L2 -12 6*L2; 6*L2 4*L2^2 -6*L2 2*L2^2; -12 -6*L2 12 -6*L2; 6*L2 2*L2^2 -6*L2 4*L2^2];
Mo_2 =(rho*A*L2/420) * [156 22*L2 54 -13*L2; 22*L2 4*L2^2 13*L2 -3*L2^2; 54 13*L2 156 -22*L2; -13*L2 -3*L2^2 -22*L2 4*L2^2];

% Shaft Element - Part O3
Ko_3 =(E*I/Lo^3) * [12 6*Lo -12 6*Lo; 6*Lo 4*Lo^2 -6*Lo 2*Lo^2; -12 -6*Lo 12 -6*Lo; 6*Lo 2*Lo^2 -6*Lo 4*Lo^2];
Mo_3 =(rho*A*Lo/420) * [156 22*Lo 54 -13*Lo; 22*Lo 4*Lo^2 13*Lo -3*Lo^2; 54 13*Lo 156 -22*Lo; -13*Lo -3*Lo^2 -22*Lo 4*Lo^2];

%% Global Matrix Assembly
M_a=zeros(2*(na+1)); K_a=zeros(2*(na+1)); for da=1:na, a=2*da-1; M_a(a:a+3,a:a+3)=M_a(a:a+3,a:a+3)+Ma; K_a(a:a+3,a:a+3)=K_a(a:a+3,a:a+3)+Ka; end
M_b=zeros(2*(nb+1)); K_b=zeros(2*(nb+1)); for db=1:nb, b=2*db-1; M_b(b:b+3,b:b+3)=M_b(b:b+3,b:b+3)+Mb; K_b(b:b+3,b:b+3)=K_b(b:b+3,b:b+3)+Kb; end
M_o1=zeros(2*(n1+1));K_o1=zeros(2*(n1+1));for d1=1:n1, o1=2*d1-1; M_o1(o1:o1+3,o1:o1+3)=M_o1(o1:o1+3,o1:o1+3)+Mo_1; K_o1(o1:o1+3,o1:o1+3)=K_o1(o1:o1+3,o1:o1+3)+Ko_1; end
M_o2=zeros(2*(n2+1));K_o2=zeros(2*(n2+1));for d2=1:n2, o2=2*d2-1; M_o2(o2:o2+3,o2:o2+3)=M_o2(o2:o2+3,o2:o2+3)+Mo_2; K_o2(o2:o2+3,o2:o2+3)=K_o2(o2:o2+3,o2:o2+3)+Ko_2; end
M_o3=zeros(2*(no+1));K_o3=zeros(2*(no+1));for d3=1:no, o3=2*d3-1; M_o3(o3:o3+3,o3:o3+3)=M_o3(o3:o3+3,o3:o3+3)+Mo_3; K_o3(o3:o3+3,o3:o3+3)=K_o3(o3:o3+3,o3:o3+3)+Ko_3; end

% Integration of all Parts
M_t = zeros(2*(nt+1)); K_t = zeros(2*(nt+1));
s_1 = 1; e_1 = length(M_a);
M_t(s_1:e_1,s_1:e_1) = M_a + M_t(s_1:e_1,s_1:e_1); K_t(s_1:e_1,s_1:e_1) = K_a + K_t(s_1:e_1,s_1:e_1);

s_2 = length(M_a)-1; e_2 = length(M_a)-1+length(M_b)-1;
M_t(s_2:e_2,s_2:e_2) = M_b + M_t(s_2:e_2,s_2:e_2); K_t(s_2:e_2,s_2:e_2) = K_b + K_t(s_2:e_2,s_2:e_2);

s_3 = length(M_a)+length(M_b)-3; e_3 = s_3+length(M_o1)-1;
M_t(s_3:e_3,s_3:e_3) = M_o1 + M_t(s_3:e_3,s_3:e_3); K_t(s_3:e_3,s_3:e_3) = K_o1 + K_t(s_3:e_3,s_3:e_3);

s_7 = length(M_a)+length(M_b)+length(M_o1)-5; e_7 = s_7+length(M_o2)-1;
M_t(s_7:e_7,s_7:e_7) = M_o2 + M_t(s_7:e_7,s_7:e_7); K_t(s_7:e_7,s_7:e_7) = K_o2 + K_t(s_7:e_7,s_7:e_7);

s_8 = length(M_a)+length(M_b)+length(M_o1)+length(M_o2)-7; e_8 = s_8+length(M_o3)-1;
M_t(s_8:e_8,s_8:e_8) = M_o3 + M_t(s_8:e_8,s_8:e_8); K_t(s_8:e_8,s_8:e_8) = K_o3 + K_t(s_8:e_8,s_8:e_8);


% Disk Mass
n_d1 = nt+1; s_6 = n_d1*2-1; e_6 = n_d1*2;
M_t(s_6:e_6,s_6:e_6) = [md+mu 0;0 Jd+Ju] + M_t(s_6:e_6,s_6:e_6);

% Overall System Matrices (X and Y directions)
M = [M_t, zeros(length(M_t)); zeros(length(M_t)), M_t];
K = [K_t, zeros(length(K_t)); zeros(length(K_t)), K_t];
G = zeros(4*(nt+1));

%% Global Orthotropic Support Stiffness Allocation
n_s1 = na+1; 
n_s2 = na+nb+1; 

% Isolate translational indices for X-plane (first half of the global vector)
dof_sx1 = 2*n_s1 - 1;
dof_sx2 = 2*n_s2 - 1;

% Isolate translational indices for Y-plane (second half of the global vector)
dof_sy1 = (n_q/2) + 2*n_s1 - 1;
dof_sy2 = (n_q/2) + 2*n_s2 - 1;

% Apply grounding stiffness directly to their respective directional planes
K(dof_sx1, dof_sx1) = K(dof_sx1, dof_sx1) + ksx;
K(dof_sx2, dof_sx2) = K(dof_sx2, dof_sx2) + ksx;
K(dof_sy1, dof_sy1) = K(dof_sy1, dof_sy1) + ksy;
K(dof_sy2, dof_sy2) = K(dof_sy2, dof_sy2) + ksy;