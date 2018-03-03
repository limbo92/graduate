function [PC,PV]=probability(not_best_fit,NCmax,bn)
%��⽻������Լ�������ʺ���
f_max=max(not_best_fit(1,:));%��Ӧ�����ֵ
f_avg=mean(not_best_fit(1,:));%��Ӧ��ƽ��ֵ
PC=zeros(1,NCmax-bn);%probability cross �������
PV=zeros(1,NCmax-bn);%probability variation�������
k1=0.7+0.01*randi(20);%k1ȡֵ�ڣ�0.5~0.7��
k2=k1;
k3=0.25+(0.05)*rand(1);%k3ȡֵ�ڣ�0.05~0.1��
k4=k3;
for i=1:NCmax-bn
    if not_best_fit(1,i)>f_avg  %�����Ӧ�ȴ���ƽ��ֵ��˵��Ⱦɫ������������Ƭ��Խ�࣬��ʱӦ���ٽ���ͱ���ĸ���
        PC(i)=k1*(f_max-not_best_fit(1,i))/(f_max-f_avg);
        PV(i)=k3*(f_max-not_best_fit(1,i))/(f_max-f_avg);
    else               %�����Ӧ��С��ƽ��ֵ��˵��Ⱦɫ������������Ƭ��Խ�٣���ʱӦ���ӽ���ͱ���ĸ���
        PC(i)=k2;
        PV(i)=k4;
    end
end

