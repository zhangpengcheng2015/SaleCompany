function [gendealnum,  gabidvol, gbbidvol] =...
    genBidVol( genprice,genintersection,ngenintersection,...
    genquotationcurvetmp,genvolsum,pga1,pga2,pga3,...
    deltavga1,deltavga2,deltavga3,pgb1,pgb2,pgb3,deltavgb1,...
    deltavgb2,deltavgb3,dealpowerUC)
% gendealnum:中标的发电商段名称与电量的集合
%genprice:发电商报价集合
%genintersection/ngenintersection:交点与更新后的交点
%gabidvol:发电商ga的中标电量
%gbbidvol:发电商gb的中标电量
%genquotationcurvetmp:发电商申报的字符串表示形式
%genvolsum:发电商申报电量
%dealpowerUC:参与市场的实际电量

global ngen mgen;

  [genprice,genquotationcurvetmp,genvolsum,...
    genvolcurve,ga,gb]=genData(pga1,pga2,pga3,deltavga1,deltavga2,deltavga3,...
    pgb1,pgb2,pgb3,deltavgb1,deltavgb2,deltavgb3,ngen,mgen);

%现阶段的发电量大于社会需求
if dealpowerUC <= genvolsum(end)
    [~,nsalevolsum]=size(genvolsum);
    sum = 0;
    for finaltranscationnum = 1:nsalevolsum
        sum = sum +genvolsum(finaltranscationnum+1)-genvolsum(finaltranscationnum);
        if(sum>=dealpowerUC)
            break;
        end
    end
    %finaltranscationnum是最后成交的发电商容量段
    % saledealnum:中标的发电商段名称与电量的集合
    gendealnum=[];
    priceequal= find(ngenintersection == genprice);%返回的是位置集合
    npriceequal = length(priceequal);
    %将位置集合的电量记录下来
    finalgenvol=[];
    %将最终的电量集合的字符串表示形式记录下来
    finalgenquotationcurvetmp=[];
    for i = 1: npriceequal
        finalgenvol = [finalgenvol,genvolcurve(priceequal(i))];
        finalgenquotationcurvetmp = ...
            [finalgenquotationcurvetmp,genquotationcurvetmp(priceequal(i))];
    end
    for i = 1: npriceequal
        finalgenvol = [finalgenvol,genvolcurve(priceequal(i))];
    end
 [minfinalvol,~]=min(finalgenvol);
    
    %-------------------最后一段申报的电量，最后一段还需要经过排序，再确定-------------------%
    finalbidvol = dealpowerUC - genvolsum(priceequal(1));
    for i = 1: priceequal(1)-1
        gendealnum = [gendealnum,...
            [genquotationcurvetmp(i),genvolsum(i+1)-genvolsum(i)]];
    end
    if length(priceequal) == 1
        for i = priceequal(1):priceequal(end)
            gendealnum=[gendealnum,...
                [genquotationcurvetmp(i),dealpowerUC-genvolsum(i)]];
        end
    else
            %--------------------------------------------------------------%
            sumpriceequal = 0;
            for finaltranscationnumtwo = 1 : npriceequal
                sumpriceequal = sumpriceequal + ...
                    finalgenvol(finaltranscationnumtwo);
                if (sumpriceequal>=finalbidvol)
                    break;
                end
            end
            sumgendealnum=0;
            for j = 1 : finaltranscationnumtwo-1
                gendealnum=[gendealnum,...
                    [finalgenquotationcurvetmp(j),finalgenvol(j)]];
                sumgendealnum = sumgendealnum + finalgenvol(j);
            end
            gendealnum=[gendealnum,...
                [finalgenquotationcurvetmp(finaltranscationnumtwo),...
                finalbidvol-sumgendealnum]];
            
            %------------------------------------------------------------------%
        %------------------------------------------------------------------%
    end
    %-----------------发电商ga,gb的中标电量--------------------------%
    gabidvol=0;
    gbbidvol=0;
    %----------------------------------------------------------------------------------%
    
    gendealnumodd=gendealnum(1:2:end);%奇数项是中标的段号
    gendealnumeven=gendealnum(2:2:end);%偶数项是电量
    [~,ngendealnumodd] = size(gendealnumodd);
    [~,ngendealnumeven] = size(gendealnumeven);
    if ngendealnumodd~=ngendealnumeven
        error('数据有误');
    else
        for  i = 1:ngendealnumodd
            if ismember(gendealnumodd{i},ga)%saledealnum{i}是字符串类型，下同
                gabidvol=gabidvol+cell2mat(gendealnumeven(i));%cell2mat(saledealnum(i+1))是double类型，下同
                continue;
            end
            if ismember(gendealnumodd{i},gb)%saledealnum{i}是字符串类型，下同
                gbbidvol=gbbidvol+cell2mat(gendealnumeven(i));%cell2mat(saledealnum(i+1))是double类型，下同
                continue;
            end
        end
    end
end
end



