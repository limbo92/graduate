function [NZ4,k,fit1,AV4,MO4,min_AV,min_MO,eb]=evolution2(NZ3,z1,preassigned,delaytime4,people,PT,price,best_AV,best_MO,bn)
%�ú����ѳ�ʼ�����õ�ǰ10%best_route�����½��棬���������Ⱦɫ��ŵ�һ���µ�������NZ3�����¼���һ�£��鿴�Ƿ�õ��˽���
%NZ3=[best_route;NZ1;NZ2];
NZ4=zeros(bn,z1);%���ε�����õ�10��Ⱦɫ��
AV4=zeros(1,bn);%���ε�����С�ĸ���ֵ����
MO4=zeros(1,bn);%���ε�����С����ʧֵ����
nz3=size(NZ3,1);%�����ʼ�����õ�ǰ10%best_route�����½��棬���������Ⱦɫ���ܵĸ�������ΪNZ3���������
[fit1,AV,MO]=fitness1(NZ3,preassigned,nz3,delaytime4,people,PT,z1,price);%��fitness�������NZ3��Ⱥ����Ӧ��ֵ�������fit1
fit3=fit1;%��fit1��ֵ����fit3
[~,eb]=sort(fit3(3,:),'descend');%��fit3�ĵ����У��ܵ���Ӧ��ֵ�������ɴ�С��˳�� ea������Ӧ��ֵ������˳��eb���µ���Ӧ��ֵ��֮ǰ��fit3�����е��кţ����Ը���eb�ҵ�֮ǰ����Ӧ��Ⱦɫ��
for i=1:10
    NZ4(i,:)=NZ3(eb(i),:);%����õ�Ⱦɫ�帳ֵ��NZ4��
    AV4(1,i)=AV(2,eb(i));%����С�ĸ���ֵ��ֵ��AV4
    MO4(1,i)=MO(2,eb(i));%����С����ʧֵ��ֵ��MO4
end
mba=max(best_AV);%�ҵ�best_AV������ֵ
mbm=max(best_MO);%�ҵ�best_MO������ֵ
ma=max(AV4);%�ҵ�AV4������ֵ
mm=max(MO4);%�ҵ�MO4������ֵ
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
ambition3=AV4/MA;%�淶��AV4
ambition4=MO4/MM;%�淶��MO4
ambition5=ambition1+ambition2;%֮ǰ����������Ŀ��ֵ
ambition6=ambition3+ambition4;%���ε�������Ŀ��ֵ
k=length(find(ambition6<ambition5));% k�Ǳ��ε�����õ�Ⱦɫ����ϴε�����õ�Ⱦɫ����õ�Ⱦɫ�����
[a5,b5]=min(ambition5);
[a6,b6]=min(ambition6);
if a5<a6
    min_AV=best_AV(b5);%�ҵ����Ž�ĸ���ֵ
    min_MO=best_MO(b5);%�ҵ����Ž����ʧֵ
else
    min_AV=AV4(b6);%�ҵ����Ž�ĸ���ֵ
    min_MO=MO4(b6);%�ҵ����Ž����ʧֵ
end






