function  plotPidVol( iterator,salevolsum, saleprice,...
    salequotationcurvetmp,genvolsum,genprice,genquotationcurvetmp,...
    actualpower,dealpowerUC)
global nsale msale;
global ngen mgen;
%PLOTPIDVOL �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
    figure('Name',strcat('�� ', num2str(iterator),'�θ��½��ױ�������'));
    xmin=0;%x�����Сֵ
    xmax=3000;%x������ֵ
    xstep=100;%x��Ĳ���
    ymin=0;%y�����Сֵ
    ymax=120;%y������ֵ
    ystep=10;%y��Ĳ���
    axis([xmin xmax ymin ymax]);
    set(gca,'XTick',xmin:xstep:xmax);
    set(gca,'YTick',ymin:ystep:ymax);
    xlabel('������(MWh)');
    ylabel('���ۣ�($/MWh)');
    title('�۵繫˾�뷢���̵ı�������','FontSize',25);
    for i = 1:msale*nsale
        g(i)=line([salevolsum(i),salevolsum(i+1)],[saleprice(i),saleprice(i)]);
        set(g(i),'linestyle','-','marker','s','linewidth',2,'color','k');
        text((salevolsum(i)+salevolsum(i+1))/2,saleprice(i),...
            salequotationcurvetmp(i),'FontSize',16,'color','r');
    end
    for i = 1:mgen*ngen
        h(i)=line([genvolsum(i),genvolsum(i+1)],...
            [genprice(i),genprice(i)]);
        set(h(i),'linestyle','-','marker','s','linewidth',2,'color','b');
        text((genvolsum(i)+genvolsum(i+1))/2,...
            genprice(i),genquotationcurvetmp(i),'FontSize',16,'color','r');
    end
    
    actualp = line([actualpower,actualpower],[0,ymax]);
    set(actualp,'linestyle','--','marker','s','linewidth',2,'color','r');
    
    dealpUC = line([dealpowerUC,dealpowerUC],[0,ymax]);
    set(dealpUC,'linestyle','-','marker','o','linewidth',3,'color','r');

end

