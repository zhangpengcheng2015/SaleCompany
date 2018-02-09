function [ gabenefitUC,gbbenefitUC ] = genBenefitUC...
    (pga1,pga2,pga3,deltavga1,deltavga2,deltavga3, ...
    pgb1,pgb2,pgb3,deltavgb1,deltavgb2,deltavgb3,...
    genprice,genintersection,ngenintersection,...
    genquotationcurvetmp,clearpriceUC,actualpower,...
    dealpowerUC,genvolsum,plotflag1,plotflag2)
%һ�־��ۺ󣬷����̵��������
%gabenefitUC��gbbenefitUC:ͳһ����󣬷�����ga��gb�ĳɱ�����
%genintersection:ʵ�ʵ����뷢��౨�۵Ľ�������
%ngenintersection:�����г��ĵ����뷢��౨�۵Ľ�������
%genprice:�����̱��ۼ���
%clearprice: ������
%actualpower:ʵ�ʵ���
%dealpowerUC:ʵ�ʲ����г��еĵ���
%genquotationcurvetmp:�ŶӺ�ķ����̸��ε��ַ�����ʾ��ʽ
%genvolsum:�źöӺ󷢵��̵ĵ�������

%�����̵����������
%benefitfromsale:ͨ�������ۣ��б����������
%gencost:����ɱ������б�����Ƕ������ߵĹ�ϵ
%-------------------------------------�������̵��б����-----------------------------------%
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
    error('�б������������');
end

%-------------------------------------������ga�ĳɱ�����-----------------------------------%
gaa = 0.0039;gab = 34.459;gac = 10;%������ga�ĳɱ�����
gacost = gaa*gabidvol^2 + gab*gabidvol+gac;
gabenefitfromsale = clearpriceUC*gabidvol;
gabenefitUC = gabenefitfromsale - gacost;


%--------------------------------------------------------------------------------------------%

%-------------------------------------������gb�ĳɱ�����-----------------------------------%
gba = 0.0039;gbb = 34.459;gbc = 10;%������ga�ĳɱ�����
gbcost = gba*gbbidvol^2 + gbb*gbbidvol+gbc;
gbbenefitfromsale = clearpriceUC*gbbidvol;
gbbenefitUC = gbbenefitfromsale - gbcost;

if plotflag1
disp(strcat('ͳһ�����£�������ga������: ', num2str(gabenefitUC),'$'));
disp(strcat('ͳһ�����£�������gb������: ', num2str(gbbenefitUC),'$'));
end
%--------------------------------------------------------------------------------------------%
if plotflag2
disp(strcat('������ga���б����: ', num2str(gabidvol),'MWh'));
disp(strcat('������gb���б����: ', num2str(gbbidvol),'MWh'));
end
end

