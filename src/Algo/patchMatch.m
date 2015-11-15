%% @yash0307, @halwai

% Window size
window_size = 5;
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
%% Compute Evaluator for created mapping