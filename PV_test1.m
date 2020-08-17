!Line definitions

clc;
clear all;
close all;
DSSObj= actxserver('OpenDSSEngine.DSS');
disp('OK up to here');
if ~DSSObj.Start(0),
    disp('Unable to start the OpenDSS Engine');
return 
end

DSSText=DSSObj.Text;
DSSCircuit = DSSObj.ActiveCircuit;
DSSText.Command='Compile (C:\Users\Krishna\Documents\MATLAB\PV_power_flow\Integrated_PV\Master.dss)';  % we need to give right path
DSSText.Command='Set mode=snapshot';
DSSText.Command='solve';
DSSText.Command='Show Losses';
DSSText.Command='Show Power';
DSSText.Command='Show voltage';
DSSText.Command='export currents';
DSSText.Command='Export Power';
DSSText.Command='export losses';
DSSText.Command='export voltages';


