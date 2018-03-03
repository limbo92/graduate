function [fit,AV,MO]=fitness1(Z,preassigned,NCmax,delaytime,people,PT,z1,price)
%求解适应度函数
%Z 再分配方案，染色体
%preassigned预分配方案
w1=1;
w2=1;
w3=1;
s=2;
h=2;
g=[48,112,184];%小，中，大机型分别每分钟因为耗油增加的成本
MO=zeros(2,NCmax);  %multiobject损失 第一行存储染色体序号，第二行存储染色体对应的损失值
AV=zeros(2,NCmax); %annoyance value干扰者 第一行存储染色体序号 第二行存储染色体对应的目标干扰值
%RA=zeros(2,NCmax);%
for i=1:NCmax %从第一个染色体开始遍历，计算干扰值
    AV1=length(find(Z(i,:)~=preassigned));%设一个变量，存储干扰值
    AV(2,i)=AV1;%把第i个染色体的干扰值赋值
end
for i=1:NCmax %计算每个染色体的损失值
    MO1=zeros(1,z1);% MO1是存储每个航班的损失值
    for j=1:z1 %遍历每个航班，查看其延误成本
        g1=g(PT(j));
        MO1(1,j)=w1*(people(j)*price(j)*((delaytime(i,j)/60)^(2/3))/29+s*people(j)*delaytime(i,j))+w2*(h*people(j)*delaytime(i,j))+w3*(g1*delaytime(i,j));%旅客，机场，航空公司因为延误造成的成本增加目标函数
    end
    MO(2,i)=sum(MO1);%计算染色体的总延误成本
end
[b,c]=sort(AV(2,:));%给干扰值排序，b存储排序后的顺序 c为原先对应的列序号
[e,f]=sort(MO(2,:));%给损失排序e存储排序后的顺序 f为原先对应的列序号
for i=1:NCmax
    AV(1,i)=c(i);%排序所对应的染色体序号
    AV(2,i)=b(i);%给干扰值按从小到达排序
    MO(1,i)=f(i);%排序所对应的染色体序号
    MO(2,i)=e(i);%给远机位值按从小到大排序
end
fit=zeros(3,NCmax);%设定一个存放适应度值的数组
for i=1:NCmax%适应度函数
    if i==1 %第一个代表是最小的解
        k=1+randi(10)*0.1;%从（1,2）随机取一个数
        fit(1,AV(1,i))=k*NCmax^2;%第一行存干扰值的适应度，序号越大说明，目标函数值越大，则适应度更小，说明与最优的分配方案差的越多，使得交叉概率以及变异概率的可能性越大
        fit(2,MO(1,i))=k*NCmax^2;%第二行存远机位值的适应度
    else
        fit(1,AV(1,i))=(NCmax-i)^2;%第一行存干扰值的适应度,序号越大说明，目标函数值越大，则适应度更小，说明与最优的分配方案差的越多，使得交叉概率以及变异概率的可能性越大
        fit(2,MO(1,i))=(NCmax-i)^2;%第二行存远机位值的适应度
    end
end
%将干扰值和远机位的适应度值相加得到总的适应度值
 fit(3,:)=fit(1,:)+fit(2,:);
