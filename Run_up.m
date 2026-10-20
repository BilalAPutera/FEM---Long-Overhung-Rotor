%% Time Integration with Speed Profile (Run-Up)

h = h_step;          
t = 0:h:te;             

%Speed profile (ramp-steady)
ramp_indices = t <= t_fin;

RPM = zeros(1,length(t));
RPM(ramp_indices) = linspace(0, RPM_fin, sum(ramp_indices));
RPM(~ramp_indices) = RPM_fin;

% Pre-calculate Speed (w) and Phase Angle (theta)
w_array = RPM * (2*pi/60);
theta_array = cumtrapz(t, w_array'); % Integral of speed over time

% Rayleigh Structural Damping Matrix
C_damp  = alpha_d * M + beta_d * K;


% Response Matrix Preparation
q_nb = zeros(3*n_q, length(t)); %Response Matrix
FB1  = zeros(2, length(t));     %Forcing Matrix at 1st Bushing Node
FB2  = zeros(2, length(t));     %Forcing Matrix at 2nd Bushing Node
q_nb(:,1) = q0;                 %Initial Condition

% Pre-allocate inverse matrix variable
inv_K_eff = []; 

tic
for i = 1:length(t)-1
    
    x = q_nb(1:n_q, i);
    v = q_nb(n_q+1:2*n_q, i);
    a = q_nb(2*n_q+1:3*n_q, i);
    
    % Current kinematics
    w_next = w_array(i+1); % From speed profile
    theta_next = theta_array(i+1); 
    
    % --- SMART MATRIX PRE-INVERSION FIX ---
    % Only recalculate and invert the massive K_eff matrix if the RPM actually changes!
    if i == 1 || w_array(i+1) ~= w_array(i)
        GYR = (Jd+Ju)*w_next;
        G = zeros(4*(nt+1));
        G((nt+1)*4,(nt+1)*2) = -GYR;
        G((nt+1)*2,(nt+1)*4) =  GYR;
        
        K_eff = M + gam*h*(G + C_damp) + bet*h^2*K;
        inv_K_eff = inv(K_eff); 
    end
    
    % Forcing Function using exact integrated phase angle
    Fu = zeros(n_q,1);
    Amp = U * w_next^2;
    Fu(dof_ytip) = Amp * sin(theta_next) ;
    Fu(dof_xtip) = Amp * cos(theta_next) ;
    
    % Predictor
    x_pred = x + h*v + h^2*(0.5 - bet)*a;
    v_pred = v + h*(1 - gam)*a;
    
    % Bushing force collision checks
    ynb1 = x_pred(dof_y1) - mis_y1; xnb1 = x_pred(dof_x1) - mis_x1; 
    dynb1 = v_pred(dof_y1); dxnb1 = v_pred(dof_x1); 
    ynb2 = x_pred(dof_y2) - mis_y2; xnb2 = x_pred(dof_x2) - mis_x2; 
    dynb2 = v_pred(dof_y2); dxnb2 = v_pred(dof_x2);
    Fb = zeros(n_q,1);   
        
    % ----- BUSHING 1 -----
    r1 = sqrt(ynb1^2 + xnb1^2);
    if r1 > c1
        vr1 = (xnb1*dxnb1 + ynb1*dynb1) / r1; 
        del1 = r1 - c1;
        if del1 >= tM
            k1 = kM * kb1;
            Fb_1 = k1/kM * del1 + k1 * (del1 - tM) + cb1 * vr1;
        else
            k1 = kb1;
            Fb_1 = k1 * del1 + cb1 * vr1;
        end
        Fb_1 = max(Fb_1, 0); 
        Ft1 = mu_f * Fb_1;
        Fb(dof_y1) = -Fb_1 * (ynb1 / r1) - Ft1 * (xnb1 / r1);
        Fb(dof_x1) = -Fb_1 * (xnb1 / r1) + Ft1 * (ynb1 / r1);
    end
    FB1(:,i) = [Fb(dof_y1);Fb(dof_x1)];

    % ----- BUSHING 2 -----
    r2 = sqrt(ynb2^2 + xnb2^2);
    if r2 > c2
        vr2 = (xnb2*dxnb2 + ynb2*dynb2) / r2;
        del2 = r2 - c2;
        if del2 >= tM
            k2 = kM * kb2;
            Fb_2 = k2/kM * del2 + k2 * (del2 - tM) + cb2 * vr2; 
        else
            k2 = kb2;
            Fb_2 = k2 * del2 + cb2 * vr2;
        end
        Fb_2 = max(Fb_2, 0);
        Ft2 = mu_f * Fb_2;
        Fb(dof_y2) = -Fb_2 * (ynb2 / r2) - Ft2 * (xnb2 / r2);
        Fb(dof_x2) = -Fb_2 * (xnb2 / r2) + Ft2 * (ynb2 / r2);
    end
    FB2(:,i) = [Fb(dof_y2);Fb(dof_x2)];
    
    F_next = Fu + Fb;
    
    % Solve
    a_next = K_eff \ (F_next - (G + C_damp)*v_pred - K*x_pred);
    
    % Corrector
    x_next = x_pred + bet*h^2*a_next;
    v_next = v_pred + gam*h*a_next;
      
    % Store
    q_nb(1:n_q, i+1) = x_next;
    q_nb(n_q+1:2*n_q, i+1) = v_next;
    q_nb(2*n_q+1:3*n_q, i+1) = a_next;
end
NB_time = toc;
disp(['Time taken for integration: ', num2str(NB_time), ' seconds']);
