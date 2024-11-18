% 清理工作区
clear;
clc;

% 指定工作表名称的变量
sheetName = 'Y5Y';  % 你可以根据需要修改工作表名称

% 从Excel读取数据，使用变量指定工作表
data = readtable('data.xlsx', 'Sheet', sheetName, 'PreserveVariableNames', true);

% 读取x轴数据（假设x轴数据在第一列）
x_data = data{:, 1};

% 读取y轴数据（假设y轴数据在第2到第11列，不超过10条曲线）
y_data = data{:, 2:end};

% 获取列的数量
[num_rows, num_columns] = size(y_data);

% 设置颜色和线型的选项，可以根据需要调整
colors = ['r', 'b', 'k', 'g', 'm', 'c', 'y', '#D95319', '#EDB120', '#7E2F8E'];
lineStyles = {'-o', '-*', '-x', '-s', '-d', '-^', '-v', '-+', '-p', '-h'};

% 创建图像
figure(1);
hold on;

% 循环绘制各条曲线
for i = 1:num_columns
    plot(x_data, y_data(:, i), lineStyles{i}, 'MarkerSize', 5, 'color', colors(i), 'LineWidth', 2);
end

% 根据sheetName中的数字设置坐标轴范围和刻度
if contains(sheetName, '5')
    % 设置坐标轴范围和刻度 - 含有 '5'
    axis([0 440 -0.5 3.5])
    set(gca, 'xtick', [0 30 60 90 120 150 180 215 250 280 310 340 375 410 440]);
    set(gca,'xticklabel',{'0#','1#', '2#','3#' ,'4#' ,'5#', '6#', '7#', '8#', '9#', '10#', '11#', '12#', '13#', '14#'});
   set(gca,'ytick',[-0.5 0 0.5 1 1.5 2 2.5 3 3.5]);
    set(gca,'yticklabel',{'-0.5','0.0', '0.5','1.0' ,'1.5' ,'2.0', '2.5', '3.0', '3.5'});
elseif contains(sheetName, '3')
    % 设置坐标轴范围和刻度 - 含有 '3'
    axis([0 365 -0.5 2.5]);
    set(gca,'xtick',[0 30 60 90 120 155 185 215 245 275 305 335 365]);
    set(gca,'xticklabel',{'0#','1#', '2#','3#' ,'4#' ,'5#', '6#', '7#', '8#', '9#', '10#', '11#', '12#'});
    set(gca,'ytick',[-0.5 0 0.5 1 1.5 2 2.5 3]);
    set(gca,'yticklabel',{'-0.5','0.0', '0.5','1.0' ,'1.5' ,'2.0', '2.5', '3.0'});
else
    % 默认坐标轴范围和刻度设置
    axis([0 440 -0.5 3.5])
    set(gca, 'xtick', [0 30 60 90 120 150 180 215 250 280 310 340 375 410 440]);
    set(gca,'xticklabel',{'0#','1#', '2#','3#' ,'4#' ,'5#', '6#', '7#', '8#', '9#', '10#', '11#', '12#', '13#', '14#'});
    set(gca,'ytick',[-0.5 0 0.5 1 1.5 2 2.5 3 3.5]);
    set(gca,'yticklabel',{'-0.5','0.0', '0.5','1.0' ,'1.5' ,'2.0', '2.5', '3.0', '3.5'});
end

% 设置x轴和y轴标签
xlabel('墩（台）号');
ylabel('高程（m）');

% 图例设置，使用Excel表头作为图例
legend(data.Properties.VariableNames(2:end), 'Location', 'best', 'Box', 'off');

% 设置字体大小和图像大小
set(gca, 'fontsize', 15);
set(gcf, 'position', [500, 450, 1800, 450]);

%设置网格
grid on;
%grid minor;

% 持续显示
hold off;

% 保存图像的代码
% 指定保存路径和文件名，使用工作表名称作为文件名
outputFolder = 'results';  % 指定保存的文件夹
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);  % 如果文件夹不存在，创建文件夹
end

% 使用传入的工作表名称作为文件名
fileName = fullfile(outputFolder, sheetName);

% 保存为不同格式的图像文件
saveas(gcf, [fileName, '.emf']);  % 保存为 EMF 格式
saveas(gcf, [fileName, '.jpg']);  % 保存为 JPG 格式
saveas(gcf, [fileName, '.fig']);  % 保存为 FIG 格式