classdef DataPlotter
    properties
        FolderName = 'results/plots';  % 设置默认文件夹名称
        ImageSize = [1000, 280];        % 图像尺寸默认值
        Xlims
        Ylims
        YPrecision = '%.2f';          % 默认小数位数精度
        AutoSetXlims = false;         % 是否自动设置X轴界限
        AutoSetYlims = false;         % 是否自动设置Y轴界限
        DrawWarningLines = false;     % 是否绘制预警线
    end
    
    methods
        function obj = DataPlotter(varargin)
            for k = 1:2:length(varargin)
                if isprop(obj, varargin{k})
                    obj.(varargin{k}) = varargin{k+1};
                end
            end
        end
        
        function plotAndSave(obj, time_data, displacement_data, headers)
            % 确保日志文件可写
            logFile = fullfile(obj.FolderName, 'plot_errors.log');
            fid = fopen(logFile, 'a');
            if fid == -1
                error('无法打开日志文件写入错误信息。');
            end  
            
            for i = 1:length(headers)
                try
                    figure('Position', [100, 100, obj.ImageSize(1), obj.ImageSize(2)]);
                    plot(time_data, displacement_data(:, i), 'LineWidth', 1.5);
                    grid on;         % 开启网格线
                    grid minor;      % 开启次要网格线
                    
                    xlabel('时间');
                    ylabel(sprintf(['裂缝宽度增量 (mm) ' obj.YPrecision]));
                    hold on;
                    
                    % 提取和设置图例名称
                    legendName = regexp(headers{i}, '^\d+[A-Z]-\d+', 'match');
                    legend(legendName);
                    
                    % 绘制预警线
                    if obj.DrawWarningLines
                        yline(0.05, 'r', 'LineWidth', 1.5, 'HandleVisibility', 'off');  % 红色预警线不显示在图例中
                        yline(0.03, 'y', 'LineWidth', 1.5, 'HandleVisibility', 'off');  % 黄色预警线不显示在图例中
                    end
                    
                    
                    % 设置X轴和Y轴
                    % 设置X轴和Y轴
                    if obj.AutoSetXlims
                        min_time = min(time_data);
                        max_time = max(time_data);
                        xlim([min_time, max_time]);
                        % 自动生成刻度
                        xticks(linspace(min_time, max_time, 5));  % 这里的数字5可以根据需要调整为更多或更少的刻度数
                    elseif isempty(obj.Xlims)
                        warning('Xlims is not set while AutoSetXlims is false. Xlim is being set automatically.');
                        xlim([min(time_data), max(time_data)]);
                        xticks(linspace(min(time_data), max(time_data), 5));
                    else
                        xlim(obj.Xlims);
                        xticks(linspace(obj.Xlims(1), obj.Xlims(2), 5));
                    end
                    % 设置日期格式
                    xtickformat('MM月dd日');
                    
                    hold off;
                    set(gca, 'YTickLabel', num2str(get(gca, 'YTick')', obj.YPrecision));
                    % 验证并设置Y轴
                    if obj.AutoSetYlims || isempty(obj.Ylims) || all(isnan(displacement_data(:, i))) || (obj.Ylims(1) == obj.Ylims(2))
                        ylim_auto = [nanmin(displacement_data(:, i)), nanmax(displacement_data(:, i))];
                        if isnan(ylim_auto(1)) || ylim_auto(1) == ylim_auto(2)  % 处理全NaN或最值相等的情况
                            ylim_auto = [0 1];  % 提供一个默认的Y轴范围
                        else
                            ylim_auto = ylim_auto + [-1, 1] * 0.1;  % 小幅扩展Y轴范围
                        end
                        ylim(ylim_auto);
                    elseif ~isempty(obj.Ylims) && obj.Ylims(1) < obj.Ylims(2)
                        ylim(obj.Ylims);
                    else
                        warning('Invalid Ylims provided for plot of %s. Adjusting based on data.', headers{i});
                        ylim([nanmin(displacement_data(:, i)), nanmax(displacement_data(:, i))]);
                    end
                    
                    hold off;
                    set(gca, 'YTickLabel', num2str(get(gca, 'YTick')', obj.YPrecision));  % 设置Y轴标签格式，避免科学计数法
                    % Save logic here
                    baseFileName = sprintf('%s/%s', obj.FolderName, headers{i});
                    savefig([baseFileName '.fig']);
                    saveas(gcf, [baseFileName '.emf'], 'meta');
                    saveas(gcf, [baseFileName '.jpg'], 'jpeg');
                    close(gcf);
                catch ME
                    fprintf(fid, '%s: Error processing %s - %s\n', datetime('now'), headers{i}, ME.message);
                    fprintf('Error processing %s: %s\n', headers{i}, ME.message);
                    close(gcf); % 确保即使出错也关闭图形窗口
                    fclose(fid);
                end
            end
            fclose(fid);
        end
    end
end
