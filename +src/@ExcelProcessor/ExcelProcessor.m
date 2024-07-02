classdef ExcelProcessor
   % 使用示例：
%{
% 导入必要模块
import src.*;

% 创建对象
processor = ExcelProcessor('data/nsh202406.xlsx');

% 匹配测点
processor = processor.matchColumns('5L-4', true); % 精确匹配
% 或者
% processor = processor.matchColumns('点1', false); % 模糊匹配

% 替换值，支持多个条件，但要确保用户输入不矛盾
processor = processor.replaceValues(300, 'greater');
processor = processor.replaceValues(-300, 'less');
processor = processor.replaceValues(300, 'abs_greater');

% 保存文件
processor.saveToFile();
%}
    properties
        FileName          % Excel文件名
        Data              % 处理后的数据
        Headers           % 表头（测点编号）
        Time              % 时间列
        MatchedColumns    % 匹配的测点列
        ReplacementLog    % 替换日志
    end
    
    methods
        % 构造函数，初始化ExcelProcessor对象
        function obj = ExcelProcessor(fileName)
            obj.FileName = fileName;
            [~, ~, raw] = xlsread(fileName); % 读取Excel文件内容
            obj.Headers = raw(1, 2:end);     % 获取表头
            obj.Time = raw(2:end, 1);        % 获取时间列
            obj.Data = obj.convertToNumeric(raw(2:end, 2:end)); % 转换数据
            obj.ReplacementLog = containers.Map(); % 初始化替换日志
        end
        
        % 将元胞数组转换为数值数组，保留非数值数据
        function numericData = convertToNumeric(obj, cellData)
            [rows, cols] = size(cellData);
            numericData = cell(rows, cols);
            for i = 1:rows
                for j = 1:cols
                    if isnumeric(cellData{i, j})
                        numericData{i, j} = cellData{i, j};
                    else
                        % 尝试将非数值字符串转换为数值
                        num = str2double(cellData{i, j});
                        if ~isnan(num)
                            numericData{i, j} = num;
                        else
                            numericData{i, j} = cellData{i, j}; % 保留原始字符串
                        end
                    end
                end
            end
        end
        
        % 匹配测点列，根据是否精确匹配搜索字符串
        function obj = matchColumns(obj, searchString, isExactMatch)
            if isExactMatch
                obj.MatchedColumns = find(strcmp(obj.Headers, searchString));
            else
                obj.MatchedColumns = find(contains(obj.Headers, searchString));
            end
        end
        
        % 根据条件替换数据，并记录替换日志
        function obj = replaceValues(obj, threshold, condition)
            for col = obj.MatchedColumns
                colHeader = obj.Headers{col}; % 获取列头
                replacementCount = 0; % 初始化替换计数
                for row = 1:size(obj.Data, 1)
                    value = obj.Data{row, col};
                    if isnumeric(value)
                        switch condition
                            case 'greater'
                                if value > threshold
                                    obj.Data{row, col} = '--';
                                    replacementCount = replacementCount + 1;
                                end
                            case 'less'
                                if value < threshold
                                    obj.Data{row, col} = '--';
                                    replacementCount = replacementCount + 1;
                                end
                            case 'abs_greater'
                                if abs(value) > threshold
                                    obj.Data{row, col} = '--';
                                    replacementCount = replacementCount + 1;
                                end
                        end
                    end
                end
                if replacementCount > 0
                    obj.ReplacementLog(colHeader) = replacementCount; % 更新替换日志
                end
            end
        end
        
        % 保存处理后的数据到Excel文件，并记录日志
        function saveToFile(obj)
            [fileDir, name, ext] = fileparts(obj.FileName); % 获取文件目录和文件名
            newFileName = sprintf('%s_processed_%s%s', name, datestr(now, 'yyyymmdd_HHMMSS'), ext);
            newFilePath = fullfile(fileDir, newFileName); % 生成新的文件路径
            
            raw = [obj.Time, obj.Data];
            raw = [['时间', obj.Headers]; raw]; % 添加表头
            xlswrite(newFilePath, raw); % 保存处理后的数据到Excel文件
            
            % 保存日志文件
            logFileName = sprintf('%s_log_%s.txt', name, datestr(now, 'yyyymmdd_HHMMSS'));
            logFilePath = fullfile(fileDir, logFileName); % 生成日志文件路径
            logFile = fopen(logFilePath, 'w'); % 打开日志文件
            fprintf(logFile, 'Replacement Log:\n');
            keys = obj.ReplacementLog.keys;
            for i = 1:length(keys)
                fprintf(logFile, '%s: %d replacements\n', keys{i}, obj.ReplacementLog(keys{i}));
            end
            fclose(logFile); % 关闭日志文件
        end
    end
end


