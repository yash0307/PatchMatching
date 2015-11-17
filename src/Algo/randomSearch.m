%% @yash0307, @halwai

% This file contains random search function.
% Input parameters.
% -> Mapping Matrix.
% -> Eval Matrix.
% -> Underconsideration indexes.
% -> maximum range of squares.
% -> factor of reduction.
function [x y Updated_mapping Updated_Eval] = randomSearch(Mapping, Eval, image_indexes, mapped_indexes,rs_max_window, rs_reduction_factor, image_size)
    
    % Will have to change log accordingly. So 2 for now.
    rs_reduction_factor = 2;
    
    Updated_mapping = Mapping;
    Updated_Eval = Eval;
    % @yash0307 : firstly compute the number of iterations.
    iter_num = log2(rs_max_window);
    for fun_iter=1:iter_num
        
        % @yash0307 : for each iteration generate compare across the new
        % patches accordingly.
        radius = rs_max_window/fun_iter;
        
        % @yash0307 : define four sides of the square.
        % Namely sq_top, sq_bottom, sq_left, sq_right.
        % for each side you need to check if it can exist.
        % else take max possible.
        % Correspondingly there will be four vertices for the square. Goal
        % is to find these vertices.
        % @yash0307 : Notation followed.
        % sq_1 = first quadrant.
        % sq_2 = second_quadrant.
        % sq_3 = third_quadrant.
        % sq_4 = fourth_quadrant.
        
        % finding sq_1
        sq_1 = [0 0]
        if(mapped_indexes(1) + radius < image_size(1))
            sq_1(1) = mapped_indexes(1) + radius;
        else
            
        end
    end
end