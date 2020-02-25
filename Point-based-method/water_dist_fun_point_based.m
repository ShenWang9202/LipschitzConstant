function out = water_dist_fun_point_based(q,param,type)
%input: q is the vector of flow, param is the water network model
%parameter, type is the type of nonlinearity (pipes, pumps, valves)
%Lipschitz constant computation using interval optimization
%Author: Sebastian A. Nugroho
%Date: 2/24/2020

% %Load data
% switch case_study
%     case 1
%         load('3-node-Lipschtiz.mat');
%     case 2
%         load('8-node-Lipschtiz.mat');
%     otherwise
%         disp('other value');
% end
% 
% %Set constant
% mu = 2;
% Headloss_pipe_R = 4.727 * L_pipe./((C_pipe*Volum_conversion).^(mu))./(D_pipe.^(4.871));

% %Individual nonlinearity
% switch type
%     case 1 %for pipes
%         sum = 0;
%         for i = 1:param.PipeCount
%             sum = sum + (param.mu*param.Headloss_pipe_R(i)*abs(q(i))^(param.mu-1))^2;
%         end
%         out = sum;
%     case 2 %for pumps
%         sum = 0;
%         for i = 1:length(param.r_vector)
%             sum = sum + (param.nu_vector(i)*param.r_vector(i)*(q(i))^(param.nu_vector(i)-1)*(1))^2;
%         end
%         out = sum;
%     case 3 %for valves
%         out = NaN;
%     otherwise
%         out = NaN;
% end

%Combined nonlinearity
if ~strcmp(param.mode,'max')
    switch type
        case 12 %for pipes and pumps
            sum = 0;
            for i = 1:param.PipeCount
                sum = sum + (param.mu*param.Headloss_pipe_R(i)*abs(q(i))^(param.mu-1))^2;
            end
            for i = param.PipeCount+1:param.PipeCount+param.PumpCount
                sum = sum + (param.nu_vector(i-param.PipeCount)*param.r_vector(i-param.PipeCount)*(q(i))^(param.nu_vector(i-param.PipeCount)-1)*(1))^2;
            end
            out = sum;
        case 3 %for valves
            out = NaN;
        otherwise
            out = NaN;
    end
else
    switch type
        case 12 %for pipes and pumps
            sum = [];
            for i = 1:param.PipeCount
                sum = [sum; (param.mu*param.Headloss_pipe_R(i)*abs(q(i))^(param.mu-1))];
            end
            for i = param.PipeCount+1:param.PipeCount+param.PumpCount
                sum = [sum; (param.nu_vector(i-param.PipeCount)*param.r_vector(i-param.PipeCount)*(q(i))^(param.nu_vector(i-param.PipeCount)-1)*(1))];
            end
            out = max(sum);
        case 3 %for valves
            out = NaN;
        otherwise
            out = NaN;
    end
end

end