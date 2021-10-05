function [ownPokemon, enemyPokemon] = imageprocessing_pokemon_sprites(ownImage, enemyImage, frontSprites, backSprites, db)
%IMAGEPROCESSING_STATUS Summary of this function goes here
%   Detailed explanation goes here
left = 17;
top = 9;
width = 31;
heightOwn = 56;
heightEnemy = 69;
enemyImageCropped = imcrop(enemyImage, [left top width heightEnemy]);
ownImageCropped = imcrop(ownImage, [left top width heightOwn]);
enemyImageThresholded = imcrop(enemyImage, [1 1 63 63]);
ownImageThresholded = imcrop(ownImage, [1 1 63 58]);

thE = otsuThreshold(enemyImageThresholded);
binaryEnemy = imcomplement(imbinarize(enemyImageThresholded, thE));
thO = otsuThreshold(ownImageThresholded);
binaryOwn = imcomplement(imbinarize(ownImageThresholded, thO));

[topE, rightE, downE, leftE] = determineWhitespace(binaryEnemy);
[topO, rightO, downO, leftO] = determineWhitespace(binaryOwn);
enemyEdge = [topE, rightE, downE, leftE];
ownEdge = [topO, rightO, downO, leftO];

current = intmax;
currentPercentFront = double(0);
bestFront = double(zeros(5));
bestBack = double(zeros(5));

for i = 1:numel(frontSprites)
    diffEnemy = abs(enemyEdge - frontSprites(i).whitespaceOriginal);
    if (diffEnemy(2) + diffEnemy(4)) > 25
        continue;
    end
    
    [sadFront, topFront, leftFront, percentageFront] = matchTemplate(enemyImageCropped, frontSprites(i).croppedSprite32);
    
    if percentageFront > currentPercentFront
        current = sadFront;
        currentPercentFront = percentageFront;
        bestFront = [sadFront, topFront, leftFront, double(percentageFront), i];
    end
    
end

current = intmax;
currentPercentBack = double(0);
for i = 1:numel(backSprites)
    diffOwn = abs(ownEdge - backSprites(i).whitespaceOriginal);
    if (diffOwn(2) + diffOwn(4)) > 25
        continue;
    end
    
    [sadBack, topBack, leftBack, percentageBack] = matchTemplate(ownImageCropped, backSprites(i).croppedSprite32);
    
    if percentageBack > currentPercentBack
       current = sadBack;
       currentPercentBack = percentageBack;
       bestBack = [sadBack, topBack, leftBack, double(percentageBack), i];
    end

end

enemyPokemon = db.getPokemon(frontSprites(bestFront(5)).number);
ownPokemon = db.getPokemon(backSprites(bestBack(5)).number);
end
