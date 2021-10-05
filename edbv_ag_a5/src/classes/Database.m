classdef Database
    %DATABASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        connection
    end
    
    methods
        function obj = Database()
            %DATABASE Construct an instance of this class
            %   Detailed explanation goes here
            dbfile = fullfile(pwd, '.\pokemondata.db');
            obj.connection = sqlite(dbfile);
        end
        
        function pokemon = getPokemon(obj, number)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            if ~isnumeric(number)
                throw(MException("Query argument must be number"));
            end
            query = strcat("SELECT * FROM POKEMON WHERE NUMBER=", num2str(number));
            data = fetch(obj.connection,query);
            if isempty(data)
                pokemon = data;
            else
                pokemon = Pokemon(cell2mat(data(1)), cell2mat(data(2)), cell2mat(data(3)), cell2mat(data(4)), cell2mat(data(5)), cell2mat(data(6)), cell2mat(data(7)), cell2mat(data(8)), cell2mat(data(9)), cell2mat(data(10)), cell2mat(data(11)));
            end
        end
        
        function testdata = getTestData(obj, filename)
            query = strcat("SELECT * FROM TESTDATA WHERE FILENAME='", filename, "'");
            data = fetch(obj.connection,query);
            if isempty(data)
                testdata = data;
            else
                testdata = TestData(cell2mat(data(1)), cell2mat(data(2)), cell2mat(data(3)), cell2mat(data(4)), cell2mat(data(5)), cell2mat(data(6)), cell2mat(data(7)), cell2mat(data(8)),cell2mat(data(9)), cell2mat(data(10)), cell2mat(data(11)), cell2mat(data(12)), cell2mat(data(13)), cell2mat(data(14)));
            end
        end
        
        function obj = close(obj)
            close(obj.connection);
        end
    end
end

