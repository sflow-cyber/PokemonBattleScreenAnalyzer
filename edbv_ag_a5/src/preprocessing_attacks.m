function [processedImage] = preprocessing_attacks(inputImage)
%PREPROCESSING_ATTACKS Summary of this function goes here
%   Detailed explanation goes here
    
    Img = imresizePA(inputImage, [160 240]);
    Part = imcropPA(Img, [0 115 160 160]); % [colBegin rowBegin colEnd rowEnd]
    grayImg = rgb2grayPA(Part);
    
    
    % pre-calculate the means at each position using a template-sized
    % kernel
    imgSize = sizePA(grayImg);
    imgWidth = imgSize(2);
    imgHeight = imgSize(1);
    tmpltHeight = 8;
    tmpltWidth = 5;
    
    grayImgSplit(:,:,1) = grayImg(1:floor(imgHeight / 2.0), ...
        1:floor(imgWidth / 2.0));
    grayImgSplit(:,:,2) = grayImg(1:floor(imgHeight / 2.0), ...
        (floor(imgWidth / 2.0) + 1):imgWidth);
    grayImgSplit(:,:,3) = grayImg((floor(imgHeight / 2.0) + 1):imgHeight, ...
        1:floor(imgWidth / 2.0));
    grayImgSplit(:,:,4) = grayImg((floor(imgHeight / 2.0) + 1):imgHeight, ...
        (floor(imgWidth / 2.0) + 1):imgWidth);
    
    imgSize = sizePA(grayImgSplit(:,:,1));
    imgHeight = imgSize(1);
    imgWidth = imgSize(2);
    
    imgMeansW5Split = zeros(imgHeight, imgWidth, 4);
    imgMeansW4Split = zeros(imgHeight, imgWidth, 4);
   
    for i = 1:4
        for row = 1:imgHeight + tmpltHeight - 1
            for col = 1:imgWidth + tmpltWidth - 1
                imgMeansW5Split(row, col, i) = mean(mean(imcropPA(grayImgSplit(:,:,i), ...
                    [max(col - tmpltWidth + 1, 1) max(row - tmpltHeight + 1, 1) ... 
                    col row])));
            end
        end
    end
    
    tmpltWidth = 4;
    
    for i = 1:4
        for row = 1:imgHeight + tmpltHeight - 1
           for col = 1:imgWidth + tmpltWidth - 1
                imgMeansW4Split(row, col, i) = mean(mean(imcropPA(grayImgSplit(:,:,i), ...
                   [max(col - tmpltWidth + 1, 1) max(row - tmpltHeight + 1, 1) ... 
                   col row])));
           end
        end
    end
    
    preProcessingDTO = AttckPreProcessingDTO;
    preProcessingDTO.grayImg = grayImgSplit;
    preProcessingDTO.imgMeansW5 = imgMeansW5Split;
    preProcessingDTO.imgMeansW4 = imgMeansW4Split;
    processedImage = preProcessingDTO;
end

% returns: resized image according to parameter size coordinate-array
% uses method: nearest
function ret = imresizePA(Img, coord) % coord = [rows cols]
    imgSize = sizePA(Img);
    oldCols = imgSize(2);
    oldRows = imgSize(1);
    newCols = coord(2);
    newRows = coord(1);
    colStep = oldCols / newCols;
    rowStep = oldRows / newRows;
    colCounter = max(colStep, 1);
    newImg = zeros(newRows, newCols, 3, 'uint8');
    for c = 1:newCols
       rowCounter = max(rowStep, 1);
       for r = 1:newRows
           newImg(r, c,:) = Img(min(round(rowCounter), oldRows), ...
               min(round(colCounter), oldCols),:);
           rowCounter = rowCounter + rowStep;
       end
       colCounter = colCounter + colStep;
    end
    ret = newImg;
end

% returns cropped image according to parameter coordinate-array
% coord = [colBegin rowBegin colEnd rowEnd], no other format possible
function ret = imcropPA(Img, coord) 
    sizeVal = sizePA(Img);
    cols = sizeVal(2);
    rows = sizeVal(1);
    colBegin = max(coord(1), 1);
    colEnd = min(coord(3), cols);
    rowBegin = max(coord(2), 1);
    rowEnd = min(coord(4), rows);
    ret = Img(rowBegin:rowEnd, colBegin:colEnd,:);
end

% returns a gray-scale image
% source of parameters: https://de.mathworks.com/help/matlab/ref/rgb2gray.html
function ret = rgb2grayPA(Img)
    rgbWeights = [0.2989 0.5870 0.1140];
    ret = round(Img(:,:,1) * rgbWeights(1) + Img(:,:,2) * rgbWeights(2) + ... 
        Img(:,:,3) * rgbWeights(3));
end

% returns size of a rgb image in the form of an array [rows cols]
function ret = sizePA(Img)
    if isempty(Img)
        ret = [0 0];
    else
        ret = [length(Img(:,1,1)), length(Img(1,:,1))];
    end
end