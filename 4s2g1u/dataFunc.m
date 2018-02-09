function datafunc=dataFunc(volsum, price)
%发电商与售电公司的价格与容量的分段函数
%volsum:容量
%price:价格
    start = 1; %数组的起始位置
    %step = 0.1;
    volsumstart = volsum(start:end-1);
    volsumstart = volsumstart+1;%matlab的矩阵是从1下标开始的
    volsumend=volsum(start+1:end);
    volsumend = volsumend+1;
    M=length(volsumstart);
    N=length(volsumend);
    datafunc=zeros(1,volsumend(end));
    if (M~=N)
        error('M must has the same length of the N');
    else
       for i =1:M
         if i == M
                datafunc(volsumstart(i):volsumend(i))=price(i);
         else
                datafunc(volsumstart(i):volsumend(i)-1)=price(i);
         end
        end
    end
end

