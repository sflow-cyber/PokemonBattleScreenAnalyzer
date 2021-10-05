function [processedImage] = preprocessing_level(inputImage)

% Turn InputImage into a grayscale Image 
% and then into a Black and White Image 
resize=imresize(inputImage, [160 NaN]);
grimg=rgb2gray(resize);
bw=imbinarize(grimg,0.5);


%Crop Level Areas and concatenate them side 
%by side into one matrix which is the return value.
recttop=[89,21,10,9];
rectbot=[211,79,10,9];
lvtop= imcrop(bw, recttop);
lvbot= imcrop(bw, rectbot);
lv= cat(2,lvtop,lvbot);


processedImage = lv;
end

