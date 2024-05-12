% 引入包中的所有类
import src.*;
addpath('tests');
results = runtests('TestDataReader');
disp(results);
%results = runtests('TestDataProcessor');
%disp(results);