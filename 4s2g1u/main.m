clc
clear
close all %�ر�����ͼ�δ���
timestart=cputime;
global deltaactualpower actualpower;
deltaactualpower = 0.01;
%========�ɽ��۸�ϵ����2��ʾ�ڱ����е�ɽ�====%
global kindex;
kindex = 2;
%===============================%

global shuffersale shuffergen;

%----------------------------------------------�۵繫˾�ı��۲���------------------------------%

%����������,�۵繫˾�۸�������
global salemaxpower salepriceceiling salepricefloor;
%�۵繫˾�ĸ����뱨�۶���
global nsale msale;
salemaxpower=600;%�۵繫˾������MWh
salepriceceiling=100;%�۵繫˾��������$/MWh
salepricefloor=30;%�۵繫˾��������$/MWh

nsale=4;%�۵繫˾�ĸ���
msale=3;%���۵Ķ���

%-------------------------------------------------------------------------------------------------------------%
%-------------------------------------------------�����̵ı��۲���---------------------------%
global genmaxpower genpriceceiling genpricefloor;
global ngen mgen;

genmaxpower=1500;%������������MWh
genpriceceiling=40;%�����̱�������$/MWh
genpricefloor=30;%�����̱�������$/MWh

ngen=2;%�����̵ĸ���
mgen=3;%���۶���
%-------------------------------------------------------------------------------------------------------------%
iteratortimesmain = 0;
for iteratormain = 0:iteratortimesmain
    shuffersale = true;%�����ѡ������˳���ʱ�򣬽�shuffersale��Ϊtrue
    shuffergen = true;
    %----------------------------------------------------------------------------------------------%
    %����ʵ�����裬�ֽ������������ݷŵ�main�����У������ڳ������е�
    %�������������ݷ����仯
    
    %-------------------------------�۵繫˾�ļ����---------------------------------%

    %�۵繫˾s�����α���($/MWh)�����(MWh)
    ps1=90;deltavs1=275;
    ps2=70;deltavs2=275;
    ps3=50;
    deltavs3=salemaxpower - deltavs1 - deltavs2;

    %�۵繫˾A�����α���($)�����(MWh)
    %mupA1 = 95;sigmapA1 = 5.5;
    %pA1=normrnd(mupA1,sigmapA1,1,1);
    %%����������г��������±���(��ͬ)
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
    
    %�۵繫˾B�����α���($)�����(MWh)
    %mupB1 = 80;sigmpB1 = 5.5;
    %pB1=normrnd(mupB1,sigmpB1,1,1);
    %%����������г��������±���(��ͬ)
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
    
    %�۵繫˾C�����α���($)�����(MWh)
    %mupC1 = 90;sigmpC1 = 5.5;
    %pC1=normrnd( mupC1 ,sigmpC1,1,1);
    %%����������г��������±���(��ͬ)
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
    %-------------------------------�����̵ļ����---------------------------------%

    %������ga�����α���($/MWh)�����(MWh)
    pga1=35;deltavga1=400;
    pga2=35;deltavga2=400;
    pga3=35;deltavga3=700;
    
    %������gb�����α���($/MWh)�����(MWh)
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
    
    %�г�ʵ�ʸ�������(Ŀǰ��Ҫ��������)���Դ���ȷ����Լ��������
    %�������1~salevolsum(end)������
    %actualpower=unidrnd(salevolsum(end));
    %actualpower=1500;
    actualpower=2200;
    %actualpower=400;
    disp(strcat('�г�ʵ�ʸ��ɵ���: ', num2str(actualpower),'MWh'));
    
    %�۵繫˾�������ߵķֶκ���
    saledatafunc=dataFunc(salevolsum, saleprice);
    %�����̱������ߵķֶκ���
    gendatafunc=dataFunc(genvolsum, genprice);
    % plot(saledatafunc);
    % hold on;
    % plot(gendatafunc);
    
    %�󽻵�����
    %�г�ʵ������������۵��Ľ�������
    saleintersection = saledatafunc(actualpower);
    %�г�ʵ����������뷢���Ľ�������
    genintersection=gendatafunc(actualpower);
    %disp(strcat('���۵�౨�����ߵĽ���������: ', ...
    %num2str(saleintersection),'$/MWh'));
    %disp(strcat('�뷢��౨�����ߵĽ���������: ', ...
    %num2str(genintersection),'$/MWh'));
    
    [ clearpriceUC,dealpowerUC ] = clearPriceUC( saleprice,salevolsum,...
        saleintersection,genprice,genvolsum,genintersection,...
        actualpower,kindex,false,true);
    
    %-----------------------------��ͼ-----------------------------%

%     plotPidVol( iteratormain,salevolsum, saleprice,...
%     salequotationcurvetmp,genvolsum,genprice,genquotationcurvetmp,...
%     actualpower,dealpowerUC);

    %===============================%
    
    %�����г�ʵ������������۵��Ľ�������
    nsaleintersection = saledatafunc(dealpowerUC);
    %�����г�ʵ����������뷢���Ľ�������
    ngenintersection=gendatafunc(dealpowerUC);
    
    disp(strcat('�����г������еĵ���: ', num2str(dealpowerUC),'MWh'));
    disp('=======================================');
    
    
    %clearway=input('\n����1����ߵ�ƥ����壬����2����߼�ͳһ����\n������������֣�');
    clearway = 2;
    if clearway == 1 || 2
        switch clearway
            %------------�ߵ�ƥ����壬��Լ��������Ϊ�۵���뷢��౨�۵�ƽ��ֵ-----------------%
            case 1
                %#########################Ϊ����ʾ�б����#######################%
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
                %-------�ߵ�ƥ����巽ʽ�£���������۵繫˾����----%
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
                
                %-------�ߵ�ƥ����巽ʽ�£�������������̵�����----%
                [ gabenefitsumPAB,gbbenefitsumPAB] = ...
                    genBenefitPAB( pga1,pga2,pga3,deltavga1,...
                    deltavga2,deltavga3, pgb1,pgb2,pgb3,deltavgb1,deltavgb2,...
                    deltavgb3,dealpowerUC, saledatafunc,...
                    gendatafunc, saleprice,genprice,saleintersection,...
                    genintersection,genquotationcurvetmp,salevolsum,...
                    genvolcurve,genvolsum,ngen,mgen,kindex,ga,gb);
                %-------------------------------------------------------------------------------------------------%
                %-----------------------------------------------------------------------------------------------------%
                
            case 2%ͳһ�߼ʳ��壬��Լ��������Ϊ���һ��ɽ��Ľ���
                %#########################Ϊ����ʾ������#######################%
                [ clearpriceUC,dealpowerUC ] = clearPriceUC( saleprice,salevolsum,...
                    saleintersection,genprice,genvolsum,genintersection,...
                    actualpower,kindex,true,true);
                %###################################################################%
                
                %�߼�ͳһ���巽ʽ�£���������۵繫˾�뷢���̵�����
                %--------------------------------------ͨ��һ���۵繫˾ѧϰ����۵繫˾������-----------------------------------------%

                %-----------------------------------�㷨����-----------------------------%
    
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
                %--------------------------------------�����̵�����-----------------------------------------%
                
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
        error('��������');
    end
end
timeend=cputime-timestart;
disp(['��������ʱ��',num2str(timeend),'��'])
