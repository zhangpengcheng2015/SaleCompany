function datafunc=dataFunc(volsum, price)
%���������۵繫˾�ļ۸��������ķֶκ���
%volsum:����
%price:�۸�
    start = 1; %�������ʼλ��
    %step = 0.1;
    volsumstart = volsum(start:end-1);
    volsumstart = volsumstart+1;%matlab�ľ����Ǵ�1�±꿪ʼ��
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

