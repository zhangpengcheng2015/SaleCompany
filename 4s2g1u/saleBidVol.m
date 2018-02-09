function [saledealnum,  sbidvol, Abidvol, Bbidvol, Cbidvol] = ...
    saleBidVol( ps1,deltavs1,ps2,deltavs2,ps3,deltavs3,...
    pA1,deltavA1,pA2,deltavA2,pA3,deltavA3,...
    pB1,deltavB1,pB2,deltavB2,pB3,deltavB3,...
    pC1,deltavC1,pC2,deltavC2,pC3,deltavC3,saleprice,...
    nsaleintersection,saleintersection,salequotationcurvetmp,...
    salevolsum,dealpowerUC)
global nsale msale;
% saledealnum:�б���۵繫˾������������ļ���
%sbidvol:�۵繫˾s���б����
%Abidvol:�۵繫˾A���б����
%Bbidvol:�۵繫˾B���б����
%Cbidvol:�۵繫˾C���б����
%salequotationcurvetmp:�۵繫˾�걨���ַ�����ʾ��ʽ
%salevolsum:�۵繫˾�걨����
%dealpowerUC:�����г���ʵ�ʵ���
%saleprice:�۵繫˾���ۼ���
%saleintersection:ʵ�ʵ������۵繫˾�Ľ��������꣬
%����ȷ�����ʱ��ʱ���������۵繫˾�ı���һ��ʱ���б�������䡣

[saleprice,salequotationcurvetmp,salevolsum,...
    salevolcurve,s,A,B,C]=saleData...
    (ps1,ps2,ps3,deltavs1,deltavs2,deltavs3,...
    pA1,pA2,pA3,deltavA1,deltavA2,deltavA3,...
    pB1,pB2,pB3,deltavB1,deltavB2,deltavB3,...
    pC1,pC2,pC3,deltavC1,deltavC2,deltavC3,...
    nsale,msale);
%�����ʵ���õ�����������ȫ���б�
%���ʵ���õ��������С���۵繫˾���뾺��ĵ����������Ͳ�����ڲ����ɱ�
if dealpowerUC <= salevolsum(end)
    [~,nsalevolsum]=size(salevolsum);
    sum = 0;
    for finaltranscationnum = 1:nsalevolsum
        sum = sum +salevolsum(finaltranscationnum+1)-salevolsum(finaltranscationnum);
        if(sum>=dealpowerUC)
            break;
        end
    end
    %finaltranscationnum�����ɽ����۵繫˾������
    % saledealnum:�б���۵繫˾������������ļ���
    saledealnum=[];
    priceequal= find(nsaleintersection == saleprice);%���ص���λ�ü���
    npriceequal = length(priceequal);
    %�����յĵ������ϼ�¼����
    finalsalevol=[];
    %�����յĵ������ϵ��ַ�����ʾ��ʽ��¼����
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
    %-----------------�۵繫˾s,A,B,C���б����--------------------------%
    sbidvol=0;
    Abidvol=0;
    Bbidvol=0;
    Cbidvol=0;
    %----------------------------------------------------------------------------------%
    
    saledealnumodd=saledealnum(1:2:end);%���������б�Ķκ�
    saledealnumeven=saledealnum(2:2:end);%ż����������
    [~,nsaledealnumodd] = size(saledealnumodd);
    [~,nsaledealnumeven] = size(saledealnumeven);
    if nsaledealnumodd~=nsaledealnumeven
        error('��������');
    else
        for  i = 1:nsaledealnumodd
            if ismember(saledealnumodd{i},s)%saledealnum{i}���ַ������ͣ���ͬ
                sbidvol=sbidvol+cell2mat(saledealnumeven(i));%cell2mat(saledealnum(i+1))��double���ͣ���ͬ
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