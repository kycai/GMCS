function proj_result = gen_proj_geo(app, name, dir, proj_vec, p, alpha_radius, interval_theta, interval_phi, toggle_visual)
% Generate the spatial projection of point cloud
% 
% Input Argument
% app:            mlapp object
% name:           file name
% dir:            output directory
% proj_vec:       projection vector
% p:              points (coordinates)
% alpha_radius:   alpha radius for generating alpha shape
% interval_theta: the number of equal theta intervals
% interval_phi:   the number of equal phi intervals
% toggle_visual:  if True, plot projection geometries
% 
% Output Argument
% proj_result:    projection result, including area and perimeter of projected shape, length and width of bounding box

    if toggle_visual
        sz=get(0, 'screensize');
        comb_fig = figure('Name', 'Spatial projection', 'outerposition', sz);
    end

    proj_result = cell(1, 4 * (numel(app.proj_vec)));
    for i = 1:length(proj_vec)

        tic;
        
        % Calculate the projected points on 23-plane perpendicular to v1
        v1_basic = proj_vec{i, 1};
        [corner, proj_plane, p_tran] = search_bound_box(v1_basic, p);
        
        % Calculate the dimensions of the projected shape
        area_dim = [0.0, norm(corner(2, :) - corner(3, :)), norm(corner(3, :) - corner(7, :))];
        area_dim_sort = sort(area_dim);
        area_dim_2 = area_dim_sort(3); % length, length >= width
        area_dim_1 = area_dim_sort(2); % width
        
        % Alpha shape the projected points
        alpha_shape = alphaShape(p_tran(:, 2), p_tran(:, 3), alpha_radius);
        shape_area = area(alpha_shape); % area
        shape_peri = perimeter(alpha_shape); % perimeter
        
        % Output result
        proj_result{1, 4 * (i - 1) + 1} = shape_area; % area
        proj_result{1, 4 * (i - 1) + 2} = shape_peri; % perimeter      
        proj_result{1, 4 * (i - 1) + 3} = area_dim_2; % length, length >= width
        proj_result{1, 4 * (i - 1) + 4} = area_dim_1; % width

        if toggle_visual
            subplot(interval_theta + 1, 2 * (interval_phi - 1), 1 + 2 * (i - 1), 'Parent', comb_fig);
            vis_proj_plane(v1_basic, p, proj_plane, corner, name, interval_theta, interval_phi)
            
            subplot(interval_theta + 1, 2 * (interval_phi - 1), 2 + 2 * (i - 1), 'Parent', comb_fig); 
            vis_proj_shape(p_tran, shape_area, shape_peri, area_dim_2, area_dim_1)
        end

        elapsedTime = toc;
        app.LogsTextArea.Value = [app.LogsTextArea.Value; sprintf('Vec %d proj \t %.2f s', i, elapsedTime)];
        drawnow;
    end
    
    if toggle_visual
        % Use sgtitle for figure-level title
        fig_title = [dir, name, ' - spatial projection.png'];
        %sgtitle(fig_title);
        print(comb_fig, fig_title, '-dpng', '-r300');
        close all;
    end
end

function vis_proj_plane(v1_basic, p, proj_plane, corner, name, interval_theta, interval_phi)
% Visualize the spatial projection

    % Compute the convex hull of the point set
    kpoint_idx = boundary(p(:, 1), p(:, 2), p(:, 3), 0.6);
    trisurf(kpoint_idx, p(:, 1), p(:, 2), p(:, 3), ...
            'FaceColor', [77/255.0, 51/255.0, 255/255.0], 'EdgeColor', 'none', ...
            'FaceAlpha', 1, 'EdgeAlpha', 0.0, ...
            'FaceLighting', 'flat', 'AmbientStrength', 0.2, 'DiffuseStrength', 0.7, 'SpecularStrength', 0.3);

    % Graphical settings
    light;
    lightangle(interval_theta * 180 + 30, interval_phi * 180);
    lighting('gouraud');
    
    hold('on');
    plotminbox(corner,'r');
    plotminbox(proj_plane, 'm');
    if v1_basic(1) == 0 &&  v1_basic(3) == 0
        kpoint_idx = boundary(proj_plane(:, 1), proj_plane(:, 3), 0.8);
    elseif v1_basic(1) == 0 &&  v1_basic(2) == 0
        kpoint_idx = boundary(proj_plane(:, 1), proj_plane(:, 2), 0.8);
    else
        kpoint_idx = boundary(proj_plane(:, 2), proj_plane(:, 3), 0.8);
    end
    fill3(proj_plane(kpoint_idx, 1), proj_plane(kpoint_idx, 2), proj_plane(kpoint_idx, 3), 'm', 'FaceAlpha', 0.3);
    
    %str1 = [name, '.asc'];
    str2 = ['Projection Vector: [', num2str(roundn((v1_basic(1))', -3)), ' ', num2str(roundn((v1_basic(2))', -3)), ' ', num2str(roundn((v1_basic(3))', -3)), ']^T'];
    plotTitle = str2; % [str1, newline, str2]
    title(plotTitle, 'HorizontalAlignment', 'center','FontSize',7);
    xlabel('x/mm');
    ylabel('y/mm');
    zlabel('z/mm');
    grid('on');
    axis('equal');
    view();
    hold('off');
end

function vis_proj_shape(p_tran, shape_area, shape_peri, area_dim_2, area_dim_1)
% Visualize the projected of alpha shape

    kpoint_idx = boundary(p_tran(:, 2), p_tran(:, 3), 0.8);
    fill(p_tran(kpoint_idx, 2), p_tran(kpoint_idx,3 ), 'm', 'FaceAlpha', 0.5, 'EdgeColor', 'k', 'LineWidth', 2);
    str1 = ['Area: ',num2str(roundn(shape_area, -1)),' mm^2, Perimeter: ',num2str(roundn(shape_peri, -1)),' mm'];
    str2 = ['Length: ',num2str(roundn(area_dim_2, -1)),' mm, Width: ',num2str(roundn(area_dim_1, -1)), ' mm'];
    plotTitle = [str1, newline, str2];
    title(plotTitle, 'HorizontalAlignment', 'center','FontSize',7);
    xlabel('Dim 1/mm');
    ylabel('Dim 2/mm');
    axis('equal');
    grid('on');
    view(2);
    hold('off');
end