function [output] = imageprocessing_status(inputImage)
%IMAGEPROCESSING_STATUS Summary of this function goes here
%   Detailed explanation goes here

s = size(inputImage);
x_of = uint8(s(2)/2);
img1 = inputImage(:,1:x_of,:);
img2 = inputImage(:,x_of+1:end,:);
thresh_hold = 0.725;

template = double(imread('../assets/status/status_template_bw.png'));

BRN = [224,112,80];
FRZ = [136,176,224];
PAR = [184,184,24];
PSN = [192,96,192];
SLP = [160,160,136];
status_col=[BRN;FRZ;PAR;PSN;SLP];
status_name=["BRN";"FRZ";"PAR";"PSN";"SLP";"-"];

%%%%   ENEMY STATUS
img1_gray = rgb2gray(img1);
img1_gray = double(img1_gray);
[templateHeight,templateWidth] = size(template);

%% Correlation
[img1Height, img1Width] = size(img1_gray);
maxI = img1Width - templateWidth + 1;
maxJ = img1Height - templateHeight + 1;
result = zeros(maxJ,maxI);
posI = [0,0];
maxVal = 0;

for i = 1:maxI
    for j = 1:maxJ
        imgt = img1_gray(j:j+templateHeight-1, i:i+templateWidth-1);
        val = corr2(template,imgt);
        if(val > maxVal)
            posI(1) = j;
            posI(2) = i;
            maxVal = val;
        end
        result(j,i) = val;
    end
end

if maxVal>=thresh_hold
    
    %img1 = img1(posI(1):posI(1)+templateHeight-1,posI(2):posI(2)+templateWidth-1,:);

    %d = size(img1);
    %idx = [d(1)/2,2];
    
    %% Color
    idx = [posI(1)+(floor((templateHeight-1))/2),posI(2)+1];
    p = impixel(img1, idx(2), idx(1));
    
    col_ind = 6;
    minDistance = 255*255 + 255*255 + 255*255 + 1;
    for i=1:5
        rDiff = p(1) - status_col(i,1);
        gDiff = p(2) - status_col(i,2);
        bDiff = p(3) - status_col(i,3);
        distance = rDiff*rDiff + gDiff*gDiff + bDiff*bDiff;
        if distance < minDistance
            minDistance = distance;
            col_ind = i;
        end
    end
   
    enemy_status = status_name(col_ind,:);
    
else
    
    enemy_status = status_name(6,:);

end
%%%%%   ENEMY STATUS end


%%%%   OWN STATUS

img2_gray = rgb2gray(img2);
img2_gray = double(img2_gray);
[templateHeight,templateWidth] = size(template);

%% Correlation
[img2Height, img2Width] = size(img2_gray);
maxI = img2Width - templateWidth + 1;
maxJ = img2Height - templateHeight + 1;
result = zeros(maxJ,maxI);
posI = [0,0];
maxVal = 0;

template = double(template);

for i = 1:maxI
    for j = 1:maxJ
        imgt = img2_gray(j:j+templateHeight-1, i:i+templateWidth-1);
        val = corr2(template,imgt);
        if(val > maxVal)
            posI(1) = j;
            posI(2) = i;
            maxVal = val;
        end
        result(j,i) = val;
    end
end

if maxVal>=thresh_hold

    %img2 = img2(posI(1):posI(1)+templateHeight-1, posI(2):posI(2)+templateWidth-1,:);
 
    %d = size(img2);
    %idx = [d(1)/2,2];
    
    %% Color
    idx = [posI(1)+(floor((templateHeight-1))/2),posI(2)+1];
    p = impixel(img2, idx(2), idx(1));
    
    col_ind = 6;
    minDistance = 255*255 + 255*255 + 255*255 + 1;
    for i=1:5
        rDiff = p(1) - status_col(i,1);
        gDiff = p(2) - status_col(i,2);
        bDiff = p(3) - status_col(i,3);
        distance = rDiff*rDiff + gDiff*gDiff + bDiff*bDiff;
        if distance < minDistance
            minDistance = distance;
            col_ind = i;
        end
    end
   
    own_status = status_name(col_ind,:);
   
else
    
    own_status = status_name(6,:);
    
end

%%%%%   OWN STATUS end

%figure, imshow(inputImage), title("enemy status: "+enemy_status+ "    own status: "+own_status);

output = [own_status, enemy_status];

end

