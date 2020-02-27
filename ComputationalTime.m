%Plot figures
h(2) = figure;
fs = 11;
set(gcf,'numbertitle','off','name','N vs sensor cost')
% subplot(2,1,1);
box on
grid off
set(gcf,'color','w');
x = categorical({'Small','Medium','Lar3ge','Extr2a Large','Larg3e','Extr3a Large'});
x = reordercats(x,{'Small','Medium','Lar3ge','Extr2a Large','Larg3e','Extr3a Large'});
%y = [mean_total_cost_cus(:) sensor_cost_std(:) sensor_cost_std_2(:)];
y = [ 1 2 3 ;
    1 2 3 ;
    1 2 3 ;
    1 2 3 ;
    1 2 3 ;
    1 2 3 ;
    ];
h1 = bar(x,y);
% xlim([0 max(max(mean_total_cost_cus))+1]);
%xlim([3 32]);
%ylim([0 max([max(mean_total_cost_cus) max(senssor_cost_std)])+2]);
xlabel('$N$', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
ylabel('$\mathbf{1}^{\top}\mathbf{\gamma}$', 'interpreter','latex','FontName','Times New Roman','FontSize',fs);
l = cell(1,2);
l{1}='S-BnB'; l{2}='$\ell_1$ Relaxation 1'; l{3}='$\ell_1$ Relaxation 2';
set(gca,'fontsize',fs);
% set(leg1,'Interpreter','latex');
% title('CH-BnB', 'FontSize', 10);
legend(h1,l,'Location','northwest','FontSize',9,'Interpreter','latex');
legend boxoff;
set(h(2), 'Position', [300 200 450 180])
print(h(2), 'assessment_4_cost.eps', '-depsc2','-r600')
saveas(h(2),'assessment_4_cost.png')