a3=length(a2);
delaytime1=zeros(a3,z1);% delaytime1是存储交叉操作后生成的航班排序产生的延误时间
for i=1:a3 % i代表染色体
    for j=1:z1 % j代表机位
        r=zeros(1);%
        if j<=100 %停机位号100之内,延误时间正常计算
            r=find(NZ1(i,:)==j);%找到停在同一个机位的航班集合
            if isempty(r) %如果没有航班停靠在停机位上
                continue;%跳过本次停机位的循环
            else %有航班停靠的停机位
                l=length(r);%航班集合长度
                if l==1% 如果只有一个航班停在停机位上，没有延误时间
                    delaytime1(i,r)=0;
                else
                    for x=1:l-1
                        if x==1 %第一个停靠的航班，没有延误时间
                            delaytime1(i,r(x))=0;
                        else % 后面陆续停靠的航班，延误时间，前一个航班的离港时间+安全间隔时间-后一个航班的进港时间
                            delaytime1(i,r(x+1))=RD(r(x),1)+interval-RA(r(x+1),1);
                            if delaytime1(i,r(x+1))<0 %如果小于0说明，后航班进港时，前一个航班已经飞走了，延误时间则是0
                                delaytime1(i,r(x+1))=0;
                            end
                        end
                    end
                end
            end
        else %航班停在101机位，那么航班是取消了，延误时间是480分钟
            r=find(NZ1(i,:)==j);%找到停在同一个机位的航班集合
            delaytime1(i,r)=480;
        end
        
    end
end