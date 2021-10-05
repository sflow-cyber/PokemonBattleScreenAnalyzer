function [output] = imageprocessing_attacks(inputImage)
    %IMAGEPROCESSING_STATUS Summary of this function goes here
    %   Detailed explanation goes here
    
    grayImgSplit = inputImage.grayImg;
    imgMeansW5Split = inputImage.imgMeansW5;
    imgMeansW4Split = inputImage.imgMeansW4;
    
    for i = 1:4
       pos(i) = "";
       atk(i) = "";
    end
    
    cnt = 1;
    for letter = 'A':'Z'
        S{cnt} = imread(strcat(strcat('..\assets\Alphabet\', ...
            letter), '.png'));
        cnt = cnt + 1;
    end
    letter = '-';
    S{27} = imread(strcat(strcat('..\assets\Alphabet\', ...
        letter), '.png'));
    
    parfor i = 1:4 
        cnt = 1;
        for letter = 'A':'Z'
            ret = coreFunc(S{cnt}, letter, grayImgSplit(:,:,i), pos(i), ...
                atk(i), imgMeansW5Split(:,:,i), imgMeansW4Split(:,:,i));
            pos(i) = ret.getPos();
            atk(i) = ret.getAtk();
            cnt = cnt + 1;
        end
    end
    
    parfor i = 1:4 
        ret = coreFunc(S{27}, '-', grayImgSplit(:,:,i), pos(i), atk(i), ...
            imgMeansW5Split(:,:,i), imgMeansW4Split(:,:,i));
        pos(i) = ret.getPos();
        atk(i) = ret.getAtk();
        atk(i) = char(atk(i));
    end
    
    output = splitLines(pos, atk);
end

function attackVec = splitLines(pos, atk)
    attck(1) = "";
    attck(2) = "";
    attck(3) = "";
    attck(4) = "";

    parfor j = 1:4   
        intPositions = str2double(strsplit(pos(j), "|"));
        i = 1;
        while i < length(intPositions)
            if i > 1
                while intPositions(i) - intPositions(i - 1) > 5
                    attck(j) = strcat(attck(j), " ");
                    intPositions(i - 1) = intPositions(i - 1) + 5;
                end
            end
            actualAtk = extractBetween(atk(j), i, i);
            attck(j) = strcat(attck(j), actualAtk);
            i = i + 1;
        end
        attck(j) = unCaps(attck(j));
    end

    attackVec = [strtrim(attck(1)) strtrim(attck(2)) strtrim(attck(3)) ...
        strtrim(attck(4))];
end

function ret = coreFunc(S, letter, grayImgSplit, pos, atk, imgMeansW5, imgMeansW4)
    retVal = sizePA(grayImgSplit);
    Imgr = retVal(1);
    Imgc = retVal(2);
    
    h = 8;
    if letter == 'I' || letter == 'Y' || letter == 'T'
       w = 4;
       imgMeans = imgMeansW4;
    else
       w = 5;
       imgMeans = imgMeansW5;
    end
    S = imresizePA(S, [h, w]);
    S = rgb2grayPA(S);
    retVal = sizePA(S);
    Sr = retVal(1);
    Sc = retVal(2);
    Corr = normxcorr2PA(S, grayImgSplit, imgMeans);
    Corr = imcropPA(Corr, [Sc Sr Imgc Imgr]);
    [r, c] = find(Corr > 0.95);
    for i = 1:length(r)
       vec1 = addLetterAtPos(letter, c(i), pos, atk);
       pos = vec1(2);
       atk = vec1(1);
    end
    retObj = AttckDTO(pos, atk);
    ret = retObj;
end

function outVec = addLetterAtPos(letter, pos, posVec, ln)
    if posVec == ""
        posVec = strcat(num2str(pos), "|");
        ln = strcat(ln, letter);
    else
        intPositions = str2double(strsplit(posVec, "|"));
        i = 1;
        inStrPos = 1;
        while i < length(intPositions)
            if pos <= intPositions(i)
                break;
            else
                if intPositions(i) < 10
                    inStrPos = inStrPos + 2;
                elseif intPositions(i) < 100
                    inStrPos = inStrPos + 3;
                elseif intPositions(i) < 241
                    inStrPos = inStrPos + 4;
                else
                    disp("ERROR, POSITION > 240!!");
                    % error, position out of bounds!!!
                end
                i = i + 1;
            end
        end
        if i == 1
            ln = strcat(letter, ln);
        elseif i > strlength(ln)
            ln = strcat(ln, letter);
        else
            ln = strcat(strcat(extractBetween(ln, 1, i - 1), letter), ...
                extractBetween(ln, i, strlength(ln)));
        end
        if inStrPos == 1
            posVec = strcat(strcat(num2str(pos), "|"), posVec);
        elseif inStrPos >= strlength(posVec)
            posVec = strcat(posVec, strcat(num2str(pos), "|"));
        else
            posVec = strcat(strcat(strcat(extractBetween(posVec, 1, inStrPos - 1), ...
                num2str(pos)), "|"), extractBetween(posVec, inStrPos, ...
                strlength(posVec)));
        end
    end
    outVec = [ln posVec];
end

% Utility function
% returns: Text with capitals at the beginning of each word
% and all lower case letters elsewhere
function phr = unCaps(caps)
    first = 1;
    caps = convertStringsToChars(caps);
    for i = 1:length(caps)
        if first
            caps(i) = upper(caps(i));
        else
            caps(i) = lower(caps(i)); 
        end
        if caps(i) == ' ' || caps(i) == '-'
            first = 1;
        else
            first = 0;
        end
    end
    phr = convertCharsToStrings(caps);
end

% returns a heatmap - the higher the value the more similar a specific
% region of the image (Img) is to the given template (Tmplt)
% source: https://de.mathworks.com/help/images/ref/normxcorr2.html
% type in terminal: help normxcorr2
function ret = normxcorr2PA(Tmplt, Img, imgMeans)
    imgSize = sizePAgray(Img);
    tmpltSize = sizePAgray(Tmplt);
    imgWidth = imgSize(2);
    imgHeight = imgSize(1);
    tmpltWidth = tmpltSize(2);
    tmpltHeight = tmpltSize(1);
    heatMap = zeros(imgHeight + tmpltHeight - 1, imgWidth + tmpltWidth - 1);
    tmpltMean = mean(mean(Tmplt));
    maxCol = imgWidth + tmpltWidth - 1;
    maxRow = imgHeight + tmpltHeight - 1;
    
    for row = 1:maxRow
        for col = 1:maxCol
            imgMean = imgMeans(min(row, imgHeight), min(col, imgWidth));
            if abs(imgMean - tmpltMean) > 10
                continue;   % mean must be quite similar if it is to be a match
            end
            croppedTmplt = imcropPA(Tmplt, [max(tmpltWidth - col + 1, 1) ...
                max(tmpltHeight - row + 1, 1) tmpltWidth tmpltHeight]);
            croppedImg = imcropPA(Img, [max(col - tmpltWidth + 1, 1) ...
                max(row - tmpltHeight + 1, 1) col row]);
            heatMap(row, col) = spatialCrossCorr(croppedImg, croppedTmplt, ... 
                tmpltWidth, tmpltHeight, tmpltMean, imgMean);
        end
    end
    ret = heatMap;
end

% calculate the heatmap value for a specific position of the template
% in the image
function ret = spatialCrossCorr(imgRegion, tmplt, fullTmpltWidth, ...
    fullTmpltHeight, tmpltMean, imgMean)
    sum1 = 0.0;
    sum2 = 0.0;
    sum3 = 0.0;
    tmpltSize = sizePAgray(tmplt);
    width = tmpltSize(2);
    height = tmpltSize(1);
    if width < fullTmpltWidth || height < fullTmpltHeight
       tmpltMean = mean(mean(tmplt)); 
    end
    imgRegionSize = sizePAgray(imgRegion);
    regWidth = imgRegionSize(2);
    regHeight = imgRegionSize(1);
    if regWidth < fullTmpltWidth || regHeight < fullTmpltHeight
       imgMean = mean(mean(imgRegion)); 
    end
    fac = double(width * height) / double(fullTmpltWidth * fullTmpltHeight);
    for col = 1:regWidth
        for row = 1:regHeight
            imgVal = double(imgRegion(row, col));
            sum1 = sum1 + (imgVal - imgMean) * ... 
                (double(tmplt(row, col)) - tmpltMean);
            sum2 = sum2 + (imgVal - imgMean)^2;
            sum3 = sum3 + (double(tmplt(row, col)) - tmpltMean)^2;
        end
    end
    den = sqrt(sum2 * sum3);
    if den == 0
        ret = 0; 
    else
        ret = (sum1 / den) * fac;
    end
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

% returns size of gray scale image in the form of an array [rows cols]
function ret = sizePAgray(grayImg)
    if isempty(grayImg)
        ret = [0 0];
    else
        ret = [length(grayImg(:,1)), length(grayImg(1,:))];
    end
end

% returns size of a rgb image in the form of an array [rows cols]
function ret = sizePA(Img)
    if isempty(Img)
        ret = [0 0];
    else
        ret = [length(Img(:,1,1)), length(Img(1,:,1))];
    end
end