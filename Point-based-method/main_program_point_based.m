%Main Program
%Lipschitz constant computation using LDS
%System: water distribution system model
%Author: Sebastian A. Nugroho
%Date: 2/24/2020

% clear 
close all

% Select case study
 case_study = inpNameIndex;
% 
% Load data
% switch case_study
%     case 1
%         load('3-node-Lipschtiz.mat');
%     case 2
%         load('8-node-Lipschtiz.mat');
%     otherwise
%         disp('other value');
% end

%Function mode
%param.mode = 'sqrt';
param.mode = mode_point_based;

%Set constant data
%Set constant data
param.mu = mu;
param.Headloss_pipe_R =Headloss_pipe_R;
if PumpCount> 0
    param.r_vector = r_vector;
    param.nu_vector = nu_vector;
end
param.PipeCount = PipeCount;
param.PumpCount = PumpCount;
param.q_max = [q_max_Pipes ;q_max_Pumps];
param.q_min = [q_min_Pipes ;q_min_Pumps];


%Bounds on x
param.Dx = [param.q_min param.q_max];

%Bounds on u
param.Du = [];

%Type of nonlinearity
param.nonlinear_type = 12; %pipes and pumps

%Case study
param.case_study = case_study;

%Number of points
%invalV = [50 100 200 400 800 1600 3200 6400 12800 25600];
invalV = [10 100 1000 10000 100000];

%Samples on each interval
sample = 5;

%Sequence type
seq_type = 'random';

[vsample_f_r,vmean_f_r] = function_water_network_lipschitz_approximation(invalV,...
    sample,seq_type,param);

%Sequence type
seq_type = 'sobol';

[vsample_f_s,vmean_f_s] = function_water_network_lipschitz_approximation(invalV,...
    sample,seq_type,param);

%Sequence type
seq_type = 'halton';

[vsample_f_h,vmean_f_h] = function_water_network_lipschitz_approximation(invalV,...
    sample,seq_type,param);

