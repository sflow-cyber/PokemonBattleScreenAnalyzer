function [processedImage] = preprocessing_all(inputImage)
%PREPROCESSING_ALL Summary of this function goes here
%   Detailed explanation goes here
%TOODO: implement preprocessing that is shared by all functions
[numRows, numCols, colors] = size(inputImage);
if numRows > 160 && numCols > 240
    inputImage = imresize(inputImage, [160, 240]);
end
processedImage = inputImage;
end

