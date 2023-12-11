
find_min_radius(w, h, epsilon, w0)


 function find_min_radius(w, h, epsilon, w0)
    % Function to find the minimum radius of curvature and plot two suction cups connected by a line w0

    % Calculate the radius directly
    R_min = (w^2 + 4*epsilon^2) / (8*epsilon);

    % Angle theta for the large triangle
    theta = asin(w0 / (2 * (R_min + h - epsilon)));
    
    % Define the first suction cup
    x_triangle0 = [-w/2, w/2, 0];
    y_triangle0 = [R_min-epsilon, R_min-epsilon, R_min-epsilon+h];

    % Define the second suction cup (rotated by 2*theta around the circle)
    x_triangle1 = x_triangle0 * cos(2*theta) - y_triangle0 * sin(2*theta);
    y_triangle1 = x_triangle0 * sin(2*theta) + y_triangle0 * cos(2*theta);

    % Define the second suction cup (rotated by 2*theta around the circle)
    x_triangle2 = x_triangle0 * cos(-2*theta) - y_triangle0 * sin(-2*theta);
    y_triangle2 = x_triangle0 * sin(-2*theta) + y_triangle0 * cos(-2*theta);
    
    % Connecting line (w0) between the tops of the triangles
    x_line_w0 = [x_triangle1(3), x_triangle2(3)];
    y_line_w0 = [y_triangle1(3), y_triangle2(3)];

    % Plotting
    figure;
    hold on;
    
    % Plot the circle
    theta_circle = linspace(0, 2*pi, 1000);
    x_circle = R_min * cos(theta_circle);
    y_circle = R_min * sin(theta_circle);
    fill(x_circle, y_circle, [0.8 0.8 0.8], 'EdgeColor', 'black'); % Light gray fill, black edge
    
    % Plot the first suction cup
    fill(x_triangle1, y_triangle1, [0.678 0.847 0.902], 'EdgeColor', 'black'); % Light blue fill, black edge
    
    % Plot the second suction cup
    fill(x_triangle2, y_triangle2, [0.678 0.847 0.902], 'EdgeColor', 'black'); % Light blue fill, black edge
    
    % Plot the connecting line w0
    plot(x_line_w0, y_line_w0, 'k-', 'LineWidth', 2); % Line w0
    
    % Set plot limits and labels
    axis equal;
    grid on;
    xlabel('X-axis');
    ylabel('Y-axis');
    title(sprintf('Dual Suction Cups on Circle (R = %.2f)', R_min));

    hold off;
end
