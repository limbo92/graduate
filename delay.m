clear; clc;%crtl+i自動排版 变量名前加关键字 global 使得变量变成全局变量
%遗传算法主函数
tic
[N1,T1,X1]=xlsread('C:\Users\Administrator\Desktop\delay.xlsx','Sheet1','A2:G21');%航班信息，以航班的实际进港时间，进行升序排列，如果delay.xlsx路径改了，这里也需要跟着更改
[N2,T2,X2]=xlsread('C:\Users\Administrator\Desktop\delay.xlsx','Sheet2');%停机位信息
[N3,T3,X3]=xlsread('C:\Users\Administrator\Desktop\delay.xlsx','Sheet3');%航班预分配信息 把近机位和远机位分开来讨论，在初始解中，先讨论近机位的可能性，如果近机位都不满足，再从远机位数组里选择
%[N4,T4,X4]=xlsread('C:\Users\Administrator\Downloads\「众智创新赛」航班信息及规则对应表20160927 (1)\20160927.xlsx','历史航班');
A1=T1(:,1);%预计到港时间
D1=T1(:,2);%预计离港时间
[a1,d1]=datetime1(A1,D1);%把航班预计到港和离港日期时间格式转换为以分钟为基本单位的数值
A1=a1;%把转化完的数组a1赋值给A1
D1=d1;%把转化完的数组b1赋值给B
RA=T1(:,3);%实际到港时间 real-arrive实际到达时间
RD=T1(:,4);%实际离港时间 real-departure实际离开时间
[a1,d1]=datetime1(RA,RD);%把航班实际到港和离港日期时间格式转换为以分钟为基本单位的数值
RA=a1;%把转化完的数组a1赋值给RA
RD=d1;%把转化完的数组b1赋值给RD
GO=T2(1:4,1);%近机位gateopen停机位开放时间 
GC=T2(1:4,2);%gateclose近机位停机位关闭时间 
[a1,d1]=datetime1(GO,GC);%把停机位的开放时间和关闭日期时间转换为以分钟为基本单位的数值
GO=a1;%把转化完的数组a1赋值给GO
GC=d1;%把转化完的数组b1赋值给GC

PT=N1(:,3);%planetype飞机类型 
GT=N2(:,1);%gatetype停机位类型 
z1=length(T1);%航班个数
z2=length(GO);%近机位停机位个数
remote=length(5);%5号停机位是远机位，远机位个数
gate=z2+remote;%总停机位个数
pn=N1(:,1);%planenumber航班型号
[U,V,Z,NCmax]=initialsolution(RA,RD,GO,PT,GT,z1,z2,pn);%生成初始解Z，根据最新实际进/离港信息给航班分配拟分配停机位
preassigned=N3;%预分配
[fit,AV,RG]=fitness(Z,preassigned,NCmax);%求解适应度函数,fit（1,:）是干扰值的适应度,fit（2,:）是远机位值的适应度,fit(3,:)是总的适应度
[PC,PV]=probability(fit,NCmax);%求解概率函数
[aa,b]=sort(fit(3,:),'descend');%给总适应度由大到小的排序 ，aa为适应度值集合，b是染色体的集合
best=aa(1:NCmax*0.1);%取每一代适应度值的前10%为非劣解集，以后对于每一代进化所产生的最好的一系列解与原有的非劣解集best进行比较,用所
                    %产生的更好的解代替原有的劣解。这样计算结束时所得到的就是算法中产生的最好的非劣解,从而构成非劣解集。
best_route=zeros(NCmax*0.1,z1);%将最好的再分配方案存入best_route里
for i=1:NCmax*0.1
    best_route(i,:)=Z(b(i),:);
end
%global l;  %设定全局变量，NZ1和Z2新染色种群的指针
%l=1;%%设定全局变量，Z1新染色种群的指针
Z2=zeros(1,NCmax);%已经交换过的染色体，需要排除掉，以免再次选到
NZ1=zeros(1,z1);%NZ1用来存储所有交叉操作出来的新染色体
[NZ1,a2,d2]=crossover1(PC,Z,NCmax,z1,NZ1);%交叉函数，NZ1为交叉后新染色体存放的新种群
Z3=zeros(1,NCmax);%已经变异的染色体，需要排除掉，以免再次选到
%global p%
%p=1;
NZ2=zeros(1,z1);%NZ2用来存储所有变异操作出来的新染色体
[NZ2,c1]=variation1(NCmax,PV,Z,z1,NZ2);%变异函数
%[Z6,Z7]=pheromone(pn,best_route,z1,z2,NCmax);
%nz3=size(best_route,1)+size(NZ1,1)+size(NZ2,1);%计算初始解的最好的前10%best_route，和新交叉，变异出来的染色体总的个数，作为NZ3矩阵的行数
NZ3=[best_route;NZ1;NZ2];%把初始解的最好的前10%best_route，和新交叉，变异出来的染色体放到一个新的数组里NZ3
[NZ4,k]=evolution(best_route,NZ3,z1,preassigned,NCmax);%该函数把初始解的最好的前10%best_route，和新交叉，变异出来的染色体放到一个新的数组里NZ3，重新计算一下，查看是否得到了进化
%NZ4是初始最优解与变异，交叉后的新的染色体结合在一起的集合（NZ3）里最好的前10个染色体
[Z6,Z7,Z8]=pheromone(pn,NZ4,z1,gate,NCmax); %pheromone函数遗传算法与蚁群算法的衔接函数，功能是把遗传算法的进化后的NZ4最优解，用来当做蚁群算法的初始信息素，首先，将最优解转化为，行是停机位，列是航班号的矩阵，根据实际停入停机位的顺序排序
[AZ,best_acroute,best_acvalue]=aco(z1,z2,PT,GT,RA,RD,GO,GC,pn,gate,Z8,NCmax,preassigned);%蚁群算法
toc