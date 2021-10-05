classdef Attack
    %' name', 'type', 'power', 'accuracy', 'pp', 'effect', 'cond_perc', 'cond', 'status_perc', 'status'
    properties
        aName;
        dbResp;
        type;
        power;
        accuracy;
        pp;
        effect;
        cond_perc;
        cond;
        status_perc;
        status;
    end
    
    methods
        function this = Attack(aName)
            this.aName = aName;
            % read other properties from database
            % check if name == '-', i.e. is empty attack
            this.type = "N/A";
            this.power = "N/A";
            this.accuracy = "N/A";
            this.pp = "N/A";
            this.effect = "N/A";
            this.cond_perc = "N/A";
            this.cond = "N/A";
            this.status_perc = "N/A";
            this.status = "N/A";
            if strtrim(aName) == "N/A"
               % data empty 
               this.dbResp = "empty";
               return;
            end
            % check if found in DB
            selectQuery = strcat("SELECT * FROM MOVES WHERE LOWER(REPLACE(REPLACE(name, ' ', ''), '-', '')) = LOWER(REPLACE(REPLACE('", aName, "', ' ', ''), '-',''));");
            conn = Database().connection;
            data = fetch(conn, selectQuery);
            foundInDb = size(data) == 1;
            close(conn);
            if ~foundInDb
                this.dbResp = "n/a";
                % write to missing attacks log:
                if exist('.\missingMovesLog.txt', 'file')
                    filetext = fileread('.\missingMovesLog.txt');
                    if ~contains(upper(filetext), newline + upper(aName) + newline)
                        fileID = fopen('.\missingMovesLog.txt', 'a');
                    else
                        return;
                    end
                else
                    fileID = fopen('.\missingMovesLog.txt', 'w');
                end
                fprintf(fileID, '%s\n', strtrim(aName));
                fclose(fileID);
                return;
            end
            % if  found, then create object with data
            this.dbResp = "found";
            this.type = convertCharsToStrings(data(1, 2));
            this.power = data{1, 3};
            this.accuracy = data{1, 4};
            this.pp = data{1, 5};
            this.effect = convertCharsToStrings(data(1, 6));
            this.cond_perc = data{1, 7};
            this.cond = convertCharsToStrings(data(1, 8));
            this.status_perc = data{1, 9};
            this.status = convertCharsToStrings(data(1, 10));
        end
        function aName = getAName(this)
            aName = this.aName;
        end
        function this = setAName(this, aName)
            this.aName = aName;
        end
        function type = getType(this)
            type = this.type;
        end
        function this = setType(this, type)
            this.type = type;
        end
        function power = getPower(this)
            power = this.power;
        end
        function this = setPower(this, power)
            this.power = power;
        end
        function accuracy = getAccuracy(this)
            accuracy = this.accuracy;
        end
        function this = setAccuracy(this, accuracy)
            this.accuracy = accuracy;
        end
        function pp = getPP(this)
            pp = this.pp;
        end
        function this = setPP(this, pp)
            this.pp = pp;
        end
        function effect = getEffect(this)
            effect = this.effect;
        end
        function this = setEffect(this, effect)
            this.effect = effect;
        end
        function cond_perc = getCond_perc(this)
            cond_perc = this.cond_perc;
        end
        function this = setCond_perc(this, cond_perc)
            this.cond_perc = cond_perc;
        end
        function cond = getCond(this)
            cond = this.cond;
        end
        function this = setCond(this, cond)
           this.cond = cond; 
        end
        function status_perc = getStatus_perc(this)
           status_perc = this.status_perc; 
        end
        function this = setStatus_perc(this, status_perc)
            this.status_perc = status_perc;
        end
        function status = getStatus(this)
            status = this.status;
        end
        function this = setStatus(this, status)
            this.status = status;
        end
        function dbResp = getDBResp(this)
            dbResp = this.dbResp;
        end
    end
end

