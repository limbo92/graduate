clear; clc;%crtl+i自動排版 变量名前加关键字 global 使得变量变成全局变量
%遗传算法主函数
final_av=cell(1,10);%
final_mo=cell(1,10);%
final_hgroute=cell(1,10);%混合算法最优路径
final_acroute=cell(1,10);%蚁群算法最优路径
min1=zeros(2,10);%混合算法每次迭代干扰值的最小值和最小值出现的迭代次数
min2=zeros(2,10);%蚁群算法每次迭代干扰值的最小值和最小值出现的迭代次数
min3=zeros(2,10);%混合算法每次迭代损失值的最小值和最小值出现的迭代次数
min4=zeros(2,10);%蚁群算法每次迭代损失值的最小值和最小值出现的迭代次数
min5=zeros(2,10);%遗传算法每次迭代干扰值值的最小值和最小值出现的迭代次数
min6=zeros(2,10);%遗传算法每次迭代损失值的最小值和最小值出现的迭代次数
for ii=1:10
    tic
    [N1,T1,X1]=xlsread('G:\程序\GACO1\delay1.xlsx','Sheet1','A2:H501');%航班信息，以航班的实际进港时间，进行升序排列，如果delay.xlsx路径改了，这里也需要跟着更改
    [N2,T2,X2]=xlsread('G:\程序\GACO1\delay1.xlsx','Sheet2');%停机位信息
    [N3,T3,X3]=xlsread('G:\程序\GACO1\delay1.xlsx','Sheet3');%航班预分配信息 把近机位和远机位分开来讨论，在初始解中，先讨论近机位的可能性，如果近机位都不满足，再从远机位数组里选择
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
    people=N1(:,2);%旅客人数
    price=N1(:,8);%航班票价
    GO=T2(1:length(T2)*0.6,1);%近机位gateopen停机位开放时间 ,近机位个数占所有飞机的60%
    GC=T2(1:length(T2)*0.6,2);%gateclose近机位停机位关闭时间
    [a1,d1]=datetime1(GO,GC);%把停机位的开放时间和关闭日期时间转换为以分钟为基本单位的数值
    GO=a1;%把转化完的数组a1赋值给GO
    GC=d1;%把转化完的数组b1赋值给GC
    PT=N1(:,3);%planetype飞机类型
    GT=N2(:,1);%gatetype停机位类型
    z1=length(T1);%航班个数
    z2=length(GO);%近机位停机位个数
    remote=length(T2)*0.4;%远机位占停机位个数的40%，远机位个数
    gate=z2+remote;%总停机位个数
    pn=N1(:,1);%planenumber航班编号
    rn=N2(z2+1:gate,4);%remotenumber远机位集合，从编号61到100
    ro=T2(z2+1:gate,1);%远机位开放时间
    rc=T2(z2+1:gate,2);%远机位关闭时间
    [ro1,rc1]=datetime1(ro,rc);%把远机位的开放时间转化为分钟单位
    ro=ro1;%把转化完的数组ro1赋值给ro
    kk=0;
    [Z,NCmax,delaytime,interval]=initialsolution1(RA,RD,GO,GC,PT,GT,z1,z2,ro,gate);%生成初始解Z，根据最新实际进/离港信息给航班分配拟分配停机位，返回值是分配结果Z，染色体个数NCmax,航班延误时间结婚delaytime
    bn=NCmax*0.1;%种群数量NCmax的10%
    preassigned=N3;%预分配
    [fit,AV,MO]=fitness1(Z,preassigned,NCmax,delaytime,people,PT,z1,price);%求解适应度函数,fit（1,:）是干扰值的适应度,fit（2,:）是远机位值的适应度,fit(3,:)是总的适应度
    [aa,b]=sort(fit(3,:),'descend');%给总适应度由大到小的排序 ，aa为适应度值集合，b是染色体的集合
    best=zeros(bn,z1);%取每一代适应度值的前10个染色体为非劣解集，以后对于每一代进化所产生的最好的一系列解与原有的非劣解集best进行比较,用所
    %产生的更好的解代替原有的劣解。这样计算结束时所得到的就是算法中产生的最好的非劣解,从而构成非劣解集。
    best_route=zeros(bn,z1);%将种群最好的前10%再分配方案存入best_route里
    not_best_route=Z(b(bn+1:NCmax),:);%将种群最好的前10%去掉，种群中剩下的90%，按照适应度由大到小的顺序，个体存入not_best_route里
    not_best_fit=fit(3,b(bn+1:NCmax));%将种群最好的前10%去掉，种群中剩下的90%，按照适应度由大到小的顺序，适应度值存入not_best_fit里
    best_AV=zeros(1,bn);%种群最好的前10%个体的干扰值集合
    best_MO=zeros(1,bn);%种群最好的前10%个体的多目标值集合
    for i=1:bn
        best_route(i,:)=Z(b(i),:);%将种群最好的前10%再分配方案存入best_route里
        bnum1=find(b(i)==AV(1,:));%找到最好的个体在AV中的列号
        best_AV(1,i)=AV(2,bnum1);%种群最好的前10%个体的干扰值集合
        bnum2=find(b(i)==MO(1,:));%找到最好的个体在MO中的列号
        best_MO(1,i)=MO(2,bnum2);%种群最好的前10%个体的多目标值集合
    end
    interation=200;%遗传算法迭代次数
    inter_AV=zeros(1,interation);%每次迭代的最优干扰值
    inter_MO=zeros(1,interation);%每次迭代的最优损失值
    for in=1:interation
        [PC,PV]=probability(not_best_fit,NCmax,bn);%求解概率函数
        %global l;  %设定全局变量，NZ1和Z2新染色种群的指针
        %l=1;%%设定全局变量，Z1新染色种群的指针
        NZ1=zeros(1,z1);%NZ1用来存储所有交叉操作出来的新染色体
        [NZ1,a2,d2,delaytime1]=crossover1(PC,not_best_route,NCmax,z1,NZ1,RA,RD,interval,gate,bn);%交叉函数，NZ1为交叉后新染色体存放的新种群
        Z3=zeros(1,NCmax);%已经变异的染色体，需要排除掉，以免再次选到
        %global p%
        %p=1;
        NZ2=[];%NZ2用来存储所有变异操作出来的新染色体
        [NZ2,delaytime2]=variation1(NCmax,PV,not_best_route,z1,NZ2,RA,RD,interval,gate,bn);%变异函数
        %[Z6,Z7]=pheromone(pn,best_route,z1,z2,NCmax);
        %nz3=size(best_route,1)+size(NZ1,1)+size(NZ2,1);%计算初始解的最好的前10%best_route，和新交叉，变异出来的染色体总的个数，作为NZ3矩阵的行数
        NZ3=[not_best_route;NZ1;NZ2];%把初始解的最好的前10%去掉，剩下的90%not_best_route和新交叉，变异出来的染色体放到一个新的数组里NZ3
        delaytime4=[delaytime(b(bn+1:NCmax),:);delaytime1;delaytime2];% NZ3染色体组的延迟时间
        best_delaytime=delaytime(b(1:bn),:);%前10%个体的延误时间
        [NZ5,new_best_route,k,fit2,new_best_AV,new_best_MO,min_AV,min_MO,eb1,delaytime5,best]=evolution3(NZ3,z1,preassigned,delaytime4,people,PT,price,best_AV,best_MO,bn,best_delaytime,best_route,NCmax,best);%该函数把初始解的最好的前10%best_route，和新交叉，变异出来的染色体放到一个新的数组里NZ3，重新计算一下，查看是否得到了进化
        %NZ5是新种群，new_best_route是初始最优解与变异，交叉后的新的染色体结合在一起的集合（NZ3）里最好的前10个染色体，min_AV和min_MO是最优解的干扰值和损失值
        inter_AV(1,in)=min_AV;%记录每次迭代最优解的干扰值
        inter_MO(1,in)=min_MO;%记录每次迭代最优解的多目标值
        best_route=new_best_route;%存储本次迭代的最好的前10%染色体，当做下一次迭代的best_route
        best_AV=new_best_AV;%存储本次迭代的最好的前10%染色体的干扰值，当做下一次迭代的best_AV
        best_MO=new_best_MO;%存储本次迭代的最好的前10%染色体的多目标值，当做下一次迭代的best_MO
        NCmax=size(fit2,2);%将新的染色体组的染色体数重新记录
        not_best_route=NZ5(eb1(bn+1:NCmax),:);%将新种群最好的前10%去掉，种群中剩下的90%，按照适应度由大到小的顺序，存入not_best_route里
        not_best_fit=fit2(3,eb1(bn+1:NCmax));%将种群最好的前10%去掉，种群中剩下的90%，按照适应度由大到小的顺序，适应度值存入not_best_fit里
        fit=fit2;%将新的染色体组的适应度值重新赋值
        b=eb1;%适应度从大到小的排序
        delaytime=delaytime5;%将新的染色体组的每个染色体的延误时间重新记录
%         if in>interation*0.3
%             if k>=5 %说明本次进化率大于10%
%                 kk=0;%如果本次迭代进化率大于40%，那么记录kk更新为0
%             else
%                 kk=kk+1;%如果本次迭代进化率小于40%，那么记录kk+1
%             end
%             if kk>11 %如果连续10代进化率低于30%或者染色体群的个数小于10个染色体，那么跳出循环
%                 break;
%             end
%         end
    end
    [Z6,Z7,Z8]=pheromone(pn,best,z1,gate,bn); %pheromone函数遗传算法与蚁群算法的衔接函数，功能是把遗传算法的进化后的NZ4最优解，用来当做蚁群算法的初始信息素，首先，将最优解转化为，行是停机位，列是航班号的矩阵，根据实际停入停机位的顺序排序
    toc
end
%     [~,best_hgroute,best_hgvalue,hg_av,hg_mo,hg_index]=hg3(z1,z2,PT,GT,RA,RD,GO,GC,pn,gate,Z8,interation,preassigned,ro,price,people,in);%混合算法
%     toc
%     tic
%     [~,best_acroute,best_acvalue,aco_av,aco_mo,aco_index]=aco2(z1,z2,PT,GT,RA,RD,GO,GC,pn,gate,interation,preassigned,ro,price,people);%蚁群算法
%     toc
%     final_av{1,ii}=[inter_AV;aco_av;hg_av];
%     final_mo{1,ii}=[inter_MO;aco_mo;hg_mo];
%     [ha,hb]=min(hg_av);
%     [aa,ab]=min(aco_av);
%     [ha1,hb1]=min(hg_mo);
%     [aa1,ab1]=min(aco_mo);
%     [ha2,hb2]=min(best_AV);
%     [aa2,ab2]=min(best_MO);
%     min1(1,ii)=ha;%混合算法每次迭代干扰值的最小值和最小值出现的迭代次数
%     min1(2,ii)=hb;
%     min2(1,ii)=aa;%蚁群算法每次迭代干扰值的最小值和最小值出现的迭代次数
%     min2(2,ii)=ab;
%     min3(1,ii)=ha1;%混合算法每次迭代损失值的最小值和最小值出现的迭代次数
%     min3(2,ii)=hb1;
%     min4(1,ii)=aa1;%蚁群算法每次迭代损失值的最小值和最小值出现的迭代次数
%     min4(2,ii)=ab1;
%     min5(1,ii)=ha2;
%     min5(2,ii)=hb2;
%     min6(1,ii)=aa2;
%     min6(2,ii)=ab2;
%     final_hgroute{1,ii}=best_hgroute;
%     final_acroute{1,ii}=best_acroute;
% end