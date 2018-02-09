clc
clear
close all %关闭所有图形窗口
timestart=cputime;
global deltaactualpower actualpower;
deltaactualpower = 0.01;
%========成交价格系数，2表示在报价中点成交====%
global kindex;
kindex = 2;
%===============================%

global shuffersale shuffergen;

%----------------------------------------------售电公司的报价参数------------------------------%

%包括最大电量,售电公司价格上下限
global salemaxpower salepriceceiling salepricefloor;
%售电公司的个数与报价段数
global nsale msale;
salemaxpower=600;%售电公司最大电量MWh
salepriceceiling=100;%售电公司报价上限$/MWh
salepricefloor=30;%售电公司报价下限$/MWh

nsale=4;%售电公司的个数
msale=3;%报价的段数

%-------------------------------------------------------------------------------------------------------------%
%-------------------------------------------------发电商的报价参数---------------------------%
global genmaxpower genpriceceiling genpricefloor;
global ngen mgen;

genmaxpower=1500;%发电商最大电量MWh
genpriceceiling=40;%发电商报价上限$/MWh
genpricefloor=30;%发电商报价下限$/MWh

ngen=2;%发电商的个数
mgen=3;%报价段数
%-------------------------------------------------------------------------------------------------------------%
iteratortimesmain = 0;
for iteratormain = 0:iteratortimesmain
    shuffersale = true;%在随机选择排序顺序的时候，将shuffersale置为true
    shuffergen = true;
    %----------------------------------------------------------------------------------------------%
    %由于实验所需，现将所有输入数据放到main函数中，以免在程序运行的
    %过程中输入数据发生变化
    
    %-------------------------------售电公司的价与段---------------------------------%

    %售电公司s的三段报价($/MWh)与电量(MWh)
    ps1=90;deltavs1=275;
    ps2=70;deltavs2=275;
    ps3=50;
    deltavs3=salemaxpower - deltavs1 - deltavs2;

    %售电公司A的三段报价($)与电量(MWh)
    %mupA1 = 95;sigmapA1 = 5.5;
    %pA1=normrnd(mupA1,sigmapA1,1,1);
    %%如果不满足市场规则，重新报价(下同)
    %while pA1 >salepriceceiling || pA1<salepricefloor
            %pA1=normrnd(mupA1,sigmapA1,1,1);
    %end
    pA1 = 90;
    deltavA1=250;
    
    %mupA2 = 65;sigmapA2 = 5.5;
    %pA2=normrnd(mupA2,sigmapA2,1,1);
    %while pA2 >pA1 || pA2<salepricefloor
            %pA2=normrnd(mupA2,sigmapA2,1,1);
    %end
    pA2 = 70;
    deltavA2=100;
    
    %mupA3 = 35;sigmpA3 = 5.5;
    %pA3=normrnd(mupA3,sigmpA3,1,1);
    %while pA3 > pA2 || pA3 < salepricefloor
            %pA3=normrnd(mupA3,sigmpA3,1,1);
    %end
    pA3 = 50;
    deltavA3=250;
    
    %售电公司B的三段报价($)与电量(MWh)
    %mupB1 = 80;sigmpB1 = 5.5;
    %pB1=normrnd(mupB1,sigmpB1,1,1);
    %%如果不满足市场规则，重新报价(下同)
    %while  pB1 >salepriceceiling || pB1<salepricefloor
        %pB1=normrnd(mupB1,sigmpB1,1,1);
    %end
    pB1 = 80;
    deltavB1=100;
    
   %mupB2 = 75;sigmpB2 = 5.5;
   %pB2=normrnd(mupB2,sigmpB2,1,1);
    %while pB2 >pB1 || pB2<salepricefloor
            %pB2=normrnd(mupB2,sigmpB2,1,1);
    %end
    pB2 = 60;
    deltavB2=400;
    
    %mupB3 = 45;sigmpB3 = 5.5;
    %pB3=normrnd(mupB3,sigmpB3,1,1);
    %while pB3 > pB2 || pB3 < salepricefloor
            %pB3=normrnd(mupB3,sigmpB3,1,1);
    %end
    pB3 = 40;
    deltavB3=100;
    
    %售电公司C的三段报价($)与电量(MWh)
    %mupC1 = 90;sigmpC1 = 5.5;
    %pC1=normrnd( mupC1 ,sigmpC1,1,1);
    %%如果不满足市场规则，重新报价(下同)
    %while  pC1 >salepriceceiling || pC1<salepricefloor
            %pC1=normrnd(mupC1,sigmpC1,1,1);
    %end
    pC1 = 90;
    deltavC1=150;
    
    %mupC2 = 70;sigmpC2 = 5.5;
    %pC2=normrnd( mupC2 ,sigmpC2,1,1);
    %while pC2 >pC1 || pC2<salepricefloor
            %pC2=normrnd(mupC2,sigmpC2,1,1);
    %end
    pC2 = 80;
    deltavC2=300;
    
    %mupC3 = 50;sigmpC3 = 5.5;
    %pC3=normrnd( mupC3 ,sigmpC3,1,1);
    %while pC3 > pC2 || pC3 < salepricefloor
            %pC3=normrnd(mupC3,sigmpC3,1,1);
    %end
    pC3 = 53;
    deltavC3=150;
    %--------------------------------------------------------------------------------------------------%
    %-------------------------------发电商的价与段---------------------------------%

    %发电商ga的三段报价($/MWh)与电量(MWh)
    pga1=35;deltavga1=400;
    pga2=35;deltavga2=400;
    pga3=35;deltavga3=700;
    
    %发电商gb的三段报价($/MWh)与电量(MWh)
    pgb1=33;deltavgb1=350;
    pgb2=35;deltavgb2=400;
    pgb3=37;deltavgb3=750;
    %--------------------------------------------------------------------------------------------------%
    
    [saleprice,salequotationcurvetmp,salevolsum,...
        salevolcurve,s,A,B,C]=saleData...
        (ps1,ps2,ps3,deltavs1,deltavs2,deltavs3,...
        pA1,pA2,pA3,deltavA1,deltavA2,deltavA3,...
        pB1,pB2,pB3,deltavB1,deltavB2,deltavB3,...
        pC1,pC2,pC3,deltavC1,deltavC2,deltavC3,...
        nsale,msale);
    
    [genprice,genquotationcurvetmp,genvolsum,...
        genvolcurve,ga,gb]=genData...
        (pga1,pga2,pga3,deltavga1,deltavga2,deltavga3,...
        pgb1,pgb2,pgb3,deltavgb1,deltavgb2,deltavgb3,ngen,mgen);
    
    %市场实际负荷容量(目前简化要求是整数)，以此来确定无约束出清电价
    %随机生成1~salevolsum(end)的整数
    %actualpower=unidrnd(salevolsum(end));
    %actualpower=1500;
    actualpower=2200;
    %actualpower=400;
    disp(strcat('市场实际负荷电量: ', num2str(actualpower),'MWh'));
    
    %售电公司报价曲线的分段函数
    saledatafunc=dataFunc(salevolsum, saleprice);
    %发电商报价曲线的分段函数
    gendatafunc=dataFunc(genvolsum, genprice);
    % plot(saledatafunc);
    % hold on;
    % plot(gendatafunc);
    
    %求交点坐标
    %市场实际需求电量与售电侧的交点坐标
    saleintersection = saledatafunc(actualpower);
    %市场实际需求电量与发电侧的交点坐标
    genintersection=gendatafunc(actualpower);
    %disp(strcat('与售电侧报价曲线的交点纵坐标: ', ...
    %num2str(saleintersection),'$/MWh'));
    %disp(strcat('与发电侧报价曲线的交点纵坐标: ', ...
    %num2str(genintersection),'$/MWh'));
    
    [ clearpriceUC,dealpowerUC ] = clearPriceUC( saleprice,salevolsum,...
        saleintersection,genprice,genvolsum,genintersection,...
        actualpower,kindex,false,true);
    
    %-----------------------------画图-----------------------------%

%     plotPidVol( iteratormain,salevolsum, saleprice,...
%     salequotationcurvetmp,genvolsum,genprice,genquotationcurvetmp,...
%     actualpower,dealpowerUC);

    %===============================%
    
    %更新市场实际需求电量与售电侧的交点坐标
    nsaleintersection = saledatafunc(dealpowerUC);
    %更新市场实际需求电量与发电侧的交点坐标
    ngenintersection=gendatafunc(dealpowerUC);
    
    disp(strcat('参与市场交易中的电量: ', num2str(dealpowerUC),'MWh'));
    disp('=======================================');
    
    
    %clearway=input('\n输入1代表高低匹配出清，输入2代表边际统一出清\n请输入你的数字：');
    clearway = 2;
    if clearway == 1 || 2
        switch clearway
            %------------高低匹配出清，无约束出清电价为售电侧与发电侧报价的平均值-----------------%
            case 1
                %#########################为了显示中标电量#######################%
                [ sbenefitUC,AbenefitUC,BbenefitUC,CbenefitUC] = saleBenefitUC...
                    (ps1,deltavs1,ps2,deltavs2,ps3,deltavs3,...
                    pA1,deltavA1,pA2,deltavA2,pA3,deltavA3,...
                    pB1,deltavB1,pB2,deltavB2,pB3,deltavB3,...
                    pC1,deltavC1,pC2,deltavC2,pC3,deltavC3,...
                    saleprice,genprice,saleintersection,nsaleintersection,genintersection,...
                    clearpriceUC,actualpower,dealpowerUC,salequotationcurvetmp,...
                    salevolsum,salevolcurve,genvolsum,nsale,msale,s,A,B,C,false,true);
                
                [ gabenefitUC,gbbenefitUC ] = genBenefitUC(pga1,pga2,pga3,deltavga1,...
                 deltavga2,deltavga3, pgb1,pgb2,pgb3,deltavgb1,deltavgb2,...
                 deltavgb3,genprice,genintersection,ngenintersection,...
                 genquotationcurvetmp,clearpriceUC,actualpower,...
                 dealpowerUC, genvolsum,false,true);
                %###################################################################%
                %-------高低匹配出清方式下，计算各个售电公司利益----%
                [ sbenefitsumPAB,AbenefitsumPAB,BbenefitsumPAB,...
                    CbenefitsumPAB ] = saleBenefitPAB...
                    ( ps1,deltavs1,ps2,deltavs2,ps3,deltavs3,...
                    pA1,deltavA1,pA2,deltavA2,pA3,deltavA3,...
                    pB1,deltavB1,pB2,deltavB2,pB3,deltavB3,...
                    pC1,deltavC1,pC2,deltavC2,pC3,deltavC3,...
                    dealpowerUC, saledatafunc,...
                    gendatafunc, saleprice,genprice,saleintersection,...
                    genintersection,salequotationcurvetmp,salevolsum,...
                    salevolcurve,genvolsum,nsale,msale,kindex,s,A,B,C);
                
                %-------高低匹配出清方式下，计算各个发电商的利益----%
                [ gabenefitsumPAB,gbbenefitsumPAB] = ...
                    genBenefitPAB( pga1,pga2,pga3,deltavga1,...
                    deltavga2,deltavga3, pgb1,pgb2,pgb3,deltavgb1,deltavgb2,...
                    deltavgb3,dealpowerUC, saledatafunc,...
                    gendatafunc, saleprice,genprice,saleintersection,...
                    genintersection,genquotationcurvetmp,salevolsum,...
                    genvolcurve,genvolsum,ngen,mgen,kindex,ga,gb);
                %-------------------------------------------------------------------------------------------------%
                %-----------------------------------------------------------------------------------------------------%
                
            case 2%统一边际出清，无约束出清电价为最后一组成交的交点
                %#########################为了显示出清电价#######################%
                [ clearpriceUC,dealpowerUC ] = clearPriceUC( saleprice,salevolsum,...
                    saleintersection,genprice,genvolsum,genintersection,...
                    actualpower,kindex,true,true);
                %###################################################################%
                
                %边际统一出清方式下，计算各个售电公司与发电商的收益
                %--------------------------------------通过一个售电公司学习后的售电公司的收益-----------------------------------------%

                %-----------------------------------算法部分-----------------------------%
    
                    [ ps1_new,ps2_new,ps3_new,deltavs1_new,...
                        deltavA2_new,deltavA3_new,sbenefitUC,...
                        AbenefitUC,BbenefitUC,CbenefitUC] = ...
                 algorithmsale(ps1,ps2,ps3,deltavs1,deltavs2,deltavs3,...
                pA1,pA2,pA3,deltavA1,deltavA2,deltavA3,...
                pB1,pB2,pB3,deltavB1,deltavB2,deltavB3,...
                pC1,pC2,pC3,deltavC1,deltavC2,deltavC3,pga1,pga2,pga3,...
                deltavga1,deltavga2,deltavga3,pgb1,pgb2,pgb3,deltavgb1,...
                deltavgb2,deltavgb3);
    

                 %---------------------------------------------------------------------------%
                
                %------------------------------------------------------------------------------------------------------------%
                disp('=======================================');
                %--------------------------------------发电商的收益-----------------------------------------%
                
%                 [ gabenefitUC,gbbenefitUC ] = genBenefitUC(pga1,pga2,pga3,...
%                     deltavga1,deltavga2,deltavga3, pgb1,pgb2,pgb3,...
%                     deltavgb1,deltavgb2,deltavgb3,genprice,...
%                     genintersection,ngenintersection,...
%                     genquotationcurvetmp,clearpriceUC,actualpower,...
%                     dealpowerUC, genvolsum,true,true);
                disp('*****************************************************************');
                %------------------------------------------------------------------------------------------------------------%
        end
    else
        error('输入有误');
    end
end
timeend=cputime-timestart;
disp(['程序运行时间',num2str(timeend),'秒'])
