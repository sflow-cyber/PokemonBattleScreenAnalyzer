function [output] = imageprocessing_level(inputImage)

%Divide Image again into the two intial Level-Numbers.
n=fix(size(inputImage,2)/2);
toplv=inputImage(:,1:n,:);
botlv=inputImage(:,n+1:end,:);

% Read 7x4 matrix of 0.
zero=imread('../assets/levels/0.png');

% n = half the column count of toplv.
n=fix(size(toplv,2)/2);

% Get the left half of toplv using n.
lefttop=toplv(:,1:n,:);

% Determin location of Digit in the left
% half of 'toplv' and crop it saving the digit 
% in 'lefttop'.
row = find( any(lefttop==0, 2), 1);
col = find( any(lefttop==0, 1), 1);
rect=[col,row,3,6];

lefttop=imcrop(lefttop,rect);

if(size(lefttop,1)==7)
    % Matching the digit in 'lefttop'
    % with the template digits.
    lefttopnum=mequal(lefttop);
else
    % If no digit is in 'lefttop' 
    % fill it with the 4x7 matrix saved previously in 'zero'.
    lefttop=zero;
    lefttopnum=0;
end  

%Get right half ot toplv
righttop=toplv(:,n+1:end,:);

% Determin location of Digit in the right
% half of toplv and crop it saving the digit 
% in 'righttop'.

row = find( any(righttop==0, 2), 1);
col = find( any(righttop==0, 1), 1);
rect=[col,row,3,6];

% Matching the digit in 'righttop'
% with the template digits.
righttop=imcrop(righttop,rect);
righttopnum=mequal(righttop);



%Get the left half of 'botlv'.
leftbot=botlv(:,1:n,:);

% Determin location of Digit in the left
% half of 'botlv' and crop it saving the digit 
% in 'leftbot'.
row = find( any(leftbot==0, 2), 1);
col = find( any(leftbot==0, 1), 1);
rect=[col,row,3,6];

leftbot=imcrop(leftbot,rect);

%If there is only one digit in 'toplv' 
% then 'lefttop' contains 'v' and not a digit
% and its size will be 6x4 instead of 7x4.
if(size(leftbot,1)==7)
    % Matching the digit in 'leftbot'
    % with the template digits.
    leftbotnum=mequal(leftbot);
else
    % If no digit is in 'leftbot' 
    % fill it with the 4x7 matrix saved in 'zero'.
    leftbot=zero;
    leftbotnum=0;
end    

%Get the right half of 'botlv'.
rightbot=botlv(:,n+1:end,:);

% Determin location of Digit in the right
% half of 'botlv' and crop it saving the digit 
% in 'rightbot'.
row = find( any(rightbot==0, 2), 1);
col = find( any(rightbot==0, 1), 1);
rect=[col,row,3,6];

rightbot=imcrop(rightbot,rect);
% Matching the digit in 'rightbot'
% with the template digits.
rightbotnum=mequal(rightbot);

%subplot(2,3,1),imshow([lefttop,righttop]),title('lvtop');
%subplot(2,3,2),imshow([leftbot,rightbot]),title('lvbot');

%Output the matched Levels.
output =[lefttopnum*10+righttopnum,leftbotnum*10+rightbotnum];

% If two Zeros are found in 'botlv' Level,
% the bottom Level equals 100.
if(leftbotnum==0)
    if(size(leftbot,1)==7)
        if(rightbotnum==0)
            output=[lefttopnum*10+righttopnum,100];
        end
    end   
end
% If two Zeros are found in 'toplv' Level,
% the top Level equals 100.
if(lefttopnum==0)
    if(size(lefttop,1)==7)
        if(righttopnum==0)
            output=[100,output(2)];
        end
    end   
end

%disp(output);
return;
end
