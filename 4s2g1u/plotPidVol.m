function  plotPidVol( iterator,salevolsum, saleprice,...
    salequotationcurvetmp,genvolsum,genprice,genquotationcurvetmp,...
    actualpower,dealpowerUC)
global nsale msale;
global ngen mgen;
%PLOTPIDVOL 此处显示有关此函数的摘要
%   此处显示详细说明
    figure('Name',strcat('第 ', num2str(iterator),'次更新交易报价曲线'));
    xmin=0;%x轴的最小值
    xmax=3000;%x轴的最大值
    xstep=100;%x轴的步长
    ymin=0;%y轴的最小值
    ymax=120;%y轴的最大值
    ystep=10;%y轴的步长
    axis([xmin xmax ymin ymax]);
    set(gca,'XTick',xmin:xstep:xmax);
    set(gca,'YTick',ymin:ystep:ymax);
    xlabel('电量：(MWh)');
    ylabel('单价：($/MWh)');
    title('售电公司与发电商的报价曲线','FontSize',25);
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

