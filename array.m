c=zeros(500,1);

for i=1:length(b)
    if b(i,1)>300
        c(i)=3;
    elseif  b(i,1)>100&&b(i,1)<=300
        c(i)=2;
    else
        c(i)=1;
    end
end
       
