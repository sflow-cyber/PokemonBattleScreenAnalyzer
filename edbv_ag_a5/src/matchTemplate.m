function [minSsd, top, left, maxPercentage] = matchTemplate(image, template)
%MATCHTEMPLATE Returns the best match for a template in an image
%   Matches the template by calculating the sum of absolute distances
%   between the input image and the template. The template must be smaller
%   than the image, the template will only be matched if it is completely
%   inside the image.

    [numrowsIm, numcolsIm, colorsIm] = size(image);
    [numrowsTmp, numcolsTmp, colorsTmp] = size(template);
    
    xOffset = 1 + numcolsIm - numcolsTmp;
    yOffset = 1 + numrowsIm - numrowsTmp;
    
    minSsd = intmax;
    maxPercentage = 0;
    top = 0;
    left = 0;
    
    for x = 1:xOffset
       for y = 1:yOffset
           [currentSad, matchingPercent] = matchTemplateXY(image, template, x, y);
           if currentSad < minSsd
               minSsd = currentSad;
               top = y;
               left = x;
               maxPercentage = matchingPercent;
           end
       end
    end

    function [sad, matchingPercent] = matchTemplateXY(image, template, x, y)
        sad = int32(0);
        numPixels = int32(0);
        matchingPercent = 0;
        for i = 1:numrowsTmp
            for j = 1:numcolsTmp
                if template(i, j) > 0
                    val1 = image(i+y-1, j+x-1);
                    val2 = template(i,j);
                    difference = (abs(int32(val1) - int32(val2)));
                    sad = (sad + int32(difference));
                    matchingPercent = matchingPercent + (1 - double(difference) / 255);
                    numPixels = numPixels + 1;
                end
            end
        end
        matchingPercent = matchingPercent / double(numPixels);
    end

end

