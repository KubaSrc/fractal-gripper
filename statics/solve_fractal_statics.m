function [F_g, r, F_f, Mb] = solve_fractal_statics(varargin)

    % INPUTS: optional - none: returns symbolic solution. struct: subs in numeric values and iteratively solves based on failure conditions
    %
    % OUTPUTS: F_g: payload r: Vacuum force distance F_f: friction force

    % Initialize default values
    values = struct();
    verbose = false;

    % Process input arguments
    for i = 1:length(varargin)
        if isstruct(varargin{i})
            values = varargin{i};
        elseif islogical(varargin{i})
            verbose = varargin{i};
        else
            error('Invalid input type.');
        end
    end

    % Check if values for substitution are provided
    substituteValues = ~isempty(fieldnames(values));

    % Symbolic parameters variables
    syms F_v F_f F_g Mb r h w s theta

    % Intermediate calculations
    x = s*w/2;
    alpha = atan2(h,x);
    phi = alpha + (theta/2) - pi/2;
    zeta = phi + atan2(x,h);

    % Sum of forces and moments based on FBDs
    M_pin = -F_f.*h + F_v.*r + Mb == 0;
    F_x = F_v.*cos(zeta) - F_f.*sin(zeta) == 0;
    F_y_block = 2.*F_v.*sin(theta/2) + 2.*F_f.*cos(theta/2) - F_g == 0;

    % Sub in numerical values
    M_pin = subs(M_pin,values);
    F_x = subs(F_x,values);
    F_y_block = subs(F_y_block,values);

    if ~substituteValues
        % Solve equation
        sol = solve([M_pin, F_y_block, F_x], [F_g, F_f, Mb],'ReturnConditions',true);
        
        % Store answer
        F_g = sol.F_g;
        F_f = sol.F_f;
        Mb = sol.Mb; 

    % Iterative solution based on inputs and failure conditions
    else
        
        if verbose
            fprintf('[Solver]: Finding solution based on paramters...\n');
        end

        solved = false;

        % Look for an initial solution
        if values.Mb_max > 0
            sol = solve([M_pin, F_y_block, F_x], [F_g, F_f, Mb],'ReturnConditions',true);
            sol.r = 0;
            values.r = 0;
        else
            sol = solve([M_pin, F_y_block, F_x], [F_g, F_f, r],'ReturnConditions',true);
            sol.Mb = 0;
            values.Mb = 0;
        end

        % Evaluate initial solution
        F_g_temp = double(subs(sol.F_g, values));
        F_f_temp = double(subs(sol.F_f, values));
        Mb_temp = double(subs(sol.Mb, values));
        r_temp = double(subs(sol.r, values));


        % Define max bounds
        r_max = double(subs(x, values));
        F_f_max = min(values.F_v * values.mu,(values.Mb_max+values.F_v.*r_max)/values.h);

        % Evaluate our analytical solutions with failure criterion
        while ~solved

            updated = false;

            % Setup new equations
            M_pin_temp = subs(M_pin,values);
            F_x_temp = subs(F_x,values);
            F_y_block_temp = subs(F_y_block,values);

            % Setup arrays for solver
            eq_array = [F_y_block_temp];
            var_array = [F_g];

            % Check slip criterion
            if abs(F_f_temp) < F_f_max
                eq_array = [eq_array,F_x_temp];
                var_array = [var_array,F_f];
            elseif abs(F_f_temp) > F_f_max
                if verbose
                    fprintf('Slip criterion exceeded. Setting F_f = F_f_max\n');
                end
                updated = true;
                values.F_f = F_f_max.*sign(F_f_temp);
                F_f_temp = F_f_max.*sign(F_f_temp);
            end

            % Check if brakes are at max load
            if abs(Mb_temp) < values.Mb_max
                eq_array = [eq_array,M_pin_temp];
                var_array = [var_array,Mb];
                % If brakes are not fully loaded, we assume r = 0
                r_temp = 0;
                values.r = 0;
            elseif abs(Mb_temp) > values.Mb_max
                if verbose
                    fprintf('Brakes reached max load. Setting Mb = Mb_max\n');
                end
                updated = true;
                values.Mb = values.Mb_max.*sign(Mb_temp);
                Mb_temp = values.Mb_max.*sign(Mb_temp);
            end
            
            % If brakes are fully loaded, we now solve for r
            if abs(Mb_temp) == values.Mb_max && abs(r_temp) < r_max
                values.r = r;
                M_pin_temp = subs(M_pin,values);
                eq_array = [eq_array,M_pin_temp];
                var_array = [var_array,r];

            % We also check if we reached peel criterion
            elseif ~updated && abs(Mb_temp) == values.Mb_max && abs(r_temp) > r_max
                if verbose
                    fprintf('Peel criterion reached. Setting r = r_max\n');
                end
                updated = true;
                values.r = r_max.*sign(r_temp);
                r_temp = r_max.*sign(r_temp);
            end

            % Solve our system of equations
            sol = solve(eq_array,var_array);
            
            % Check if 'sol' has a field 'F_g'
            if isfield(sol, 'F_g')
                F_g_temp = double(subs(sol.F_g, values));
            else
                % If 'sol' does not have 'F_v', we assume it's a single solution in 'sol.val'
                F_g_temp = double(subs(sol, values));
            end

            % Pull out friction if applicable
            if ismember(F_f,var_array)
                F_f_temp = double(subs(sol.F_f, values));
            end

            % Pull out Mb if applicable
            if ismember(Mb,var_array)
                Mb_temp = double(subs(sol.Mb, values));
            end

            % Pull out r if applicable
            if ismember(r,var_array)
                r_temp = double(subs(sol.r, values));
            end

            % Only solved when no failure condition is met
            if abs(r_temp) <=  r_max && abs(F_f_temp) <= F_f_max && abs(Mb_temp) <= values.Mb_max
                solved = true;
                F_g = F_g_temp;
                r = r_temp;
                F_f = F_f_temp;
                Mb = Mb_temp;
            end

        end

    end

    % Check for empty solution.
    if (isempty(F_g) || isempty(r) || isempty(F_f)) && verbose
        fprintf('\n Unable to find solution for given inputs!');
    end

end