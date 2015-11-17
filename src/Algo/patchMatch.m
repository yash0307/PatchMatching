%% @yash0307, @halwai

% Window size
window_size = 5;
num_iterations = 10;
% Take input image 1 and 2.
% 2 will be same as 1, for 
% object removal.
im_A = double(imread('a.png'));
im_B = double(imread('a.png'));
%initial radius of random search to be decreased exponentialy
Radius = min(size(im_A,1),size(im_A,2))/2

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

%random_search = @(,Radius) ;
%% Iteration Mapping and updating Eval.
for iter=1:num_iterations
    Radius = Radius * exp(-i)
    % @yash0307, for odd i
    % move top-left to bottom-right
    % Check for (top,left and current pixels) and update according to the
    % least found value
    
    % CASE-1 : iter is even.
    if mod(iter,2)==0
        for i=1:im_A_size(1)
            for j=1:im_A_size(2)
                %propagation and updation
                if j>1 
                    top = Eval[i,j-1];
                else 
                    top = Inf;
                end
                if i>1
                    left = Eval[i-1,j];
                else
                    left = Inf;
                end
                current  = Eval[i,j];
                [Eval[i,j],min_idx] = min(current,left,top)
                if min_idx ==2
                    Mapping[i,j] = Mapping[i-1,j];
                elseif min_idx==3
                    Mapping[i,j] = Mapping[i,j-1];
                else
                    Mapping[i,j] = Mapping[i,j];
                    'Mapping[i,j] remains unchanged';
                end
                %search and update
                temp_eval = random_search(Mapping[i,j],Radius)
            end
        end
    end
end