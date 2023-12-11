n = 0:1:5;
s = 0.5;
w0 = 5;

wn = (s.^n).*w0;
epsilon = wn*10^-2;

R_min = (wn.^2 + 4.*epsilon.^2) ./ (8.*epsilon);
Kappa = 1./R_min;

figure(1); clf; hold on; grid on;

ax = gca; % Get current axes
ax.FontSize = 16; % Set font size
ax.LineWidth = 1.5; % Set axes line width

plot(n,w0./R_min,'o:','lineWidth',3,'Color','#6280C2','MarkerSize',5,'MarkerFaceColor','#6280C2','MarkerEdgeColor','#6280C2')

ylabel('w_0 / R_{min}','FontName','Times New Roman','fontSize',20)
xlabel("Number of branches",'FontName','Times New Roman','fontSize',20)

xlim([0,5])
xticks(0:1:5)

%exportgraphics(gcf,'../figures/kappa.png','Resolution',300)