% Sampling parameters
T_Sampling = t_ss(2)-t_ss(1);   %Sampling Period
fs = 1/T_Sampling;              %Sampling Frequency

X_sim = q_nb_ss(dof_xn,2:end);
Y_sim = q_nb_ss(dof_yn,2:end);

datasets = {Y_sim(:)', X_sim(:)'};

for i = 1:2
    
    DATA = datasets{i};
    L = length(DATA);
    f_axis = fs * (0:(L/2)) / L;
    % Compute FFT
    Y_fft = fft(DATA);
    P2 = abs(Y_fft / L);
    P1 = P2(1 : floor(L/2) + 1);
    P1(2:end-1) = 2 * P1(2:end-1);
    Peak(i,:) = P1;
end

figure()

subplot(2,1,1)
plot(f_axis,1000*Peak(1,:),'b');
grid on
xlabel('Frequency (hz)')
ylabel('Amplitude (mm)')
xlim([0 150])                            
title('Y-Axis FFT')

subplot(2,1,2)
plot(f_axis,1000*Peak(2,:),'r');
grid on
xlabel('Frequency (hz)')
ylabel('Amplitude (mm)')
xlim([0 150])
title('X-Axis FFT')
