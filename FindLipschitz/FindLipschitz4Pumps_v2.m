function K_M1 = FindLipschitz4Pumps_v2(q_min_Pumps,q_max_Pumps,PumpEquation)

% hs_vector = PumpEquation(:,1);
r_vector = -PumpEquation(:,2);
nu_vector = PumpEquation(:,3);

K_M = [];

k_M = abs(nu_vector.*r_vector.*q_min_Pumps.^(nu_vector-1));
K_M = [K_M; k_M];
k_M = abs(nu_vector.*r_vector.*q_max_Pumps.^(nu_vector-1));
K_M = [K_M; k_M];

K_M1 = max(K_M);
end