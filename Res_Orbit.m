figure()
plot(1000*q_nb_ss(dof_xn,:),1000*q_nb_ss(dof_yn,:),'b');
grid on
xlabel('x-axis (mm)')
ylabel('y-axis (mm)')
title('Rotor node orbit')
axis equal
