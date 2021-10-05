classdef PokemonSprite
    %POKEMONSPRITE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        sprite;
        croppedSprite48;
        croppedSprite32;
        file;
        number;
        whitespaceOriginal;
    end
    
    methods
        function obj = PokemonSprite(varargin)
            %POKEMONSPRITE Construct an instance of this class
            %   Detailed explanation goes here
            if nargin == 0
                obj.sprite = uint8(zeros(64,64));
                obj.croppedSprite48 = uint8(zeros(48,48));
                obj.croppedSprite32 = uint8(zeros(32,32));
                obj.file = "";
                obj.number = 0;
            elseif nargin == 4
                obj.sprite = uint8(varargin{1});
                obj.file = varargin{2};
                obj.number = varargin{3};
                obj.croppedSprite48 = uint8(imcrop(obj.sprite, [9, 9, 47, 47]));
                obj.croppedSprite32 = uint8(imcrop(obj.sprite, [17, 17, 31, 31]));
                obj.whitespaceOriginal(1:4) = varargin{4}(1:4);
            else
                throw(MException("Invalid constructor arguments"));
            end
            
            
        end
        
        function obj = setSprite(obj, sprite)
            obj.sprite = sprite;
            obj.croppedSprite48 = uint8(imcrop(sprite, [9, 9, 47, 47]));
            obj.croppedSprite32 = uint8(imcrop(sprite, [17, 17, 31, 31]));
        end
        
    end
end

