classdef AttckDTO
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        pos;
        atk;
    end
    
    methods
        function obj = AttckDTO(pos, atk)
            obj.pos = pos;
            obj.atk = atk;
        end
        function pos = getPos(obj)
            pos = obj.pos;
        end
        function atk = getAtk(obj)
            atk = obj.atk;
        end
   
    end
end

