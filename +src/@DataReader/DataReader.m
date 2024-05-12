classdef DataReader
    properties
        Filename
        Sheetname
    end
    
    methods
        function obj = DataReader(filename, sheetname)
            obj.Filename = filename;
            obj.Sheetname = sheetname;
        end
        
        function [time_data, strain_data, headers] = readData(obj)
            [~, ~, raw_data] = xlsread(obj.Filename, obj.Sheetname);
            headers = raw_data(1, :);
            data = raw_data(2:end, :);
            time_data = datetime(data(:, 1), 'InputFormat', 'yyyy-MM-dd HH:mm:ss');
            strain_indices = contains(headers, '微应变(με)');
            headers = headers(strain_indices);
            strain_data = data(:, strain_indices);
            for i = 1:size(strain_data, 2)
                for j = 1:size(strain_data, 1)
                    if strcmp(strain_data{j, i}, '--')
                        strain_data{j, i} = NaN;
                    end
                end
            end
            strain_data = cell2mat(strain_data);
        end
    end
end
