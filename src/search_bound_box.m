function [corner, proj_plane, p_tran] = search_bound_box(v1_basic, p)
% Search the bounding box according to a specific projection direction
% 
% Input Argument
% v1_basic:   projection vector along 1-axis direction
% p:          points
% 
% Output Argument
% corner:     corner points of the bounding box
% proj_plane: projection plane, perpendicular to v1_basic
% p_tran:     transformated points on the projection plane

    % Calculate the projection matrix to the 23-plane
    v1_norm = v1_basic / norm(v1_basic);
    
    if v1_basic(3, 1) ~= 0.0
        v2_temp_basic = [1.0; 1.0; -(v1_basic(1, 1) + v1_basic(2, 1)) / v1_basic(3, 1)];
    elseif v1_basic(2, 1) ~= 0.0 && v1_basic(1, 1) ~= 0.0
        v2_temp_basic = [0.0; 0.0; 1.0];
    elseif v1_basic(2, 1) == 0.0 && v1_basic(1, 1) ~= 0.0
        v2_temp_basic = [0.0; 1.0; 1.0];
    elseif v1_basic(2, 1) ~= 0.0 && v1_basic(1, 1) == 0.0
        v2_temp_basic = [1.0; 0.0; 1.0];
    end
    v2_temp_norm = v2_temp_basic / norm(v2_temp_basic);
    
    v3_temp_basic = cross(v1_basic, v2_temp_basic);
    v3_temp_norm = v3_temp_basic / norm(v3_temp_basic);
    
    v1_plane23 = [v2_temp_norm v3_temp_norm];
    mat_proj = (v1_plane23 * ((v1_plane23)' * v1_plane23)^(-1) * (v1_plane23)')';
    
    % Project point cloud to 23-plane
    p_proj = ones(length(p(:, 1)), 3);
    for i = 1:length(p(:, 1))
        p_proj(i, :) = p(i, :) * mat_proj;
    end
    
    % Find a pair points on the 23-plane with farthest distance, taken their connection line as the 2-axis direction
    [p_1, p_2] = search_farthest_point_pair(p_proj);
    v2_basic = (p_2 - p_1)';
    v2_norm = v2_basic / norm(v2_basic);

    % Calculate the 3-axis direction based on the 1- and 2-axis directions
    v3_basic = cross(v1_norm, v2_norm);
    v3_norm = v3_basic / norm(v3_basic);
    
    % Calculate the corner points of the bounding box
    mat_tran = (([v1_norm, v2_norm, v3_norm])')^(-1);
    p_tran = ones(length(p(:, 1)), 3);
    for i = 1:length(p(:,1))
        p_tran(i, :) = p(i, :) * mat_tran;
    end
    
    limit = [min(p_tran(:, 1)), min(p_tran(:, 2)), min(p_tran(:, 3));
             max(p_tran(:, 1)), max(p_tran(:, 2)), max(p_tran(:, 3));];
    
    corner_tran = [limit(1, 1), limit(1, 2), limit(1, 3);
                   limit(2, 1), limit(1, 2), limit(1, 3);
                   limit(2, 1), limit(2, 2), limit(1, 3);
                   limit(1, 1), limit(2, 2), limit(1, 3);
                   limit(1, 1), limit(1, 2), limit(2, 3);
                   limit(2, 1), limit(1, 2), limit(2, 3);
                   limit(2, 1), limit(2, 2), limit(2, 3);
                   limit(1, 1), limit(2, 2), limit(2, 3);];

    corner = corner_tran/mat_tran; % Corner points

    proj_plane = [ones(8, 1) * corner_tran(1, 1), corner_tran(:, 2), corner_tran(:, 3)]/mat_tran; % Projection plane (23-plane)
end
