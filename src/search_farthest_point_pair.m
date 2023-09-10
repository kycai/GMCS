function [p_1, p_2] = search_farthest_point_pair(p)
% Search the point pair with the farthest distance in the point group
% 
% Input Argument
% p:        points (coordinates)
% 
% Output Argument
% p_1, p_2: point pair with the farthest distance

    p_1 = p(1, 1:3);
    p_2 = p(2, 1:3);
    for i = 3:length(p(:, 1))
        p_3 = p(i, 1:3);
        dist_12 = norm(p_1 - p_2);
        dist_13 = norm(p_1 - p_3);
        dist_23 = norm(p_2 - p_3);
        if  dist_12 < dist_13 || dist_12 < dist_23
            if dist_13 <= dist_23
                p_1 = p(i, 1:3);
            elseif dist_13 > dist_23
                p_2 = p(i, 1:3);
            end
        end
    end
end