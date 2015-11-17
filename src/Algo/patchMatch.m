%% @yash0307, @halwai

% Window size
window_size = 5;
num_iterations = 5;
% Take input image 1 and 2.
% 2 will be same as 1, for 
% object removal.
im_A = double(imread('a.png'));
im_B = double(imread('a.png'));


% Initialize Mapping matrix.
% Corresponding Evaluator matrix.
% @yash0307, Note : Update evaluator each time,
%                   you update mapping matrix

% Naming style : 
% Mapping for Pixels from Image A -> Image B == Mapping
% Evaluator == Eval

%% Initialization for Mapping.
% Random initializatio.
im_A_size = size(im_A);
im_B_size = size(im_B);

% @yash0307, Generate random mapping.
Mapping = zeros(im_A_size(1), im_A_size(2), 2);
Mapping(:,:,1) = randi([1 im_B_size(1)], im_A_size(1), im_A_size(2));
Mapping(:,:,2) = randi([1 im_B_size(2)], im_A_size(1), im_A_size(2));

% Pad both the images by 2 pixels.
% Window size = 5;
% After padding we operate on im_A and im_B.
A = padarray(im_A, [floor(window_size/2) floor(window_size/2)], 0, 'both');
B = padarray(im_B, [floor(window_size/2) floor(window_size/2)], 0, 'both');

%% Compute Evaluator for created initlialized mapping

% @yash0307, compute eval corresponding to initialization.
Eval = zeros(im_A_size(1), im_A_size(2));
for i=1:im_A_size(1)
    for j=1:im_A_size(2)
        
        % @yash0307, Padded indexes
        i_pad = i+floor(window_size/2);
        j_pad = j+floor(window_size/2);
        
        % @yash0307, extract the two windows
        half_window_size = floor(window_size/2);
        first_window = A(i_pad-half_window_size:i_pad+half_window_size, j_pad-half_window_size:j_pad+half_window_size);
        mapped_x = Mapping(i,j,1);
        mapped_y = Mapping(i,j,2);
        map_x_pad = mapped_x+floor(window_size/2);
        map_y_pad = mapped_y+floor(window_size/2);
        second_window = B(map_x_pad-half_window_size:map_x_pad+half_window_size, map_y_pad-half_window_size:map_y_pad+half_window_size);
        
        % @yash0307, compute the difference between them and strore in
        % eval.
        Eval(i,j) = sum(sum(abs(first_window - second_window)));

    end
end


%% Iteration Mapping and updating Eval.
for iter=1:num_iterations

    % @yash0307, for odd i
    % move top-left to bottom-right
    % Check for (top,left and current pixels) and update according to the
    % least found value
    
    % CASE-1 : iter is even.
    if mod(iter,2)==0
        % @yash0307, For even case check top, left, current.
        % Take the minimum, and apply random search for
        % corresponding matching.
        % Note : Need to check existence of top, left as per situation.

        for i=1:im_A_size(1)
            for j=1:im_A_size(2)
                
                % STEP - 1
                % @yash0307 : First evaluate top, left, current.
                current_val = Eval(i,j);
                current_index = [i , j];
                % @yash0307 : if i > 1 top exists. Else take top as
                % infinity.
                % Note : Use this carefully.
                if i > 1
                    top_val = Eval(i-1,j);
                    top_index = [i-1 , j];
                else
                    top_val = Inf;
                    top_index = [Inf, Inf];
                end
                % @yash0307 : if j > 1 left exists. Else take left as
                % infinity.
                % Note : Use this carefully.
                if j > 1
                    left_val = Eval(i,j-1);
                    left_index = [i , j-1];
                else
                    left_val = Inf;
                    left_index = [Inf Inf];
                end
                
                % STEP - 2
                % @yash0307 : Compare top, left and current values.
                % Choose minimum among them. And apply random search for
                % it.
                % NOTE : don't forget to update Mapping Matrix accordingly.
                
                
            end
        end
    elseif mod(iter,2)==1
        % @yash0307, For even case check bottom, right, current.
        % Take the minimum, and apply random search for
        % corresponding matching.
        % Note : Need to check existence of bottom, right as per situation.

        for i=im_A_size(1):-1:1
            for j=im_A_size(1):-1:1
                
                % STEP - 1
                % @yash0307 : First evaluate bottom, right, current.
                current_val = Eval(i,j);
                current_index = [i , j];
                % @yash0307 : if i < im_A_size(1) bottom exists. Else take bottom as
                % infinity.
                % Note : Use this carefully.
                if i < im_A_size(1)
                    bottom_val = Eval(i+1,j);
                    bottom_index = [i+1 , j];
                else
                    bottom_val = Inf;
                    bottom_index = [Inf, Inf];
                end
                % @yash0307 : if j < im_A_size(2) right exists. Else take right as
                % infinity.
                % Note : Use this carefully.
                if j < im_A_size(2)
                    right_val = Eval(i,j+1);
                    right_index = [i , j+1];
                else
                    right_val = Inf;
                    right_index = [Inf Inf];
                end
                
                % STEP - 2
                % @yash0307 : Compare top, left and current values.
                % Choose minimum among them. And apply random search for
                % it.
                % NOTE : don't forget to update Mapping Matrix accordingly.
                
            end
        end
        
    end
end