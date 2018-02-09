function [ gabenefitUC,gbbenefitUC ] = genBenefitUC...
    (pga1,pga2,pga3,deltavga1,deltavga2,deltavga3, ...
    pgb1,pgb2,pgb3,deltavgb1,deltavgb2,deltavgb3,...
    genprice,genintersection,ngenintersection,...
    genquotationcurvetmp,clearpriceUC,actualpower,...
    dealpowerUC,genvolsum,plotflag1,plotflag2)
%一轮竞价后，发电商的收益计算
%gabenefitUC，gbbenefitUC:统一出清后，发电商ga，gb的成本收益
%genintersection:实际电量与发电侧报价的交点坐标
%ngenintersection:参与市场的电量与发电侧报价的交点坐标
%genprice:发电商报价集合
%clearprice: 出清电价
%actualpower:实际电量
%dealpowerUC:实际参与市场中的电量
%genquotationcurvetmp:排队后的发电商各段的字符串表示形式
%genvolsum:排好队后发电商的电量集合

%发电商的收益包括：
%benefitfromsale:通过出清电价，中标电量的收益
%gencost:发电成本，与中标电量是二次曲线的关系
%-------------------------------------各发电商的中标电量-----------------------------------%
global deltaactualpower;
global genmaxpower;

[gendealnum,  gabidvol, gbbidvol] = ...
    genBidVol( genprice,genintersection,ngenintersection,...
    genquotationcurvetmp,genvolsum,pga1,pga2,pga3,...
    deltavga1,deltavga2,deltavga3,pgb1,pgb2,pgb3,deltavgb1,...
    deltavgb2,deltavgb3,dealpowerUC);

if ~(gabidvol+gbbidvol <= dealpowerUC+deltaactualpower ...
        && gabidvol+gbbidvol >= dealpowerUC-deltaactualpower...
        && gabidvol>=0 && gabidvol<=genmaxpower && gbbidvol>=0 ...
        && gbbidvol<=genmaxpower )
    error('中标电量数据有误');
end

%-------------------------------------发电商ga的成本收益-----------------------------------%
gaa = 0.0039;gab = 34.459;gac = 10;%发电商ga的成本参数
gacost = gaa*gabidvol^2 + gab*gabidvol+gac;
gabenefitfromsale = clearpriceUC*gabidvol;
gabenefitUC = gabenefitfromsale - gacost;


%--------------------------------------------------------------------------------------------%

%-------------------------------------发电商gb的成本收益-----------------------------------%
gba = 0.0039;gbb = 34.459;gbc = 10;%发电商ga的成本参数
gbcost = gba*gbbidvol^2 + gbb*gbbidvol+gbc;
gbbenefitfromsale = clearpriceUC*gbbidvol;
gbbenefitUC = gbbenefitfromsale - gbcost;

if plotflag1
disp(strcat('统一出清下，发电商ga的收益: ', num2str(gabenefitUC),'$'));
disp(strcat('统一出清下，发电商gb的收益: ', num2str(gbbenefitUC),'$'));
end
%--------------------------------------------------------------------------------------------%
if plotflag2
disp(strcat('发电商ga的中标电量: ', num2str(gabidvol),'MWh'));
disp(strcat('发电商gb的中标电量: ', num2str(gbbidvol),'MWh'));
end
end

