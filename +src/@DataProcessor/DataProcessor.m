classdef DataProcessor
    properties
        CorrectionMap
        LogFile = 'default_logfile.log'; % 默认日志文件路径
        DataFile = 'data/裂缝宽度监测结果.xlsx'; % 默认数据文件路径
        SheetName = '裂缝宽度数据汇总表'; % 默认工作表名称
        DecimalPrecision = 3; % 默认保留小数位数
    end
    
    methods
        function obj = DataProcessor(varargin)
            % 处理输入参数，允许动态设置属性
            for k = 1:2:length(varargin)
                if isprop(obj, varargin{k})
                    obj.(varargin{k}) = varargin{k+1};
                end
            end
        end
        
        function displacement_data = convertToStrain(obj, strain_data, headers)
            displacement_data = strain_data * 10^-6 * 150;
            
            % 提取纯测点编号
            pattern = '^\d+[A-Z]-\d+';
            for i = 1:length(headers)
                headerParts = regexp(headers{i}, pattern, 'match');
                if ~isempty(headerParts)
                    pointID = headerParts{1};  % 匹配到的测点编号
                    if isKey(obj.CorrectionMap, pointID)
                        correction = obj.CorrectionMap(pointID);
                        displacement_data(:, i) = displacement_data(:, i) + correction;
                    end
                end
            end
        end
        
        function results = calculateMetrics(obj, displacement_data, headers)
            % 读取历史峰值数据
            historicalData = readtable(obj.DataFile, 'Sheet', obj.SheetName);
            historicalSensors = historicalData{:, 2};
            historicalPeakValues = historicalData{:, 4};
            lastPeriodMeans = historicalData{:, 7};
            
            numSensors = length(headers);
            results = struct('SensorID', {}, 'PeakValue', {}, 'HistoricalPeakValue', {}, 'PeakDifference', {}, 'MeanValue', {}, 'LastPeriodMean', {}, 'MeanDifference', {});
            
            for i = 1:numSensors
                % 初始化每个传感器的结构体元素
                results(i).SensorID = headers{i};
                results(i).PeakValue = 0;
                results(i).MeanValue = 0;
            end
            
            % 打开日志文件以追加模式
            fid = fopen(obj.LogFile, 'a');
            if fid == -1
                error('Failed to open log file.');
            end
            
            try
                for i = 1:numSensors
                    sensorData = displacement_data(:, i);
                    % 提取测点编号
                    sensorID = regexp(headers{i}, '^\d+[A-Z]-\d+', 'match', 'once');
                    results(i).SensorID = sensorID;
                    try
                        % 计算峰值和均值
                        results(i).PeakValue = round(max(sensorData), obj.DecimalPrecision);
                        results(i).MeanValue = round(mean(sensorData, 'omitnan'), obj.DecimalPrecision);
                          
                        % 匹配历史峰值
                        index = find(strcmp(historicalSensors, sensorID));
                        if ~isempty(index)
                            if ~strcmp(historicalData{index, 4}, '--')
                                results(i).HistoricalPeakValue = historicalPeakValues(index);
                                results(i).PeakDifference = results(i).PeakValue - results(i).HistoricalPeakValue;
                            else
                                results(i).HistoricalPeakValue = NaN;
                                results(i).PeakDifference = NaN;
                            end
                            if ~strcmp(historicalData{index, 7}, '--')
                                results(i).LastPeriodMean = lastPeriodMeans(index);
                                results(i).MeanDifference = results(i).MeanValue - results(i).LastPeriodMean;
                            else
                                results(i).LastPeriodMean = NaN;
                                results(i).MeanDifference = NaN;
                            end
                        else
                            results(i).HistoricalPeakValue = NaN;
                            results(i).PeakDifference = NaN;
                            results(i).LastPeriodMean = NaN;
                            results(i).MeanDifference = NaN;
                        end
                        
                    catch ME
                        errorMsg = sprintf('%s: Failed to process sensor %s - %s\n', datestr(now), headers{i}, ME.message);
                        fprintf(fid, errorMsg);  % Log to file
                        fprintf(2, errorMsg);  % Print to console as well
                        results(i).PeakValue = NaN;
                        results(i).MeanValue = NaN;
                    end
                end
            catch ME
                errorMsg = sprintf('%s: Unexpected error - %s\n', datestr(now), ME.message);
                fprintf(fid, errorMsg);  % Log to file
                fprintf(2, errorMsg);  % Print to console as well
            end
            
            fclose(fid);  % 确保在函数结束前关闭文件
        end
        
    end
end
