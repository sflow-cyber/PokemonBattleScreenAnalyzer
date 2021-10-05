function img = filterBackground(image)
%FILTERBACKGROUND Summary of this function goes here
%   Detailed explanation goes here
[rows, columns] = size(image);
img = image;
for i = 1:rows
    firstval = img(i, 1);
    if img(i, 1) == img(i, 2)
        for j = 1:columns
            if img(i, j) == firstval
                img(i, j) = 255;
            end
        end
    end
    
end
end

