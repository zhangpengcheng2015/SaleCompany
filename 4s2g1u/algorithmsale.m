function [ ps1_new,ps2_new,ps3_new,deltavs1_new,deltavs2_new,...
    deltavs3_new,sbenefitUC,AbenefitUC,BbenefitUC,CbenefitUC] = ...
    algorithmsale(ps1,ps2,ps3,deltavs1,deltavs2,deltavs3,...
    pA1,pA2,pA3,deltavA1,deltavA2,deltavA3,...
    pB1,pB2,pB3,deltavB1,deltavB2,deltavB3,...
    pC1,pC2,pC3,deltavC1,deltavC2,deltavC3,...
    pga1,pga2,pga3,deltavga1,deltavga2,deltavga3,...
    pgb1,pgb2,pgb3,deltavgb1,deltavgb2,deltavgb3)
%售电公司的个数与报价段数
global nsale msale;
global actualpower;
%-------------------------------------------------------------------------------------------------------------%
%-------------------------------------------------发电商的报价参数---------------------------%
%包括三段价格，三段电量，要求发电商的报价逐步上升，否则报错
global ngen mgen;

global salemaxpower salepriceceiling salepricefloor;
global kindex;
%算法函数，不断修正售电公司s的三段报价和量，获得最大的利益
%ps1,ps2,ps3的初始值为90,70,50
%不断调整ps3
%deltavs1,deltavs2,deltavs3的初始值均为200
salemaxpower=600;%售电公司最大电量MWh
salepriceceiling=100;%售电公司报价上限$/MWh
salepricefloor=30;%售电公司报价下限$/MWh

epsilon = 0.2;%分配系数初始化
phi = 0.2;%遗忘因子

%-------------售电公司s策略报价集合----------%
deltaps3 = [];
step = 1;
for i = salepricefloor : step:ps2
    deltaps3 = [deltaps3,i];
end
[~,mdeltaps3] = size(deltaps3);
%------------------------------------------%
%-------------售电公司A策略报价集合----------%
deltapA3 = [30,40,50];
[~,mdeltapA3] = size(deltapA3);
%-------------售电公司B策略报价集合----------%
deltapB3 = [30,40,50];
[~,mdeltapB3] = size(deltapB3);
%-------------售电公司C策略报价集合----------%
deltapC3 = [30,40,50];
[~,mdeltapC3] = size(deltapC3);
%初始化概率集合pdeltaps3和行为倾向qdeltaps3
pdeltaps3 =[];
qdeltaps3 =[];
%--------倾向系数初始化---------%
initqdeltaps3 = 10000;%初始倾向
for i = 1:mdeltaps3
    qdeltaps3 = [qdeltaps3,initqdeltaps3]; 
end
%--------------------------------------%

%------------------------初始化概率---------------------%
for i = 1:mdeltaps3
     pdeltaps3=[pdeltaps3,qdeltaps3(i)/sum(qdeltaps3)];
end
%--------------------------------------------------------------%
%------随机选择一个策略计算----------%
selps3 = randperm(mdeltaps3,1);
%selps3 = 27;
ps3_new =  deltaps3(selps3);%ps3_new初始化
%--------记录售电公司s的收益集合，价格集合--------%
sbenefitUCplot = [];
ps3_newplot=[ps3];
%--------------------------------------------------------------%


%=========开始迭代==========%  
iteratortimesalgs = 10000;
for iteratoralgs = 1:iteratortimesalgs
    
    %--------------重新更新分配系数---------------------%
    if ismember(iteratoralgs,1:iteratortimesalgs*0.1:iteratortimesalgs)
        epsilon =epsilon-epsilon*0.2;
        if epsilon <=0
            epsilon = 0;
        end
    end
    %--------------重新更新分配系数---------------------%

%--------------售电公司s的报价参数保持不变---------------------%
ps1_new = ps1;
ps2_new = ps2;
deltavs1_new=deltavs1;
deltavs2_new=deltavs2;
deltavs3_new=deltavs3;
%--------------售电公司A,B,C的最后一段报价---------------------%
%    mupA3 = 35;sigmpA3 = 5.5;
%   %规则约束(下同)
%    pA3=normrnd(mupA3,sigmpA3,1,1);
%     while pA3 > pA2 || pA3 < salepricefloor
%             pA3=normrnd(mupA3,sigmpA3,1,1);
%     end
    selpA3 = randperm(mdeltapA3,1);
    pA3 = deltapA3(selpA3);
%    mupB3 = 45;sigmpB3 = 5.5;
%    pB3=normrnd(mupB3,sigmpB3,1,1);
%     while pB3 > pB2 || pB3 < salepricefloor
%           pB3=normrnd(mupB3,sigmpB3,1,1);
%     end
    selpB3 = randperm(mdeltapB3,1);
    pB3 = deltapB3(selpB3);
%    mupC3 = 50;sigmpC3 = 5.5;
%    pC3=normrnd( mupC3 ,sigmpC3,1,1);
%     while pC3 > pC2 || pC3 < salepricefloor
%            pC3=normrnd(mupC3,sigmpC3,1,1);
%    end
    selpC3 = randperm(mdeltapC3,1);
    pC3 = deltapC3(selpC3);
%-------------------------------------------------------------------------------------%
%--------------------------------------重新计算利润------------------------------%
%---------------------更新输入数据----------------------%
[saleprice,salequotationcurvetmp,salevolsum,...
    salevolcurve,s,A,B,C]=saleData...
    (ps1_new,ps2_new,ps3_new,deltavs1_new,deltavs2_new,...
    deltavs3_new,pA1,pA2,pA3,deltavA1,deltavA2,deltavA3,...
    pB1,pB2,pB3,deltavB1,deltavB2,deltavB3,...
    pC1,pC2,pC3,deltavC1,deltavC2,deltavC3,...
    nsale,msale);

[genprice,genquotationcurvetmp,genvolsum,...
        genvolcurve,ga,gb]=genData...
        (pga1,pga2,pga3,deltavga1,deltavga2,deltavga3,...
        pgb1,pgb2,pgb3,deltavgb1,deltavgb2,deltavgb3,ngen,mgen);
%--------计算售电公司利润，需要计算利润函数的参数重新更新---------%

    %售电公司报价曲线的分段函数
    saledatafunc=dataFunc(salevolsum, saleprice);
    %发电商报价曲线的分段函数
    gendatafunc=dataFunc(genvolsum, genprice);
    %市场实际需求电量与售电侧的交点坐标
    saleintersection = saledatafunc(actualpower);
    %市场实际需求电量与发电侧的交点坐标
    genintersection=gendatafunc(actualpower);
    

    [ clearpriceUC,dealpowerUC ] = clearPriceUC(saleprice,...
        salevolsum,saleintersection,genprice,genvolsum,...
        genintersection,actualpower,kindex,false,true);
    
     %更新市场实际需求电量与售电侧的交点坐标
    nsaleintersection = saledatafunc(dealpowerUC);
    %更新市场实际需求电量与发电侧的交点坐标
    ngenintersection=gendatafunc(dealpowerUC);
    
    %===============画图更新报价曲线==========%
 %plotPidVol( iteratoralgs,salevolsum, saleprice,...
    %salequotationcurvetmp,genvolsum,genprice,...
    %genquotationcurvetmp,actualpower,dealpowerUC);
    %================================%
    
    [ sbenefitUC,~,~,~] = saleBenefitUC...
    (ps1_new,deltavs1_new,ps2_new,deltavs2_new,ps3_new,...
    deltavs3_new, pA1,deltavA1,pA2,deltavA2,pA3,deltavA3,...
    pB1,deltavB1,pB2,deltavB2,pB3,deltavB3,...
    pC1,deltavC1,pC2,deltavC2,pC3,deltavC3,saleprice,...
    genprice,saleintersection,nsaleintersection,genintersection,...
    clearpriceUC,actualpower, dealpowerUC,salequotationcurvetmp,...
    salevolsum,salevolcurve,genvolsum,nsale,msale,s,A,B,C,false,false);
    %-------------------------------------------------------------------------------------%
    
%更新选择倾向q
%exp:倾向的修改量
for i = 1:mdeltaps3
    if i ~= selps3
        %倾向的修改量exptmp
        exptmp(i)=sbenefitUC*epsilon/(mdeltaps3-1);
    else
        exptmp(i) = sbenefitUC*(1-epsilon);
    end
    qdeltaps3(i) = (1-phi)*qdeltaps3(i)+exptmp(i);
end

%-------更新选择概率----------%
for i = 1:mdeltaps3
    pdeltaps3(i)=qdeltaps3(i) /sum(qdeltaps3);
end

sbenefitUCplot = [sbenefitUCplot,sbenefitUC];
%------------以新概率pdeltaps3开始从策略集合deltaps3选取元素-----------%
ps3_newtmp=[];
tmp = 1;%取tmp个时刻的报价来影响下一个时刻的报价
for i = 1:tmp
    % 取法
    % 1 产生均匀分布随机数
    ptmp=rand;
    selps3=unidrnd(mdeltaps3);
    % 2 判断是否满足概率
    while(pdeltaps3(selps3) < ptmp)
        ptmp=rand;
        selps3=unidrnd(mdeltaps3);
    end
    % 输出
    ps3_newtmp=[ps3_newtmp,deltaps3(selps3)];
end
ps3_new = ps3_newtmp(1);%更新售电公司s的第三段价格
ps3_newplot=[ps3_newplot,ps3_new];
end

%-------------------售电公司s收益散点图----------------------%
% figure();
% [~,msbenefitUCplot] = size(sbenefitUCplot);
% xsbenefitUCplot = 1:1:msbenefitUCplot;
% plot(xsbenefitUCplot,sbenefitUCplot);
% xlabel('竞价轮次');
% ylabel('售电公司s的收益($)');
% title('售电公司s的收益变化','FontSize',25);
% xmin=0;%x轴的最小值
% xmax=iteratortimesalgs;%x轴的最大值
% xstep=100;%x轴的步长
% ymin=0;%y轴的最小值
% ymax=60000;%y轴的最大值
% ystep=5000;%y轴的步长
% axis([xmin xmax ymin ymax]);
% set(gca,'XTick',xmin:xstep:xmax);
% set(gca,'YTick',ymin:ystep:ymax);
%----------------------------------------------------------%
%-------------------售电公司s报价散点图----------------------%
figure();
[~,mps3_newplot] = size(ps3_newplot);
xps3_newplot= 1:1:mps3_newplot;
scatter(xps3_newplot,ps3_newplot,1,'r');
xlabel('竞价轮次');
ylabel('售电公司s报价($)');
title('售电公司s报价变化','FontSize',25);
xmin=0;%x轴的最小值
xmax=iteratortimesalgs;%x轴的最大值
xstep=iteratortimesalgs/10;%x轴的步长
ymin=0;%y轴的最小值
ymax=90;%y轴的最大值
ystep=5;%y轴的步长
axis([xmin xmax ymin ymax]);
set(gca,'XTick',xmin:xstep:xmax);
set(gca,'YTick',ymin:ystep:ymax);
%----------------------------------------------------------%
%==================================%  


%--------经过若干次迭代之后选出概率最大的位置---------%
maxpospdeltaps3 =  pdeltaps3==max(pdeltaps3);
%-----------------------------------------------------------------------------%
%------------------选定最后时刻的价格-------------------%
ps3_new = deltaps3(maxpospdeltaps3);
ps3_newplot = [ps3_newplot,ps3_new];
%--------------------------------------重新计算利润------------------------------%
%-------重新整理输入数据------%
[saleprice,salequotationcurvetmp,salevolsum,...
    salevolcurve,s,A,B,C]=saleData...
    (ps1_new,ps2_new,ps3_new,deltavs1_new,...
    deltavs2_new,deltavs3_new,pA1,pA2,pA3,...
    deltavA1,deltavA2,deltavA3,pB1,pB2,pB3,...
    deltavB1,deltavB2,deltavB3, pC1,pC2,pC3,...
    deltavC1,deltavC2,deltavC3, nsale,msale);

[genprice,genquotationcurvetmp,genvolsum,...
        genvolcurve,ga,gb]=genData...
        (pga1,pga2,pga3,deltavga1,deltavga2,deltavga3,...
        pgb1,pgb2,pgb3,deltavgb1,deltavgb2,deltavgb3,ngen,mgen);

%--------计算售电公司利润，需要计算利润函数的参数重新更新---------%

    %售电公司报价曲线的分段函数
    saledatafunc=dataFunc(salevolsum, saleprice);
    %发电商报价曲线的分段函数
    gendatafunc=dataFunc(genvolsum, genprice);
    %市场实际需求电量与售电侧的交点坐标
    saleintersection = saledatafunc(actualpower);
    %市场实际需求电量与发电侧的交点坐标
    genintersection=gendatafunc(actualpower);

    [ clearpriceUC,dealpowerUC ] = clearPriceUC( saleprice,salevolsum,...
        saleintersection,genprice,genvolsum,genintersection,...
        actualpower,kindex,false,true);
    
     %更新市场实际需求电量与售电侧的交点坐标
    nsaleintersection = saledatafunc(dealpowerUC);
    %更新市场实际需求电量与发电侧的交点坐标
    ngenintersection=gendatafunc(dealpowerUC);
    
    [ sbenefitUC,AbenefitUC,BbenefitUC,CbenefitUC] = saleBenefitUC...
    (ps1_new,deltavs1_new,ps2_new,deltavs2_new,ps3_new,deltavs3_new,...
    pA1,deltavA1,pA2,deltavA2,pA3,deltavA3,...
    pB1,deltavB1,pB2,deltavB2,pB3,deltavB3,...
    pC1,deltavC1,pC2,deltavC2,pC3,deltavC3,...
    saleprice,genprice,saleintersection,nsaleintersection,genintersection,...
    clearpriceUC,actualpower, dealpowerUC,salequotationcurvetmp,...
    salevolsum,salevolcurve,genvolsum,nsale,msale,s,A,B,C,false,false);
    %-------------------------------------------------------------------------------------%
 
% sbenefitUCplot
% ps3_newplot
end

