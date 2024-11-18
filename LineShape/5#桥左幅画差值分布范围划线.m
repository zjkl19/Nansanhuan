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
287.5 
295.0 
302.5 
310.0 
317.5 
325.0 
332.5 
340.0 
348.8 
357.5 
366.3 
375.0 
383.8 
392.5 
401.3 
410.0 
417.5 
425.0 
432.5 
440.0  
]'

y_3_z=[-0.00004 
0.00133 
-0.00464 
-0.00264 
-0.00336 
-0.00428 
-0.00094 
-0.00511 
-0.00262 
-0.00230 
-0.00402 
-0.00181 
-0.00272 
-0.00198 
-0.00279 
-0.00173 
-0.00246 
-0.00283 
-0.00171 
-0.00211 
-0.00081 
-0.00083 
0.00025 
-0.00373 
-0.00341 
-0.00426 
-0.00579 
-0.00518 
-0.00361 
-0.00295 
-0.00205 
-0.00168 
-0.00035 
-0.00159 
-0.00388 
-0.00351 
-0.00380 
-0.00389 
-0.00409 
-0.00422 
-0.00962 
-0.00517 
-0.00555 
-0.00611 
-0.00626 
-0.00601 
-0.00378 
-0.00388 
-0.00185 
-0.00238 
-0.00432 
-0.00502 
-0.00125 
0.00020 
0.00009 
-0.00039 
-0.00173 
-0.00085 
0.00416 

]'

y_3_z2=[-0.00421
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

y_3_z3=[0.00183 
0.00281 
0.00216 
0.01502 
0.00756 
0.02750 
0.00737 
0.02974 
0.00878 
0.00868 
0.00828 
0.00592 
0.00753 
0.00392 
0.00281 
0.00329 
0.00283 
0.00137 
0.00398 
0.00823 
0.00715 
0.00821 
0.01197 
0.00643 
0.00765 
0.00858 
0.00985 
0.00865 
0.00768 
0.00624 
0.00489 
0.00346 
0.00186 
0.00491 
0.00919 
0.00719 
0.00631 
0.00562 
0.00812 
0.00462 
0.01612 
0.01129 
0.01116 
0.01207 
0.01135 
0.01342 
0.01013 
0.00903 
0.00566 
0.00568 
0.00530 
0.00688 
0.00606 
0.00426 
0.00500 
0.00601 
0.00812 
0.00089 
0.00365 
]'




figure(1)
a=plot(x_3,y_3_z,'o','MarkerSize',5,'color',"r",'linewidth',2)
hold on 
b=plot(x_3,y_3_z2,'*','MarkerSize',5,'color',"b",'linewidth',1)
hold on 
b=plot(x_3,y_3_z3,'o','MarkerSize',5,'color',"k",'linewidth',1)



axis([0 440 -0.02 0.020])

set(gca,'xtick',[0 30 60 90 120 150 180 215 250 280 310 340 375 410 440]);
%5#桥左侧
%5#桥右侧set(gca,'xtick',[0 30 60 90 120 150 180 215 250 280 315 350 385 412.5 440]);
set(gca,'xticklabel',{'0#','1#', '2#','3#' ,'4#' ,'5#', '6#', '7#', '8#', '9#', '10#', '11#', '12#', '13#', '14#'});
set(gca,'ytick',[-0.02 -0.015 -0.010 -0.005 0.000 0.005 0.010 0.015 0.02]);
set(gca,'yticklabel',{'-20','-15', '-10','-5' ,'0' ,'5', '10', '15','20',});
xlabel('墩（台）号');
ylabel('高程差（mm）');


hh=legend('2023.12-2021.3高程差值','2023.5-2022.9高程差值','2023.12-2023.5高程差值');
set(hh,'box','off')

set(gca,'fontsize',15)
positionAndSize=[500,450,1800,450];
set(gcf,'position',positionAndSize)





