close all; clear all; clc

% Define fractal parameters
sl = .5;
sc = 1;
h0 = 50;
w0 = 100;
n = 2;

% Determine the suction cup width
if n == 0
    wn = w0;
elseif n > 0
    wn = (sc.*sl.^(n)).*h0;
end

epsilon = wn*10^-(1.3);

find_min_radius(w0, h0, sc, sl, n, wn, epsilon);

%% Function to find minimum radius
function find_min_radius(w0, h0, sc, sl, n, wn, epsilon)
    
    % Line widths
    tri_line = 3.5;
    arc_line = 4;
    circ_line = 3;
    dotted_line = 3;
    link_line = 2.5;

    % View ratio
    vr = 0.65;

    % Calculate the radius directly
    R_min = (wn^2 + 4*epsilon^2) / (8*epsilon)

    % Function to find the minimum radius of curvature and plot two suction cups connected by a line w0
    if n == 0
    
        h0 = w0./sc;

        % Define the circle
        theta = linspace(0, 2*pi, 1000);
        x_circle = R_min * cos(theta);
        y_circle = R_min * sin(theta);
    
        % Define the first suction cup
        x_triangle = [-wn/2, wn/2, 0];
        y_triangle = [R_min-epsilon, R_min-epsilon, R_min-epsilon+h0];
    
        % Define the arc length
        % The arc is centered at the top of the circle (theta = pi/2)
        theta_arc_start = pi/2 - asin(wn/(2*R_min));
        theta_arc_end = pi/2 + asin(wn/(2*R_min));
        theta_arc = linspace(theta_arc_start, theta_arc_end, 100);
        x_arc = R_min * cos(theta_arc);
        y_arc = R_min * sin(theta_arc);
    
        % Plotting
        figure; clf; hold on; axis off;
        set(gcf, 'Color', 'white'); % Set the color of the current figure to white
        
        % Plot and fill the triangle with a dotted base line
        fill(x_triangle, y_triangle, [173/256 216/256 230/256], 'EdgeColor', 'black','lineWidth',tri_line); % Light blue fill, black edge
        
        % Plot dotted line at base of triangle
        plot([x_triangle(1),x_triangle(2)],[y_triangle(1),y_triangle(2)],'k:','lineWidth',tri_line)

        % Plot and fill the circle
        fill(x_circle, y_circle, [0.8 0.8 0.8], 'EdgeColor', 'black','lineWidth',circ_line);

        % Plot the arc length where the suction cup meets the circle
        plot(x_arc, y_arc, 'g-', 'LineWidth', arc_line);

        % Dotted base line
        plot(x_triangle(1:2), y_triangle(1:2), 'k:','lineWidth',dotted_line);
        
        % Set plot limits and labels
        axis equal;
        xlim([-w0.*vr,w0.*vr]);
        ylim([R_min-(w0.*vr),R_min+(w0.*vr)])

        hold off;

    elseif n == 1
    
        hn = wn./sc;

        % Angle theta for the large triangle
        theta = asin(w0 / (2 * (R_min + hn - epsilon)));
    
        % Define the first suction cup
        x_triangle0 = [-wn/2, wn/2, 0];
        y_triangle0 = [R_min-epsilon, R_min-epsilon, R_min-epsilon+hn];

        % Define the arc length
        % The arc is centered at the top of the circle (theta = pi/2)
        theta_arc_start = pi/2 - asin(wn/(2*R_min));
        theta_arc_end = pi/2 + asin(wn/(2*R_min));
        theta_arc = linspace(theta_arc_start, theta_arc_end, 100);
        x_arc0 = R_min * cos(theta_arc);
        y_arc0 = R_min * sin(theta_arc);
    
        % Define the second suction cup (rotated by theta around the circle)
        x_triangle1 = x_triangle0 * cos(theta) - y_triangle0 * sin(theta);
        y_triangle1 = x_triangle0 * sin(theta) + y_triangle0 * cos(theta);
        x_arc1 = x_arc0 *cos(theta) - y_arc0* sin(theta);
        y_arc1 = x_arc0 * sin(theta) + y_arc0 * cos(theta);
    
        % Define the second suction cup (rotated by 2*theta around the circle)
        x_triangle2 = x_triangle0 * cos(-theta) - y_triangle0 * sin(-theta);
        y_triangle2 = x_triangle0 * sin(-theta) + y_triangle0 * cos(-theta);
        x_arc2 = x_arc0 *cos(-theta) - y_arc0* sin(-theta);
        y_arc2 = x_arc0 * sin(-theta) + y_arc0 * cos(-theta);
    
        % Connecting line (w0) between the tops of the triangles
        x_line_w0 = [x_triangle1(3), x_triangle2(3)];
        y_line_w0 = [y_triangle1(3), y_triangle2(3)];
    
        % Plotting
        figure; clf; hold on; axis off;
        set(gcf, 'Color', 'white'); % Set the color of the current figure to white
    
        % Plot the first suction cup
        fill(x_triangle1, y_triangle1, [173/256 216/256 230/256], 'EdgeColor', 'black','lineWidth',tri_line); % Light blue fill, black edge
    
        % Plot the second suction cup
        fill(x_triangle2, y_triangle2, [173/256 216/256 230/256], 'EdgeColor', 'black','lineWidth',tri_line); % Light blue fill, black edge
    
        % Plot the circle
        theta_circle = linspace(0, 2*pi, 1000);
        x_circle = R_min * cos(theta_circle);
        y_circle = R_min * sin(theta_circle);
        fill(x_circle, y_circle, [0.8 0.8 0.8], 'EdgeColor', 'black','lineWidth',circ_line); % Light gray fill, black edge
    
        plot(x_arc1, y_arc1, 'g-', 'LineWidth', arc_line);
        plot(x_arc2, y_arc2, 'g-', 'LineWidth', arc_line);

        % Set plot limits and labels
        axis equal;
        xlim([-w0.*vr,w0.*vr]);
        ylim([R_min-(w0.*vr),R_min+(w0.*vr)])
    
        hold off;

    elseif n == 2
    
        % Scaled triangle sizes
        h1 = h0.*sl;
        w1 = w0.*sl;
        h2 = h1.*sl;

        theta2 = asin((w1/2)/(R_min+h2));
        y = (R_min+h2).*cos(theta2);
        theta1 = asin((w0/2)/(y+h1));

        % Define the first suction cup
        x_triangle0 = [-wn/2, wn/2, 0];
        y_triangle0 = [R_min-epsilon, R_min-epsilon, R_min-epsilon+h2];

        % Define the arc length
        % The arc is centered at the top of the circle (theta = pi/2)
        theta_arc_start = pi/2 - asin(wn/(2*R_min));
        theta_arc_end = pi/2 + asin(wn/(2*R_min));
        theta_arc = linspace(theta_arc_start, theta_arc_end, 100);
        x_arc0 = R_min * cos(theta_arc);
        y_arc0 = R_min * sin(theta_arc);
    
        % Define the second suction cup (rotated by theta around the circle)
        theta = theta1+theta2;
        x_triangle1 = x_triangle0 * cos(theta) - y_triangle0 * sin(theta);
        y_triangle1 = x_triangle0 * sin(theta) + y_triangle0 * cos(theta);
        x_arc1 = x_arc0 *cos(theta) - y_arc0* sin(theta);
        y_arc1 = x_arc0 * sin(theta) + y_arc0 * cos(theta);
   
        % Define the second suction cup (rotated by 2*theta around the circle)
        theta = theta1-theta2;
        x_triangle2 = x_triangle0 * cos(theta) - y_triangle0 * sin(theta);
        y_triangle2 = x_triangle0 * sin(theta) + y_triangle0 * cos(theta);
        x_arc2 = x_arc0 *cos(theta) - y_arc0* sin(theta);
        y_arc2 = x_arc0 * sin(theta) + y_arc0 * cos(theta);
    

        x_test = (R_min+h2) * sin(theta2);
        disp(2.*x_test)
        disp(w0*sl)


        % Plotting
        figure; clf; hold on; axis off;
        set(gcf, 'Color', 'white'); % Set the color of the current figure to white
    
        % Plot the first suction cup
        fill(x_triangle1, y_triangle1, [173/256 216/256 230/256], 'EdgeColor', 'black','lineWidth',tri_line); % Light blue fill, black edge
    
        % Plot the second suction cup
        fill(x_triangle2, y_triangle2, [173/256 216/256 230/256], 'EdgeColor', 'black','lineWidth',tri_line); % Light blue fill, black edge
    
        % Plot the first suction cup
        fill(-x_triangle1, y_triangle1, [173/256 216/256 230/256], 'EdgeColor', 'black','lineWidth',tri_line); % Light blue fill, black edge
    
        % Plot the second suction cup
        fill(-x_triangle2, y_triangle2, [173/256 216/256 230/256], 'EdgeColor', 'black','lineWidth',tri_line); % Light blue fill, black edge
    

        % Plot the circle
        theta_circle = linspace(0, 2*pi, 1000);
        x_circle = R_min * cos(theta_circle);
        y_circle = R_min * sin(theta_circle);
        fill(x_circle, y_circle, [0.8 0.8 0.8], 'EdgeColor', 'black','lineWidth',circ_line); % Light gray fill, black edge
    
        plot(x_arc1, y_arc1, 'g-', 'LineWidth', arc_line);
        plot(x_arc2, y_arc2, 'g-', 'LineWidth', arc_line);

        plot(-x_arc1, y_arc1, 'g-', 'LineWidth', arc_line);
        plot(-x_arc2, y_arc2, 'g-', 'LineWidth', arc_line);

        % Set plot limits and labels
        axis equal;
        xlim([-w0.*vr,w0.*vr]);
        ylim([R_min-(w0.*vr),R_min+(w0.*vr)])


        hold off;
    end
end
