addpath classes
db = Database();
conn = db.connection;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Pokemon %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Check if pokemon are already in database
data = fetch(conn, "SELECT * FROM POKEMON");

if numel(data) == 0
    jsonString = fileread('..\assets\pokemonData\pokemonList.json');

    pokemon = jsondecode(jsonString);

    colnames = {'NUMBER', 'NAME', 'TYPE1', 'TYPE2', 'TOTAL', 'HP', 'ATTACK', 'DEFENSE', 'SPATTACK', 'SPDEFENSE', 'SPEED'};
    sprintf("Populating pokemon table...")
    for i = 1:numel(pokemon)
        data = {str2num(pokemon(i).number), pokemon(i).name, pokemon(i).type1, pokemon(i).type2, str2num(pokemon(i).total), str2num(pokemon(i).hp), str2num(pokemon(i).attack), str2num(pokemon(i).defense), str2num(pokemon(i).spAttack), str2num(pokemon(i).spDefense), str2num(pokemon(i).speed)};
        insert(conn, "pokemon", colnames, data);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Test data %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data = fetch(conn, "SELECT * FROM TESTDATA");

if numel(data) == 0
    jsonString = fileread('..\assets\pokemonData\testData.json');
    testdata = jsondecode(jsonString);
    colnames = {'FILENAME', 'RESOLUTION', 'SPRITE', 'ENEMYSPRITE', 'LVL', 'ENEMYLVL', 'HP', 'ENEMYHP', 'STATE', 'ENEMYSTATE', 'ATTACK1', 'ATTACK2', 'ATTACK3', 'ATTACK4'};
    
    sprintf("Populating testdata table...")
    for i = 1:numel(testdata)
        data = {testdata(i).FileName, testdata(i).Resolution, testdata(i).Sprite, testdata(i).EnemySprite, testdata(i).Lvl, testdata(i).EnemyLvl, testdata(i).HP, testdata(i).EnemyHP, testdata(i).State, testdata(i).EnemyState, testdata(i).Attack1, testdata(i).Attack2, testdata(i).Attack3, testdata(i).Attack4};
        insert(conn, "testdata", colnames, data);
    end
end

sprintf("Done!")

close(conn);