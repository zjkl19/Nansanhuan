clear
clc

x_3=[0.0 
7.5 
15.0 
22.5 
30.0 
37.5 
45.0 
52.5 
60.0 
67.5 
75.0 
82.5 
89.5 
91.5 
97.5 
105.0 
112.5 
120.0 
128.8 
137.5 
146.3 
155.0 
162.5 
170.0 
177.5 
185.0 
192.5 
200.0 
207.5 
215.0 
222.5 
230.0 
237.5 
244.5 
245.5 
252.5 
260.0 
267.5 
275.0 
282.5 
290.0 
297.5 
305.0 
312.5 
320.0 
327.5 
335.0 
342.5 
350.0 
357.5 
365.0 
]'

y_3_z=[0.0161 
0.0003 
0.0008 
0.0024 
-0.0017 
-0.0018 
-0.0018 
-0.0008 
-0.0011 
-0.0010 
-0.0010 
-0.0006 
-0.0004 
-0.0013 
0.0005 
0.0004 
0.0014 
0.0018 
0.0018 
0.0017 
0.0018 
0.0016 
0.0018 
0.0016 
0.0016 
0.0023 
0.0032 
0.0022 
0.0035 
0.0022 
0.0026 
0.0023 
0.0049 
0.0029 
0.0029 
0.0033 
0.0026 
0.0022 
0.0039 
0.0018 
0.0018 
0.0008 
0.0018 
0.0009 
0.0014 
0.0022 
0.0049 
0.0051 
0.0085 
0.0069 
0.0093 

]'

y_3_z2=[0.00918
0.00992
0.00868
0.00984
-0.0049
0.00771
0.00934
0.00894
0.01027
0.01087
0.01016
0.00973
0.00885
0.00791
0.00764
0.00826
0.00884
0.00798
0.00881
0.01042
0.00878
0.00905
0.00896
0.01081
0.00952
0.00954
0.00785
0.00886
0.00603
0.00503
0.00405
0.00318
-0.00358
0.00207
0.00167
0.0059
0.00118
0.00269
-0.00128
0.00519
0.00466
0.00394
-0.00012
0.00148
0.00188
-0.00031
-0.00116
-0.00088
-0.00172
0.00829
-0.00495

]'

y_3_z3=[0.00950 
-0.00554 
-0.00414 
-0.00357 
0.00643 
-0.00683 
-0.00786 
-0.00765 
-0.00810 
-0.00799 
-0.00750 
-0.00735 
-0.00627 
-0.00670 
-0.00614 
-0.00680 
-0.00690 
-0.00527 
-0.00609 
-0.00688 
-0.00553 
-0.00527 
-0.00506 
-0.00630 
-0.00543 
-0.00602 
-0.00442 
-0.00614 
-0.00463 
-0.00335 
-0.00357 
-0.00249 
0.00034 
-0.00247 
-0.00229 
-0.00459 
-0.00192 
-0.00246 
-0.00130 
-0.00351 
-0.00321 
-0.00234 
-0.00086 
-0.00121 
-0.00161 
-0.00061 
0.00090 
0.00055 
0.00248 
-0.00799 
0.00387 
]'


figure(1)
a=plot(x_3,y_3_z,'o','MarkerSize',5,'color',"r",'linewidth',2)
hold on 
b=plot(x_3,y_3_z2,'*','MarkerSize',5,'color',"b",'linewidth',1)
hold on 
b=plot(x_3,y_3_z3,'o','MarkerSize',5,'color',"k",'linewidth',1)


axis([0 365 -0.025 0.015])
positionAndSize=[500,450,1800,450];
set(gcf,'position',positionAndSize)
set(gca,'xtick',[0 30 60 90 120 155 185 215 245 275 305 335 365]);
%5#桥左侧
%5#桥右侧
set(gca,'xticklabel',{'0#','1#', '2#','3#' ,'4#' ,'5#', '6#', '7#', '8#', '9#', '10#', '11#', '12#'});
set(gca,'ytick',[-0.025 -0.02 -0.015 -0.01 -0.005 0 0.005 0.01 0.015]);
set(gca,'yticklabel',{'-25','-20','-15', '-10','-5' ,'0' ,'5', '10', '15',});
xlabel('墩（台）号');
ylabel('高程差（mm）');

hh=legend('2023.12-2021.3高程差值','2023.5-2022.9高程差值','2023.12-2023.5高程差值');
set(hh,'box','off')
set(gca,'fontsize',15)







