for ii=1:10
av1=final_av{1,ii};
mo1=final_mo{1,ii};
aco_av=av1(2,:);
aco_mo=mo1(2,:);
inter_AV=av1(1,1:in);
inter_MO=mo1(1,1:in);
hg_av=av1(3,1:interation-in);
hg_mo=mo1(3,1:interation-in);
min_aco_av=min(aco_av);%混合算法干扰值最小值
min_aco_mo=min(aco_mo);%混合算法损失值最小值
min_ga_av=min(inter_AV);%遗传算法干扰值最小值
min_ga_mo=min(inter_MO);%遗传算法损失值最小值
min_hg_av=min(hg_av);%混合算法干扰值最小值
min_hg_mo=min(hg_mo);%混合算法损失值最小值
time_ga=time(1:10,4);%遗传算法运行时间
time_aco=time(1:10,3);%蚁群算法运行时间
time_hg=time(1:10,2);%混合算法运行时间
x=(1:10);
plot(x,time_ga,'g*',x,time_aco,'b-',x,time_hg,'r-');
legend('GA','ACO','GAOTWSH');%图例名称
axis([ 1 10 120 200]);
xlabel('迭代次数');
ylabel('算法运行时间（秒）');
title('对比图');
end