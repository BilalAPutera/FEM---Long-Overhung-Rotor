%% Campbell Diagram Calculation
Parameter
Matrix_Prep

RPM_Range = 0:10:5000; % Increased step size slightly to speed up computation

Campbell_Data = zeros(length(RPM_Range), 2*length(M));
for k = 1:length(RPM_Range)
    wc = RPM_Range(k) * (2*pi/60);
    GYR = (Jd+Ju);
    G_camp = zeros(size(M));
    G_camp((nt+1)*4,(nt+1)*2) = GYR;
    G_camp((nt+1)*2,(nt+1)*4) = -GYR;
    
    eigs_sys = polyeig(K, G_camp*wc, M);
    wn_hz = abs(imag(eigs_sys)) / (2*pi);
    Campbell_Data(k, :) = wn_hz';
end
%%
figure()
plot(RPM_Range,Campbell_Data,'.b','MarkerSize',3); hold on
plot(RPM_Range,RPM_Range/60,'--r')
grid on
ylim([0 100])
xlabel('Rotor Speed (RPM)')
ylabel('Frequency (Hz)')
title('Campbell Diagram')
