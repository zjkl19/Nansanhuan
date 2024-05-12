classdef TestDataReader < matlab.unittest.TestCase
    properties
        Reader
    end

    methods (TestMethodSetup)
        function createReader(testCase)
            import src.*
            testCase.Reader = DataReader('data/nsh202403.xlsx', '传感器监测数据报表');
        end
    end
    
    methods (Test)
        function testReadData(testCase)
            [time_data, strain_data, headers] = testCase.Reader.readData();
            testCase.verifyNotEmpty(time_data, '时间数据为空');
            testCase.verifyNotEmpty(strain_data, '应变数据为空');
            testCase.verifyEqual(numel(headers), size(strain_data, 2), '头部数量与数据列数不匹配');
            testCase.verifyClass(time_data, 'datetime', '时间数据类型应为datetime');
        end
    end
end
