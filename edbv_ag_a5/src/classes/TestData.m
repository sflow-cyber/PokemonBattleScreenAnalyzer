classdef TestData
    %TESTDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        FileName;
        Resolution;
        Sprite;
        EnemySprite;
        Lvl;
        EnemyLvl;
        HP;
        EnemyHP;
        State;
        EnemyState;
        Attack1;
        Attack2;
        Attack3;
        Attack4;
    end
    
    methods
        function obj = TestData(FileName, Resolution, Sprite, EnemySprite, Lvl, EnemyLvl, HP, EnemyHP, State, EnemyState, Attack1, Attack2, Attack3, Attack4)
            %TESTDATA Construct an instance of this class
            %   Detailed explanation goes here
            obj.FileName = FileName;
            obj.Resolution = Resolution;
            obj.Sprite = Sprite;
            obj.EnemySprite = EnemySprite;
            obj.Lvl = Lvl;
            obj.EnemyLvl = EnemyLvl;
            obj.HP = HP;
            obj.EnemyHP = EnemyHP;
            obj.State = State;
            obj.EnemyState = EnemyState;
            obj.Attack1 = Attack1;
            obj.Attack2 = Attack2;
            obj.Attack3 = Attack3;
            obj.Attack4 = Attack4;
        end
    end
end

