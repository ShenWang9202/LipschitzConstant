function [data_all_out,data_mean_out] = function_water_network_lipschitz_approximation(invalV,...
    sample,seq_type,param)
%Approximation function for Lipschitz constants computation for water
%network model
%Input: vector of sample points as invalV, 
%       number of repeated experiments for each sample point as sample;
%       certain types of LD sequence as seq_type e.g. 'sobol' or 'halton' or 'random',
%       param is water network's parameter
%Output: vector of sample points as vsample_f,
%        vector of mean values as vmean_f;
%Author: Sebastian A. Nugroho
%Date: 2/25/2020

%Function type
fun_type = param.mode;

%Initialize table
datatable_all = cell(length(invalV)*sample,6 );
datatable_mean = cell(length(invalV),3);

%Table index counter
counter = 1;

%Determine which case study
switch param.case_study
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

%Get data
for i = 1:size(invalV,2)   
    ctr = 1;
    for j = 1:sample
        tt = tic;
        lip = water_network_approximate_lipschitz_2arg(param,param.Dx,param.Du,seq_type,invalV(i));
        timelapse = toc(tt);
        
        %Compute mean
        if j == 1
            lipmean = lip;
        else
            datmean = cell2mat(datatable_all((i-1)*sample+1:i*sample-1,1));
            lipmean = mean([datmean; lip]);
        end
        
        if (j == sample)
            datatable_mean(i,:) = {lipmean invalV(i) seq_type};
        end
        
        datatable_all(counter,:) = {lip lipmean invalV(i) seq_type timelapse j};
        
        %Convert to table
        table_lipschitz = cell2table(datatable_all,'VariableNames',{'lip_constant','lip_mean',...
                'samples','seq_type','timelapse','index_sample'});
            
        %Save file
        filename = strcat('data_LDS_lipschitz_water_dist_',seq_type,'_',fun_type,'_',str_case);
        save(filename,'datatable_mean','datatable_all','table_lipschitz',...
            'seq_type','fun_type');
        
        %Update counter
        counter = counter + 1;
        ctr = ctr + 1;
    end
end

%Translate to output
data_all_out = datatable_all;
data_mean_out = datatable_mean;

end