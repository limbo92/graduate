a3=length(a2);
delaytime1=zeros(a3,z1);% delaytime1�Ǵ洢������������ɵĺ����������������ʱ��
for i=1:a3 % i����Ⱦɫ��
    for j=1:z1 % j������λ
        r=zeros(1);%
        if j<=100 %ͣ��λ��100֮��,����ʱ����������
            r=find(NZ1(i,:)==j);%�ҵ�ͣ��ͬһ����λ�ĺ��༯��
            if isempty(r) %���û�к���ͣ����ͣ��λ��
                continue;%��������ͣ��λ��ѭ��
            else %�к���ͣ����ͣ��λ
                l=length(r);%���༯�ϳ���
                if l==1% ���ֻ��һ������ͣ��ͣ��λ�ϣ�û������ʱ��
                    delaytime1(i,r)=0;
                else
                    for x=1:l-1
                        if x==1 %��һ��ͣ���ĺ��࣬û������ʱ��
                            delaytime1(i,r(x))=0;
                        else % ����½��ͣ���ĺ��࣬����ʱ�䣬ǰһ����������ʱ��+��ȫ���ʱ��-��һ������Ľ���ʱ��
                            delaytime1(i,r(x+1))=RD(r(x),1)+interval-RA(r(x+1),1);
                            if delaytime1(i,r(x+1))<0 %���С��0˵�����󺽰����ʱ��ǰһ�������Ѿ������ˣ�����ʱ������0
                                delaytime1(i,r(x+1))=0;
                            end
                        end
                    end
                end
            end
        else %����ͣ��101��λ����ô������ȡ���ˣ�����ʱ����480����
            r=find(NZ1(i,:)==j);%�ҵ�ͣ��ͬһ����λ�ĺ��༯��
            delaytime1(i,r)=480;
        end
        
    end
end