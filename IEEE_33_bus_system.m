% Created by JY Wong, 26 October 2019
% MATLAB program for Simulink model of the IEEE 33 bus system 
% Reference: Baran and Wu, 1989
% Optimal sizing of capacitors placed on a radial-distribution system
% IEEE Trans. Power Deliv., 4 (1989), pp. 735-743
% Voltage measurements are phase to phase
% Current measurements are per phase
%% General information of the system
noBranches = 32;                % number of branches
noNoP = 5;                      % number of normally-open points (tielines) 
noBuses = 33;                   % number of buses
noMeaurements = noBranches;     % number of V and I measurements
%% Initialization of the circuit breaker input vector
% Simulation time 0.2 s with step size of 1 ms
timeTS = (0:0.001:0.2)';        
% set the circuit breaker status, close all branches and open all NoPs
% (syntax is similar to that in the MATPOWER case branch data)
CBStats = [ones(length(timeTS),noBranches),zeros(length(timeTS),noNoP)];
% Change the CBStats variable to change the branch connections in the system
% EXAMPLE: disconnect Branch 16, close all other branches and open all NoPs
% CBStats = [ones(length(timeTS),15),zeros(length(timeTS),1),...
%    ones(length(timeTS),noBranches-16),zeros(length(timeTS),noNoP)];
% initialize the timeseries for simulation input
siminCB = timeseries(CBStats,timeTS);
%% Simulation phase
% Prepare simulation 
simName = 'IEEE33BusTestSystem';
simIn = Simulink.SimulationInput(simName);
simIn = simIn.setVariable('siminCB',siminCB);
% Run simulation
simout = sim(simIn);
% Output: Voltage and Current Measurements
% Each output matrix has 32 branches x 3 phases = 96 entries
ISimMat = simout.simOutputI.data;
VSimMat = simout.simOutputV.data;
% Obtain the average of the three phases for each branch 
% 96 entries / 3 phases = 32 branches
IRMSMat = zeros(size(ISimMat,1),size(ISimMat,2)/3);
for iterS = 1:size(ISimMat,2)/3
    IRMSMat(:,iterS) = mean(ISimMat(:,(iterS-1)*3+1:(iterS-1)*3+3),2);
end
VRMSMat = zeros(size(VSimMat,1),size(VSimMat,2)/3);
for iterS = 1:size(VSimMat,2)/3
    VRMSMat(:,iterS) = mean(VSimMat(:,(iterS-1)*3+1:(iterS-1)*3+3),2);
end
