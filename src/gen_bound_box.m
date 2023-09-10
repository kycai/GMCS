function [min_bd_1, min_bd_2, min_bd_3, max_bd_1, max_bd_2, max_bd_3] = gen_bound_box(file_name, dir, p, toggle_visual)
% Generate the minimal/maximal bounding box of point cloud
%
% Input Argument
% file_name:                    file name
% dir:                          output directory
% p:                            points (coordinates)
% toggle_visual:                if true, plot alpha shape
% 
% Output Argument
% min_bd_1, min_bd_2, min_bd_3: the boundary dimension of minimal bounding box
%                               min_bd_1 <= min_bd_2 <= min_bd_3
% max_bd_1, max_bd_2, max_bd_3: the boundary dimension of maximal bounding box
%                               max_bd_1 <= max_bd_2 <= max_bd_3

    % Minimal bounding box

    % Calculate the corner points of minimal bounding box
    [~, corner, ~, ~] = minboundbox(p(:, 1), p(:, 2), p(:, 3), 'v', 3);
    
    % Calculate the dimensions of minimal bounding box
    box_dim = [norm(corner(1, :) - corner(2, :)), norm(corner(2, :) - corner(3, :)), norm(corner(3, :) - corner(7, :))];
    box_dim_sort = sort(box_dim);
    min_bd_3 = box_dim_sort(3); % length, length >= width >= thickness
    min_bd_2 = box_dim_sort(2); % width
    min_bd_1 = box_dim_sort(1); % thickness

    if toggle_visual
        vis_bound_box(p, corner, file_name, dir, 'Min bound box', min_bd_3, min_bd_2, min_bd_1);
    end
    
    % Maximal bounding box

    % Find a pair of end points with largest distance as the 1-axis direction (projection direction)
    [v1_p1, v1_p2] = search_farthest_point_pair(p);
    v1_basic = (v1_p2 - v1_p1)';

    % Calculate the corner points of maximal bounding box
    [corner, ~, ~] = search_bound_box(v1_basic, corner);
    
    % Calculate the dimensions of maximal bounding box
    box_dim = [norm(corner(1, :) - corner(2, :)), norm(corner(2, :) - corner(3, :)), norm(corner(3, :) - corner(7, :))];
    box_dim_sort = sort(box_dim);
    max_bd_3 = box_dim_sort(3); % length, length >= width >= thickness
    max_bd_2 = box_dim_sort(2); % width
    max_bd_1 = box_dim_sort(1); % thickness

    if toggle_visual
        vis_bound_box(p, corner, file_name, dir, 'Max bound box', max_bd_3, max_bd_2, max_bd_1);
    end
end

function vis_bound_box(p, corner, name, dir, label, box_dim_3, box_dim_2, box_dim_1)
% Visualize the bounding box with corresponding alpha shape

    fig = figure('Name','Bounding box');

    % Compute the convex hull of the point set
    kpoint_idx = boundary(p(:, 1), p(:, 2), p(:, 3), 0.6);
    trisurf(kpoint_idx, p(:, 1), p(:, 2), p(:, 3), ...
           'FaceColor', [77/255.0, 51/255.0, 255/255.0], 'EdgeColor', 'none', ...
           'FaceAlpha', 1, 'EdgeAlpha', 0.0, ...
           'FaceLighting', 'flat', 'AmbientStrength', 0.2, 'DiffuseStrength', 0.7, 'SpecularStrength', 0.3);

    % Graphical settings
    light;
    lightangle(30, 45);
    lighting('gouraud');
    
    hold('on');
    plotminbox(corner,'r');
    
    str1 = [label, ' of ', name, '.asc'];
    str2 = ['Length: ', num2str(roundn(box_dim_3, -1)),' mm, Width: ',num2str(roundn(box_dim_2, -1)),' mm, Thickness: ',num2str(roundn(box_dim_1, -1)),' mm'];
    plot_title = [str1, newline, str2];
    title(plot_title,'HorizontalAlignment', 'center', 'FontSize', 11);
    xlabel('x/mm');
    ylabel('y/mm');
    zlabel('z/mm');
    grid('on');
    axis('equal');
    view();
    hold('off');

    fig_title = [dir, name, ' - ', lower(label), '.png'];
    print(fig, fig_title, '-dpng', '-r300');
    close all;
end
