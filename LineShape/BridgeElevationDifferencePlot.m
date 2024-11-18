% File: BridgeElevationDifferencePlot.m
% 清理工作区
clear;
clc;

% 主函数调用，读取数据并绘图
main();

function main()
    % 读取数据
    [x_data, y_data, variableNames, sheetName] = readData();
    
    % 绘制高程差图
    plotElevationDifference(x_data, y_data, variableNames, sheetName);
end

% 读取数据的函数
function [x_data, y_data, variableNames, sheetName] = readData()
    % 指定 Excel 文件名和工作表名称
    fileName = 'data.xlsx';  % Excel 文件名称
    sheetName = 'Y5YDelta';  % 工作表名称

    % 从 Excel 文件读取数据
    data = readtable(fileName, 'Sheet', sheetName, 'PreserveVariableNames', true);

    % 假设 x_data 在第一列，y_data 在第2到第n列
    x_data = data{:, 1};             % 读取 x 轴数据
    y_data = data{:, 2:end};         % 读取 y 轴数据（支持多列）
    variableNames = data.Properties.VariableNames(2:end);  % 获取 y 轴数据的列名
end

% 绘制高程差的函数
% 绘制高程差的函数
function plotElevationDifference(x_data, y_data, variableNames, sheetName)
    % 创建图像
    figure(1);
    hold on;

    % 定义颜色和标记
    colors = ['r', 'b', 'k', 'g', 'm', 'c', 'y', '#D95319', '#EDB120', '#7E2F8E'];
    markers = {'o', '*', 'x', 's', 'd', '^', 'v', '+', 'p', 'h'};

    % 循环绘制各条曲线
    num_columns = min(size(y_data, 2), length(colors));  % 确保不超过预定义的颜色和标记数量
    for i = 1:num_columns
        plot(x_data, y_data(:, i), markers{i}, 'MarkerSize', 5, 'color', colors(i), 'LineWidth', 2);
    end

    % 根据 sheetName 设置坐标轴范围和刻度
    if contains(sheetName, '5')
        % 设置坐标轴范围和刻度 - 含有 '5'
        axis([0 440 -0.02*1000 0.020*1000]);
        set(gca, 'xtick', [0 30 60 90 120 150 180 215 250 280 310 340 375 410 440]);
        set(gca,'xticklabel',{'0#','1#', '2#','3#' ,'4#' ,'5#', '6#', '7#', '8#', '9#', '10#', '11#', '12#', '13#', '14#'});
        set(gca, 'ytick', [-0.02 -0.015 -0.010 -0.005 0.000 0.005 0.010 0.015 0.02]*1000);
        set(gca, 'yticklabel', {'-20.0', '-15.0', '-10.0', '-5.0', '0.0', '5.0', '10.0', '15.0', '20.0'});
    elseif contains(sheetName, '3')
        % 设置坐标轴范围和刻度 - 含有 '3'
        axis([0 365 -0.025*1000 0.015*1000]);
        set(gca,'xtick',[0 30 60 90 120 155 185 215 245 275 305 335 365]);
        set(gca,'xticklabel',{'0#','1#', '2#','3#' ,'4#' ,'5#', '6#', '7#', '8#', '9#', '10#', '11#', '12#'});
        set(gca,'ytick',[-0.025 -0.02 -0.015 -0.01 -0.005 0 0.005 0.01 0.015]*1000);
        set(gca,'yticklabel',{'-25','-20','-15', '-10','-5' ,'0' ,'5', '10', '15'});
    else
        % 默认设置
        axis([0 440 -0.02*1000 0.020*1000]);
        set(gca, 'xtick', [0 30 60 90 120 150 180 215 250 280 310 340 375 410 440]);
        set(gca,'xticklabel',{'0#','1#', '2#','3#' ,'4#' ,'5#', '6#', '7#', '8#', '9#', '10#', '11#', '12#', '13#', '14#'});
        set(gca, 'ytick', [-0.02 -0.015 -0.010 -0.005 0.000 0.005 0.010 0.015 0.02]*1000);
        set(gca, 'yticklabel', {'-20.0', '-15.0', '-10.0', '-5.0', '0.0', '5.0', '10.0', '15.0', '20.0'});
    end

    % 设置x轴和y轴标签
    xlabel('墩（台）号');
    ylabel('高程差（mm）');

    % 图例设置，使用从Excel中获取的列名
    legend(variableNames, 'Location', 'best', 'Box', 'off');

    % 设置字体大小和图像大小
    set(gca, 'fontsize', 15);
    set(gcf, 'position', [500, 450, 1800, 450]);

    % 设置网格
    grid on;
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
end

