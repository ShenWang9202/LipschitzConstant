function K_P1 = FindLipschitz4Pipes_v2(q_min_Pipes,q_max_Pipes,Headloss_pipe_R,mu)

K_P = [];

Headloss_pipe_R = Headloss_pipe_R';
q_min_Pipes = abs(q_min_Pipes);

k_P = mu* Headloss_pipe_R.*((q_min_Pipes).^(mu-1));
K_P = [K_P; k_P];

k_P = mu* Headloss_pipe_R.*((q_max_Pipes).^(mu-1));
K_P = [K_P; k_P];


K_P1 = max(K_P);
end