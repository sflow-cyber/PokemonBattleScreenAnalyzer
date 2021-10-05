function [threshold] = otsuThreshold(image)
%OTSUTHRESHOLD Returns the global otsu threshold for a given 8bit greyscale
%image.
%   Returns the global otsu threshold for a given greyscale
%image. The value is normalized between 0 and 1. Only works for 8bit
%greyscale images.
histogram = int32(zeros(256, 0));

total = 0;

for i = 0:255
    val = sum( image(:) == i);
    total = total + val;
    histogram(i+1) = val;
end

w0 = double(histogram(1)) / double(total);
w1 = double((total - histogram(1))) / double(total);

m0 = double(0);
m1 = sum( (double(histogram)./total) .* (0:255));

currentMax = 0;
currentVar = 0;
for i = 2:256
    if histogram(i) == 0
        continue;
    end
    
    w0 = w0 + double(histogram(i))/total;
    w1 = w1 - double(histogram(i))/total;
    
    if w0 == 0
        continue;
    end
    
    if w1 == 0
        break;
    end
    
    m0 = m0 + ((i-1) * double(histogram(i))/total);
    m1 = m1 - ((i-1) * double(histogram(i))/total);
    
    mean0 = m0/w0;
    mean1 = m1/w1;
    
    interClassVar = w0*w1*(mean0 - mean1)^2;
    
    if interClassVar > currentVar
        currentVar = interClassVar;
        currentMax = (i-1);
    end
    
end

threshold = currentMax / 255;
end

