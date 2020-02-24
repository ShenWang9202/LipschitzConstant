function K_M1 = FindLipschitz4Pumps(q_max,PumpEquation)

% hs_vector = PumpEquation(:,1);
r_vector = -PumpEquation(:,2);
nu_vector = PumpEquation(:,3);

K_M = abs(nu_vector.*r_vector*q_max.^(nu_vector-1));
 
K_M1 = max(K_M);
end