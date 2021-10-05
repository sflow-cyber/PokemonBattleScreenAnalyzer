addpath classes

db = Database();

if exist('frontSprites', 'var') ~= 1 || exist('backSprites', 'var') ~= 1
    tic;
    [frontSprites, backSprites] = loadSprites();
    spritesLoadingTime = toc
end

inputDir = '..\dataset\';
dataset = dir(fullfile(inputDir, '*.png'));
time = double(zeros(numel(dataset), 1));
correctness = uint8(zeros(numel(dataset), 1));
ownMap = containers.Map;
enemyMap = containers.Map;

notFound = 0;
for i = 1:numel(dataset)
    image = imread(fullfile(inputDir, dataset(i).name), 'png');
    testData = db.getTestData(dataset(i).name);
    
    if isempty(testData)
        notFound = notFound + 1;
        continue;
    end
    
    testing = sprintf("Testing image %s ...", dataset(i).name)
    if ownMap.isKey(testData.Sprite)
       ownMap(testData.Sprite) = ownMap(testData.Sprite) + 1;
    else
       ownMap(testData.Sprite) = 1; 
    end
    if enemyMap.isKey(testData.EnemySprite)
        enemyMap(testData.EnemySprite) = enemyMap(testData.EnemySprite) + 1;
    else
        enemyMap(testData.EnemySprite) = 1;
    end
    
    %Process Image and check with test data
    %image processing for all sub functions
    image = preprocessing_all(image);

    %feature specific preprocessing and segmentation
    %preprocessedStatus = preprocessing_status(image);
    %preprocessedLevel = preprocessing_level(image);
    [own, enemy] = preprocessing_pokemon_sprites(image);
    %preprocessedAttacks = preprocessing_attacks(image);
    %preprocessingHealthbar = preprocessing_healthbar(image);

    %reading information from the preprocessed images
    %TODO: discuss output format
    %imageprocessing_status(image);
    %imageprocessing_level(image);
    tic;
    [ownPokemon, enemyPokemon] = imageprocessing_pokemon_sprites(own, enemy, frontSprites, backSprites, db);
    time(i) = toc;
    
    correct = 1;
    
    if ~strcmpi(ownPokemon.name, testData.Sprite)
        correct = 0;
        own = sprintf("%s was falsely recognized, but %s was correct", ownPokemon.name, testData.Sprite)
    end
    if ~strcmpi(enemyPokemon.name, testData.EnemySprite)
        correct = 0;
        enemy = sprintf("%s was falsely recognized, but %s was correct", enemyPokemon.name, testData.EnemySprite)
    end
    if correct
        %success = sprintf("Both pokemon were correctly recognized")
    end
    
    correctness(i) = correct;
    
    %imageprocessing_attacks(image);
    %imageprocessing_healthbar(image);
    
end 
percentage = 100* sum(correctness)/(numel(correctness)-notFound);
result = sprintf("%d / %d test files were matched correctly (%.2f). Matching Templates took an average of %.3f seconds, highest duration: %.3f, lowest duration: %.3f. %d screenshots were not found in the test database", sum(correctness), numel(correctness)-notFound, percentage, mean(time), max(time), min(time), notFound)
db.close();