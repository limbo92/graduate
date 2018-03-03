function [NZ4,k]=evolution(best_route,NZ3,z1,preassigned,NCmax,delaytime4,people,PT,price)
%该函数把初始解的最好的前10%best_route，和新交叉，变异出来的染色体放到一个新的数组里NZ3，重新计算一下，查看是否得到了进化
%NZ3=[best_route;NZ1;NZ2];
NZ4=zeros(10,z1);
nz3=size(NZ3,1);%计算初始解的最好的前10%best_route，和新交叉，变异出来的染色体总的个数，作为NZ3矩阵的行数
[fit1,~,~]=fitness1(NZ3,preassigned,nz3,delaytime4,people,PT,z1,price);%用fitness函数求解NZ3种群的适应度值，结果是fit1
fit3=fit1;%把fit1的值赋给fit3
[~,eb]=sort(fit3(3,:),'descend');%将fit3的第三行（总的适应度值）排序，由大到小的顺序 ea代表适应度值的排序顺序，eb是新的适应度值，之前的fit3矩阵中的列号，可以根据eb找到之前所对应的染色体
for i=1:10
    NZ4(i,:)=NZ3(eb(i),:);%把最好的染色体赋值到NZ4中
end
k=0;%记录初始最优解与进化后的最优解相同的个数
for i=1:10 % 用来检测NZ4与best_route有多少个染色体是相同的，
    for j=1:10 %best_route里的每条染色体都与NZ4比对一下
        if isequal(best_route(j,:),NZ4(i,:))==1  %isequal()两行是否相等
            k=k+1;%如果找到相等的，让k+1
            break%退出内循环，开始NZ4的下一条染色体与best_route对比
        end
    end
end


