function [NZ5,new_best_route,k,fit2,new_best_AV,new_best_MO,min_AV,min_MO,eb1,delaytime5,best]=evolution3(NZ3,z1,preassigned,delaytime4,people,PT,price,best_AV,best_MO,bn,best_delaytime,best_route,NCmax,best)
%�ú����ѳ�ʼ�����õ�ǰ10%best_route�����½��棬���������Ⱦɫ��ŵ�һ���µ�������NZ3�����¼���һ�£��鿴�Ƿ�õ��˽���
%NZ3=[best_route;NZ1;NZ2];
NZ4=zeros(NCmax-bn,z1);%���ε���������õ�ǰ10%���壬ʣ�µ�90%Ⱦɫ��
new_best_route=zeros(bn,z1);%���ε�������Ⱥ����õ�ǰ10%Ⱦɫ��
new_best_AV=zeros(1,bn);%���ε�����С�ĸ���ֵ����
new_best_MO=zeros(1,bn);%���ε�����С����ʧֵ����
nz3=size(NZ3,1);%�ѳ�ʼ�����õ�ǰ10%ȥ����ʣ�µ�90%not_best_route���½��棬���������Ⱦɫ���ܵĸ�������ΪNZ3���������
[fit1,~,~]=fitness1(NZ3,preassigned,nz3,delaytime4,people,PT,z1,price);%��fitness�������NZ3��Ⱥ����Ӧ��ֵ�������fit1
fit3=fit1;%��fit1��ֵ����fit3
[~,eb]=sort(fit3(3,:),'descend');%��fit3�ĵ����У��ܵ���Ӧ��ֵ�������ɴ�С��˳�� ea������Ӧ��ֵ������˳��eb���µ���Ӧ��ֵ��֮ǰ��fit3�����е��кţ����Ը���eb�ҵ�֮ǰ����Ӧ��Ⱦɫ��
for i=1:NCmax-bn %�ҳ���Ⱥ��ǰNCmax-bn������
    NZ4(i,:)=NZ3(eb(i),:);%����õ�Ⱦɫ�帳ֵ��NZ4��
%     AV4(1,i)=AV(2,eb(i));%����С�ĸ���ֵ��ֵ��AV4
%     MO4(1,i)=MO(2,eb(i));%����С����ʧֵ��ֵ��MO4
end
NZ5=[best_route;NZ4];%��һ�ε�������������best_route�뽻���������������NCmax-bn��������ɱ��ε������ɵ�����Ⱥ
delaytime5=[best_delaytime;delaytime4(eb(1:NCmax-bn),:)];%���ε������ɵ�����Ⱥ������ʱ��
nz5=size(NZ5,1);%��������Ⱥ�ĸ�����Ӧ�ú�NCmax���
[fit2,AV2,MO2]=fitness1(NZ5,preassigned,nz5,delaytime5,people,PT,z1,price);%��fitness1�����������Ⱥ����Ӧ��ֵ
fit4=fit2;%��fit2��ֵ����fit4
[~,eb1]=sort(fit4(3,:),'descend');%%��fit2�ĵ����У��ܵ���Ӧ��ֵ�������ɴ�С��˳��eb1���µ���Ӧ��ֵ��֮ǰ��fit3�����е��кţ����Ը���eb1�ҵ�֮ǰ����Ӧ��Ⱦɫ��
for i=1:bn
    new_best_route(i,:)=NZ5(eb1(i),:);%������Ⱥ��õ�ǰ10%�ٷ��䷽������best_route��
    new_bnum1=find(eb1(i)==AV2(1,:));%�ҵ���õĸ�����AV�е��к�
    new_best_AV(1,i)=AV2(2,new_bnum1);%����Ⱥ��õ�ǰ10%����ĸ���ֵ����
    new_bnum2=find(eb1(i)==MO2(1,:));%�ҵ���õĸ�����MO�е��к�
    new_best_MO(1,i)=MO2(2,new_bnum2);%����Ⱥ��õ�ǰ10%����Ķ�Ŀ��ֵ����
end
mba=max(best_AV);%�ҵ�best_AV������ֵ
mbm=max(best_MO);%�ҵ�best_MO������ֵ
ma=max(new_best_AV);%�ҵ� new_best_AV������ֵ
mm=max(new_best_MO);%�ҵ� new_best_MO������ֵ
if mba<ma  %�ҵ�����ֵ����ֵMA
    MA=ma;
else
    MA=mba;
end
if mbm<mm %�ҵ���ʧֵ����ֵMM
    MM=mm;
else
    MM=mbm;
end
ambition1=best_AV/MA;%�淶��best_AV
ambition2=best_MO/MM;%�淶��best_MO
ambition3=new_best_AV/MA;%�淶��AV4
ambition4=new_best_MO/MM;%�淶��MO4
ambition5=ambition1+ambition2;%֮ǰ����������Ŀ��ֵ
ambition6=ambition3+ambition4;%���ε�������Ŀ��ֵ
[a5,b5]=min(ambition5);
k=length(find(ambition6<a5));% k�Ǳ��ε�����õ�Ⱦɫ����ϴε�����õ�Ⱦɫ����õ�Ⱦɫ�����
[a6,b6]=min(ambition6);
if a5<a6
    min_AV=best_AV(b5);%�ҵ����Ž�ĸ���ֵ
    min_MO=best_MO(b5);%�ҵ����Ž����ʧֵ
else
    min_AV=new_best_AV(b6);%�ҵ����Ž�ĸ���ֵ
    min_MO=new_best_MO(b6);%�ҵ����Ž����ʧֵ
end
if k~=0 %�������Ž⼯
    fa=find(ambition6<a5);
    [~,sb]=sort(ambition5,'descend');
    best=best_route;
    best(sb(1:k),:)=new_best_route(fa,:);
%     new_best_route=best_route;%ÿ�ε����������Ž⼯����Ϊ�´ε���������10%����
end






