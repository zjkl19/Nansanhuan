classdef TestDataProcessor < matlab.unittest.TestCase
    properties
        Processor
        StrainData
        Headers
        CorrectionMap
    end

    methods (TestMethodSetup)
        function createProcessor(testCase)
            import src.*
            testCase.CorrectionMap = containers.Map({'3R-2', '3R-3'}, [-0.01475, -0.01469]);
            testCase.Processor = DataProcessor(testCase.CorrectionMap);
            testCase.StrainData = [500; 1000];  % 假设的测试数据
            testCase.Headers = {'3R-2', '3R-3'};
        end
    end
    
    methods (Test)
        function testConvertToStrain(testCase)
            displacement_data = testCase.Processor.convertToStrain(testCase.StrainData, testCase.Headers);
            expected_data = testCase.StrainData * 10^-6 * 150 + [-0.01475; -0.01469];
            testCase.verifyEqual(displacement_data, expected_data, 'AbsTol', 1e-5, '位移数据转换或修正不正确');
        end
    end
end
