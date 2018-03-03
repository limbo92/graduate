function  [U,V,Z,NCmax]=initialsolution(RA,RD,GO,PT,GT,z1,z2,pn) %求解初始化函数
NC=1;
NCmax=100;
U=zeros(z1,z2);%U为空闲停机位集合 航班个数*近机位个数
V=zeros(z1,z2);%V为可用停机位集合 航班个数*近机位个数   
Z=zeros(NCmax,z1);%染色体集合   迭代次数*航班个数
GO1=GO;%存储停机位开放时间
f=5; %远机位号
while NC<=NCmax
    GO=GO1;%每次迭代开始的时候都要把停机位的开始时间刷新一下
    for i=1:z1
        k=1;%记录空闲机位集合的指针
        l=1;%记录可用机位集合的指针
        for j=1:z2
            if datetime(RA(i,1),GO(j,1))==2  %判断航班的进港时间是否晚于停机位的空闲时间
                U(i,k)=j;%把空闲的停机位装入空闲停机位集合中
                k=k+1;  %把空闲机位的集合指针往后挪一位
                if(PT(i,1)<=GT(j,1))%该停机位还满足类型约束，将它装入可用停机位集合
                    V(i,l)=j; %把满足的停机位号存入可用机位集合中
                    l=l+1;  %把可用机位的集合指针往后挪一位
                end
            end
        end
        if all(V(i,:)==0)==1%如果可用机位集合里都是0，说明可用机位集合里没有满足的，那么从空闲机位里找停机位
            if all(U(i,:)==0)==1%如果空闲机位集合里都是0，说明当航班进港时，没有停机位可以用，则从停机位集合中随机选取一个机位，更新后机位空间时间=该航班的占用时间+更新前机位空闲时间
                h=0;
                for m=1:z2
                    n=datenum(GO(m,1))-datenum(RA(i,1)); %计算延误时间 停机位开始空闲时间 - 航班实际进港时间
                    if n>0.0417%datestr(0.0417) 时间为一个小时,如果延误时间大于一个小时，那么h+1
                        h=h+1;
                    end
                end
                if h==z2 %说明所有停机位的延误时间都要大于1个小时，那么则把该航班分配到远机位
                    Z(NC,pn(i,1))=f; %这里先暂时设定f号停机位是远机位，并且远机位可以无视空闲时间的更新，假设只要飞机被要求停在远机位，那么一定就有空闲的远机位
                else  %否则
                    ii=randi(z2);%从停机位里随机选取一个%
                    %while ii==f %随机出来的不能是远机位f
                    %   ii=randi(z2);
                    %end
                    Z(NC,pn(i,1))=ii;%把停机位放入所对应的航班下
                    GO(ii,1)={datestr(datenum(GO(ii,1))+datenum(RD(i,1))-datenum(RA(i,1)),31)};%将选取的停机位的空闲时间更新，即更新前的停机位时间+本次航班的占用时间
                end
            else
                UU=U(i,:);%将该航班对应的空闲停机位集合赋给UU
                UUU=UU(UU~=0);%选取出UU集合中非0的值
                %if all(U==f)==0 %检查UUU里的值是否只有远机位
                    r=randi(length(UUU));%随机选取出来的停机位
                    %while r==f %随机出来的停机位不能是远机位
                    %    r=randi(length(VVV));
                    %end
                    Z(NC,pn(i,1))=UUU(r);%当空闲机位集合里有值的时候，直接从空闲机位集合里随机取出一个停机位赋给所对应的航班，存入到染色体
                    GO(UUU(r),1)=RD(i,1);%通过randi(length(U)),根据U的维度，随机取一列
                    
                %end
            end
        else
            VV=V(i,:);%将该航班对应的可用停机位集合赋给VV
            VVV=VV(VV~=0);%选出VV集合中非0的值，装入VVV
            r=randi(length(VVV));%随机选取出来的停机位
           % while VVV(r)==f   %随机出来的停机位不能是远机位
           %     r=randi(length(VVV));
           %end
            Z(NC,pn(i,1))=VVV(r);%当可用机位集合里有值的时候，直接从空闲机位集合里随机取出一个停机位赋给所对应的航班，存入到染色体
            GO(VVV(r),1)=RD(i,1);%把停机位的空闲时间更新
        end
    end
    
    NC=NC+1;
end
