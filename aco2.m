function [AZ,best_acroute,best_acvalue,aco_av,aco_mo,aco_index]=aco2(z1,z2,PT,GT,RA,RD,GO,GC,pn,gate,interation,preassigned,ro,price,people)
%!!!无遗传较优解转化的信息素，只有蚁群算法!!!
%还得是航班找停机位  找到某航班，查询可停靠的机位，蚂蚁代表的是停机位，
%可能航班5号，能停在1,2,3号停机位，分别求5号航班停在1号停机位，2号停机位，3号停机位的概率PPa(k) =(Tau(visited(end),J(k))^Alpha)*(abs(Eta(visited(end),J(k)))^Beta)*d(visited(end),J(k));
%pp=ppa/sum(ppa),选择概率，可能2号机位概率最大，把5号航班停在2停机位上
max_Tau=8*ones(z1,gate+1);%信息素浓度最大值矩阵
initialtau=4;%信息素初始值大小
maxtau=8;%信息素最大值设定
mintau=1;%信息素最小值设定
maxeta=4;%启发式最大值，当航班再分配与预分配停在同一个停机位
mineta=2;%启发式最小值，当航班再分配与预分配不停在同一个停机位
NC=1;%蚁群算法的迭代指针
ants=10;%蚂蚁种群数
alpha=2;%信息素因子
beta=4;%启发式因子
rho=0.8;%信息素残留因子
Q=2;%信息素增量
GO1=GO;%记录近机位初始开放时间
ro1=ro;%记录远机位初始开放时间
%a_route=zeros(gate,z1);%a_route存储一个蚂蚁种群的蚁群算法的再分配结果的矩阵
aco_av=zeros(1,interation);%蚁群算法每次迭代得到的最优解的干扰值
aco_mo=zeros(1,interation);%蚁群算法每次迭代得到的最优解的损失值
best_nroute=cell(1,interation);%存储每次迭代最优解的路径
best_nvalue=zeros(1,interation);%存储每次迭代的最优解的值
interval=8;%航班之间的安全间隔
initial_Tau=max_Tau/2;%蚁群初始时信息素浓度 信息素浓度最大值的一半+遗传算法Z8得到的路径信息素
while NC<=interation  %蚁群算法迭代interation次
    s_route=cell(1,ants);%s_route用来存储所有蚂蚁种群的再分配结果的矩阵
    ambition=zeros(3,ants);%ambition用来存储一次迭代里，所有种群的目标函数值
    AZ=zeros(ants+1,z1);%和遗传算法中的染色体群体是一个含义，长度是航班个数，数组里的值，代表航班停靠的停机位号
    AZ(ants+1,:)=pn';%把航班号存入AZ的最后一行
    delaytime=zeros(ants,z1);%延误时间
    ambition1=zeros(3,ants);%ambition1也是用来存储一次迭代里，所有种群的目标函数值
    for s=1:ants  %遍历蚂蚁种群
        %第一步  根据航班的到达顺序给飞机分配停机位
        GO=GO1;
        ro=ro1;
        U=zeros(z1,z2);%U为存储在未来4个小时内，会空闲出来的停机位集合
        V=zeros(z1,z2);%V为可用停机位集合 航班个数*近机位个数
        for i=1:z1 %遍历每个航班找到可用停机位
            c=find(RD(i,1)<GC(:,1));%先找到航班的离港时间小于近机位的关闭时间的停机位
            if isempty (c)  %如果近机位上的停机位结束服务时间，都小于航班的离港时间，那么给航班分配到远机位
                r=find(RA(i,1)+480>ro);%查找远机位中，最多延误8个小时，可以停靠的远机位
                if isempty(r) %延误了8个小时也没有航班空闲出来，那么取消航班，即以z1+1停机位号标注
                    AZ(s,i)=gate+1;%取消航班，即以z1+1停机位号标注
                    delaytime(s,i)=480;%取消航班，延误时间为8小时
                else
                    r1=find(ro<=RA(i,1));%从远机位找是否有可用停机位赋给航班停靠
                    if isempty(r1)%如果没有可用机位，那么找到一个延误时间最少的停机位
                        r2=z2+r;
                        V(i,1:length(r2))=r2;
                    else%如果有可用机位，那么早到一个空闲时间最长的停机位
                        r3=z2+r1;
                        V(i,1:length(r3))=r3;
                    end
                end
            else  %否则近机位里有停机位的结束服务时间，大于航班的离港时间
                uu=find(GO(c,1)<=RA(i,1));%再从c集合停机位里找到航班进港时，机位已经开始空闲的停机位
                u=c(uu); %uu是空闲机位在c集合里对应的行号，u是空闲停机位的机位号集合
                if isempty(u)  %如果u是空数组，没有停机位在航班到港时是空闲出来的，检查如果过了4个小时还没有停机位空闲出来，就停在远机位上
                    nn=find(GO(c,1)<=RA(i,1)+240);%nn是符合的停机位在c中的行号
                    n=c(nn,1); % n代表，距离预计航班进港时间4个小时之后空闲出来的停机位集合
                    if isempty(n) %如果延误了4个小时，也没有近机位空闲出来，就把飞机停靠在远机位
                        r=find(ro<RA(i,1)+480);%查找远机位中，最多延误8个小时，可以停靠的远机位
                        if isempty(r) %延误了8个小时也没有航班空闲出来，那么取消航班，即以z1+1停机位号标注
                            AZ(NC,i)=gate+1;%取消航班，即以z1+1停机位号标注
                            delaytime(s,i)=480;%取消航班，延误时间为8小时
                        else
                            r1=find(ro<=RA(i,1));%从远机位找是否有可用停机位赋给航班停靠，r1是可用停机位集合
                            if isempty(r1)%如果没有可用机位，延误远机位集合r装入V中
                                r2=z2+r;%因为r是1到40的数值，而远机位号是60到100，所以要将r+60才是远机位号
                                V(i,1:length(r2))=r2;
                            else%如果有可用远机位，空闲远机位集合r1装入V中
                                r3=z2+r1;%因为r1是1到40的数值，而远机位号是60到100，所以要将r1+60才是远机位号
                                V(i,1:length(r3))=r3;
                            end;
                        end
                    else % n不是空数组，那么在240分钟之内，会有近机位空闲出来
                        V(i,1:length(n))=n;%延误近机位集合n装入V中
                    end
                else
                    %如果u不是空数组，则航班进港时有停机位是空闲的
                    V(i,1:length(u))=u;%空闲近机位集合u装入V中
                end
            end
            %到这步，除了被取消的航班，V（i,:)集合里的第i行，都已经存储了停机位，从这些停机位，根据蚁群概率公式，随机取出一个停机位
            if all(V(i,:)==0)==0 %V（i,:)集合里并不是所有的值都是0，那么航班就是被取消了，可以从V（i,：）找到可以停靠的机位
                PPa=zeros(1,length(find(V(i,:)~=0)));%存储所有的航班停靠停机位的（信息素*启发式的值）
                PP = zeros(1,length(find(V(i,:)~=0)));%%存储所有的航班停靠停机位的概率
                for  j=1:length(find(V(i,:)~=0)) %遍历可用停机位集合V
                    if preassigned(1,i)==V(i,j)
                        Eta=maxeta;%Eta是蚁群算法里的启发式算子,如果该航班预分配的停机位与现在遍历到的航班是同一个，说明分配没发生变化，这是最好的情况，让Eta的值大一些
                    else
                        Eta=mineta;%如果该航班预分配的停机位与现在遍历到的航班不是同一个，说明分配发生了变化，这是最差的情况，让Eta的值小一些
                    end 
                    Tau=initial_Tau(i,V(i,j));%找到航班与停靠的机位之间的信息素
                    PPa(j)=Tau^alpha*Eta^beta;%将概率按照停机位顺序存入PPa矩阵
                end
                for j=1:length(find(V(i,:)~=0))
                    PP(j)=PPa(j)/sum(PPa); %计算每一个节点的概率值
                end
                %设定个constQ，随机选取停机位,all(PPa<constQ)==1表示PPa内所有的元素都小于constQ,则从PPa里选取最大值
                constQ=rand(1,1);
                if all(PP<constQ)==1
                    [~, PPa_index] = max(PPa);
                    g=V(i,PPa_index);
                else       %如果PPa里的值有大于constQ的，那么根据概率，从V里选
                    g=randsrc(1,1,[V(i,find(V(i,:)~=0));PP]);%根据概率PP，随机从V中选出一个停机位赋值给g
                end
                %查询U里是否有g号停机位，如果有，说明这个停机位在4个小时内才能空闲出来，那么这个停机位的再次空闲时间=GO+RD-RA
                if g<=60 %查看停靠的是近机位还是远机位
                    delaytime(s,i)=GO(g,1)-RA(i,1);
                    if delaytime>0%如果延误时间大于0，说明航班需要延误才能进港
                        GO(g,1)=GO(g,1)+RD(i,1)-RA(i,1)+interval;%更新停机位的空闲时间，延误时间+安全间隔+飞机起飞时间
                        delaytime(s,i)=GO(g,1)-RA(i,1);%存储延误时间
                        AZ(s,i)=g; %第s个蚁群种群里第i个航班存入停机位g
                    else  %说明航班到了，就有近机位空闲，近机位再次空闲时间=航班的实际离开实际RD
                        GO(g,1)=RD(i,1)+interval;%更新停机位的空闲时间，安全间隔+飞机起飞时间
                        delaytime(s,i)=0;
                        AZ(s,i)=g;  %第s个蚁群种群里第i个航班存入停机位g
                    end
                else %如果停靠的是远机位
                    AZ(s,i)=g;%将远机位号存入AZ中
                    g=g-z2;%g转化成1-40的格式
                    delaytime(s,i)=ro(g,1)-RA(i,1);%延误时间
                    if delaytime(s,i)<0 %如果<0说明航班进港时，远机位就是空闲的，那么没有延误时间
                        delaytime(s,i)=0;
                        ro(g,1)=RD(i,1)+interval;%远机位空闲时间更新
                    else
                        ro(g,1)=ro(g,1)-RA(i,1)+RD(i,1)+interval;%如果>0说明航班进港时，远机位没有空闲，航班需要等待
                    end
                end
            else %V（i,:)都是0，那么本次航班是取消的航班
                delaytime(s,i)=480;%取消的航班延误时间是480分钟
                AZ(s,i)=gate+1;
            end
        end
        %下一步
        %根据分配结果AZ转化为行数代表停机位，矩阵里的值代表航班号的矩阵，存入到a_route里,再把a_route存入s_route的集合里
        a_route=zeros(gate,z1);%a_route存储一个蚂蚁种群的蚁群算法的再分配结果的矩阵
        for k=1:gate+1 %从1号停机位开始遍历
            a=find(AZ(s,:)==k); %选出AZ中停在同一个停机位的值，所在的列号
            b=pn(a); %通过列号，找到对应的航班号，b是生成了一个列向量，代表停在同一个停机位的航班进入停机位顺序
            b=b'; %'代表矩阵的转置，列向量转置为行向量
            a_route(k,1:length(b))=b;%将分配结果存入到a_route中
        end
        s_route(1,s)={a_route};%根据蚂蚁种群的编号，存入到s_route里
        AV2=length(find(AZ(s,:)~=preassigned));%设一个变量，存储干扰值annoyance value
        MO1=zeros(1,z1);%每个航班的延误成本
        w1=1;%旅客比例
        w2=1;%机场比例
        w3=1;%航空公司比例
        ss=2;%乘客延误单位成本
        h=2;%机场延误单位成本
        g=[48,112,184];%小，中，大机型分别每分钟因为耗油增加的成本
        for j=1:z1 %遍历每个航班，查看其延误成本
            g1=g(PT(j));
            MO1(1,j)=w1*(people(j)*price(j)*((delaytime(s,j)/60)^(2/3))/29+ss*people(j)*delaytime(s,j))+w2*(h*people(j)*delaytime(s,j))+w3*(g1*delaytime(s,j));%旅客，机场，航空公司因为延误造成的成本增加目标函数
        end; %设一个变量，存储远机位值remote gate
        MO2=sum(MO1);%所有飞机的延误成本
        ambition(1,s)=AV2;%干扰值
        ambition(2,s)=MO2;%损失延误成本
    end
    %结束完一次迭代，根据各蚂蚁种群的分配结果，求出对应的目标函数值，找出最优解，更新最优解路径的信息素浓度
    ambition1(1,:)=ambition(1,:)/max(ambition(1,:));%干扰值规范化
    ambition1(2,:)=ambition(2,:)/max(ambition(2,:));%损失值规范化
    ambition1(3,:)=0.7*ambition1(1,:)+0.3*ambition1(2,:);%总目标值
    [min_avalue,min_aindex]=min(ambition1(3,:));%找到蚂蚁种群里第几个蚂蚁的路径是最小值，以及目标函数的最小值，即ambition最小值min_value，和ambition最小值所在的列号min_index
    best_nroute(1,NC)=s_route(1,min_aindex);%存储所有迭代里，每次迭代最优解的路径
    best_nvalue(1,NC)=min_avalue;%存储所有迭代里，每次迭代最优解的值
    aco_av(1,NC)=ambition(1,min_aindex);%每次迭代最小的干扰值
    aco_mo(1,NC)=ambition(2,min_aindex);%每次迭代最小的损失值
    Delta_tau=zeros(z1,gate+1);%路径上信息素的所有增量
    for m=1:z1 %从best_aroute的第一行开始遍历
        Delta_tau(m,AZ(min_aindex,m))=Q; %把边的信息素+Q
        
    end
    initial_Tau=initial_Tau*rho+Delta_tau;%将挥发后的剩余信息+信息素增量=下一次迭代的初始信息素增量
    initial_Tau(find(initial_Tau>maxtau))=maxtau;%设置信息素最大值，以免信息素太大，降低了全局搜索性能
    initial_Tau(find(initial_Tau<mintau))=mintau;%设置信息素最小值，以免信息素太小，降低了全局搜索性能
    NC=NC+1; %开始下一次迭代
end
[min_nroute,min_nindex]=min(best_nvalue);%找到所有迭代里最小值，和最小值所对应的迭代号
best_acroute=best_nroute{1,min_nindex};%最优的再分配方案
best_acvalue=min_nroute;%最小的目标值
aco_index=min_nindex;%蚁群最优值出现的迭代次数

