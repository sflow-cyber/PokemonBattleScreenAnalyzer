function [processedImage] = preprocessing_status(inputImage)
%PREPROCESSING_STATUS Summary of this function goes here
%   Detailed explanation goes here

inputImage = imresize(inputImage, [160,240]);

img1 = inputImage(30:40,20:41,:);
img2 = inputImage(96:106,142:163,:);
img3 = [img1,img2];

processedImage = img3;
end

