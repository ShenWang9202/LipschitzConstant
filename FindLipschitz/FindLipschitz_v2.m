clc;
clear;
close all;
start_toolkit

%% Select networks and nail down the parameters
inpNameIndex = 2;
switch inpNameIndex
    case 1
        disp('3-node network')
        inpname='Threenodes.inp';
        
        PumpEquation = [393.7008 -3.746E-006 2.59;];
        
    case 2
        disp('tutorial 8node')
        inpname='tutorial8node.inp';
        
        PumpEquation = [393.7008 -3.746E-006 2.59;];
        
    case 3
        disp('Anytown network ')
        inpname='Anytown.inp';
        
        PumpEquation = [360 -5.626E-006 2;];
    case 4
        disp('Net2')
        inpname='Net2.inp';
        
        PumpEquation = [];
    case 5
        disp('Net3')
        inpname='Net3.inp';
        
        PumpEquation = [200 -0.003503 1.09;
                        104 -1.69E-005 1.77;];
    case 6
        disp('OBCL network')
        inpname='OBCL.inp';
        
        PumpEquation = [45 -2.357E-006 2.54;];
    otherwise
        disp('other value')
end



% Create EPANET object using the INP file

% Net1 Net2 Net3 BWSN_Network_1 example tutorial2
d=epanet(inpname);
%d.plot('nodes','yes','links','yes','highlightnode',{'1','8'},'highlightlink',{'7'},'fontsize',8);


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

if (~isempty(PumpEquation))
hs_vector = PumpEquation(:,1);
r_vector = -PumpEquation(:,2);
nu_vector = PumpEquation(:,3);
end

% assume speed is 1;
% s = 1;
% q_max = s.* (hs_vector./r_vector).^(1/nu_vector);
% q_min = -q_max;

Flows_Pipes = Flows(:,PipeIndex);
q_min_Pipes = min(Flows_Pipes);
q_max_Pipes = max(Flows_Pipes);
q_min_Pipes = q_min_Pipes';
q_max_Pipes = q_max_Pipes';

Flows_Pumps = Flows(:,PumpIndex);
q_min_Pumps = min(Flows_Pumps);
q_max_Pumps = max(Flows_Pumps);
q_min_Pumps = q_min_Pumps';
q_max_Pumps = q_max_Pumps';

%% Find Lipschtiz Constant for all pipes


% find the roughness of pipes
FlowUnits = d.getFlowUnits;
if(strcmp('LPS',FlowUnits{1})) % convert to gpm
    L_pipe = d.getLinkLength *Constants4WDN.m2feet; % ft
    D_pipe = d.getLinkDiameter *Constants4WDN.mm2inch; % inches ; be careful, pump's diameter is 0
end
if(strcmp('GPM',FlowUnits{1})) % convert to gpm
    L_pipe = d.getLinkLength ; % ft
    D_pipe = d.getLinkDiameter; % inches ; be careful, pump's diameter is 0
end
C_pipe = d.getLinkRoughnessCoeff; % roughness of pipe

diameter_conversion = Constants4WDN.feet2inch;
Volum_conversion = Constants4WDN.GPM2CFS;


PipeIndex = d.getLinkPipeIndex;
PipeCount = d.getLinkPipeCount;

PumpCount = d.getLinkPumpCount;

L_pipe = L_pipe(PipeIndex);
D_pipe = D_pipe(PipeIndex)/diameter_conversion;
C_pipe = C_pipe(PipeIndex);



%%


mu = 2;
Headloss_pipe_R = 4.727 * L_pipe./((C_pipe*Volum_conversion).^(mu))./(D_pipe.^(4.871));

% switch inpNameIndex
%     case 1
%         save '3-node-Lipschtiz.mat';
%     case 2
%         save '8-node-Lipschtiz.mat';
%     case 3
%         save 'anytown-Lipschtiz.mat';
%     case 4
%         save 'net2-Lipschtiz.mat';
%     case 5
%         save 'net3-Lipschtiz.mat';
%     case 6
%         save 'OBCL-Lipschtiz.mat';
%     otherwise
%         disp('other value')
% end

%

disp('Analytical solution:')

K_P = FindLipschitz4Pipes_v2(q_min_Pipes,q_max_Pipes,Headloss_pipe_R,mu)

if (~isempty(PumpEquation))
K_M = FindLipschitz4Pumps_v2(q_min_Pumps,q_max_Pumps,PumpEquation)
else
    disp('No pump, no K_M')
end


