function [NZ4,k]=evolution(best_route,NZ3,z1,preassigned,NCmax,delaytime4,people,PT,price)
%�ú����ѳ�ʼ�����õ�ǰ10%best_route�����½��棬���������Ⱦɫ��ŵ�һ���µ�������NZ3�����¼���һ�£��鿴�Ƿ�õ��˽���
%NZ3=[best_route;NZ1;NZ2];
NZ4=zeros(10,z1);
nz3=size(NZ3,1);%�����ʼ�����õ�ǰ10%best_route�����½��棬���������Ⱦɫ���ܵĸ�������ΪNZ3���������
[fit1,~,~]=fitness1(NZ3,preassigned,nz3,delaytime4,people,PT,z1,price);%��fitness�������NZ3��Ⱥ����Ӧ��ֵ�������fit1
fit3=fit1;%��fit1��ֵ����fit3
[~,eb]=sort(fit3(3,:),'descend');%��fit3�ĵ����У��ܵ���Ӧ��ֵ�������ɴ�С��˳�� ea������Ӧ��ֵ������˳��eb���µ���Ӧ��ֵ��֮ǰ��fit3�����е��кţ����Ը���eb�ҵ�֮ǰ����Ӧ��Ⱦɫ��
for i=1:10
    NZ4(i,:)=NZ3(eb(i),:);%����õ�Ⱦɫ�帳ֵ��NZ4��
end
k=0;%��¼��ʼ���Ž������������Ž���ͬ�ĸ���
for i=1:10 % �������NZ4��best_route�ж��ٸ�Ⱦɫ������ͬ�ģ�
    for j=1:10 %best_route���ÿ��Ⱦɫ�嶼��NZ4�ȶ�һ��
        if isequal(best_route(j,:),NZ4(i,:))==1  %isequal()�����Ƿ����
            k=k+1;%����ҵ���ȵģ���k+1
            break%�˳���ѭ������ʼNZ4����һ��Ⱦɫ����best_route�Ա�
        end
    end
end


