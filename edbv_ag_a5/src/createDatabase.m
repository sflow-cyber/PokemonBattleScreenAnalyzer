fid = fopen('moves.txt', 'r');
tablename = 'moves';
 
% set up db
 
 
if ~isfile('./pokemondata.db')
    disp('Creating Database File...');
    dbfile = fullfile(pwd, 'pokemondata.db');
    conn = sqlite(dbfile, 'create');
    disp('Creatinging Table Moves...');
    createAttackTable = ('create table moves (name VARCHAR PRIMARY KEY, type VARCHAR, power NUMERIC, accuracy NUMERIC, pp NUMERIC, effect VARCHAR, cond_perc NUMERIC, cond VARCHAR , status_perc NUMERIC, status VARCHAR  )');
    exec(conn,createAttackTable)
    exec(conn, 'create table pokemon (NUMBER NUMERIC PRIMARY KEY, NAME VARCHAR, TYPE1 VARCHAR, TYPE2 VARCHAR, TOTAL NUMERIC, HP NUMERIC, ATTACK NUMERIC, DEFENSE NUMERIC, SPATTACK NUMERIC, SPDEFENSE, SPEED)')
    exec(conn, 'create table testdata (FILENAME VARCHAR PRIMARY KEY, RESOLUTION NUMERIC, SPRITE VARCHAR, ENEMYSPRITE VARCHAR, LVL NUMERIC, ENEMYLVL NUMERIC, HP NUMERIC, ENEMYHP NUMERIC, STATE VARCHAR, ENEMYSTATE VARCHAR, ATTACK1 VARCHAR, ATTACK2 VARCHAR, ATTACK3 VARCHAR, ATTACK4 VARCHAR)')

else
    disp('Connecting to database moves ... ');
    dbfile = fullfile(pwd, 'pokemondata.db');
    conn = sqlite(dbfile);
end
 
answer = questdlg("Would you like to see the table or create a new one?", 'Box', 'create' , 'see', 'hm' );
 
switch(answer)
    case 'create'
    tline = fgetl(fid);
    eff_str = "Move type:";
    while ischar(tline)
        if strncmp(eff_str, tline, 9)        
            % READING LINES AND ERASING UNNESSESARY INFORMATION %
            % NAME (READ PREVIOUS UNTIL BLANK -> NEXT IS NAME) %
                name = string(tprev);
		name = strtrim(name);
            % TYPE %
                type = erase(string(tline), 'Move type:');
		type = strtrim(type);
            % MOVE POWER | DB SEEMS TO BE PARSING THE NUMERIC AUTOMATICALLY %
                tline = fgetl(fid);
                power = erase(string(tline), 'Move power:');
		power = strtrim(power);
            % ACCURACY %
                tline = fgetl(fid);
            	accuracy = erase(string(tline), 'Accuracy: ');
		accuracy = strtrim(accuracy);
            % PP %
                tline = fgetl(fid);
                pp = erase(string(tline), 'PP: ');
		pp = strtrim(pp);
            % EFFECT %
                tline = fgetl(fid);
                effect = erase(string(tline), 'Effects: ');
		effect = strtrim(effect);
            % CONDITION AND PERCANTAGE %
                tline = fgetl(fid);
                cond = erase(string(tline), 'Condition:');
		cond = strtrim(cond);
                tline = fgetl(fid);
                cond_perc = erase(string(tline), 'Condition_Chance:');
		cond_perc = strtrim(cond_perc);
            % STATUS AND PERCANTAGE %
                tline = fgetl(fid);
                status= erase(string(tline), 'Status:');
		status = strtrim(status);
                tline = fgetl(fid);
                status_perc = erase(string(tline), 'Status_Chance:');
		status_perc = strtrim(status_perc);

            % CREATE SQL INSERT QUERY %
            sql_query = strcat("INSERT INTO " , tablename , " ('name', 'type', 'power', 'accuracy', 'pp', 'effect', 'cond_perc', 'cond', 'status_perc', 'status') VALUES ('", name , "' , '", type, "' ,'", power, "' ,'", accuracy , "' ,'", pp, "' ,'", effect, "' , '", cond_perc, "' ,'", cond, "' ,'", status_perc, "' ,'", status, "' )");
            exec(conn, sql_query);
 
        end
 
        tprev = tline;
        tline = fgetl(fid);  
 
    end
 
clear data, sql_query, name, accuracy, power, pp, effect, cond, cond_perc, status_perc, status;
 
    case 'see'
        query = "SELECT * FROM MOVES";
        rows = fetch(conn, query);
        disp(rows);
       
        clear query, rows, name, type, power, accuracy, pp ,  effect, cond_perc, cond, status_perc, status ;
end
 
 
clear answer, tablename;
close(conn);
clear conn;
clear dbfile;
fclose(fid);
clear fid;
