function [NZ2,delaytime2]=variation1(NCmax,PV,not_best_route,z1,NZ2,RA,RD,interval,gate,bn)
%变异函数，因为变异概率小，有时需要找寻许多次才能找到变异的染色体，由于变异概率实在太小，需要非常多的时间才能遍历完
%改变策略，随机选取100个数，与变异概率每个元素一 一做对比，找到所有小于变异概率的染色体进行变异
a1=zeros(1,NCmax-bn); %用来存储NCmax-bn个随机数，与PV做对比
for i=1:NCmax-bn  %给a1数组赋值
    a1(i)=rand(1);  %a1的每个值都在0~1之间随机取值
end
b1=a1<PV; %a1与PV做对比，如果小于变异概率，相对应的b1数组里值是1，反之是0
if all(b1==0)==1%如果没有变异的
    delaytime2=[];%延误时间为0
    return           %如果b1数组里都是0，就是说本次迭代没有染色体可以变异，跳回主程序delay
else
    c1=find(b1==1);      %c1是所有变异的染色体的序号，找到b1里为1的值的列号，赋值给c1，通过c1找到需要变异的染色体
end
for i=1:length(c1)     %进行length(c1)的循环遍历
    VZ=not_best_route(c1(i),:) ;     %VZ是要变异的染色体
    e=randi(z1/2);  %从染色体前半段选出一个点
    f=10+randi(z1/2);  %从染色体后半段选出一个点
    B=VZ(e:f);  %截取这段数组赋值给B
    C=fliplr(B);  %fliplr()数组倒序
    VZ(e:f)=C;  %将倒序过来的数组C取代回到原先位置上的数组
    NZ2(i,:)=VZ; %NZ2用来存储所有变异的新染色体
end
a3=size(NZ2,1);% a3变异操作产生的染色体个数
delaytime2=zeros(a3,z1);% delaytime2存储变异染色体的延误时间
for i=1:a3 % i代表染色体
    for j=1:gate+1 % j代表机位
        r=zeros;%
        if j<=100 %停机位号100之内,延误时间正常计算
            r=find(NZ2(i,:)==j);%找到停在同一个机位的航班集合
            if isempty(r) %如果没有航班停靠在停机位上
                continue;%跳过本次停机位的循环
            else %有航班停靠的停机位
                l=length(r);%航班集合长度
                if l==1% 如果只有一个航班停在停机位上，没有延误时间
                    delaytime2(i,r)=0;
                else
                    for x=1:l-1
                        if x==1 %第一个停靠的航班，没有延误时间
                            delaytime2(i,r(x))=0;
                        else % 后面陆续停靠的航班，延误时间，前一个航班的离港时间+安全间隔时间-后一个航班的进港时间
                            delaytime2(i,r(x+1))=RD(r(x),1)+interval-RA(r(x+1),1);
                            if delaytime2(i,r(x+1))<0 %如果小于0说明，后航班进港时，前一个航班已经飞走了，延误时间则是0
                                delaytime2(i,r(x+1))=0;
                            end
                        end
                    end
                end
            end
        else %航班停在101机位，那么航班是取消了，延误时间是480分钟
            r=find(NZ2(i,:)==j);%找到停在同一个机位的航班集合
            delaytime2(i,r)=480;
        end
        
    end
end
