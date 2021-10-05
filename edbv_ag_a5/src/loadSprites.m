function [frontSprites,backSprites] = loadSprites()
%LOADSPRITES Summary of this function goes here
%   Detailed explanation goes here
inputDirFront = '..\assets\sprites\front\';
inputDirBack = '..\assets\sprites\back\';
front = dir(fullfile(inputDirFront, '*.png'));
back = dir(fullfile(inputDirBack, '*.png'));

frontSprites(numel(front)) = PokemonSprite;
backSprites(numel(back)) = PokemonSprite;

for f = 1:numel(back)
    [sprite, cmap] = imread(fullfile(inputDirBack, back(f).name), 'png');
    if isempty(cmap)
        sprite = rgb2gray(sprite);
    else
        sprite = ind2gray(sprite, cmap); 
    end
    
    number = strsplit(back(f).name, [".", "-"]);
    number = str2num(char(number(1)));
    [top1, right1, down1, left1] = determineWhitespace(sprite);
    whitespaceOriginal = [top1, right1, down1, left1];
    backSprites(f) = PokemonSprite(sprite, back(f).name, number, whitespaceOriginal);
    %Remove part of the image that would not be hidden by attack box
    backSprites(f).sprite(59:64, 1:64) = 0;
    fullfile(inputDirBack, back(f).name)
end

for f = 1:numel(front)
    [sprite, cmap] = imread(fullfile(inputDirFront, front(f).name), 'png');
    if isempty(cmap)
        sprite = rgb2gray(sprite);
    else
        sprite = ind2gray(sprite, cmap); 
    end
    
    number = strsplit(front(f).name, [".", "-"]);
    number = str2num(char(number(1)));
    [top1, right1, down1, left1] = determineWhitespace(sprite);
    whitespaceOriginal = [top1, right1, down1, left1];
    frontSprites(f) = PokemonSprite(sprite, front(f).name, number, whitespaceOriginal);
    fullfile(inputDirFront, front(f).name)
end

end



