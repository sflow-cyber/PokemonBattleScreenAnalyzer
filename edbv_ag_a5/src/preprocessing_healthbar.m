function [processedImage] = preprocessing_healthbar(inputImage, type )
%PREPROCESSING_HEALTHBAR Summary of this function goes here
%   Detailed explanation goes here
processedImage = inputImage;

[x , y , c] = size(processedImage);

% Checks which type of healthbar ( user or enemy ) is searched for
switch type
    % Height for both cropped images is 1 pixel 
	case 0
        % fixed Values for enemy Screen coordinates 
		processedImage = imcrop(processedImage,[x * 0.329 , y * 0.145 , x * 0.29  , y * 0.0001] );
	case 1
        % fixed Values for user Screen coordinates 
		processedImage = imcrop(processedImage,[x * 1.091 , y * 0.39 , x * 0.29  , y * 0.0001 ] );
    otherwise
        warning('Unexpected Value')
end 

% Processing cropped information from RBG to grey ...
processedImage = rgb2gray(processedImage);
% and then to black and white.
processedImage = imbinarize(processedImage, 0.45);

end

