clear; clc;%crtl+i�Ԅ��Ű� ������ǰ�ӹؼ��� global ʹ�ñ������ȫ�ֱ���
%�Ŵ��㷨������
final_av=cell(1,10);%
final_mo=cell(1,10);%
final_hgroute=cell(1,10);%����㷨����·��
final_acroute=cell(1,10);%��Ⱥ�㷨����·��
min1=zeros(2,10);%����㷨ÿ�ε�������ֵ����Сֵ����Сֵ���ֵĵ�������
min2=zeros(2,10);%��Ⱥ�㷨ÿ�ε�������ֵ����Сֵ����Сֵ���ֵĵ�������
min3=zeros(2,10);%����㷨ÿ�ε�����ʧֵ����Сֵ����Сֵ���ֵĵ�������
min4=zeros(2,10);%��Ⱥ�㷨ÿ�ε�����ʧֵ����Сֵ����Сֵ���ֵĵ�������
min5=zeros(2,10);%�Ŵ��㷨ÿ�ε�������ֵֵ����Сֵ����Сֵ���ֵĵ�������
min6=zeros(2,10);%�Ŵ��㷨ÿ�ε�����ʧֵ����Сֵ����Сֵ���ֵĵ�������
for ii=1:10
    tic
    [N1,T1,X1]=xlsread('G:\����\GACO1\delay1.xlsx','Sheet1','A2:H501');%������Ϣ���Ժ����ʵ�ʽ���ʱ�䣬�����������У����delay.xlsx·�����ˣ�����Ҳ��Ҫ���Ÿ���
    [N2,T2,X2]=xlsread('G:\����\GACO1\delay1.xlsx','Sheet2');%ͣ��λ��Ϣ
    [N3,T3,X3]=xlsread('G:\����\GACO1\delay1.xlsx','Sheet3');%����Ԥ������Ϣ �ѽ���λ��Զ��λ�ֿ������ۣ��ڳ�ʼ���У������۽���λ�Ŀ����ԣ��������λ�������㣬�ٴ�Զ��λ������ѡ��
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
    kk=0;
    [Z,NCmax,delaytime,interval]=initialsolution1(RA,RD,GO,GC,PT,GT,z1,z2,ro,gate);%���ɳ�ʼ��Z����������ʵ�ʽ�/�����Ϣ��������������ͣ��λ������ֵ�Ƿ�����Z��Ⱦɫ�����NCmax,��������ʱ����delaytime
    bn=NCmax*0.1;%��Ⱥ����NCmax��10%
    preassigned=N3;%Ԥ����
    [fit,AV,MO]=fitness1(Z,preassigned,NCmax,delaytime,people,PT,z1,price);%�����Ӧ�Ⱥ���,fit��1,:���Ǹ���ֵ����Ӧ��,fit��2,:����Զ��λֵ����Ӧ��,fit(3,:)���ܵ���Ӧ��
    [aa,b]=sort(fit(3,:),'descend');%������Ӧ���ɴ�С������ ��aaΪ��Ӧ��ֵ���ϣ�b��Ⱦɫ��ļ���
    best=zeros(bn,z1);%ȡÿһ����Ӧ��ֵ��ǰ10��Ⱦɫ��Ϊ���ӽ⼯���Ժ����ÿһ����������������õ�һϵ�н���ԭ�еķ��ӽ⼯best���бȽ�,����
    %�����ĸ��õĽ����ԭ�е��ӽ⡣�����������ʱ���õ��ľ����㷨�в�������õķ��ӽ�,�Ӷ����ɷ��ӽ⼯��
    best_route=zeros(bn,z1);%����Ⱥ��õ�ǰ10%�ٷ��䷽������best_route��
    not_best_route=Z(b(bn+1:NCmax),:);%����Ⱥ��õ�ǰ10%ȥ������Ⱥ��ʣ�µ�90%��������Ӧ���ɴ�С��˳�򣬸������not_best_route��
    not_best_fit=fit(3,b(bn+1:NCmax));%����Ⱥ��õ�ǰ10%ȥ������Ⱥ��ʣ�µ�90%��������Ӧ���ɴ�С��˳����Ӧ��ֵ����not_best_fit��
    best_AV=zeros(1,bn);%��Ⱥ��õ�ǰ10%����ĸ���ֵ����
    best_MO=zeros(1,bn);%��Ⱥ��õ�ǰ10%����Ķ�Ŀ��ֵ����
    for i=1:bn
        best_route(i,:)=Z(b(i),:);%����Ⱥ��õ�ǰ10%�ٷ��䷽������best_route��
        bnum1=find(b(i)==AV(1,:));%�ҵ���õĸ�����AV�е��к�
        best_AV(1,i)=AV(2,bnum1);%��Ⱥ��õ�ǰ10%����ĸ���ֵ����
        bnum2=find(b(i)==MO(1,:));%�ҵ���õĸ�����MO�е��к�
        best_MO(1,i)=MO(2,bnum2);%��Ⱥ��õ�ǰ10%����Ķ�Ŀ��ֵ����
    end
    interation=200;%�Ŵ��㷨��������
    inter_AV=zeros(1,interation);%ÿ�ε��������Ÿ���ֵ
    inter_MO=zeros(1,interation);%ÿ�ε�����������ʧֵ
    for in=1:interation
        [PC,PV]=probability(not_best_fit,NCmax,bn);%�����ʺ���
        %global l;  %�趨ȫ�ֱ�����NZ1��Z2��Ⱦɫ��Ⱥ��ָ��
        %l=1;%%�趨ȫ�ֱ�����Z1��Ⱦɫ��Ⱥ��ָ��
        NZ1=zeros(1,z1);%NZ1�����洢���н��������������Ⱦɫ��
        [NZ1,a2,d2,delaytime1]=crossover1(PC,not_best_route,NCmax,z1,NZ1,RA,RD,interval,gate,bn);%���溯����NZ1Ϊ�������Ⱦɫ���ŵ�����Ⱥ
        Z3=zeros(1,NCmax);%�Ѿ������Ⱦɫ�壬��Ҫ�ų����������ٴ�ѡ��
        %global p%
        %p=1;
        NZ2=[];%NZ2�����洢���б��������������Ⱦɫ��
        [NZ2,delaytime2]=variation1(NCmax,PV,not_best_route,z1,NZ2,RA,RD,interval,gate,bn);%���캯��
        %[Z6,Z7]=pheromone(pn,best_route,z1,z2,NCmax);
        %nz3=size(best_route,1)+size(NZ1,1)+size(NZ2,1);%�����ʼ�����õ�ǰ10%best_route�����½��棬���������Ⱦɫ���ܵĸ�������ΪNZ3���������
        NZ3=[not_best_route;NZ1;NZ2];%�ѳ�ʼ�����õ�ǰ10%ȥ����ʣ�µ�90%not_best_route���½��棬���������Ⱦɫ��ŵ�һ���µ�������NZ3
        delaytime4=[delaytime(b(bn+1:NCmax),:);delaytime1;delaytime2];% NZ3Ⱦɫ������ӳ�ʱ��
        best_delaytime=delaytime(b(1:bn),:);%ǰ10%���������ʱ��
        [NZ5,new_best_route,k,fit2,new_best_AV,new_best_MO,min_AV,min_MO,eb1,delaytime5,best]=evolution3(NZ3,z1,preassigned,delaytime4,people,PT,price,best_AV,best_MO,bn,best_delaytime,best_route,NCmax,best);%�ú����ѳ�ʼ�����õ�ǰ10%best_route�����½��棬���������Ⱦɫ��ŵ�һ���µ�������NZ3�����¼���һ�£��鿴�Ƿ�õ��˽���
        %NZ5������Ⱥ��new_best_route�ǳ�ʼ���Ž�����죬�������µ�Ⱦɫ������һ��ļ��ϣ�NZ3������õ�ǰ10��Ⱦɫ�壬min_AV��min_MO�����Ž�ĸ���ֵ����ʧֵ
        inter_AV(1,in)=min_AV;%��¼ÿ�ε������Ž�ĸ���ֵ
        inter_MO(1,in)=min_MO;%��¼ÿ�ε������Ž�Ķ�Ŀ��ֵ
        best_route=new_best_route;%�洢���ε�������õ�ǰ10%Ⱦɫ�壬������һ�ε�����best_route
        best_AV=new_best_AV;%�洢���ε�������õ�ǰ10%Ⱦɫ��ĸ���ֵ��������һ�ε�����best_AV
        best_MO=new_best_MO;%�洢���ε�������õ�ǰ10%Ⱦɫ��Ķ�Ŀ��ֵ��������һ�ε�����best_MO
        NCmax=size(fit2,2);%���µ�Ⱦɫ�����Ⱦɫ�������¼�¼
        not_best_route=NZ5(eb1(bn+1:NCmax),:);%������Ⱥ��õ�ǰ10%ȥ������Ⱥ��ʣ�µ�90%��������Ӧ���ɴ�С��˳�򣬴���not_best_route��
        not_best_fit=fit2(3,eb1(bn+1:NCmax));%����Ⱥ��õ�ǰ10%ȥ������Ⱥ��ʣ�µ�90%��������Ӧ���ɴ�С��˳����Ӧ��ֵ����not_best_fit��
        fit=fit2;%���µ�Ⱦɫ�������Ӧ��ֵ���¸�ֵ
        b=eb1;%��Ӧ�ȴӴ�С������
        delaytime=delaytime5;%���µ�Ⱦɫ�����ÿ��Ⱦɫ�������ʱ�����¼�¼
%         if in>interation*0.3
%             if k>=5 %˵�����ν����ʴ���10%
%                 kk=0;%������ε��������ʴ���40%����ô��¼kk����Ϊ0
%             else
%                 kk=kk+1;%������ε���������С��40%����ô��¼kk+1
%             end
%             if kk>11 %�������10�������ʵ���30%����Ⱦɫ��Ⱥ�ĸ���С��10��Ⱦɫ�壬��ô����ѭ��
%                 break;
%             end
%         end
    end
    [Z6,Z7,Z8]=pheromone(pn,best,z1,gate,bn); %pheromone�����Ŵ��㷨����Ⱥ�㷨���νӺ����������ǰ��Ŵ��㷨�Ľ������NZ4���Ž⣬����������Ⱥ�㷨�ĳ�ʼ��Ϣ�أ����ȣ������Ž�ת��Ϊ������ͣ��λ�����Ǻ���ŵľ��󣬸���ʵ��ͣ��ͣ��λ��˳������
    toc
end
%     [~,best_hgroute,best_hgvalue,hg_av,hg_mo,hg_index]=hg3(z1,z2,PT,GT,RA,RD,GO,GC,pn,gate,Z8,interation,preassigned,ro,price,people,in);%����㷨
%     toc
%     tic
%     [~,best_acroute,best_acvalue,aco_av,aco_mo,aco_index]=aco2(z1,z2,PT,GT,RA,RD,GO,GC,pn,gate,interation,preassigned,ro,price,people);%��Ⱥ�㷨
%     toc
%     final_av{1,ii}=[inter_AV;aco_av;hg_av];
%     final_mo{1,ii}=[inter_MO;aco_mo;hg_mo];
%     [ha,hb]=min(hg_av);
%     [aa,ab]=min(aco_av);
%     [ha1,hb1]=min(hg_mo);
%     [aa1,ab1]=min(aco_mo);
%     [ha2,hb2]=min(best_AV);
%     [aa2,ab2]=min(best_MO);
%     min1(1,ii)=ha;%����㷨ÿ�ε�������ֵ����Сֵ����Сֵ���ֵĵ�������
%     min1(2,ii)=hb;
%     min2(1,ii)=aa;%��Ⱥ�㷨ÿ�ε�������ֵ����Сֵ����Сֵ���ֵĵ�������
%     min2(2,ii)=ab;
%     min3(1,ii)=ha1;%����㷨ÿ�ε�����ʧֵ����Сֵ����Сֵ���ֵĵ�������
%     min3(2,ii)=hb1;
%     min4(1,ii)=aa1;%��Ⱥ�㷨ÿ�ε�����ʧֵ����Сֵ����Сֵ���ֵĵ�������
%     min4(2,ii)=ab1;
%     min5(1,ii)=ha2;
%     min5(2,ii)=hb2;
%     min6(1,ii)=aa2;
%     min6(2,ii)=ab2;
%     final_hgroute{1,ii}=best_hgroute;
%     final_acroute{1,ii}=best_acroute;
% end