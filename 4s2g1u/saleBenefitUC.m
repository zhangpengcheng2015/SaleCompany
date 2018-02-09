function [ sbenefitUC,AbenefitUC,BbenefitUC,CbenefitUC] = saleBenefitUC...
    (ps1,deltavs1,ps2,deltavs2,ps3,deltavs3,...
    pA1,deltavA1,pA2,deltavA2,pA3,deltavA3,...
    pB1,deltavB1,pB2,deltavB2,pB3,deltavB3,...
    pC1,deltavC1,pC2,deltavC2,pC3,deltavC3,saleprice,genprice,saleintersection,nsaleintersection,genintersection,...
    clearpriceUC,actualpower, dealpowerUC,salequotationcurvetmp,...
    salevolsum,salevolcurve,genvolsum,nsale,msale,s,A,B,C,showflag1,showflag2)
%一轮竞价后，统一出清，售电公司的收益计算
%saleintersection:实际电量与售电侧报价的交点坐标
%ngenintersection:参与市场的电量与售电侧报价的交点坐标
%saleprice:售电公司报价集合
%salebenefit:售电公司的收益
%clearprice 出清电价
%actualpower:实际市场中需求电量
%dealpowerUC:实际参与市场的电量
%salequotationcurvetmp:排队后的售电公司各段的字符串表示形式
%salevolsum:排好队后售电公司的容量集合
%salevolcurve:排好队后的售电公司的电量集合
%nsale:售电公司的个数
%msale:售电公司报价的段数

%售电公司的收益包括:
%   1)benefitfromuser:向购电用户售电取得的售电收入,与售电公司的中标电量有关和
%合同电价有关，假设售电公司与用户签合同的平均合同电价为售电侧的市场价格上限
%   2)deviationcost:最终的中标电量与合同电量有偏差而对购电用户支付的赔偿费用
%如果是因为售电公司的报价造成的用户用不了足够的电量，售电公司
%需向用户支付一定偏差补偿

%   3)elecost:售电公司的购电成本，与出清电价有关
%   4)opercost:售电公司运营成本，与中标电量是一个二次函数关系

global deltaactualpower;
global salepriceceiling;
global salemaxpower;

%售电公司报价曲线的分段函数
saledatafunc=dataFunc(salevolsum, saleprice);
%发电商报价曲线的分段函数
gendatafunc=dataFunc(genvolsum, genprice);
%市场成交电量与售电侧的交点坐标

%-------------------------------------各售电公司的中标电量-----------------------------------%
[saledealnum,  sbidvol, Abidvol, Bbidvol, Cbidvol] = ...
    saleBidVol( ps1,deltavs1,ps2,deltavs2,ps3,deltavs3,...
    pA1,deltavA1,pA2,deltavA2,pA3,deltavA3,...
    pB1,deltavB1,pB2,deltavB2,pB3,deltavB3,...
    pC1,deltavC1,pC2,deltavC2,pC3,deltavC3,saleprice,...
    nsaleintersection,saleintersection,salequotationcurvetmp,...
    salevolsum,dealpowerUC);


if ~(sbidvol+Abidvol+Bbidvol+Cbidvol <= ...
        dealpowerUC +deltaactualpower...
        && sbidvol+Abidvol+Bbidvol+Cbidvol ...
        >=dealpowerUC-deltaactualpower...
        && sbidvol>=0 && sbidvol<=salemaxpower && Abidvol>=0 ...
        && Bbidvol<=salemaxpower &&  Cbidvol>=0 &&  ...
        Cbidvol<=salemaxpower)
    error('中标电量数据有误');
end

%-------------------------计算偏差成本--------------------------%
%偏差电量
beta = 80;%中断电价
sdeviationcost = 0;
Adeviationcost = 0;
Bdeviationcost = 0;
Cdeviationcost = 0;
%----------------------售电公司的偏差成本-----------------------------%
%如果售电公司的中标电量满足实际电量，那么不存在偏差成本
if (sbidvol+Abidvol+Bbidvol+Cbidvol ==actualpower)
    sdeviationcost = 0;Adeviationcost = 0;
    Bdeviationcost = 0;Cdeviationcost = 0;
elseif (sbidvol+Abidvol+Bbidvol+Cbidvol <=actualpower)
    %未成交的电量
    notdealpower = actualpower - dealpowerUC;
    intersectionpos = find (saleintersection == saleprice);%交点的位置
    dealpos = intersectionpos(end);
    while saleintersection<genintersection
        if  dealpos == 0
            error('交易失败');
        end
        if saledatafunc(salevolsum(dealpos))...
                >= gendatafunc((salevolsum(dealpos)))
            break;
        end
        dealpos = dealpos - 1;
    end
    notsalequotationcurvetmp = salequotationcurvetmp(dealpos:end);
    notsalevolcurve = salevolcurve(dealpos:end);
    
    [~,nnotsalequotationcurvetmp] = size(notsalequotationcurvetmp);
    notsalevolsum = 0;
    %未成交的电量划在了第finalnnotsalevolcurve的位置
    finalnnotsalevolcurve = 0;
    for finalnnotsalevolcurve = 1 : nnotsalequotationcurvetmp
        notsalevolsum =notsalevolsum+notsalevolcurve(finalnnotsalevolcurve);
        if notsalevolsum>notdealpower
            break;
        end
    end
    notsalevolcurve = notsalevolcurve(1:finalnnotsalevolcurve);
    notsalevolcurve(finalnnotsalevolcurve) = notdealpower-...
        sum(notsalevolcurve(1:finalnnotsalevolcurve-1));
    
    for nfinalnnotsalevolcurve = 1:finalnnotsalevolcurve
        if ismember(notsalequotationcurvetmp{nfinalnnotsalevolcurve},s)
            sdeviationcost = sdeviationcost+...
                beta*notsalevolcurve(nfinalnnotsalevolcurve);
            continue;
        end
        if ismember(notsalequotationcurvetmp{nfinalnnotsalevolcurve},A)
            Adeviationcost = Adeviationcost+...
                beta*notsalevolcurve(nfinalnnotsalevolcurve);
            continue;
        end
        if ismember(notsalequotationcurvetmp{nfinalnnotsalevolcurve},B)
            Bdeviationcost = Bdeviationcost+...
                beta*notsalevolcurve(nfinalnnotsalevolcurve);
            continue;
        end
        if ismember(notsalequotationcurvetmp{nfinalnnotsalevolcurve},C)
            Cdeviationcost = Cdeviationcost+...
                beta*notsalevolcurve(nfinalnnotsalevolcurve);
            continue;
        end
    end
end
%-----------------------------------------------------------------------------------------------%
%售电公司与用户的平均合同电价($/MWh)
%暂定为售电公司报价上限
contractprice = salepriceceiling;

%-----------------------售电公司s的成本收益模型-----------------------%
sbenefitfromuser = contractprice*sbidvol; %售电公司s的售电收入(下同)
selecost = clearpriceUC*sbidvol;%售电公司s的购电成本(下同)
sa = 0.0015;sb=1.3;sc=13.5;%售电公司s运营成本三个参数(下同)
sopercost = sa*sbidvol^2+sb*sbidvol+sc;%售电公司s运营成本(下同)
sbenefitUC= sbenefitfromuser-selecost-sopercost- sdeviationcost;


%--------------------------------------------------------------------------------------%

%-----------------------售电公司A的成本收益模型-----------------------%
Abenefitfromuser = contractprice*Abidvol;
Aelecost = clearpriceUC*Abidvol;
Aa = 0.0015;Ab=1.3;Ac=13.5;
Aopercost = Aa*Abidvol^2+Ab*Abidvol+Ac;
AbenefitUC= Abenefitfromuser-Aelecost-Aopercost- Adeviationcost;

%--------------------------------------------------------------------------------------%


%-----------------------售电公司B的成本收益模型-----------------------%
Bbenefitfromuser = contractprice*Bbidvol;
Belecost = clearpriceUC*Bbidvol;
Ba = 0.0015;Bb=1.3;Bc=13.5;
Bopercost = Ba*Bbidvol^2+Bb*Bbidvol+Bc;
BbenefitUC= Bbenefitfromuser- Belecost-Bopercost-Bdeviationcost;


%--------------------------------------------------------------------------------------%

%--------------------------售电公司C的成本收益模型--------------------------%
Cbenefitfromuser = contractprice*Cbidvol;
Celecost = clearpriceUC*Cbidvol;
Ca = 0.0015;Cb=1.3;Cc=13.5;
Copercost = Ca*Cbidvol^2+Cb*Cbidvol+Cc;
CbenefitUC= Cbenefitfromuser- Celecost-Copercost-Cdeviationcost;
%--------------------------------------------------------------------------------------%
if showflag1
disp(strcat('统一出清下，售电公司s的收益: ', num2str(sbenefitUC),'$'));
disp(strcat('统一出清下，售电公司A的收益: ', num2str(AbenefitUC),'$'));
disp(strcat('统一出清下,售电公司B的收益: ', num2str(BbenefitUC),'$'));
disp(strcat('统一出清下售电公司C的收益: ', num2str(CbenefitUC),'$'));
end
if showflag2
disp(strcat('售电公司s的中标电量: ', num2str(sbidvol),'MWh'));
disp(strcat('售电公司A的中标电量: ', num2str(Abidvol),'MWh'));
disp(strcat('售电公司B的中标电量: ', num2str(Bbidvol),'MWh'));
disp(strcat('售电公司C的中标电量: ', num2str(Cbidvol),'MWh'));
end
%--------------------------------------------------------------------------------------%
end

