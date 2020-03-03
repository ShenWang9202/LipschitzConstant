close all

%Dimesion
N = 2;

%Number of points
n = 100;

%Sobol
Psob = sobolset(N);
Xsob = net(Psob,n);

%Halton
Phal = haltonset(N);
Xhal = net(Phal,n*2);

%Random
Xrdn = rand(n,N);
 
%Plot
h = figure

splt2 = subplot(1,3,1);
box(splt2,'on');
hold on
p1b = scatter(Xrdn(:,1),Xrdn(:,2),'b');
hold off
legend(gca,[p1b],{'Random'},...
    'location','northeast','interpreter','latex','FontSize',16);
xlim([0 1]);
ylim([0 1]);
xticks([0 0.2 0.4 0.6 0.8 1])
yticks([0 0.2 0.4 0.6 0.8 1])


splt1 = subplot(1,3,2);
box(splt1,'on');
hold on
p1a = scatter(Xsob(:,1),Xsob(:,2),'r');
hold off
legend(gca,[p1a],{'Sobol'},...
    'location','northeast','interpreter','latex','FontSize',16);
xlim([0 1]);
ylim([0 1]);
xticks([0 0.2 0.4 0.6 0.8 1])
yticks([0 0.2 0.4 0.6 0.8 1])

splt3 = subplot(1,3,3);
box(splt3,'on');
hold on
p1c = scatter(Xhal(101:end,1),Xhal(101:end,2),'magenta');
hold off
legend(gca,[p1c],{'Halton'},...
    'location','northeast','interpreter','latex','FontSize',16);
xlim([0 1]);
ylim([0 1]);
xticks([0 0.2 0.4 0.6 0.8 1])
yticks([0 0.2 0.4 0.6 0.8 1])

set(gcf,'color','w');
set(h, 'Position', [100 0 1000 250])
print(h, 'lds2.eps', '-depsc2','-r300')
print(h, 'lds2.jpg', '-djpeg','-r300')
savefig(h,'lds2.fig')
% 
% %Plot
% h2 = figure
% splt2 = subplot(3,1,1);
% box(splt2,'on');
% hold on
% p1b = scatter(Xrdn(:,1),Xrdn(:,2),'b');
% hold off
% legend(gca,[p1b],{'Random'},...
%     'location','northeast','interpreter','latex','FontName','Times New Roman','FontSize',16);
% xlim([0 1]);
% ylim([0 1]);
% splt1 = subplot(3,1,2);
% box(splt1,'on');
% hold on
% p1a = scatter(Xsob(:,1),Xsob(:,2),'r');
% hold off
% legend(gca,[p1a],{'Sobol'},...
%     'location','northeast','interpreter','latex','FontName','Times New Roman','FontSize',16);
% xlim([0 1]);
% ylim([0 1]);
% splt3 = subplot(3,1,3);
% box(splt3,'on');
% hold on
% p1c = scatter(Xhal(:,1),Xhal(:,2),'magenta');
% hold off
% legend(gca,[p1c],{'Halton'},...
%     'location','northeast','interpreter','latex','FontName','Times New Roman','FontSize',16);
% xlim([0 1]);
% ylim([0 1]);
% set(gcf,'color','w');
% set(gca,'fontsize',16);
% set(h2, 'Position', [100 0 250 800])
% print(h2, 'lds2v.eps', '-depsc2','-r600')
% print(h2, 'lds2v.jpg', '-djpeg','-r600')
% savefig(h2,'lds2v.fig')