figure()

subplot(2,1,1)
plot(t_ss,1000*q_nb_ss(dof_yn,:),'b');
grid on
xlabel('Time (s)')
ylabel('Amplitude (mm)')
xlim([t_Start t_Stop])                            
title('Y-Axis Displacement over time')

subplot(2,1,2)
plot(t_ss,1000*q_nb_ss(dof_xn,:),'r');
grid on
xlabel('Time (s)')
ylabel('Amplitude (mm)')
xlim([t_Start t_Stop])
title('X-Axis Displacement over time')

figure()

subplot(2,1,1)
plot(t_ss,q_nb_ss(dof_dyn,:),'b');
grid on
xlabel('Time (s)')
ylabel('Amplitude (m/s)')
xlim([t_Start t_Stop])                            
title('Y-Axis Velocity over time')

subplot(2,1,2)
plot(t_ss,q_nb_ss(dof_dxn,:),'r');
grid on
xlabel('Time (s)')
ylabel('Amplitude (m/s)')
xlim([t_Start t_Stop])
title('X-Axis Velocity over time')

figure()

subplot(2,1,1)
plot(t_ss,q_nb_ss(dof_ddyn,:),'b');
grid on
xlabel('Time (s)')
ylabel('Amplitude (m/s^{2})')
xlim([t_Start t_Stop])                            
title('Y-Axis Acceleration over time')

subplot(2,1,2)
plot(t_ss,q_nb_ss(dof_ddxn,:),'r');
grid on
xlabel('Time (s)')
ylabel('Amplitude (m/s^{2})')
xlim([t_Start t_Stop])
title('X-Axis Acceleration over time')