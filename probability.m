function [PC,PV]=probability(not_best_fit,NCmax,bn)
%求解交叉概率以及变异概率函数
f_max=max(not_best_fit(1,:));%适应度最大值
f_avg=mean(not_best_fit(1,:));%适应度平均值
PC=zeros(1,NCmax-bn);%probability cross 交叉概率
PV=zeros(1,NCmax-bn);%probability variation变异概率
k1=0.7+0.01*randi(20);%k1取值在（0.5~0.7）
k2=k1;
k3=0.25+(0.05)*rand(1);%k3取值在（0.05~0.1）
k4=k3;
for i=1:NCmax-bn
    if not_best_fit(1,i)>f_avg  %如果适应度大于平均值，说明染色体中优良基因片段越多，这时应减少交叉和变异的概率
        PC(i)=k1*(f_max-not_best_fit(1,i))/(f_max-f_avg);
        PV(i)=k3*(f_max-not_best_fit(1,i))/(f_max-f_avg);
    else               %如果适应度小于平均值，说明染色体中优良基因片段越少，这时应增加交叉和变异的概率
        PC(i)=k2;
        PV(i)=k4;
    end
end

