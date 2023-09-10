function vector = gen_proj_vec(app, dir, interval_theta, interval_phi, toggle_print)
% Generate projection vectors according to spherical coordinate system (r, theta, phi), r = 1, theta in [0, pi], phi in [0, pi]
% 
% Input Argument
% app:            mlapp object
% dir:            output directory
% interval_theta: the number of equal theta intervals
% interval_phi:   the number of equal phi intervals
% toggle_print:   if true, print projection vectors
% 
% Output Argument
% vector:         projection vector

    anlge_theta = 0.0:pi/interval_theta:pi;
    anlge_phi = 0.0:pi/interval_phi:pi;
    vector = cell(length(anlge_theta) * (length(anlge_phi) - 2), 1);
    
    % Axial vectors - Cartesian coordinate
    for i = 1:3
        if i == 1 % along x-axis
            vector{i, 1} = [1.0; 0.0; 0.0];
        elseif i == 2 % along y-axis
            vector{i, 1} = [0.0; 1.0; 0.0];
        elseif i == 3 % along z-axis
            vector{i, 1} = [0.0; 0.0; 1.0];
        end
    end
    
    % Spatial vectors
    i = 4;
    for j = 2:length(anlge_phi) - 1
        for k = 1:length(anlge_theta)
            if anlge_phi(j) ~= pi/2 || (anlge_theta(k) ~= 0 && anlge_theta(k) ~= pi/2 && anlge_theta(k) ~= pi) % Exclude repeated or axial vectors
                vector{i, 1} = [sin(anlge_phi(j)) * cos(anlge_theta(k)); sin(anlge_phi(j)) * sin(anlge_theta(k)); cos(anlge_phi(j))];
                i = i + 1;
            end
        end
    end
    
    vis_proj_vec(app, vector);

    if toggle_print
        print_proj_vec(dir, vector);
    end
end

function vis_proj_vec(app, vector)
% Visualize projection vectors
    
    % Generate the unit sphere
    [x, y, z] = sphere;
    
    % Adjust x, y, z to represent half-sphere where theta is in [0, pi]
    y(y < 0) = NaN;
    surf(app.UIAxes, x, y, z, 'EdgeColor', 'none', 'FaceAlpha', 0.4); 
    
    axis(app.UIAxes, 'equal');
    hold(app.UIAxes, 'on');
    
    % Define colormap
    colormap(app.UIAxes, jet(256));
    cLimLow = -1;  % Define lower limit
    cLimHigh = 1;  % Define upper limit
    caxis(app.UIAxes, [cLimLow cLimHigh]);
    
    % Plot the projection vectors as arrows
    for i = 1:length(vector)
        vec = vector{i, :};
        if i <= 3
            quiver3(app.UIAxes, 0, 0, 0, vec(1), vec(2), vec(3), 0, 'Color', [0 0 0], 'LineWidth', 2.0, 'MaxHeadSize', 0.5);
        else % Determine the color based on the Z value of the vector
            normVal = (vec(3) - cLimLow) / (cLimHigh - cLimLow);  % Normalize the Z value between 0 and 1
            colorIndex = max(1, min(256, round(normVal * 255 + 1)));  % Convert normalized value to an index between 1 and 256
            arrowColor = app.UIAxes.Colormap(colorIndex, :);
            quiver3(app.UIAxes, 0, 0, 0, vec(1), vec(2), vec(3), 0, 'Color', arrowColor, 'LineWidth', 1.5, 'MaxHeadSize', 0.5);
        end
    end
    
    title(app.UIAxes, 'Projection Vectors', 'HorizontalAlignment', 'center', 'FontSize', 11);
    xlabel(app.UIAxes, 'x/mm');
    ylabel(app.UIAxes, 'y/mm');
    zlabel(app.UIAxes, 'z/mm');
    grid(app.UIAxes, 'on');
    view(app.UIAxes, 145, 22.5); % 3D view
    
    % Release the plot for new drawings
    hold(app.UIAxes, 'off');
end

function print_proj_vec(dir, vector)
% Print projection vectors

    outp_file = fopen([dir, 'projection vectors.out'], 'wt');
    fprintf(outp_file, '%32s\n', 'Projection Vectors');
    
    for i = 1:numel(vector)
        for j = 1:3
            fprintf(outp_file, '%10.7f %10.7f %10.7f\n', vector{i, 1}(j, :));
        end
        fprintf(outp_file,'\n');
    end
    
    fclose(outp_file);
end