function [ sbenefitUC,AbenefitUC,BbenefitUC,CbenefitUC] = saleBenefitUC...
    (ps1,deltavs1,ps2,deltavs2,ps3,deltavs3,...
    pA1,deltavA1,pA2,deltavA2,pA3,deltavA3,...
    pB1,deltavB1,pB2,deltavB2,pB3,deltavB3,...
    pC1,deltavC1,pC2,deltavC2,pC3,deltavC3,saleprice,genprice,saleintersection,nsaleintersection,genintersection,...
    clearpriceUC,actualpower, dealpowerUC,salequotationcurvetmp,...
    salevolsum,salevolcurve,genvolsum,nsale,msale,s,A,B,C,showflag1,showflag2)
%һ�־��ۺ�ͳһ���壬�۵繫˾���������
%saleintersection:ʵ�ʵ������۵�౨�۵Ľ�������
%ngenintersection:�����г��ĵ������۵�౨�۵Ľ�������
%saleprice:�۵繫˾���ۼ���
%salebenefit:�۵繫˾������
%clearprice ������
%actualpower:ʵ���г����������
%dealpowerUC:ʵ�ʲ����г��ĵ���
%salequotationcurvetmp:�ŶӺ���۵繫˾���ε��ַ�����ʾ��ʽ
%salevolsum:�źöӺ��۵繫˾����������
%salevolcurve:�źöӺ���۵繫˾�ĵ�������
%nsale:�۵繫˾�ĸ���
%msale:�۵繫˾���۵Ķ���

%�۵繫˾���������:
%   1)benefitfromuser:�򹺵��û��۵�ȡ�õ��۵�����,���۵繫˾���б�����йغ�
%��ͬ����йأ������۵繫˾���û�ǩ��ͬ��ƽ����ͬ���Ϊ�۵����г��۸�����
%   2)deviationcost:���յ��б�������ͬ������ƫ����Թ����û�֧�����⳥����
%�������Ϊ�۵繫˾�ı�����ɵ��û��ò����㹻�ĵ������۵繫˾
%�����û�֧��һ��ƫ���

%   3)elecost:�۵繫˾�Ĺ���ɱ�����������й�
%   4)opercost:�۵繫˾��Ӫ�ɱ������б������һ�����κ�����ϵ

global deltaactualpower;
global salepriceceiling;
global salemaxpower;

%�۵繫˾�������ߵķֶκ���
saledatafunc=dataFunc(salevolsum, saleprice);
%�����̱������ߵķֶκ���
gendatafunc=dataFunc(genvolsum, genprice);
%�г��ɽ��������۵��Ľ�������

%-------------------------------------���۵繫˾���б����-----------------------------------%
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
    error('�б������������');
end

%-------------------------����ƫ��ɱ�--------------------------%
%ƫ�����
beta = 80;%�жϵ��
sdeviationcost = 0;
Adeviationcost = 0;
Bdeviationcost = 0;
Cdeviationcost = 0;
%----------------------�۵繫˾��ƫ��ɱ�-----------------------------%
%����۵繫˾���б��������ʵ�ʵ�������ô������ƫ��ɱ�
if (sbidvol+Abidvol+Bbidvol+Cbidvol ==actualpower)
    sdeviationcost = 0;Adeviationcost = 0;
    Bdeviationcost = 0;Cdeviationcost = 0;
elseif (sbidvol+Abidvol+Bbidvol+Cbidvol <=actualpower)
    %δ�ɽ��ĵ���
    notdealpower = actualpower - dealpowerUC;
    intersectionpos = find (saleintersection == saleprice);%�����λ��
    dealpos = intersectionpos(end);
    while saleintersection<genintersection
        if  dealpos == 0
            error('����ʧ��');
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
    %δ�ɽ��ĵ��������˵�finalnnotsalevolcurve��λ��
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
%�۵繫˾���û���ƽ����ͬ���($/MWh)
%�ݶ�Ϊ�۵繫˾��������
contractprice = salepriceceiling;

%-----------------------�۵繫˾s�ĳɱ�����ģ��-----------------------%
sbenefitfromuser = contractprice*sbidvol; %�۵繫˾s���۵�����(��ͬ)
selecost = clearpriceUC*sbidvol;%�۵繫˾s�Ĺ���ɱ�(��ͬ)
sa = 0.0015;sb=1.3;sc=13.5;%�۵繫˾s��Ӫ�ɱ���������(��ͬ)
sopercost = sa*sbidvol^2+sb*sbidvol+sc;%�۵繫˾s��Ӫ�ɱ�(��ͬ)
sbenefitUC= sbenefitfromuser-selecost-sopercost- sdeviationcost;


%--------------------------------------------------------------------------------------%

%-----------------------�۵繫˾A�ĳɱ�����ģ��-----------------------%
Abenefitfromuser = contractprice*Abidvol;
Aelecost = clearpriceUC*Abidvol;
Aa = 0.0015;Ab=1.3;Ac=13.5;
Aopercost = Aa*Abidvol^2+Ab*Abidvol+Ac;
AbenefitUC= Abenefitfromuser-Aelecost-Aopercost- Adeviationcost;

%--------------------------------------------------------------------------------------%


%-----------------------�۵繫˾B�ĳɱ�����ģ��-----------------------%
Bbenefitfromuser = contractprice*Bbidvol;
Belecost = clearpriceUC*Bbidvol;
Ba = 0.0015;Bb=1.3;Bc=13.5;
Bopercost = Ba*Bbidvol^2+Bb*Bbidvol+Bc;
BbenefitUC= Bbenefitfromuser- Belecost-Bopercost-Bdeviationcost;


%--------------------------------------------------------------------------------------%

%--------------------------�۵繫˾C�ĳɱ�����ģ��--------------------------%
Cbenefitfromuser = contractprice*Cbidvol;
Celecost = clearpriceUC*Cbidvol;
Ca = 0.0015;Cb=1.3;Cc=13.5;
Copercost = Ca*Cbidvol^2+Cb*Cbidvol+Cc;
CbenefitUC= Cbenefitfromuser- Celecost-Copercost-Cdeviationcost;
%--------------------------------------------------------------------------------------%
if showflag1
disp(strcat('ͳһ�����£��۵繫˾s������: ', num2str(sbenefitUC),'$'));
disp(strcat('ͳһ�����£��۵繫˾A������: ', num2str(AbenefitUC),'$'));
disp(strcat('ͳһ������,�۵繫˾B������: ', num2str(BbenefitUC),'$'));
disp(strcat('ͳһ�������۵繫˾C������: ', num2str(CbenefitUC),'$'));
end
if showflag2
disp(strcat('�۵繫˾s���б����: ', num2str(sbidvol),'MWh'));
disp(strcat('�۵繫˾A���б����: ', num2str(Abidvol),'MWh'));
disp(strcat('�۵繫˾B���б����: ', num2str(Bbidvol),'MWh'));
disp(strcat('�۵繫˾C���б����: ', num2str(Cbidvol),'MWh'));
end
%--------------------------------------------------------------------------------------%
end

