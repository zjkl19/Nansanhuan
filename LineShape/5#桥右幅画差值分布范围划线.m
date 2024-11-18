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
90.0 
97.5 
105.0 
112.5 
119.5
120.5
127.5 
135.0 
142.5 
150.0 
157.5 
165.0 
172.5 
180.0 
188.8 
197.5 
206.3 
215.0 
223.8 
232.5 
241.3 
250.0 
257.5 
265.0 
272.5 
279.5
280.5
288.8 
297.5 
306.3 
315.0 
323.8 
332.5 
341.3 
350.0 
358.8 
367.5 
376.3 
385.0 
391.9 
398.8 
405.6 
412.5 
419.4 
426.3 
433.1 
440.0 
]'

y_3_z=[-0.00187
-0.00148
-0.0068
-0.01766
-0.01092
-0.03178
-0.00831
-0.03485
-0.0114
-0.01098
-0.0123
-0.00773
-0.01025
-0.0059
-0.0056
-0.00502
-0.00529
-0.0042
-0.00569
-0.01034
-0.00796
-0.00904
-0.01172
-0.01016
-0.01106
-0.01284
-0.01564
-0.01383
-0.01129
-0.00919
-0.00694
-0.00514
-0.00221
-0.0065
-0.01307
-0.0107
-0.01011
-0.00951
-0.01221
-0.00884
-0.02574
-0.01646
-0.01671
-0.01818
-0.01761
-0.01943
-0.01391
-0.01291
-0.00751
-0.00806
-0.00962
-0.0119
-0.00731
-0.00406
-0.00491
-0.0064
-0.00985
-0.00174
0.00051
]'

y_3_z2=[0.00329
0.005
0.01334
0.00582
2E-05
0.00498
0.00513
0.00134
0.00531
0.00896
0.00821
0.00979
0.00659
0.00801
0.00786
0.0008
0.00597
0.00522
0.00405
0.00376
0.00219
0.00122
0.00081
0.00402
0.00316
0.0048
0.00342
0.00328
0.00513
0.00323
0.00429
0.00326
0.00313
0.00175
0.00081
0.00137
0.00223
0.00264
0.00199
0.00216
0.01231
0.00128
0.00654
0.00288
0.00226
0.00273
0.00319
0.00115
-0.00194
-0.00019
-0.00341
0.0031
-0.00042
0.00501
0.00479
0.00455
0.01185
0.00287
0.0128
]'

y_3_z3=[-0.00421
-0.00901
-0.0103
-0.02154
-0.0076
-0.03175
-0.01385
-0.02973
-0.01475
-0.01688
-0.015
-0.01537
-0.01424
-0.0119
-0.00969
-0.00491
-0.00773
-0.00604
-0.00565
-0.00862
-0.00877
-0.00822
-0.00974
-0.01156
-0.01259
-0.01451
-0.01619
-0.01488
-0.01484
-0.01185
-0.0102
-0.00705
-0.00482
-0.00706
-0.01273
-0.01061
-0.01132
-0.00947
-0.01285
-0.01548
-0.02694
-0.01802
-0.02305
-0.02124
-0.01995
-0.02082
-0.01648
-0.01418
-0.00947
-0.00898
-0.00629
-0.00873
-0.01087
-0.00872
-0.01008
-0.01162
-0.01451
-0.00092
-0.01147
]'


figure(1)
a=plot(x_3,y_3_z,'o','MarkerSize',5,'color',"r",'linewidth',2)
hold on 
b=plot(x_3,y_3_z2,'*','MarkerSize',5,'color',"b",'linewidth',1)
hold on 
b=plot(x_3,y_3_z3,'o','MarkerSize',5,'color',"k",'linewidth',1)




axis([0 440 -0.02 0.020])

set(gca,'xtick',[0 30 60 90 120 150 180 215 250 280 315 350 385 412.5 440]);
%5#桥左侧
%5#桥右侧set(gca,'xtick',[0 30 60 90 120 150 180 215 250 280 315 350 385 412.5 440]);
set(gca,'xticklabel',{'0#','1#', '2#','3#' ,'4#' ,'5#', '6#', '7#', '8#', '9#', '10#', '11#', '12#', '13#', '14#'});
set(gca,'ytick',[-0.02 -0.015 -0.010 -0.005 0.000 0.005 0.010 0.015 0.02]);
set(gca,'yticklabel',{'-20','-15', '-10','-5' ,'0' ,'5', '10', '15','20',});
xlabel('墩（台）号');
ylabel('高程差（mm）');


hh=legend('2023.5-2021.3高程差值','2022.9-2022.3高程差值','2023.5-2022.9高程差值');
set(hh,'box','off')
set(gca,'fontsize',15)
positionAndSize=[500,450,1800,450];
set(gcf,'position',positionAndSize)





