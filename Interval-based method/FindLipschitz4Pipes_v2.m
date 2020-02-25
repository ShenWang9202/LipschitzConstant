function K_P1 = FindLipschitz4Pipes_v2(q_max,Headloss_pipe_R,mu,PipeCount)

K_P = [];


for i = 1:PipeCount
    %     k_P =   Headloss_pipe_R(i) * ((q_max)^(mu-1)+ mu*(q_max)^(mu));
    k_P =  mu* Headloss_pipe_R(i) * ((q_max)^(mu-1));
    K_P = [K_P k_P];
end

K_P1 = max(K_P);
end