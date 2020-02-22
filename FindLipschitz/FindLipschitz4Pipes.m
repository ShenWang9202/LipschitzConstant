function K_P = FindLipschitz4Pipes(d,q_max)

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
mu = 1.852;


PipeIndex = d.getLinkPipeIndex;
L_pipe = L_pipe(PipeIndex);
D_pipe = D_pipe(PipeIndex)/diameter_conversion;
C_pipe = C_pipe(PipeIndex);

Headloss_pipe_R = 4.727 * L_pipe./((C_pipe*Volum_conversion).^(mu))./(D_pipe.^(4.871));
PipeCount = d.getLinkPipeCount;

K_P = []
 
for i = 1:PipeCount
    k_P = mu * Headloss_pipe_R(i) * (q_max)^(mu-1);
    K_P = [K_P k_P];
end

K_P1 = max(K_P);
end