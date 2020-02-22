clc;
clear;
close all;
start_toolkit

%% Select networks and nail down the parameters
inpNameIndex = 1;
switch inpNameIndex
    case 1
        disp('3-node network')
        inpname='Threenodes.inp';
        
        PumpEquation = [393.7008 -3.746E-006 2.59;];
    otherwise
        disp('other value')
end



% Create EPANET object using the INP file

% Net1 Net2 Net3 BWSN_Network_1 example tutorial2
d=epanet(inpname);
d.plot('nodes','yes','links','yes','highlightnode',{'1','8'},'highlightlink',{'7'},'fontsize',8);


% if(inpNameIndex == 1) %AnytownModify
%     PumpEquation = [300 -4.059E-06 1.91;];
% end
% if(zhi == 2) %BWSN_Network_1
%     PumpEquation = [445.00 -1.947E-05 2.28;
%         740.00 -8.382E-05 1.94;
%         ];
% end
% if(inpNameIndex == 3) %ctown
%     PumpEquation = [229.659 -0.005969 1.36;
%         229.659 -0.005969 1.36;
%         295.28 -0.0001146 2.15;
%         393.7 -3.746E-006 2.59;
%         295.28 -0.0001146 2.15;
%         295.28 -4.652E-005 2.41;
%         ];
% end
% if(inpNameIndex == 4 )
%     PumpEquation = [393.7008 -3.746E-006 2.59;];
%     %PumpEquation = [200*0.3048 -0.01064 2;];
% end



%% Simulate all

% Another way to Simulate all
d.openHydraulicAnalysis;
d.initializeHydraulicAnalysis;
tstep=1;Velocity=[];Pressure=[];T=[]; Demand=[]; Head=[];Flows=[];TankVolume=[]; HeadLoss = [];Efficiency=[];Energy=[];Settings=[];Status=[];

TimeStep = d.getTimeHydraulicStep;
while (tstep>0)
    t=d.runHydraulicAnalysis;   %current simulation clock time in seconds.
    Velocity=[Velocity; d.getLinkVelocity];
    Pressure=[Pressure; d.getNodePressure];
    Demand=[Demand; d.getNodeActualDemand];
    TankVolume=[TankVolume; d.getNodeTankVolume];
    HeadLoss=[HeadLoss; d.getLinkHeadloss];
    Head=[Head; d.getNodeHydaulicHead];
    Flows=[Flows; d.getLinkFlows];
    Efficiency = [Efficiency; d.getLinkEfficiency];
    Energy = [Energy;d.getLinkEnergy];
    Status = [Status;d.getLinkStatus];
    T=[T; t];
    tstep=d.nextHydraulicAnalysisStep;
end
d.closeHydraulicAnalysis


%% get info from EPANET
% get index info from EPANET
%PipeIndex = 1:d.getLinkPipeCount;
PipeIndex = d.getLinkPipeIndex;
PumpIndex = d.getLinkPumpIndex;
ValveIndex = d.getLinkValveIndex;
NodeJunctionIndex = d.getNodeJunctionIndex;
ReservoirIndex = d.getNodeReservoirIndex;
NodeTankIndex = d.getNodeTankIndex;

% get LinkDiameter from EPANET
LinkDiameter = d.getLinkDiameter;
LinkDiameterPipe = LinkDiameter(PipeIndex);
LinkLength = d.getLinkLength;
LinkLengthPipe = LinkLength(PipeIndex);


%% Find the q_min and q_max for all networks


hs_vector = PumpEquation(:,1);
r_vector = -PumpEquation(:,2);
nu_vector = PumpEquation(:,3);

% assume speed is 1;
s = 1;
q_max = s.* (hs_vector./r_vector).^(1/nu_vector);







%% Find Lipschtiz Constant for all pipes

K_P = FindLipschitz4Pipes(d,q_max);