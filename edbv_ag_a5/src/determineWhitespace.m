function [top, right, down, left] = determineWhitespace(sprite)
%DETERMINEWHITESPACE Summary of this function goes here
%   Detailed explanation goes here
%read 64x64 image of pokemon sprite and convert to grayscale

top = 0;
right = 0;
down = 0;
left = 0;

[rows, columns] = size(sprite);
%top
for row = 1:rows
    if max(sprite(row, :)) > 0
        top = row-1;
        break;
    end
end

%left
for column = 1:columns
    if max(sprite(:, column)) > 0
        left = column-1;
        break;
    end
end

%right
for column = columns:-1:1
    if max(sprite(:, column)) > 0
        right = columns-column;
        break;
    end
end

%down
for row = rows:-1:1
    if max(sprite(row, :)) > 0
        down = rows-row;
        break;
    end
end

end

