clear; clc;%crtl+i�Ԅ��Ű� ������ǰ�ӹؼ��� global ʹ�ñ������ȫ�ֱ���
%�Ŵ��㷨������
tic
[N1,T1,X1]=xlsread('C:\Users\Administrator\Desktop\delay1.xlsx','Sheet1','A2:H501');%������Ϣ���Ժ����ʵ�ʽ���ʱ�䣬�����������У����delay.xlsx·�����ˣ�����Ҳ��Ҫ���Ÿ���
[N2,T2,X2]=xlsread('C:\Users\Administrator\Desktop\delay1.xlsx','Sheet2');%ͣ��λ��Ϣ
[N3,T3,X3]=xlsread('C:\Users\Administrator\Desktop\delay1.xlsx','Sheet3');%����Ԥ������Ϣ �ѽ���λ��Զ��λ�ֿ������ۣ��ڳ�ʼ���У������۽���λ�Ŀ����ԣ��������λ�������㣬�ٴ�Զ��λ������ѡ��
%[N4,T4,X4]=xlsread('C:\Users\Administrator\Downloads\�����Ǵ�������������Ϣ�������Ӧ��20160927 (1)\20160927.xlsx','��ʷ����');
A1=T1(:,1);%Ԥ�Ƶ���ʱ��
D1=T1(:,2);%Ԥ�����ʱ��
[a1,d1]=datetime1(A1,D1);%�Ѻ���Ԥ�Ƶ��ۺ��������ʱ���ʽת��Ϊ�Է���Ϊ������λ����ֵ
A1=a1;%��ת���������a1��ֵ��A1
D1=d1;%��ת���������b1��ֵ��B
RA=T1(:,3);%ʵ�ʵ���ʱ�� real-arriveʵ�ʵ���ʱ��
RD=T1(:,4);%ʵ�����ʱ�� real-departureʵ���뿪ʱ��
[a1,d1]=datetime1(RA,RD);%�Ѻ���ʵ�ʵ��ۺ��������ʱ���ʽת��Ϊ�Է���Ϊ������λ����ֵ
RA=a1;%��ת���������a1��ֵ��RA
RD=d1;%��ת���������b1��ֵ��RD
people=N1(:,2);%�ÿ�����
price=N1(:,8);%����Ʊ��
GO=T2(1:length(T2)*0.6,1);%����λgateopenͣ��λ����ʱ�� ,����λ����ռ���зɻ���60%
GC=T2(1:length(T2)*0.6,2);%gateclose����λͣ��λ�ر�ʱ��
[a1,d1]=datetime1(GO,GC);%��ͣ��λ�Ŀ���ʱ��͹ر�����ʱ��ת��Ϊ�Է���Ϊ������λ����ֵ
GO=a1;%��ת���������a1��ֵ��GO
GC=d1;%��ת���������b1��ֵ��GC
PT=N1(:,3);%planetype�ɻ�����
GT=N2(:,1);%gatetypeͣ��λ����
z1=length(T1);%�������
z2=length(GO);%����λͣ��λ����
remote=length(T2)*0.4;%Զ��λռͣ��λ������40%��Զ��λ����
gate=z2+remote;%��ͣ��λ����
pn=N1(:,1);%planenumber������
rn=N2(z2+1:gate,4);%remotenumberԶ��λ���ϣ��ӱ��61��100
ro=T2(z2+1:gate,1);%Զ��λ����ʱ��
rc=T2(z2+1:gate,2);%Զ��λ�ر�ʱ��
[ro1,rc1]=datetime1(ro,rc);%��Զ��λ�Ŀ���ʱ��ת��Ϊ���ӵ�λ
ro=ro1;%��ת���������ro1��ֵ��ro
[Z,NCmax,delaytime,interval]=initialsolution1(RA,RD,GO,GC,PT,GT,z1,z2,ro,gate);%���ɳ�ʼ��Z����������ʵ�ʽ�/�����Ϣ��������������ͣ��λ������ֵ�Ƿ�����Z��Ⱦɫ�����NCmax,��������ʱ����delaytime
preassigned=N3;%Ԥ����
[fit,AV,MO]=fitness1(Z,preassigned,NCmax,delaytime,people,PT,z1,price);%�����Ӧ�Ⱥ���,fit��1,:���Ǹ���ֵ����Ӧ��,fit��2,:����Զ��λֵ����Ӧ��,fit(3,:)���ܵ���Ӧ��
interation=100;
for in=1:interation
    [PC,PV]=probability(fit,NCmax);%�����ʺ���
    [aa,b]=sort(fit(3,:),'descend');%������Ӧ���ɴ�С������ ��aaΪ��Ӧ��ֵ���ϣ�b��Ⱦɫ��ļ���
    best=aa(1:10);%ȡÿһ����Ӧ��ֵ��ǰ10��Ⱦɫ��Ϊ���ӽ⼯���Ժ����ÿһ����������������õ�һϵ�н���ԭ�еķ��ӽ⼯best���бȽ�,����
    %�����ĸ��õĽ����ԭ�е��ӽ⡣�����������ʱ���õ��ľ����㷨�в�������õķ��ӽ�,�Ӷ����ɷ��ӽ⼯��
    best_route=zeros(10,z1);%����õ��ٷ��䷽������best_route��
    for i=1:10
        best_route(i,:)=Z(b(i),:);
    end
    %global l;  %�趨ȫ�ֱ�����NZ1��Z2��Ⱦɫ��Ⱥ��ָ��
    %l=1;%%�趨ȫ�ֱ�����Z1��Ⱦɫ��Ⱥ��ָ��
    Z2=zeros(1,NCmax);%�Ѿ���������Ⱦɫ�壬��Ҫ�ų����������ٴ�ѡ��
    NZ1=zeros(1,z1);%NZ1�����洢���н��������������Ⱦɫ��
    [NZ1,a2,d2,delaytime1]=crossover1(PC,Z,NCmax,z1,NZ1,RA,RD,interval,gate);%���溯����NZ1Ϊ�������Ⱦɫ���ŵ�����Ⱥ
    Z3=zeros(1,NCmax);%�Ѿ������Ⱦɫ�壬��Ҫ�ų����������ٴ�ѡ��
    %global p%
    %p=1;
    NZ2=[];%NZ2�����洢���б��������������Ⱦɫ��
    [NZ2,c1,delaytime2]=variation1(NCmax,PV,Z,z1,NZ2,RA,RD,interval,gate);%���캯��
    %[Z6,Z7]=pheromone(pn,best_route,z1,z2,NCmax);
    %nz3=size(best_route,1)+size(NZ1,1)+size(NZ2,1);%�����ʼ�����õ�ǰ10%best_route�����½��棬���������Ⱦɫ���ܵĸ�������ΪNZ3���������
    NZ3=[best_route;NZ1;NZ2];%�ѳ�ʼ�����õ�ǰ10%best_route�����½��棬���������Ⱦɫ��ŵ�һ���µ�������NZ3
    delaytime4=[delaytime(b(1:10),:);delaytime1;delaytime2];% NZ3Ⱦɫ������ӳ�ʱ��
    [NZ4,k,fit1]=evolution1(best_route,NZ3,z1,preassigned,NCmax,delaytime4,people,PT,price);%�ú����ѳ�ʼ�����õ�ǰ10%best_route�����½��棬���������Ⱦɫ��ŵ�һ���µ�������NZ3�����¼���һ�£��鿴�Ƿ�õ��˽���
    %NZ4�ǳ�ʼ���Ž�����죬�������µ�Ⱦɫ������һ��ļ��ϣ�NZ3������õ�ǰ10��Ⱦɫ��
    NCmax=size(fit1,2);%���µ�Ⱦɫ�����Ⱦɫ�������¼�¼
    fit=fit1;%���µ�Ⱦɫ�������Ӧ��ֵ���¸�ֵ
    delaytime=delaytime4;%���µ�Ⱦɫ�����ÿ��Ⱦɫ�������ʱ�����¼�¼
    if k>6 %˵��ÿ�ν����ʶ�С��40%
        kk=kk+1;%������ε���������С��40%����ô��¼kk����һ��
    else
        kk=0;%������ε��������ʴ���40%����ô��¼kk����Ϊ0
    end
    if kk>3||NCmax<=10 %�������3�������ʵ���30%����Ⱦɫ��Ⱥ�ĸ���С��10��Ⱦɫ�壬��ô����ѭ��
        break;
    end
end
[Z6,Z7,Z8]=pheromone(pn,NZ4,z1,gate,NCmax); %pheromone�����Ŵ��㷨����Ⱥ�㷨���νӺ����������ǰ��Ŵ��㷨�Ľ������NZ4���Ž⣬����������Ⱥ�㷨�ĳ�ʼ��Ϣ�أ����ȣ������Ž�ת��Ϊ������ͣ��λ�����Ǻ���ŵľ��󣬸���ʵ��ͣ��ͣ��λ��˳������
[AZ,best_acroute,best_acvalue]=aco(z1,z2,PT,GT,RA,RD,GO,GC,pn,gate,Z8,interation,preassigned,ro,price,people);%��Ⱥ�㷨
toc