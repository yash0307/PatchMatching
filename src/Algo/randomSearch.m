%% @yash0307, @halwai

% This file contains random search function.
% Input parameters.
% -> Mapping Matrix.
% -> Eval Matrix.
% -> Underconsideration indexes.
% -> maximum range of squares.
% -> factor of reduction.
function [x_ret y_ret Updated_mapping Updated_Eval] = randomSearch(Mapping, Eval, image_indexes, mapped_indexes,rs_max_window, rs_reduction_factor, image_size, image)
    %image_indexes
    %Random max search thing.
    %a = randi([5 10], 1,1);
    %rs_max_window = double(rs_max_window*(a/10));
    
    % Will have to change log accordingly. So 2 for now.
    rs_reduction_factor = 2;
    
    Updated_mapping = Mapping;
    Updated_Eval = Eval;
    % @yash0307 : firstly compute the number of iterations.
    iter_num = log2(rs_max_window);
    for fun_iter=1:iter_num
        
        % @yash0307 : for each iteration generate compare across the new
        % patches accordingly.
        % This minus 2 is for window. 
        % Window shall not exceed indexes.
        
        
        r = int16(rs_max_window/fun_iter);
        
        w = 2; % Window size ka half.
        
        best_window = image(mapped_indexes(1)-w+w:mapped_indexes(1)+w+w, mapped_indexes(2)-w+w:mapped_indexes(2)+w+w);
        best_value = Eval(image_indexes(1), image_indexes(2));
        
        current_window = image(image_indexes(1)-w+w:image_indexes(1)+w+w, image_indexes(2)-w+w:image_indexes(2)+w+w);
        
        x = mapped_indexes(1);
        y = mapped_indexes(2);
        
        max_x = image_size(1);
        max_y = image_size(2);
                
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
        x_right=0;
        x_left=0;
        y_top=0;
        y_bottom=0;
        if (x+r <= max_x)
            x_right = x+r;
        else
            x_right = max_x;
        end
        if (x-r >= 1)
            x_left = x-r;
        else
            x_left = 1;
        end
        if(y+r <= max_y)
            y_bottom = y+r;
        else
            y_bottom = max_y;
        end
        if(y-r >= 1)
            y_top = y-r;
        else
            y_top = 1;
        end
        
        % Compute sq_1
        sq_1 = [x_right y_top];
        % Compute sq_2
        sq_2 = [x_left y_top];
        % Compute sq_3
        sq_3 = [x_left y_bottom];
        % Compute sq_4
        sq_4 = [x_right y_bottom];
        
        % Move on line 1.
        % Line 1 is from sq_2 to sq_1.
        % Thus moving along x-axis.
        line_1_x = sq_2(1):3:sq_1(1);
        line_1_y = sq_2(2);
        for move=line_1_x
            temp_coordinates = int16([move line_1_y]);
            temp_window = image(move-w+w:move+w+w, line_1_y-w+w:line_1_y+w+w);
            
            % Compare this temp window with current window.
            temp_val = sum(sum(abs(temp_window - current_window)));
            if(temp_val < best_value)
                best_value = temp_val;
                best_window = temp_window;
                Eval(image_indexes(1), image_indexes(2)) = best_value;
                Mapping(image_indexes(1), image_indexes(2), 1) = temp_coordinates(1);
                Mapping(image_indexes(1), image_indexes(2), 2) = temp_coordinates(2);
            end
        end
        
        % Move on line 2.
        % Line 2 is from sq_3 to sq_2.
        % Thus moving along y-axis.
        line_2_x = sq_2(1);
        line_2_y = sq_3(2):3:sq_2(2);
        for move=line_2_y
            temp_coordinates = int16([line_2_x move]);
            temp_window = image(line_2_x-w+w:line_2_x+w+w, move-w+w:move+w+w);
            
            % Compare this temp window with current window.
            temp_val = sum(sum(abs(temp_window - current_window)));
            if(temp_val < best_value)
                best_value = temp_val;
                best_window = temp_window;
                Eval(image_indexes(1), image_indexes(2)) = best_value;
                Mapping(image_indexes(1), image_indexes(2), 1) = temp_coordinates(1);
                Mapping(image_indexes(1), image_indexes(2), 2) = temp_coordinates(2);
            end
        end
        % Move on line 3.
        % Line 3 is from sq_3 to sq_4.
        % Thus moving along x-axis.
        line_3_x = sq_3(1):3:sq_4(1);
        line_3_y = sq_3(2);
        for move=line_3_x
            temp_coordinates = int16([move line_3_y]);
            temp_window = image(move-w+w:move+w+w, line_3_y-w+w:line_3_y+w+w);
            
            % Compare this temp window with current window.
            temp_val = sum(sum(abs(temp_window - current_window)));
            if(temp_val < best_value)
                best_value = temp_val;
                best_window = temp_window;
                Eval(image_indexes(1), image_indexes(2)) = best_value;
                Mapping(image_indexes(1), image_indexes(2), 1) = temp_coordinates(1);
                Mapping(image_indexes(1), image_indexes(2), 2) = temp_coordinates(2);
            end
        end
        % Move on line 4.
        % Line 4 is from sq4 to sq_1.
        % Thus movign along y-axis.
        line_4_x = sq_4(1);
        line_4_y = sq_4(2):3:sq_1(2);
        for move=line_4_y
            temp_coordinates = [line_4_x move];
            temp_window = image(line_4_x-w+w:line_4_x+w+w, move-w+w:move+w+w);
            
            % Compare this temp window with current window.
            temp_val = sum(sum(abs(temp_window - current_window)));
            if(temp_val < best_value)
                best_value = temp_val;
                best_window = temp_window;
                Eval(image_indexes(1), image_indexes(2)) = best_value;
                Mapping(image_indexes(1), image_indexes(2), 1) = temp_coordinates(1);
                Mapping(image_indexes(1), image_indexes(2), 2) = temp_coordinates(2);
            end
        end
    end
    x_ret = Mapping(image_indexes(1), image_indexes(2),1);
    y_ret = Mapping(image_indexes(1), image_indexes(2),2);
    Updated_mapping = Mapping;
    Updated_Eval = Eval;
end