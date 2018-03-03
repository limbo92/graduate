function  [Z,NCmax,delaytime,interval]=initialsolution1(RA,RD,GO,GC,PT,GT,z1,z2,ro,gate) %求解初始化函数,
NC=1;
NCmax=500;%染色体群组中染色体的总个数
Z=zeros(NCmax,z1);%染色体集合   迭代次数*航班个数,按照实际的到港时间顺序排列
GO1=GO;%存储停机位开放时间
ro1=ro;
interval=8;%停在同一停机位的两个连续航班最小时间间隔10分钟
delaytime=zeros(NCmax,z1);%存储航班延误时间，用来求解目标函数 延误耗油量
while NC<=NCmax
    GO=GO1;%每次迭代开始的时候都要把近机位的开始时间刷新一下
    ro=ro1;%每次迭代开始的时候都要把远机位的开始时间刷新一下
    for i=1:z1 %遍历每个航班找到可用停机位
        c=find(RD(i,1)<GC(:,1));%先找到航班的离港时间小于近机位的关闭时间的停机位
        if isempty (c)  %如果近机位上的停机位结束服务时间，都小于航班的离港时间，那么给航班分配到远机位
            r=find(RA(i,1)+480>ro);%查找远机位中，最多延误8个小时，可以停靠的远机位
            if isempty(r) %延误了8个小时也没有航班空闲出来，那么取消航班，即以z1+1停机位号标注
                Z(NC,i)=gate+1;%取消航班，即以z1+1停机位号标注
                delaytime(NC,i)=480;%取消航班，延误时间为8小时
                continue;
            else
                r1=find(ro<=RA(i,1));%从远机位找是否有可用停机位赋给航班停靠
                if isempty(r1)%如果没有可用机位，那么找到一个延误时间最少的停机位
                    [r22]=min(ro);% r222空闲时间最长的停机位集合
                    r222=find(ro==r22);%
                    r2=r222(randi(length(r222)));%从集合里随机找到一个远机位r2
                else%如果有可用机位，那么早到一个空闲时间最长的停机位
                    [r22]=min(ro(r1));% r222空闲时间最长的停机位集合
                    r222=find(ro==r22);%
                    r2=r222(randi(length(r222)));%从集合里随机找到一个远机位r2
                end
                r3=z2+r2;%远机位不考虑停机位关闭时间
                Z(NC,i)=r3;%航班停靠的机位号
                delaytime(NC,i)=r22-RA(i,1);%延误时间
                if delaytime(NC,i)<0 %如果<0说明航班进港时，远机位就是空闲的，那么没有延误时间
                    delaytime(NC,i)=0;
                    ro(r2,1)=RD(i,1)+interval;%远机位空闲时间更新
                    continue;
                end
                ro(r2,1)=ro(r2,1)-RA(i,1)+RD(i,1)+interval;%如果>0说明航班进港时，远机位没有空闲，航班需要等待
                continue;
            end
        else  %否则近机位里有停机位的结束服务时间，大于航班的离港时间
            uu=find(GO(c,1)<=RA(i,1));%再从c集合近机位里找到航班进港时，近机位已经开始空闲
            u=c(uu); %uu是空闲机位在c集合里对应的行号，u是空闲停机位的机位号集合
            gg=find(GT(u,1)>=PT(i,1));%此处判断空闲的近机位的大小是否能装下航班
            u=u(gg);%空闲的近机位能够装下航班的集合
        end
        if isempty(u)  %如果u是空数组，没有停机位在航班到港时是空闲出来的，检查如果过了4个小时还没有停机位空闲出来，就停在远机位上
            nn=find(GO(c,1)<=RA(i,1)+240);%nn是符合的停机位在c中的行号
            n=c(nn,1); % n代表，距离预计航班进港时间4个小时之后空闲出来的停机位集合
            kk=find(GT(n,1)>=PT(i,1));%此处判断延误的近机位的大小是否能装下航班
            n=n(kk);%延误的近机位可以装下航班的集合
            if isempty(n) %如果延误了4个小时，也没有近机位空闲出来，就把飞机停靠在远机位
                r=find(ro<RA(i,1)+480);%查找远机位中，最多延误8个小时，可以停靠的远机位
                if isempty(r) %延误了8个小时也没有航班空闲出来，那么取消航班，即以z1+1停机位号标注
                    Z(NC,i)=gate+1;%取消航班，即以z1+1停机位号标注
                    delaytime(NC,i)=480;%取消航班，延误时间为8小时
                    continue;
                else
                    r1=find(ro<=RA(i,1));%从远机位找是否有可用停机位赋给航班停靠，r1是可用停机位集合
                    if isempty(r1)%如果没有可用机位，那么早到一个延误时间最少的停机位
                        [r22]=min(ro);% r222空闲时间最长的停机位集合
                        r222=find(ro==r22);%
                        r2=r222(randi(length(r222)));%从集合里随机找到一个远机位r2，r22是最小值
                    else%如果有可用机位，那么早到一个空闲时间最长的停机位
                        [r22]=min(ro(r1));% r222空闲时间最长的停机位集合
                        r222=find(ro==r22);%
                        r2=r222(randi(length(r222)));%从集合里随机找到一个远机位r2，r22是最小值
                    end
                    r3=z2+r2;%远机位不考虑停机位关闭时间，如果延误超过8个小时，那么航班取消，航班停靠的机位号z1+1，取消的航班以延误8小时计算
                    Z(NC,i)=r3;%航班停靠的机位号
                    delaytime(NC,i)=r22-RA(i,1);%延误时间
                    if delaytime(NC,i)<0 %如果<0说明航班进港时，远机位就是空闲的，那么没有延误时间
                        delaytime(NC,i)=0;
                        ro(r2,1)=RD(i,1)+interval;%远机位空闲时间更新
                        continue;
                    end
                    ro(r2,1)=ro(r2,1)-RA(i,1)+RD(i,1)+interval;%如果>0说明航班进港时，远机位没有空闲，航班需要等待
                    continue;
                end
            else % n不是空数组，那么在240分钟之内，会有停机位空闲出来
                N= n(randi(length(n)));%从集合n里随机选取一个停机位分配
                Z(NC,i)=N;%把停机位存入Z（NC，i）里
                delaytime(NC,i)=GO(N,1)-RA(i,1); %航班进港了，需要等一段时间才能停靠到停机位,delaytime=延误时间
                GO(N,1)=GO(N,1)-RA(i,1)+RD(i,1)+interval;%更新停机位开始空闲时间=航班延误时间+飞机实际离开时间+最小时间间隔
                continue;
            end
        else
            %如果u不是空数组，则航班进港时有停机位是空闲的并且满足机型约束
            delaytime(NC,i)=0;%航班进港了，直接就可以停靠到停机位，那么没有延误时间 delaytime=0
                N=u(randi(length(u)));%u里随机选取
                Z(NC,i)=N;%把停机位存入Z里
                GO(N,1)=RD(i,1)+interval;%更新停靠的停机位开始空闲时间
                continue;
        end
    end
    NC=NC+1;
end

