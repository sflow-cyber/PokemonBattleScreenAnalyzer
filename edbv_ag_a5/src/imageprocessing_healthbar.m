function [output] = imageprocessing_healthbar(inputImage)
%IMAGEPROCESSING_HEALTHBAR Summary of this function goes here
%   Detailed explanation goes here

%figure, imshow(inputImage);

[x , y, color ] = size(inputImage);

length = y - x;
count = 0;

% Each pixel for the image in question is checked if it is still white while
% counting the amount of pixels with count 
% If this is not the case the loop breaks. 
for count = 1:length
	if (inputImage(count) == 0)
		count = count - 1;
		break
	end 
end

% Calculates the approximate Health in proportion to the maximum length of
% the healthbar. 
output = (count)/ ( length );

end
