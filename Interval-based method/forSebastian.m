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

Lip_analytical = max([K_P K_M])

r_vector = -PumpEquation(:,2);
nu_vector = PumpEquation(:,3);
a = 2*Headloss_pipe_R*q_max;
b = nu_vector*r_vector*q_max^(nu_vector-1);
Lip_analytical_3nodes = sqrt(a^2+b^2)