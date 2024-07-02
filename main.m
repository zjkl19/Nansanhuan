% 引入包中的所有类
import src.*

% 创建实例
reader = DataReader('data/nsh202406.xlsx', '传感器监测数据报表');
correctionValues = -1*[-0.01475, -0.01469, -0.02281, 0.007769, 0.0056, 0.0053, 0.006189, 0.0036, 0.004347, 0.0043, 0.0087, -0.005697, -0.002195, 0.004105, 0.006639, 0.004022, 0.004296, 0.00469, -0.004077];
correctionPoints = {'3R-2', '3R-3', '3R-5', '3R-6', '5L-1', '5L-5', '5L-6', '5L-9', '5L-10', '5L-12', '5L-13', '5L-15', '5R-4', '5R-9', '5R-14', '5R-15', '5R-17', '5R-18', '5R-23'};
correctionMap = containers.Map(correctionPoints, correctionValues);
processor = DataProcessor('CorrectionMap', correctionMap, 'LogFile', 'my_custom_log.log');

plotter = DataPlotter(    'FolderName', 'results/plots','ImageSize', [1000, 280],'AutoSetXlims', false,'AutoSetYlims', false,'Xlims', ...
    [datetime(2024, 06, 01), datetime(2024, 06, 30)], 'Ylims', [-0.10,0.10], 'YPrecision', '%.2f',     'DrawWarningLines', true);
% 创建控制器
controller = Controller(reader, processor, plotter);

%处理
controller.processSensorStatistics();
% 作图
controller.run();

% plotter = DataPlotter(    'FolderName', 'results/plots', ...  % 指定图像保存的文件夹
%     'ImageSize', [800, 600], ...        % 设置图像尺寸
%     'AutoSetXlims', true,  ...          % 开启自动设置X轴范围
%     'AutoSetYlims', false,  ...         % 关闭自动设置Y轴范围，如果需要开启，设置为true
%     'Xlims', [],       ...              % X轴范围，如果AutoSetXlims为false且需要手动设置，请提供如[0, 10]
%     'Ylims', [],        ...             % Y轴范围，如果AutoSetYlims为false且需要手动设置，请提供如[0, 5]
%     'YPrecision', '%.2f',   ...         %设置Y轴标签的数值精度
%     'DrawWarningLines', true ...       %开启绘制预警线
% );