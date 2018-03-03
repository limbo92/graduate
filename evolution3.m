function [NZ5,new_best_route,k,fit2,new_best_AV,new_best_MO,min_AV,min_MO,eb1,delaytime5,best]=evolution3(NZ3,z1,preassigned,delaytime4,people,PT,price,best_AV,best_MO,bn,best_delaytime,best_route,NCmax,best)
%该函数把初始解的最好的前10%best_route，和新交叉，变异出来的染色体放到一个新的数组里NZ3，重新计算一下，查看是否得到了进化
%NZ3=[best_route;NZ1;NZ2];
NZ4=zeros(NCmax-bn,z1);%本次迭代除了最好的前10%个体，剩下的90%染色体
new_best_route=zeros(bn,z1);%本次迭代新种群的最好的前10%染色体
new_best_AV=zeros(1,bn);%本次迭代最小的干扰值集合
new_best_MO=zeros(1,bn);%本次迭代最小的损失值集合
nz3=size(NZ3,1);%把初始解的最好的前10%去掉，剩下的90%not_best_route和新交叉，变异出来的染色体总的个数，作为NZ3矩阵的行数
[fit1,~,~]=fitness1(NZ3,preassigned,nz3,delaytime4,people,PT,z1,price);%用fitness函数求解NZ3种群的适应度值，结果是fit1
fit3=fit1;%把fit1的值赋给fit3
[~,eb]=sort(fit3(3,:),'descend');%将fit3的第三行（总的适应度值）排序，由大到小的顺序 ea代表适应度值的排序顺序，eb是新的适应度值，之前的fit3矩阵中的列号，可以根据eb找到之前所对应的染色体
for i=1:NCmax-bn %找出种群中前NCmax-bn个个体
    NZ4(i,:)=NZ3(eb(i),:);%把最好的染色体赋值到NZ4中
%     AV4(1,i)=AV(2,eb(i));%把最小的干扰值赋值给AV4
%     MO4(1,i)=MO(2,eb(i));%把最小的损失值赋值给MO4
end
NZ5=[best_route;NZ4];%上一次迭代复制下来的best_route与交叉变异后存留下来的NCmax-bn个个体组成本次迭代生成的新种群
delaytime5=[best_delaytime;delaytime4(eb(1:NCmax-bn),:)];%本次迭代生成的新种群的延误时间
nz5=size(NZ5,1);%计算新种群的个数，应该和NCmax相等
[fit2,AV2,MO2]=fitness1(NZ5,preassigned,nz5,delaytime5,people,PT,z1,price);%用fitness1函数求解新种群的适应度值
fit4=fit2;%把fit2的值赋给fit4
[~,eb1]=sort(fit4(3,:),'descend');%%将fit2的第三行（总的适应度值）排序，由大到小的顺序，eb1是新的适应度值，之前的fit3矩阵中的列号，可以根据eb1找到之前所对应的染色体
for i=1:bn
    new_best_route(i,:)=NZ5(eb1(i),:);%将新种群最好的前10%再分配方案存入best_route里
    new_bnum1=find(eb1(i)==AV2(1,:));%找到最好的个体在AV中的列号
    new_best_AV(1,i)=AV2(2,new_bnum1);%新种群最好的前10%个体的干扰值集合
    new_bnum2=find(eb1(i)==MO2(1,:));%找到最好的个体在MO中的列号
    new_best_MO(1,i)=MO2(2,new_bnum2);%新种群最好的前10%个体的多目标值集合
end
mba=max(best_AV);%找到best_AV中最大的值
mbm=max(best_MO);%找到best_MO中最大的值
ma=max(new_best_AV);%找到 new_best_AV中最大的值
mm=max(new_best_MO);%找到 new_best_MO中最大的值
if mba<ma  %找到干扰值最大的值MA
    MA=ma;
else
    MA=mba;
end
if mbm<mm %找到损失值最大的值MM
    MM=mm;
else
    MM=mbm;
end
ambition1=best_AV/MA;%规范化best_AV
ambition2=best_MO/MM;%规范化best_MO
ambition3=new_best_AV/MA;%规范化AV4
ambition4=new_best_MO/MM;%规范化MO4
ambition5=ambition1+ambition2;%之前迭代的最优目标值
ambition6=ambition3+ambition4;%本次迭代最优目标值
[a5,b5]=min(ambition5);
k=length(find(ambition6<a5));% k是本次迭代最好的染色体比上次迭代最好的染色体更好的染色体个数
[a6,b6]=min(ambition6);
if a5<a6
    min_AV=best_AV(b5);%找到最优解的干扰值
    min_MO=best_MO(b5);%找到最优解的损失值
else
    min_AV=new_best_AV(b6);%找到最优解的干扰值
    min_MO=new_best_MO(b6);%找到最优解的损失值
end
if k~=0 %更新最优解集
    fa=find(ambition6<a5);
    [~,sb]=sort(ambition5,'descend');
    best=best_route;
    best(sb(1:k),:)=new_best_route(fa,:);
%     new_best_route=best_route;%每次迭代更新最优解集，作为下次迭代的最优10%个体
end






