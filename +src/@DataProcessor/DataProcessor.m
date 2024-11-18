classdef DataProcessor
    properties
        CorrectionMap
        LogFile = 'default_logfile.log'; % 默认日志文件路径
        DataFile = 'data/裂缝宽度监测结果.xlsx'; % 默认数据文件路径
        OutputDir = 'results/crack_monitoring';
        SheetName = '裂缝宽度数据汇总表';
        OutputFileName = '裂缝宽度监测结果-输出.xlsx'; % 文件名作为属性
        DecimalPrecision=3
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
        
        function results = computeSensorStatistics(obj, displacement_data, headers)
            % 读取历史峰值数据
            historicalData = readtable(obj.DataFile, 'Sheet', obj.SheetName);
            historicalSensors = historicalData{:, 2};
            historicalPeakValues = historicalData{:, 4};
            lastPeriodMeans = historicalData{:, 7};
            
            numSensors = length(headers);
            results = struct('SensorID', {}, 'PeakValue', {}, 'HistoricalPeakValue', {}, 'PeakDifference', {}, 'MeanValue', {}, 'LastPeriodMean', {}, 'MeanDifference', {}, 'IsHistoricalPeakUpdated', {}, 'CurrentHistoricalPeak', {});
            for i = 1:numSensors
                % 初始化每个传感器的结构体元素
                results(i).SensorID = headers{i};
                results(i).PeakValue = 0;
                results(i).MeanValue = 0;
            end
            
            % 打开或创建日志文件
            fid = fopen(obj.LogFile, 'a');
            if fid == -1
                [fid, msg] = fopen(obj.LogFile, 'wt'); % 尝试以写模式创建新文件
                if fid == -1
                    error('Failed to open or create log file: %s', msg);
                end
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
                                % 计算是否更新历史峰值
                                if results(i).PeakValue > results(i).HistoricalPeakValue
                                    results(i).IsHistoricalPeakUpdated = 1;
                                    results(i).CurrentHistoricalPeak = results(i).PeakValue;
                                    % 在日志中记录超过历史峰值的具体值和索引
                                    exceedingIndices = find(sensorData > results(i).HistoricalPeakValue);
                                    exceedingValues = sensorData(exceedingIndices);
                                    fprintf(fid, '%s: 传感器 %s 超过历史峰值。新峰值: %.3f, 历史峰值: %.3f\n', ...
                                        datestr(now), sensorID, results(i).PeakValue, results(i).HistoricalPeakValue);
                                    fprintf(2, '%s: 传感器 %s 超过历史峰值。新峰值: %.3f, 历史峰值: %.3f\n', ...
                                        datestr(now), sensorID, results(i).PeakValue, results(i).HistoricalPeakValue);
                                    for k = 1:length(exceedingIndices)
                                        fprintf(fid, '索引: %d, 值: %.3f\n', exceedingIndices(k), exceedingValues(k));
                                        fprintf(2, '索引: %d, 值: %.3f\n', exceedingIndices(k), exceedingValues(k));
                                    end
                                    
                                else
                                    results(i).IsHistoricalPeakUpdated = 0;
                                    results(i).CurrentHistoricalPeak = results(i).HistoricalPeakValue;
                                end
                            else
                                results(i).HistoricalPeakValue = NaN;
                                results(i).PeakDifference = NaN;
                                results(i).IsHistoricalPeakUpdated = 0;
                                results(i).CurrentHistoricalPeak = NaN;
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
                            results(i).IsHistoricalPeakUpdated = 0;
                            results(i).CurrentHistoricalPeak = NaN;
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
        function outputFile= prepareOutputDirectory(obj)
            if ~exist(obj.OutputDir, 'dir')
                mkdir(obj.OutputDir);
            end
            % 移除原始文件名中的.xlsx后缀
            baseFileName = regexprep(obj.OutputFileName, '\.xlsx$', '');
            
            % 添加时间戳到输出文件名
            timestamp = datestr(now, 'yyyymmdd_HHMMSS');
            outputFile = fullfile(obj.OutputDir, [baseFileName, '_', timestamp, '.xlsx']);
            if ~exist(outputFile, 'file')
                copyfile(obj.DataFile, outputFile, 'f');
            end
        end
        
        function updateExcelFile(obj, results)
            outputFile =obj.prepareOutputDirectory();
            % 使用 results 数组的长度确定行数
            numSensors = numel(results);
            
            % 现在读取前10列，到最后一个传感器数据行
            range = sprintf('A1:J%d', numSensors + 1);
            [~, ~, raw] = xlsread(outputFile, obj.SheetName, range);
            
            % 创建一个与现有数据大小相同的 cell array
            updatedData = raw;
            
            for i = 1:numel(results)
                coreSensorID = regexp(results(i).SensorID, '^\d+[A-Z]-\d+', 'match', 'once');
                sensorIndex = find(strcmp(raw(2:end, 2), coreSensorID)) + 1; % 加1因为跳过了表头
                if ~isempty(sensorIndex)
                    updatedData{sensorIndex, 3} = results(i).PeakValue;
                    updatedData{sensorIndex, 5} = results(i).PeakDifference;
                    updatedData{sensorIndex, 6} = results(i).MeanValue;
                    updatedData{sensorIndex, 8} = results(i).MeanDifference;
                    updatedData{sensorIndex, 9} = results(i).IsHistoricalPeakUpdated;
                    updatedData{sensorIndex, 10} = results(i).CurrentHistoricalPeak;
                end
            end
            
            % 将更新后的数据写回 Excel 文件，写入相同的范围
            xlswrite(outputFile, updatedData, obj.SheetName, range);
        end
        
        
    end
end
