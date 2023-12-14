close all; clc; clear all;

% Plotting parameters
n = 1:1:5;
s_c = 0.5;
w0 = 5;
h0 = w0./s_c;

% Calculate the cup width
sl = [0.4;.6;.8];
R_min = zeros([length(sl),length(n)+1]);

% Calculate R min for all sl
for i = 1:length(sl)
    wn = [w0,(s_c.*sl(i).^(n)).*h0];
    epsilon = wn*10^-2;
    R = (wn.^2 + 4.*epsilon.^2) ./ (8.*epsilon);
    R_min(i,:) = R;
end


% Create figure
figure(1); clf;
map = brewermap(3, 'Set1');

ax = gca; % Get current axes
ax.FontSize = 10; % Set font size
set(gca, 'FontName', 'Times New Roman');
ax.LineWidth = 1.5; % Set axes line width

% Plot out data
semilogy([0,n], (w0./R_min(1,:)), 'o:', 'lineWidth', 2.5, 'Color', map(:,1), 'MarkerSize', 4, 'MarkerFaceColor', map(:,1), 'MarkerEdgeColor', map(:,1), 'Marker', 'diamond');
hold on;
semilogy([0,n], (w0./R_min(2,:)), 'o:', 'lineWidth', 2.5, 'Color', map(:,2), 'MarkerSize', 3, 'MarkerFaceColor', map(:,2), 'MarkerEdgeColor', map(:,2), 'Marker', '^');
semilogy([0,n], (w0./R_min(3,:)), 'o:', 'lineWidth', 2.5, 'Color', map(:,3), 'MarkerSize', 3, 'MarkerFaceColor', map(:,3), 'MarkerEdgeColor', map(:,3), 'Marker', 'o');

grid on;
hold off; % Release the hold after plotting

% legend(["S_c = 0.25",])
% s.SizeData = 150;
% s.Marker = "diamond";

set(gcf, 'Units', 'inches'); % Set the units of the figure to inches
set(gcf, 'Position', [1, 1, 2.75, 2.25]);

% Define ticks
xlim([0,5])
xticks(0:1:5)


%exportgraphics(gcf,'../figures/kappa.png','Resolution',300)