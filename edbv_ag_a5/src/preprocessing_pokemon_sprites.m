function [own, enemy] = preprocessing_pokemon_sprites(inputImage)
%PREPROCESSING_POKEMON_SPRITES Summary of this function goes here
%   Detailed explanation goes here
inputImage = rgb2gray(inputImage);
own = imcrop(inputImage, [41, 54, 63, 64]);
enemy = imcrop(inputImage, [145, 11, 63, 77]);
end

