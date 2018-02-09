function [gendealnum,  gabidvol, gbbidvol] =...
    genBidVol( genprice,genintersection,ngenintersection,...
    genquotationcurvetmp,genvolsum,pga1,pga2,pga3,...
    deltavga1,deltavga2,deltavga3,pgb1,pgb2,pgb3,deltavgb1,...
    deltavgb2,deltavgb3,dealpowerUC)
% gendealnum:�б�ķ����̶�����������ļ���
%genprice:�����̱��ۼ���
%genintersection/ngenintersection:��������º�Ľ���
%gabidvol:������ga���б����
%gbbidvol:������gb���б����
%genquotationcurvetmp:�������걨���ַ�����ʾ��ʽ
%genvolsum:�������걨����
%dealpowerUC:�����г���ʵ�ʵ���

global ngen mgen;

  [genprice,genquotationcurvetmp,genvolsum,...
    genvolcurve,ga,gb]=genData(pga1,pga2,pga3,deltavga1,deltavga2,deltavga3,...
    pgb1,pgb2,pgb3,deltavgb1,deltavgb2,deltavgb3,ngen,mgen);

%�ֽ׶εķ����������������
if dealpowerUC <= genvolsum(end)
    [~,nsalevolsum]=size(genvolsum);
    sum = 0;
    for finaltranscationnum = 1:nsalevolsum
        sum = sum +genvolsum(finaltranscationnum+1)-genvolsum(finaltranscationnum);
        if(sum>=dealpowerUC)
            break;
        end
    end
    %finaltranscationnum�����ɽ��ķ�����������
    % saledealnum:�б�ķ����̶�����������ļ���
    gendealnum=[];
    priceequal= find(ngenintersection == genprice);%���ص���λ�ü���
    npriceequal = length(priceequal);
    %��λ�ü��ϵĵ�����¼����
    finalgenvol=[];
    %�����յĵ������ϵ��ַ�����ʾ��ʽ��¼����
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
    
    %-------------------���һ���걨�ĵ��������һ�λ���Ҫ����������ȷ��-------------------%
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
    %-----------------������ga,gb���б����--------------------------%
    gabidvol=0;
    gbbidvol=0;
    %----------------------------------------------------------------------------------%
    
    gendealnumodd=gendealnum(1:2:end);%���������б�Ķκ�
    gendealnumeven=gendealnum(2:2:end);%ż�����ǵ���
    [~,ngendealnumodd] = size(gendealnumodd);
    [~,ngendealnumeven] = size(gendealnumeven);
    if ngendealnumodd~=ngendealnumeven
        error('��������');
    else
        for  i = 1:ngendealnumodd
            if ismember(gendealnumodd{i},ga)%saledealnum{i}���ַ������ͣ���ͬ
                gabidvol=gabidvol+cell2mat(gendealnumeven(i));%cell2mat(saledealnum(i+1))��double���ͣ���ͬ
                continue;
            end
            if ismember(gendealnumodd{i},gb)%saledealnum{i}���ַ������ͣ���ͬ
                gbbidvol=gbbidvol+cell2mat(gendealnumeven(i));%cell2mat(saledealnum(i+1))��double���ͣ���ͬ
                continue;
            end
        end
    end
end
end



