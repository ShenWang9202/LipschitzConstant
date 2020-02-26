
start_toolkit

%% Select networks and nail down the parameters

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

switch inpNameIndex
    case 1
        str_case = '3_node.mat';
    case 2
        str_case = '8_node.mat';
    case 3
        str_case = 'Anytown.mat';
    case 4
        str_case = 'Net2.mat';
    case 5
        str_case = 'Net3.mat';
    case 6
        str_case = 'OBCL.mat';
    otherwise
        str_case = 'other value';
end
%

disp('Analytical solution:')
totalTime = 0;
tic
K_P = FindLipschitz4Pipes_v2(q_min_Pipes,q_max_Pipes,Headloss_pipe_R,mu);

% disp('The overall Lipschitz constant from Pipes is')
% K_P
%
% disp('The overall Lipschitz constant from Pumps is')
if (~isempty(PumpEquation))
    K_M = FindLipschitz4Pumps_v2(q_min_Pumps,q_max_Pumps,PumpEquation)
else
    %     disp('No pump, no K_M')
end
%
% disp('The overall Lipschitz constant is')

if (~isempty(PumpEquation))
    finalLip = max(K_P,K_M)
else
    finalLip = K_P
end

totalTime = totalTime + toc;

%Save file
filename = strcat('Analytical_lipschitz_',str_case);
save(filename,'totalTime','finalLip');