for ii=1:10
av1=final_av{1,ii};
mo1=final_mo{1,ii};
aco_av=av1(2,:);
aco_mo=mo1(2,:);
inter_AV=av1(1,1:in);
inter_MO=mo1(1,1:in);
hg_av=av1(3,1:interation-in);
hg_mo=mo1(3,1:interation-in);
min_aco_av=min(aco_av);%����㷨����ֵ��Сֵ
min_aco_mo=min(aco_mo);%����㷨��ʧֵ��Сֵ
min_ga_av=min(inter_AV);%�Ŵ��㷨����ֵ��Сֵ
min_ga_mo=min(inter_MO);%�Ŵ��㷨��ʧֵ��Сֵ
min_hg_av=min(hg_av);%����㷨����ֵ��Сֵ
min_hg_mo=min(hg_mo);%����㷨��ʧֵ��Сֵ
time_ga=time(1:10,4);%�Ŵ��㷨����ʱ��
time_aco=time(1:10,3);%��Ⱥ�㷨����ʱ��
time_hg=time(1:10,2);%����㷨����ʱ��
x=(1:10);
plot(x,time_ga,'g*',x,time_aco,'b-',x,time_hg,'r-');
legend('GA','ACO','GAOTWSH');%ͼ������
axis([ 1 10 120 200]);
xlabel('��������');
ylabel('�㷨����ʱ�䣨�룩');
title('�Ա�ͼ');
end