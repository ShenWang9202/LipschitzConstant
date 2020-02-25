function out = water_dist_fun_inval2(Q,param,type)
%input: Q is the vector of flow, param is the water network model
%parameter, type is the type of nonlinearity (pipes, pumps, valves)
%Lipschitz constant computation using interval optimization
%Author: Sebastian A. Nugroho
%Date: 2/24/2020

switch type
    case 12 %for pipes and pumps
        sum = [0 0];
        Q{1}
        Q{2}
        for i = 1:param.PipeCount
            A0 = inv_abs(Q{i});
            A1 = inv_pow(A0,param.mu-1);
            A2 = inv_mul_c(inv_mul_c(A1,param.Headloss_pipe_R(i)),param.mu);
            A3 = inv_pow(A2,2);
            sum = inv_add(sum,A3);
        end 
        for i = param.PipeCount+1:param.PipeCount+length(param.r_vector)
            A1 = inv_pow(Q{i},param.nu_vector(i-param.PipeCount)-1);
            A2 = inv_mul_c(inv_mul_c(A1,param.r_vector(i-param.PipeCount)),param.nu_vector(i-param.PipeCount));
            A3 = inv_pow(A2,2);
            sum = inv_add(sum,A3);
        end
        out = sum
    case 3 %for valves
        out = [NaN NaN];
    otherwise
        out = [NaN NaN];
end



end