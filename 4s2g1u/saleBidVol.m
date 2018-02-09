function [saledealnum,  sbidvol, Abidvol, Bbidvol, Cbidvol] = ...
    saleBidVol( ps1,deltavs1,ps2,deltavs2,ps3,deltavs3,...
    pA1,deltavA1,pA2,deltavA2,pA3,deltavA3,...
    pB1,deltavB1,pB2,deltavB2,pB3,deltavB3,...
    pC1,deltavC1,pC2,deltavC2,pC3,deltavC3,saleprice,...
    nsaleintersection,saleintersection,salequotationcurvetmp,...
    salevolsum,dealpowerUC)
global nsale msale;
% saledealnum:中标的售电公司段名称与电量的集合
%sbidvol:售电公司s的中标电量
%Abidvol:售电公司A的中标电量
%Bbidvol:售电公司B的中标电量
%Cbidvol:售电公司C的中标电量
%salequotationcurvetmp:售电公司申报的字符串表示形式
%salevolsum:售电公司申报电量
%dealpowerUC:参与市场的实际电量
%saleprice:售电公司报价集合
%saleintersection:实际电量与售电公司的交点纵坐标，
%用来确定最后时刻时，当存在售电公司的报价一致时，中标电量分配。

[saleprice,salequotationcurvetmp,salevolsum,...
    salevolcurve,s,A,B,C]=saleData...
    (ps1,ps2,ps3,deltavs1,deltavs2,deltavs3,...
    pA1,pA2,pA3,deltavA1,deltavA2,deltavA3,...
    pB1,pB2,pB3,deltavB1,deltavB2,deltavB3,...
    pC1,pC2,pC3,deltavC1,deltavC2,deltavC3,...
    nsale,msale);
%社会中实际用电需求量以左全部中标
%如果实际用电的需求量小于售电公司参与竞标的电量，这样就不会存在补偿成本
if dealpowerUC <= salevolsum(end)
    [~,nsalevolsum]=size(salevolsum);
    sum = 0;
    for finaltranscationnum = 1:nsalevolsum
        sum = sum +salevolsum(finaltranscationnum+1)-salevolsum(finaltranscationnum);
        if(sum>=dealpowerUC)
            break;
        end
    end
    %finaltranscationnum是最后成交的售电公司电量段
    % saledealnum:中标的售电公司段名称与电量的集合
    saledealnum=[];
    priceequal= find(nsaleintersection == saleprice);%返回的是位置集合
    npriceequal = length(priceequal);
    %将最终的电量集合记录下来
    finalsalevol=[];
    %将最终的电量集合的字符串表示形式记录下来
    finalsalequotationcurvetmp=[];
    for i = 1: npriceequal
        finalsalevol = [finalsalevol,salevolcurve(priceequal(i))];
        finalsalequotationcurvetmp = [finalsalequotationcurvetmp,...
            salequotationcurvetmp(priceequal(i))];
    end
    
    finalbidvol = dealpowerUC - salevolsum(priceequal(1));
    for i = 1: priceequal(1)-1
        saledealnum = [saledealnum,[salequotationcurvetmp(i),...
            salevolsum(i+1)-salevolsum(i)]];
    end
    if length(priceequal) == 1
        for i = priceequal(1):priceequal(end)
            saledealnum=[saledealnum,[salequotationcurvetmp(i),...
                dealpowerUC-salevolsum(i)]];
        end
    else   
            sumpriceequal = 0;
            for finaltranscationnumtwo = 1 : npriceequal
                sumpriceequal = sumpriceequal + ...
                    finalsalevol(finaltranscationnumtwo);
                if (sumpriceequal>=finalbidvol)
                    break;
                end
            end
            sumsaledealnum=0;
            for j = 1 : finaltranscationnumtwo-1
                saledealnum=[saledealnum,[finalsalequotationcurvetmp(j),...
                    finalsalevol(j)]];
                sumsaledealnum = sumsaledealnum + finalsalevol(j);
            end
            saledealnum=[saledealnum,...
                [finalsalequotationcurvetmp(finaltranscationnumtwo),...
                finalbidvol-sumsaledealnum]];
            
            %------------------------------------------------------------------%
    end
    %-----------------售电公司s,A,B,C的中标电量--------------------------%
    sbidvol=0;
    Abidvol=0;
    Bbidvol=0;
    Cbidvol=0;
    %----------------------------------------------------------------------------------%
    
    saledealnumodd=saledealnum(1:2:end);%奇数项是中标的段号
    saledealnumeven=saledealnum(2:2:end);%偶数项是容量
    [~,nsaledealnumodd] = size(saledealnumodd);
    [~,nsaledealnumeven] = size(saledealnumeven);
    if nsaledealnumodd~=nsaledealnumeven
        error('数据有误');
    else
        for  i = 1:nsaledealnumodd
            if ismember(saledealnumodd{i},s)%saledealnum{i}是字符串类型，下同
                sbidvol=sbidvol+cell2mat(saledealnumeven(i));%cell2mat(saledealnum(i+1))是double类型，下同
                continue;
            end
            if ismember(saledealnumodd{i},A)
                Abidvol=Abidvol+cell2mat(saledealnumeven(i));
                continue;
            end
            if ismember(saledealnumodd{i},B)
                Bbidvol=Bbidvol+cell2mat(saledealnumeven(i));
                continue;
            end
            if ismember(saledealnumodd{i},C)
                Cbidvol=Cbidvol+cell2mat(saledealnumeven(i));
                continue;
            end
        end
    end
end
end