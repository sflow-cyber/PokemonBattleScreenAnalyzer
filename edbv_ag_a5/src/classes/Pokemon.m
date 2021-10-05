classdef Pokemon
    %POKEMON Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        number;
        name;
        type1;
        type2;
        total;
        hp;
        attack;
        defense;
        spAttack;
        spDefense;
        speed;
    end
    
    methods
        function obj = Pokemon(number, name, type1, type2, total, hp, attack, defense, spAttack, spDefense, speed)
            %POKEMON Construct an instance of this class
            %   Detailed explanation goes here
            obj.number = number;
            obj.name = name;
            obj.type1 = type1;
            obj.type2 = type2;
            obj.total = total;
            obj.hp = hp;
            obj.attack = attack;
            obj.defense = defense;
            obj.spAttack = spAttack;
            obj.spDefense = spDefense;
            obj.speed = speed;
        end
    end
end

