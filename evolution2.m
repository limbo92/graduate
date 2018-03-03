function [NZ4,k,fit1,AV4,MO4,min_AV,min_MO,eb]=evolution2(NZ3,z1,preassigned,delaytime4,people,PT,price,best_AV,best_MO,bn)
%该函数把初始解的最好的前10%best_route，和新交叉，变异出来的染色体放到一个新的数组里NZ3，重新计算一下，查看是否得到了进化
%NZ3=[best_route;NZ1;NZ2];
NZ4=zeros(bn,z1);%本次迭代最好的10个染色体
AV4=zeros(1,bn);%本次迭代最小的干扰值集合
MO4=zeros(1,bn);%本次迭代最小的损失值集合
nz3=size(NZ3,1);%计算初始解的最好的前10%best_route，和新交叉，变异出来的染色体总的个数，作为NZ3矩阵的行数
[fit1,AV,MO]=fitness1(NZ3,preassigned,nz3,delaytime4,people,PT,z1,price);%用fitness函数求解NZ3种群的适应度值，结果是fit1
fit3=fit1;%把fit1的值赋给fit3
[~,eb]=sort(fit3(3,:),'descend');%将fit3的第三行（总的适应度值）排序，由大到小的顺序 ea代表适应度值的排序顺序，eb是新的适应度值，之前的fit3矩阵中的列号，可以根据eb找到之前所对应的染色体
for i=1:10
    NZ4(i,:)=NZ3(eb(i),:);%把最好的染色体赋值到NZ4中
    AV4(1,i)=AV(2,eb(i));%把最小的干扰值赋值给AV4
    MO4(1,i)=MO(2,eb(i));%把最小的损失值赋值给MO4
end
mba=max(best_AV);%找到best_AV中最大的值
mbm=max(best_MO);%找到best_MO中最大的值
ma=max(AV4);%找到AV4中最大的值
mm=max(MO4);%找到MO4中最大的值
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
ambition3=AV4/MA;%规范化AV4
ambition4=MO4/MM;%规范化MO4
ambition5=ambition1+ambition2;%之前迭代的最优目标值
ambition6=ambition3+ambition4;%本次迭代最优目标值
k=length(find(ambition6<ambition5));% k是本次迭代最好的染色体比上次迭代最好的染色体更好的染色体个数
[a5,b5]=min(ambition5);
[a6,b6]=min(ambition6);
if a5<a6
    min_AV=best_AV(b5);%找到最优解的干扰值
    min_MO=best_MO(b5);%找到最优解的损失值
else
    min_AV=AV4(b6);%找到最优解的干扰值
    min_MO=MO4(b6);%找到最优解的损失值
end






