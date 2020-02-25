%Main Program
%Lipschitz constant computation using interval optimization
%Use value from the left corner of S to update L (Moa)
%System: water distribution system model
%Author: Sebastian A. Nugroho
%Date: 2/24/2020

clc
clear 
close all
format long

%Select case study
case_study = 3;

%Load data
switch case_study
    case 1
        load('3-node-Lipschtiz.mat');
    case 2
        load('8-node-Lipschtiz.mat');
    case 3
        load('anytown-Lipschtiz.mat');
    case 4
        load('net2-Lipschtiz.mat');
    case 5
        load('net3-Lipschtiz.mat');
    case 6
        load('OBCL-Lipschtiz.mat');
    otherwise
        disp('other value');
end

%Set constant data
param.mu = 2;
param.Headloss_pipe_R = 4.727 * L_pipe./((C_pipe*Volum_conversion).^(param.mu))./(D_pipe.^(4.871));
param.r_vector = -PumpEquation(:,2);
param.nu_vector = PumpEquation(:,3);
param.PipeCount = PipeCount;
param.q_max = q_max*ones(param.PipeCount + length(param.r_vector),1);
param.q_min = [-q_max*ones(param.PipeCount,1); 0*ones(length(param.r_vector),1)];

%%%%Experiment 1-A
%Epsilons for stopping criteria
eps_X = [10^-3];
eps_F = [1*10^0];
max_iter = Inf;

%Experiment Data
for i = 1:length(eps_F)
    exp_data1.result{i} = {[]};
end

%Initialize data
data1_tab = cell(length(eps_F),11);

%Experiment 1
for i = 1:length(eps_F)
    
    %Total time
    totalTime = 0;

    %Compute Lipschitz constant for pipes + pumps
    %Define domain X for pipes
    for j = 1:param.PipeCount
        Xset.dim(j).l = param.q_min(j); 
        Xset.dim(j).u = param.q_max(j);
    end
    %Define domain X for pumps
    for j = param.PipeCount+1:param.PipeCount+length(param.r_vector)
        Xset.dim(j).l = param.q_min(j); 
        Xset.dim(j).u = param.q_max(j);
    end
    
    nonlinear_type = 12; %pipes and pumps

    tic
    %Compute the maximum of the squared norm of gradient vector for each
    result{1} = fun_inval_maximization(Xset,param,nonlinear_type,param.PipeCount+length(param.r_vector),eps_F(i),eps_X(i),max_iter);
    totalTime = totalTime + toc;

    %Compute the Lipschitz constant
    LipSumSqr = result{1}{1}; 
    
    %Compute total split
    total_split = result{1}{4}; 
    
    %Compute total time
    totalTime = result{1}{5}; 
       
    %Compute total subset
    total_subset = result{1}{6}; 
    
    %Compute gap
    gap = mean([result{1}{7}]); 
    
    %Optimality
    isOpt = result{1}{8};
    
    %Compute total split 1 
    total_split1 = result{1}{9};
              
    %Compute total split 2
    total_split2 = result{1}{10};

    %Approximated Lipschitz constant
    Lip = sqrt(LipSumSqr);
    disp(' ');
    fprintf('The overall Lipschitz constant is: %.10f\n',Lip);
    disp(' ');
    fprintf('The overall computation time: %.3f\n',totalTime);
    
    %Store data    
    data1_tab(i,:) = {i eps_F(i) eps_X(i) Lip totalTime total_split total_split1 total_split2 total_subset gap isOpt};

    %Convert to table
    Tab1 = cell2table(data1_tab,'VariableNames',{'index','eps_F', 'eps_X', 'gamma','comp_time','total_split','total_split1','total_split2','total_subset','gap','is_optimal'});

    %Save file
    filename = 'data_experiment_tab_case_2.mat';
    save(filename,'Tab1');
    
    %Save data
    exp_data1.result{i} = {i, eps_F(i), eps_X(i), Lip, totalTime, result, param};
    save('data_experiment_case_2.mat','exp_data1');
    
end

