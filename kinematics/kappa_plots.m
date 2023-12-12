n = 0:1:5;
s = 0.5;
w0 = 5;

wn = (s.^n).*w0;
epsilon = wn*10^-2;

R_min = (wn.^2 + 4.*epsilon.^2) ./ (8.*epsilon);
Kappa = 1./R_min;

figure(1); clf; hold on; grid on;

ax = gca; % Get current axes
ax.FontSize = 10; % Set font size
set(gca, 'FontName', 'Times New Roman');
ax.LineWidth = 1.5; % Set axes line width

plot(n,w0./R_min,'o:','lineWidth',2.5,'Color','#6280C2','MarkerSize',3,'MarkerFaceColor','#6280C2','MarkerEdgeColor','#6280C2')
set(gcf, 'Units', 'inches'); % Set the units of the figure to inches
set(gcf, 'Position', [1, 1, 2.75, 2.25]);


% ylabel('W_0 / R_{min}','FontName','Times New Roman','fontSize',16)
% xlabel("Number of layers",'FontName','Times New Roman','fontSize',16)

xlim([0,5])
xticks(0:1:5)

%exportgraphics(gcf,'../figures/kappa.png','Resolution',300)