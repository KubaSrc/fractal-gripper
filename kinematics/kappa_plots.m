close all; clc; clear all;

% Plotting parameters
n = 0:1:5;
s_c = 0.5;
w0 = 5;
h0 = w0./s_c;
sigma = atan(w0./(2.*h0));
e = 10.^-1.25;

% Sweep of sl
sl = [0.25;.3;.45];

% Matricies to store values
H = zeros([length(sl),length(n)]);
W = zeros([length(sl),length(n)]);
Wn = zeros([length(sl),length(n)]);
X = zeros([length(sl),length(n)]);
Y = zeros([length(sl),length(n)]);
L = zeros([length(sl),length(n)]);
PSI = zeros([length(sl),length(n)]);

% Initialize values
H(:,1) = h0; % n = 0
W(:,1) = w0; % n = 0
Wn(:,1) = w0; % n = 0
X(:,2) = h0; % n = 1
Y(:,2) = 0;  % n = 1
PSI(:,2) = 0; % n = 1

% Our output results
R_min = zeros([length(sl),length(n)]);

% Calculate R min for all sl
for i = 1:length(sl)
    for j = 1:length(n)

        % Calculate suction width
        if j > 1
            Wn(i,j) = (s_c.*sl(i).^(j-1)).*h0;
            H(i,j) = H(i,j-1).*sl(i);
            W(i,j)= W(i,j-1).*sl(i);
        end

        % R_min based on epsilon
        epsilon = Wn(i,j)*e;
        R_e = (Wn(i,j).^2 + 4.*epsilon.^2) ./ (8.*epsilon);
       
        % R_min based on geometry
        % Box dims after (n > 1)
        if j > 2
            X(i,j) = X(i,j-1) - 2.*L(i,j-1).*cos(sigma-PSI(i,j-1));
            Y(i,j) = Y(i,j-1) + 2.*L(i,j-1).*sin(sigma-PSI(i,j-1));
            PSI(i,j) = atan(Y(i,j)/X(i,j));
        end

        % Calculate geometry
        if j > 1
            L(i,j) = sqrt(H(i,j).^2+(W(i,j)./2).^2);
            R_g = (sqrt(X(i,j).^2+Y(i,j).^2)./2) + H(i,j) - epsilon;

        else
            R_g = 0;
        end
        
        % Radius is constrained by largest value
        R_min(i,j) = max(R_g,R_e);
    end
end

% Create figure
figure(1); clf;
map = brewermap(3, 'Set1');

ax = gca; % Get current axes
ax.FontSize = 10; % Set font size
set(gca, 'FontName', 'Times New Roman');
ax.LineWidth = 1.5; % Set axes line width

% Plot out data
semilogy(n, (w0./R_min(1,:)), 'o:', 'lineWidth', 2.5, 'Color', map(:,1), 'MarkerSize', 4, 'MarkerFaceColor', map(:,1), 'MarkerEdgeColor', map(:,1), 'Marker', 'diamond');
hold on;
semilogy(n, (w0./R_min(2,:)), 'o:', 'lineWidth', 2.5, 'Color', map(:,2), 'MarkerSize', 3, 'MarkerFaceColor', map(:,2), 'MarkerEdgeColor', map(:,2), 'Marker', '^');
semilogy(n, (w0./R_min(3,:)), 'o:', 'lineWidth', 2.5, 'Color', map(:,3), 'MarkerSize', 3, 'MarkerFaceColor', map(:,3), 'MarkerEdgeColor', map(:,3), 'Marker', 'o');

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