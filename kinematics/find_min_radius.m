


function find_min_radius(w, h, epsilon)
    % Function to find the minimum radius of curvature and plot

    % Calculate the radius directly
    R_min = (w^2 + 4*epsilon^2) / (8*epsilon);

    % Define the circle
    theta = linspace(0, 2*pi, 1000);
    x_circle = R_min * cos(theta);
    y_circle = R_min * sin(theta);

    % Define the triangle
    x_triangle = [-w/2, w/2, 0, -w/2];
    y_triangle = [R_min-epsilon, R_min-epsilon, R_min-epsilon+h, R_min-epsilon];

    % Define the arc length
    % The arc is centered at the top of the circle (theta = pi/2)
    % and spans an angle such that its endpoints are at the intersection with the triangle base
    theta_arc_start = pi/2 - asin(w/(2*R_min));
    theta_arc_end = pi/2 + asin(w/(2*R_min));
    theta_arc = linspace(theta_arc_start, theta_arc_end, 100);
    x_arc = R_min * cos(theta_arc);
    y_arc = R_min * sin(theta_arc);

    % Plotting
    figure;
    hold on;
    
    % Plot and fill the circle
    fill(x_circle, y_circle, [0.8 0.8 0.8], 'EdgeColor', 'black'); % Light gray fill, black edge
    
    % Plot and fill the triangle
    fill(x_triangle, y_triangle, [0.678 0.847 0.902], 'EdgeColor', 'black'); % Light blue fill, black edge
    
    % Plot the arc length where the suction cup meets the circle
    plot(x_arc, y_arc, 'g-', 'LineWidth', 3); % Green arc
    
    % Set plot limits and labels
    xlim([min(x_circle)-1, max(x_circle)+1]);
    ylim([min(y_circle)-1, h+1]);
    axis equal;
    grid on;
    xlabel('X-axis');
    ylabel('Y-axis');
    title(sprintf('Suction Cup and Circle (R = %.2f)', R_min));

    hold off;
end
