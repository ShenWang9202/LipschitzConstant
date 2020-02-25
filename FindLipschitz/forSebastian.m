clear;
clc;

inpNameIndex = 1;

switch inpNameIndex
    case 1
        load('3-node-Lipschtiz.mat')
    case 2
        load('8-node-Lipschtiz.mat')
    otherwise
        disp('other value')
end


mu = 2;
Headloss_pipe_R = 4.727 * L_pipe./((C_pipe*Volum_conversion).^(mu))./(D_pipe.^(4.871));

%
K_P = FindLipschitz4Pipes_v2(q_max,Headloss_pipe_R,mu,PipeCount);
K_M = FindLipschitz4Pumps_v2(q_max,PumpEquation);