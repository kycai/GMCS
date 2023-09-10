function [p_cen, alpha_radius, shape_vol, shape_surf_area] = gen_alpha_shape(app, file_dir, file_name, toggle_visual)
% Generate alpha shapes based on the data cloud files
% 
% Input Argument
% app:             mlapp object
% file_dir:        directory of data cloud files
% file_name:       file name
% toggle_visual:   if true, plot alpha shape
% 
% Output Argument
% p_cen:           centralized points (coordinates)
% alpha_radius:    alpha radius for generating alpha shape
% shape_vol:       volume of the generated alpha shape
% shape_surf_area: surface area of the generated alpha shape

    % Original point coordinates
    p_ori = read_asc_file(file_dir, file_name);

    % Translate points to their geometric center
    p_avg = mean(p_ori);
    p_cen = p_ori - p_avg;
    
    % Find a pair of points with largest distance as the alpha radius
    [p_1, p_2] = search_farthest_point_pair(p_cen);
    
    % alpha shape the translated point clouds
    alpha_radius = norm((p_2 - p_1)')/2.0;
    shape = alphaShape(p_cen(:, 1), p_cen(:, 2), p_cen(:, 3), alpha_radius);
    shape_vol = volume(shape); % Volume
    shape_surf_area = surfaceArea(shape); % Surface area
    
    if toggle_visual
        vis_alpha_shape(app, p_cen, file_name, shape_vol, shape_surf_area)
    end
end

function p = read_asc_file(dir, file_name)
% Read point coordinates from .asc files
    
    [p_coord_1, p_coord_2, p_coord_3] = textread([dir, [file_name,'.asc']], '%s%s%s', 'headerlines', 2);
    p = ones(length(p_coord_1) - 1, 3);
    for i = 1:length(p_coord_1) - 1
        p(i, :) = [str2double(p_coord_1{i, 1}), str2double(p_coord_2{i, 1}), str2double(p_coord_3{i, 1})];
    end
end

function vis_alpha_shape(app, p, name, shape_vol, shape_surf_area)
% Visualize the point cloud and its corresponding alpha shape

    % Plot the point cloud
    scatter3(app.UIAxes, p(:, 1), p(:, 2), p(:, 3), '.');
    hold(app.UIAxes, 'on');
    
    % Compute the convex hull of the point set
    kpoint_idx = boundary(p(:, 1), p(:, 2), p(:, 3), 0.6);
    trisurf(kpoint_idx, p(:, 1), p(:, 2), p(:, 3), ...
            'FaceColor', [77/255.0, 51/255.0, 255/255.0], 'EdgeColor', 'none', ...
            'FaceAlpha', 1.0, 'EdgeAlpha', 0.0, ...
            'FaceLighting', 'flat', 'AmbientStrength', 0.2, 'DiffuseStrength', 0.7, 'SpecularStrength', 0.3, ...
            'Parent', app.UIAxes); % Specify Parent directly for clarity

    % Graphical settings
    light(app.UIAxes);
    lightangle(app.UIAxes, 30, 45);
    lighting(app.UIAxes, 'gouraud');
    
    % Annotations
    str1 = ['Alpha Shape of ', name, '.asc'];
    str2 = ['Volume: ', num2str(roundn(shape_vol, -1)), ' mm^3, SurfArea: ', num2str(roundn(shape_surf_area, -1)), ' mm^2'];
    plotTitle = [str1, newline, str2];
    title(app.UIAxes, plotTitle, 'HorizontalAlignment', 'center', 'FontSize', 11);
    xlabel(app.UIAxes, 'x/mm');
    ylabel(app.UIAxes, 'y/mm');
    zlabel(app.UIAxes, 'z/mm');
    grid(app.UIAxes, 'on');
    axis(app.UIAxes, 'equal');
    view(app.UIAxes);

    % Release the hold for new drawings
    hold(app.UIAxes, 'off');
    
    % Refresh the UIAxes to show the plots
    drawnow;
end