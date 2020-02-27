% Main Program
% Lipschitz constant computation using Analytical, interval-based, and
% point-based method
% System: water distribution system model
% Author: Shen Wang
% Date: 2/27/2020

% The bar plot only work with Matlab 2019
Interval_Computational_Time = [];
point_based_computational_time_sqrt = [];
point_based_computational_time_max = [];
Analytical_computational_time = [];
for case_study = 1:6
    switch case_study
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
            disp('other value');
            str_case = 'other value';
    end
    % load analytical computational time data
    filename = strcat('Analytical_lipschitz','_',str_case);
    load(filename)
   
    Analytical_computational_time = [Analytical_computational_time; totalTime];
   
   
    % load interval computational time data
    filename = strcat('data_experiment_tab','_',str_case);
    load(filename)
    interval_computational_time = Tab1.comp_time;
    Interval_Computational_Time = [Interval_Computational_Time; interval_computational_time];
   
    % computer average computational time data for halton random sobol when the
    % sampling is fixed 10000
   
    sqrt_10000 = [];
    max_10000 = [];
   
    % select model
    for j = 1:2
        if j == 1
            fun_type = 'sqrt';
        else
            fun_type = 'max';
        end
       
        % selct seq_type
        for k = 1:3
            if k == 1
                seq_type = 'random';
            else
                if k ==2
                    seq_type = 'sobol';
                else
                    seq_type = 'halton';
                end
            end
            fun_type
            seq_type
           
            filename = strcat('data_LDS_lipschitz_water_dist_',seq_type,'_',fun_type,'_',str_case)
            load(filename)
            comput_time_point_base_10000 = datatable_all(46:50,5);
            comput_time_point_base_10000 = cell2mat(comput_time_point_base_10000);
            computational_time_10000 = mean(comput_time_point_base_10000);
           
            if (j==1)
                sqrt_10000 = [sqrt_10000 computational_time_10000];
            else
                max_10000 = [max_10000 computational_time_10000];
            end
           
        end
    end
   
    point_based_computational_time_sqrt = [point_based_computational_time_sqrt; mean(sqrt_10000)];
    point_based_computational_time_max = [point_based_computational_time_max; mean(max_10000)];
   
   
   
   
   
end


h = figure;
fs = 32;
set(gcf,'numbertitle','off','name','N vs sensor cost')
box on
grid off
set(gcf,'color','w');
% x = categorical({'Three-node','Eight-node','Anytown'});
% x = reordercats(x,{'Three-node','Eight-node','Anytown'});
x = categorical({'Three-node','Eight-node','Anytown','Net2','Net3','OBCL'});
x = reordercats(x,{'Three-node','Eight-node','Anytown','Net2','Net3','OBCL'});
%y = [mean_total_cost_cus(:) sensor_cost_std(:) sensor_cost_std_2(:)];
y = [ Analytical_computational_time point_based_computational_time_max point_based_computational_time_sqrt Interval_Computational_Time];
h1 = bar(x,y);

%xlabel('Network', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
ylabel('Computational time (second)', 'interpreter','latex','FontSize',fs-5);
l = cell(1,4);
l{1}='Anlytical'; l{2}='Point-based-max'; l{3}='Point-based-sqrt';l{4}='Interval-based';
set(gca,'fontsize',fs);
% set(leg1,'Interpreter','latex');
% title('CH-BnB', 'FontSize', 10);
legend(h1,l,'Location','Best','FontSize',fs,'Interpreter','latex');
legend boxoff;
set(gcf,'PaperUnits','inches','PaperPosition',[0 0 13 7])
print(h,'computational_time','-depsc2','-r300');