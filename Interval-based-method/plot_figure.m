%Plot figure

clear all
close all

%Load file
filename = 'data_experiment_table_F.mat';
load(filename);

%Convert to matrix
tab_mat = table2cell(Tab1(:,1:end-1));
tab_mat_F = cell2mat(tab_mat);
eps_F = tab_mat_F(:,2);
time_F = tab_mat_F(:,5);
lip_F = tab_mat_F(:,4);
% eps_F = flip(eps_F);
xv = 1:length(eps_F);
eps_F_tick = [10^-1 10^-2 10^-3 10^-4 10^-5];
% eps_F_tick = [5*10^-1 5*10^-2 5*10^-3 5*10^-4 5*10^-5];

%Load file
filename = 'data_experiment_table_X.mat';
load(filename);

%Convert to matrix
tab_mat = table2cell(Tab1(:,1:end-1));
tab_mat_X = cell2mat(tab_mat);
eps_X = tab_mat_X(:,3);
time_X = tab_mat_X(:,5);
lip_X = tab_mat_X(:,4);
% eps_X = flip(eps_X);

% semilogx(eps_F,time_F)
% 

%Plot trajectory
h(1) = figure;
fs = 18;
set(gcf,'numbertitle','off','name','Traffic Networks')
% Create axes
axes1 = axes;
hold on
yyaxis left
% p1 = semilogx(eps_F,time_F);
yv1 = interp1(eps_F, time_F, eps_F, 'linear', 'extrap');     
p1 = plot(xv,yv1,'MarkerFaceColor',[1 1 1],...
    'Marker','square',... %'Color',[0 0 1],...
    'MarkerEdgeColor',[0 0 0],'LineWidth',2.5);
% p1 = plot(xv,yv1,'LineWidth',2.5);
xlabel('$\epsilon_h$', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
ylabel('$\Delta t$ (seconds)', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
set(gca,'xticklabels',eps_F_tick) 
% xticklabels(eps_F)
yyaxis right
% p2 = semilogx(eps_F,lip_F);
yv2 = interp1(eps_F, lip_F, eps_F, 'linear', 'extrap');    
p2 = plot(xv,yv2,'MarkerFaceColor',[1 1 1],...
    'Marker','diamond',... %'Color',[1 0 0],...
    'MarkerEdgeColor',[0 0 0],'LineStyle','-.','LineWidth',2.5);
% p2 = plot(xv,yv2,'LineStyle','-.','LineWidth',2.5);
% xlabel('$\epsilon_h$', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
ylabel('$\gamma$', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
set(gca,'xticklabels',eps_F_tick) 
% xticklabels(eps_F)
grid off
box on

Lgd = legend(gca,[p1 p2],{'$\Delta t$','$\gamma$'},'location','northwest','interpreter','latex','FontName','Times New Roman','FontSize',18);
% Lgd.FontSize = 18;
% Lgd.Interpreter ='Latex';
% Lgd.Location ='best';
% legend(gca,[p1a p1b p2a p2b p3a p3b],{'$x_2$','$\hat{x}_2$','$x_5$','$\hat{x}_5$','$x_{7}$','$\hat{x}_{7}$'},...
%     'location','northeast','interpreter','latex','FontName','Times New Roman','FontSize',fs);
xlim([min(xv) max(xv)]);
% ylim([min(min(time_cor,time_pro)) max(max(time_cor,time_pro))]);
set(gcf,'color','w');
% set(gca,'fontsize',18);
set(gca,'fontsize',18);

% % axes2 = axes('Position',[0.3 0.575 0.37 0.32]);
% axes2 = axes('Position',[0.27 0.72 0.43 0.19]);
% box on
% hold on
% p3 = plot(N_cor,time_cor,'MarkerFaceColor',[1 1 1],...
%     'Marker','square','Color',[0 0 1],...
%     'MarkerEdgeColor',[0 0 0],'LineWidth',2.5);
% xlim([N_cor(1) N_cor(end)]);
% ylim([min(time_cor) max(time_cor)]);
% 
% % Lgd = legend('Mosek','SDPNAL+');
% % Lgd.FontSize = 15;
% % Lgd.Interpreter ='Latex';
% % Lgd.Location ='bestoutside';
% % legend boxoff   
% 
% xlabel('$M$', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
% ylabel('$t$', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
% 
% set(gcf,'color','w');
% set(gca,'fontsize',14);

set(h(1), 'Position', [700 300 500 370])
print(h(1), 'gen_eps_F.eps', '-depsc2','-r600')
saveas(h(1),'gen_eps_F.png')

%Plot trajectory
h(2) = figure;
fs = 18;
set(gcf,'numbertitle','off','name','Traffic Networks')
% Create axes
axes1 = axes;
hold on
yyaxis left
yv1 = interp1(eps_X, time_X, eps_X, 'linear', 'extrap'); 
p1 = plot(xv,yv1,'MarkerFaceColor',[1 1 1],...
    'Marker','square',... %'Color',[0 0 1],...
    'MarkerEdgeColor',[0 0 0],'LineWidth',2.5);
% p1 = plot(xv,yv1,'LineWidth',2.5);
xlabel('$\epsilon_{\Omega}$', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
ylabel('$\Delta t$ (seconds)', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
set(gca,'xticklabels',eps_F_tick) 
yyaxis right
yv2 = interp1(eps_X, lip_X, eps_X, 'linear', 'extrap');    
p2 = plot(xv,yv2,'MarkerFaceColor',[1 1 1],...
    'Marker','diamond',... %'Color',[1 0 0],...
    'MarkerEdgeColor',[0 0 0],'LineStyle','-.','LineWidth',2.5);
% p2 = plot(xv,yv2,'LineStyle','-.','LineWidth',2.5);
ylabel('$\gamma$', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
set(gca,'xticklabels',eps_F_tick) 
grid off
box on

Lgd = legend(gca,[p1 p2],{'$\Delta t$','$\gamma$'},'location','southeast','interpreter','latex','FontName','Times New Roman','FontSize',18);
xlim([min(xv) max(xv)]);
set(gcf,'color','w');
set(gca,'fontsize',18);

set(h(2), 'Position', [700 300 500 370])
print(h(2), 'gen_eps_X.eps', '-depsc2','-r600')
saveas(h(2),'gen_eps_X.png')