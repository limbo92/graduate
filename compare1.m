%function []=compare(inter_AV,inter_MO,aco_av,aco_mo,hg_av,hg_mo,best_nvalue,interation)
%����㷨�뵥�㷨�ĶԱ�
 for ii=1:10
av1=final_av{1,ii};
mo1=final_mo{1,ii};
aco_av=av1(2,:);
aco_mo=mo1(2,:);
inter_AV=av1(1,1:in);
inter_MO=mo1(1,1:in);
hg_av=av1(3,1:interation-in);
hg_mo=mo1(3,1:interation-in);
max_aco_av=max(aco_av);%����㷨����ֵ��Сֵ
max_aco_mo=max(aco_mo);%����㷨��ʧֵ��Сֵ
max_ga_av=max(inter_AV);%�Ŵ��㷨����ֵ��Сֵ
max_ga_mo=max(inter_MO);%�Ŵ��㷨��ʧֵ��Сֵ
max_hg_av=max(hg_av);%����㷨����ֵ��Сֵ
max_hg_mo=max(hg_mo);%����㷨��ʧֵ��Сֵ
av=[max_aco_av,max_hg_av,max_ga_av];
mo=[max_aco_mo,max_hg_mo,max_ga_mo];
max_av=max(av);%�ҵ������㷨�����ĸ���ֵ
max_mo=max(mo);%�ҵ������㷨��������ʧֵ
aco_ambition=zeros(3,interation);%
ga_ambition=zeros(3,in);%
hg_ambition=zeros(3,interation-in);%
aco_ambition(1,:)=aco_av/max_av;%����ֵ�淶��
aco_ambition(2,:)=aco_mo/max_mo;%��ʧֵ�淶��
ga_ambition(1,:)=inter_AV/max_av;%����ֵ�淶��
ga_ambition(2,:)=inter_MO/max_mo;%��ʧֵ�淶��
hg_ambition(1,:)=hg_av/max_av;%����ֵ�淶��
hg_ambition(2,:)=hg_mo/max_mo;%��ʧֵ�淶��
aco_ambition(3,:)=aco_ambition(1,:)+aco_ambition(2,:);%��Ⱥ�㷨Ŀ�꺯��ֵ
ga_ambition(3,:)=ga_ambition(1,:)+ga_ambition(2,:);%�Ŵ��㷨Ŀ�꺯��ֵ
hg_ambition(3,:)=hg_ambition(1,:)+hg_ambition(2,:);%����㷨Ŀ�꺯��ֵ
l=length(find(ga_ambition(3,:)~=0));%�ҵ�ga_ambition(3,:)Ϊ0�Ĳ��ֵĳ���
[ga_min_ambition,ga_index]=min(ga_ambition(3,1:l));%�Ŵ��㷨Ŀ�꺯��ֵ����Сֵ
[aco_min_ambition,aco_index]=min(aco_ambition(3,:));%��Ⱥ�㷨Ŀ�꺯��ֵ����Сֵ
[hg_min_ambition,hg_index]=min(hg_ambition(3,:));%��Ⱥ�㷨Ŀ�꺯��ֵ����Сֵ
zero=find(ga_ambition(3,:)==0);%�ҵ�ga_ambition(3,:)Ϊ0�Ĳ���
ga_ambition1=nonzeros(ga_ambition(3,:))';%�����Ŵ��㷨Ŀ��ֵ��Ϊ0�Ĳ���
ga_ambition(3,zero)=ga_min_ambition;%��ga_ambitionΪ0�Ĳ���Ϊ��Сֵ
aco_y=zeros(1,interation);
aco_y(1,1)=aco_ambition(3,1);
for i=1:interation-1
    if aco_ambition(3,i+1)<aco_y(1,i)
        aco_y(1,i+1)=aco_ambition(3,i+1);
    else
        aco_y(1,i+1)=aco_y(1,i);
    end
end
hg_y=zeros(1,interation-in);
hg_y(1,1)=hg_ambition(3,1);
for i=1:interation-in-1
    if hg_ambition(3,i+1)<hg_y(1,i)
        hg_y(1,i+1)=hg_ambition(3,i+1);
    else
        hg_y(1,i+1)=hg_y(1,i);
    end
end
%ga_ambition(3,30:100)=min(ga_ambition(3,:));

hg_y=[ga_ambition(3,:),hg_y];
% temp=hg_y(1,1:interation/2);
% hg_y(1,1:interation/2)=ga_ambition(3,1:interation/2);%���׶��㷨��ǰ50�����Ŵ��㷨���ã���50������Ⱥ�㷨
% hg_y(1,(interation/2)+1:interation)=temp;
 ga_ambition(3,73:200)=ga_min_ambition;%
x=(1:interation);
plot(x,ga_ambition(3,:),'g*',x,aco_y,'b-',x,hg_y,'r-');
axis([ 0 interation 1.1 2.2]);
xlabel('��������');
ylabel('Ŀ�꺯��ֵ');
title('�Ա�ͼ');
% [a5,b5]=min(aco_y);  %���Ž⻭ͼ
% [a4,b4]=min(hg_y);
% [a6,b6]=min(ga_ambition(3,:));
% ambition4(1,ii)=a4;
% ambition4(2,ii)=b4;
% ambition5(1,ii)=a5;
% ambition5(2,ii)=b5;
% ambition6(1,ii)=a6;
% ambition6(2,ii)=b6;
% x=(1:10);
% plot(x,ambition6(1,:),'g*',x,ambition5(1,:),'b-',x,ambition4(1,:),'r-');
% legend('GA','ACO','GAOTWSH');%ͼ������
% axis([ 1 10 1.1 2.2]);
% xlabel('��������');
% ylabel('���Ž�');
% title('�Ա�ͼ');
end