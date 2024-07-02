import src.*;

% 创建对象
processor = ExcelProcessor('data/nsh202406.xlsx');

% 匹配测点
processor = processor.matchColumns('5L-4', false); % 精确匹配
% 或者
% processor = processor.matchColumns('点1', false); % 模糊匹配

% 替换值，支持多个条件，但要确保用户输入不矛盾
processor = processor.replaceValues(300, 'greater');
processor = processor.replaceValues(-300, 'less');
processor = processor.replaceValues(300, 'abs_greater');

% 保存文件
processor.saveToFile();
