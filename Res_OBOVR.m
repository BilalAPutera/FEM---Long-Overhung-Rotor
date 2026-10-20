%Load Parameter and matrix preparation
Parameter
Matrix_Prep

%Set-up Z-coordinate
Z_nodes = zeros(1, nt+1);
current_z = 0;
idx = 1;
% Loop through the element lengths defined in Parameter.m
for i = 1:na; current_z = current_z + La; idx = idx+1; Z_nodes(idx) = current_z; end
for i = 1:nb; current_z = current_z + Lb; idx = idx+1; Z_nodes(idx) = current_z; end
for i = 1:n1; current_z = current_z + L1; idx = idx+1; Z_nodes(idx) = current_z; end
for i = 1:n2; current_z = current_z + L2; idx = idx+1; Z_nodes(idx) = current_z; end
for i = 1:no; current_z = current_z + Lo; idx = idx+1; Z_nodes(idx) = current_z; end

% 3. Set up the 3D Figure
figure()
hold on;
grid on;
view(45,30)


% Define a colormap to color the orbits based on their position
colors = jet(nt + 1); 

% 4. Loop through every single node to plot its orbit
for node = 1:(nt+1)
    
    % DOF Indexing rule (based on your Matrix_Prep.m structure):
    % Y-translations are in the first half: 2*node - 1
    % X-translations are in the second half: n_q/2 + 2*node - 1
    dof_y_node = 2*node - 1; 
    dof_x_node = (n_q/2) + 2*node - 1;
    
    % Extract steady state displacements
    X_orb = q_nb_ss(dof_x_node, idx_Start:idx_Stop);
    Y_orb = q_nb_ss(dof_y_node, idx_Start:idx_Stop);
    
    % Create Z array to place this orbit at the correct axial location
    Z_orb = repmat(Z_nodes(node), 1, length(X_orb));
    
    % Plot the 3D Orbit line
    plot3(Z_orb, X_orb, Y_orb, 'Color', colors(node, :), 'LineWidth', 0.5);
    
    % Draw a faint line connecting the center (0,0) to show the shaft centerline
    plot3([Z_nodes(node) Z_nodes(node)], [0 X_orb(idx_Mid-idx_Start)], [0 Y_orb(idx_Mid-idx_Start)], '-k', 'LineWidth',0.5);
    plot3([Z_nodes(node) Z_nodes(node)], [0 X_orb(idx_Mid-idx_Start)], [0 Y_orb(idx_Mid-idx_Start)], '.b', 'LineWidth',10)
end

% 5. Add Visual Markers for the Bearings and Bushings
% Support Bearings (Nodes: na+1 and na+nb+1)
plot3(Z_nodes(na+1), 0, -0.000, 'k^', 'MarkerSize', 12, 'MarkerFaceColor', 'k');
plot3(Z_nodes(na+nb+1), 0, -0.000, 'k^', 'MarkerSize', 12, 'MarkerFaceColor', 'k');

% Bushing Clearances (Nodes: NB1 and NB2)
% Draw a red circle to represent the clearance boundary
theta = linspace(0, 2*pi, 100);
plot3(repmat(Z_nodes(NB1), 1, 100), c1*cos(theta) + mis_x1, c1*sin(theta) + mis_y1, 'k', 'LineWidth', 2);
plot3(repmat(Z_nodes(NB2), 1, 100), c2*cos(theta) + mis_x2, c2*sin(theta) + mis_y2, 'k', 'LineWidth', 2);

% Disk Location (Tip)

% 6. Formatting
% title(sprintf('Full Rotor 3D Whirl Orbits at %d RPM', round(RPM_current)), 'FontSize', 14);
xlabel('Z-Axis: Shaft Length (m)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('X-Axis Displacement (m)', 'FontSize', 12, 'FontWeight', 'bold');
zlabel('Y-Axis Displacement (m)', 'FontSize', 12, 'FontWeight', 'bold');

grid on
% axis equal;          % Forces X, Y, and Z to be equal
pbaspect([1 1 0.75]); % Dynamically alters the plot box aspect ratio if needed
