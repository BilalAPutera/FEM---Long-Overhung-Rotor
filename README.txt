FEM-Long Overhung Rotor
MATLAB finite element model for simulating a long overhung rotor under operating conditions, including intermittent rotor-stator contact.
Table of Contents
Introduction & Underlying Physics
Program Overview
Simulation
Results Interpretation
Res_OVT
Res_Orbit
Res_FFT
Res_OBOVR
Campbell
---
Introduction & Underlying Physics
These MATLAB programs are a group of modular codes that work together to build a finite element model dedicated to a long overhung rotor, and to simulate the rotor in operating condition while intermittent contact occurs between rotor and stator.
Real systems (e.g. sump pumps, drill strings, turbines) may run through contact at multiple locations. Currently, the programs are limited to a maximum of 2 contact points.
The system motion is governed by discretized finite element equations incorporating speed-dependent gyroscopic coupling and non-linear rotor-stator contact forces:
$$
M\ddot{q}(t) + (C + \Omega G)\dot{q}(t) + Kq(t) = F_{unbalance}(t) + F_{contact}(t)
$$
where:
Symbol	Meaning
$M$, $C$, $G$, $K$	Global mass, damping, gyroscopic, and stiffness matrices
$\Omega$	Rotational speed
$q(t)$	Rotor displacement and angular response over time
Contact force
The nonlinearity lies in $F_{contact}(t)$, which only has a value when contact occurs. It is a function of a normal force and a tangential force:
Normal force, a function of contact stiffness and damping:
$$
F_{normal} = k_{contact} \times |r - c| + c_{contact} \times \dot{r}
$$
Tangential force, a function of the coefficient of friction and the normal force itself:
$$
F_{tangential} = \mu \times F_{normal}
$$
Physically, the normal force only appears when contact occurs; otherwise its value is zero. The stiffness term is determined by the penetration, i.e. the radial displacement ($r$) minus the radial clearance ($c$). The damping term depends on the radial speed ($\dot{r}$) and might negate the normal force when the velocity pulls the rotor away from the stator. In actual conditions this is unlikely to happen, so an adjustment was made to prevent the force value from becoming negative.
Model scope
The current model is an overhung rotor with 2 supports and a maximum of 2 contact points. It can be used to simulate the displacement, velocity, and acceleration of each node in the model. Contact forces in both axes are also obtainable for analysis.
The package also provides basic analysis tools: FFT, orbit, and overall orbital response.
---
Program Overview
To use the FE model, download all the programs and put them in one folder. The programs have two main functions: running the simulation and interpreting the results.
Simulation
These codes work together to run the simulation:
File	Description
`Main_Program.m`	Run this to perform the simulation.
`Parameter.m`	Where you input the system configuration (model characteristics, element distribution, and simulation configuration).
`Matrix_Prep.m`	Matrix builder for the model; adjusts the system matrices based on the element distribution defined by the user.
`Run_up.m`	Newmark-β solver for time response integration. Unless you want to change the coefficients of the integration method, preferably do not open or change anything in this program.
Results interpretation
These programs handle the analysis of results:
File	Description
`Result_Compiler.m`	Run this to analyze the simulation results and view the desired outputs.
`Res_FFT.m`	Shows the FFT of vibration at a certain node.
`Res_Orbit.m`	Shows the orbit of a certain node.
`Res_OBOVR.m`	Shows the orbit and deflectional shape of all nodes (OBOVR stands for Orbit-Overall).
`Res_OVT.m`	Shows the displacement, velocity, acceleration, and force applied to the system over time.
`Campbell`	Shows the Campbell diagram.
---
Simulation
To run a simulation, open `Main_Program.m` and `Parameter.m` in MATLAB. Enter the rotor, element, and simulation parameters in `Parameter.m`.
> **Key variables**
>
> | Variable | File | Purpose |
> | --- | --- | --- |
> | `te` | `Parameter.m` | Simulation time, i.e. how long the rotor is operated. |
> | `Tr` | `Main_Program.m` | Recording time. Rotor response is usually analyzed in steady state, so only the last few seconds of the simulation are recorded. |
> | `dec` | `Main_Program.m` | Decimation factor. Increase it to enlarge the sampling period (`dec` × time step) and reduce the size of the result file. |
Output
The default result is a `.mat` file with a user-defined name (example: `NoBushing_RPM_2000.mat`) containing 4 matrices:
Matrix	Contents
`t_ss`	Time
`q_nb_ss`	Displacement, velocity, and acceleration
`FB1_ss`	Force at the first bushing / contact point
`FB2_ss`	Force at the second bushing / contact point
You can add other matrices if you want to.
---
Results Interpretation
The simulation results saved in the `.mat` file are matrices, which are hard to interpret directly. You can either visualize them yourself or use the functions provided in this package.
Using `Result_Compiler.m`, you can:
choose the node to observe by changing the variable `n`
set the time window of observation with `t_Start` and `t_Stop`
execute the analysis functions below
Res_OVT
Shows several responses as a function of time.
Displacement, velocity, and acceleration are shown only for the defined nodes over the defined time range.
Contact force is shown only for the defined time range, for both bushings / contact points.
![Displacement over time](images/res_ovt_displacement.png)
![Contact force over time](images/res_ovt_contact_force.png)
Res_Orbit
Shows the radial movement of a defined node over a defined time range.
![Rotor node orbit](images/res_orbit.png)
Res_FFT
Shows the spectral components of a defined node over the entire time range in the data.
![FFT of node vibration](images/res_fft.png)
Res_OBOVR
Shows the orbit of each node of the rotor over a defined time range. This plot shows how the rotor moves and deflects, especially when contact occurs.
![Overall orbit and deflection shape](images/res_obovr.png)
Campbell
Shows a Campbell diagram, which is useful for determining the critical speeds of the rotor and the mode shape at each critical speed.
![Campbell diagram](images/campbell_diagram.png)