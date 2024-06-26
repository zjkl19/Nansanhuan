classdef Controller
    properties
        Reader
        Processor
        Plotter
    end
    
    methods
        function obj = Controller(reader, processor, plotter)
            obj.Reader = reader;
            obj.Processor = processor;
            obj.Plotter = plotter;
        end
        
        function run(obj)
            [time_data, strain_data, headers] = obj.Reader.readData();
            displacement_data = obj.Processor.convertToStrain(strain_data, headers);
            obj.Plotter.plotAndSave(time_data, displacement_data, headers);
        end
        
        function processSensorStatistics(obj)
            % 读取数据
            [time_data, strain_data, headers] = obj.Reader.readData();
            % 转换应变为位移
            displacement_data = obj.Processor.convertToStrain(strain_data, headers);
            % 计算峰值和均值
            results = obj.Processor.computeSensorStatistics(displacement_data, headers);
            % 更新Excel文件
            obj.Processor.updateExcelFile(results);
            % 可选：处理结果的其他用途，例如进一步的数据分析或可视化
        end
        
    end
end
