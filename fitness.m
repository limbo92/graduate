function [fit,AV,RG]=fitness(Z,preassigned,NCmax)
%求解适应度函数
%Z 再分配方案，染色体
%preassigned预分配方案
RG=zeros(2,NCmax);  %remote gate远机位 第一行存储染色体序号，第二行存储染色体对应的目标远机位值
AV=zeros(2,NCmax); %annoyance value干扰者 第一行存储染色体序号 第二行存储染色体对应的目标干扰值
%RA=zeros(2,NCmax);%
f=5;%远机位号
for k=1:NCmax %第一行设置染色体序号，使得排序时，知道是第几个染色体
    RG(1,k)=k;
    AV(1,k)=k;
end
for i=1:NCmax %从第一个染色体开始遍历，计算目标值
    AV1=length(find(Z(i,:)~=preassigned));%设一个变量，存储干扰值
    RG1=length(find(Z(i,:)==f));  %设一个变量，存储远机位值
   % for j=1:z1 %从第一个航班开始遍历
      %  if  Z(i,j)~=preassigned(1,j) %和预分配方案做对比，查看航班是否更换了停机位，如果更换了，则干扰目标值+1
          %  AV1=AV1+1;
       % end
        %if  Z(i,j)==f %查看航班是否停在了远机位上 如果停在了远机位上，则远机位目标值+1
          %  RG1=RG1+1;
       % end
   % end
    %第i个染色体的所有航班遍历完
    AV(2,i)=AV1;%把第i个染色体的干扰值赋值
    RG(2,i)=RG1;%把第i个染色体的远机位值赋值
end
[b,c]=sort(AV(2,:));%b存储排序后的顺序 c为原先对应的列序号
[e,f]=sort(RG(2,:));%e存储排序后的顺序 f为原先对应的列序号
for i=1:NCmax
    AV(1,i)=c(i);%排序所对应的染色体序号
    AV(2,i)=b(i);%给干扰值按从小到达排序
    RG(1,i)=f(i);%排序所对应的染色体序号
    RG(2,i)=e(i);%给远机位值按从小到大排序
end
fit=zeros(3,NCmax);%设定一个存放适应度值的数组
for i=1:NCmax%适应度函数
    if i==1 %第一个代表是最小的解
        k=1+rand(1);%从（1,2）随机取一个数
        k=vpa(k,2);%保留1位小数
        fit(1,AV(1,i))=k*NCmax^2;%第一行存干扰值的适应度，序号越大说明，目标函数值越大，则适应度更小，说明与最优的分配方案差的越多，使得交叉概率以及变异概率的可能性越大
        fit(2,RG(1,i))=k*NCmax^2;%第二行存远机位值的适应度
    else
        fit(1,AV(1,i))=(NCmax-i)^2;%第一行存干扰值的适应度,序号越大说明，目标函数值越大，则适应度更小，说明与最优的分配方案差的越多，使得交叉概率以及变异概率的可能性越大
        fit(2,RG(1,i))=(NCmax-i)^2;%第二行存远机位值的适应度
    end
end
%将干扰值和远机位的适应度值相加得到总的适应度值
 fit(3,:)=fit(1,:)+fit(2,:);

