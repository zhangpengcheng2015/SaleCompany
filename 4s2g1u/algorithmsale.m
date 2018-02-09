function [ ps1_new,ps2_new,ps3_new,deltavs1_new,deltavs2_new,...
    deltavs3_new,sbenefitUC,AbenefitUC,BbenefitUC,CbenefitUC] = ...
    algorithmsale(ps1,ps2,ps3,deltavs1,deltavs2,deltavs3,...
    pA1,pA2,pA3,deltavA1,deltavA2,deltavA3,...
    pB1,pB2,pB3,deltavB1,deltavB2,deltavB3,...
    pC1,pC2,pC3,deltavC1,deltavC2,deltavC3,...
    pga1,pga2,pga3,deltavga1,deltavga2,deltavga3,...
    pgb1,pgb2,pgb3,deltavgb1,deltavgb2,deltavgb3)
%�۵繫˾�ĸ����뱨�۶���
global nsale msale;
global actualpower;
%-------------------------------------------------------------------------------------------------------------%
%-------------------------------------------------�����̵ı��۲���---------------------------%
%�������μ۸����ε�����Ҫ�󷢵��̵ı��������������򱨴�
global ngen mgen;

global salemaxpower salepriceceiling salepricefloor;
global kindex;
%�㷨���������������۵繫˾s�����α��ۺ����������������
%ps1,ps2,ps3�ĳ�ʼֵΪ90,70,50
%���ϵ���ps3
%deltavs1,deltavs2,deltavs3�ĳ�ʼֵ��Ϊ200
salemaxpower=600;%�۵繫˾������MWh
salepriceceiling=100;%�۵繫˾��������$/MWh
salepricefloor=30;%�۵繫˾��������$/MWh

epsilon = 0.2;%����ϵ����ʼ��
phi = 0.2;%��������

%-------------�۵繫˾s���Ա��ۼ���----------%
deltaps3 = [];
step = 1;
for i = salepricefloor : step:ps2
    deltaps3 = [deltaps3,i];
end
[~,mdeltaps3] = size(deltaps3);
%------------------------------------------%
%-------------�۵繫˾A���Ա��ۼ���----------%
deltapA3 = [30,40,50];
[~,mdeltapA3] = size(deltapA3);
%-------------�۵繫˾B���Ա��ۼ���----------%
deltapB3 = [30,40,50];
[~,mdeltapB3] = size(deltapB3);
%-------------�۵繫˾C���Ա��ۼ���----------%
deltapC3 = [30,40,50];
[~,mdeltapC3] = size(deltapC3);
%��ʼ�����ʼ���pdeltaps3����Ϊ����qdeltaps3
pdeltaps3 =[];
qdeltaps3 =[];
%--------����ϵ����ʼ��---------%
initqdeltaps3 = 10000;%��ʼ����
for i = 1:mdeltaps3
    qdeltaps3 = [qdeltaps3,initqdeltaps3]; 
end
%--------------------------------------%

%------------------------��ʼ������---------------------%
for i = 1:mdeltaps3
     pdeltaps3=[pdeltaps3,qdeltaps3(i)/sum(qdeltaps3)];
end
%--------------------------------------------------------------%
%------���ѡ��һ�����Լ���----------%
selps3 = randperm(mdeltaps3,1);
%selps3 = 27;
ps3_new =  deltaps3(selps3);%ps3_new��ʼ��
%--------��¼�۵繫˾s�����漯�ϣ��۸񼯺�--------%
sbenefitUCplot = [];
ps3_newplot=[ps3];
%--------------------------------------------------------------%


%=========��ʼ����==========%  
iteratortimesalgs = 10000;
for iteratoralgs = 1:iteratortimesalgs
    
    %--------------���¸��·���ϵ��---------------------%
    if ismember(iteratoralgs,1:iteratortimesalgs*0.1:iteratortimesalgs)
        epsilon =epsilon-epsilon*0.2;
        if epsilon <=0
            epsilon = 0;
        end
    end
    %--------------���¸��·���ϵ��---------------------%

%--------------�۵繫˾s�ı��۲������ֲ���---------------------%
ps1_new = ps1;
ps2_new = ps2;
deltavs1_new=deltavs1;
deltavs2_new=deltavs2;
deltavs3_new=deltavs3;
%--------------�۵繫˾A,B,C�����һ�α���---------------------%
%    mupA3 = 35;sigmpA3 = 5.5;
%   %����Լ��(��ͬ)
%    pA3=normrnd(mupA3,sigmpA3,1,1);
%     while pA3 > pA2 || pA3 < salepricefloor
%             pA3=normrnd(mupA3,sigmpA3,1,1);
%     end
    selpA3 = randperm(mdeltapA3,1);
    pA3 = deltapA3(selpA3);
%    mupB3 = 45;sigmpB3 = 5.5;
%    pB3=normrnd(mupB3,sigmpB3,1,1);
%     while pB3 > pB2 || pB3 < salepricefloor
%           pB3=normrnd(mupB3,sigmpB3,1,1);
%     end
    selpB3 = randperm(mdeltapB3,1);
    pB3 = deltapB3(selpB3);
%    mupC3 = 50;sigmpC3 = 5.5;
%    pC3=normrnd( mupC3 ,sigmpC3,1,1);
%     while pC3 > pC2 || pC3 < salepricefloor
%            pC3=normrnd(mupC3,sigmpC3,1,1);
%    end
    selpC3 = randperm(mdeltapC3,1);
    pC3 = deltapC3(selpC3);
%-------------------------------------------------------------------------------------%
%--------------------------------------���¼�������------------------------------%
%---------------------������������----------------------%
[saleprice,salequotationcurvetmp,salevolsum,...
    salevolcurve,s,A,B,C]=saleData...
    (ps1_new,ps2_new,ps3_new,deltavs1_new,deltavs2_new,...
    deltavs3_new,pA1,pA2,pA3,deltavA1,deltavA2,deltavA3,...
    pB1,pB2,pB3,deltavB1,deltavB2,deltavB3,...
    pC1,pC2,pC3,deltavC1,deltavC2,deltavC3,...
    nsale,msale);

[genprice,genquotationcurvetmp,genvolsum,...
        genvolcurve,ga,gb]=genData...
        (pga1,pga2,pga3,deltavga1,deltavga2,deltavga3,...
        pgb1,pgb2,pgb3,deltavgb1,deltavgb2,deltavgb3,ngen,mgen);
%--------�����۵繫˾������Ҫ�����������Ĳ������¸���---------%

    %�۵繫˾�������ߵķֶκ���
    saledatafunc=dataFunc(salevolsum, saleprice);
    %�����̱������ߵķֶκ���
    gendatafunc=dataFunc(genvolsum, genprice);
    %�г�ʵ������������۵��Ľ�������
    saleintersection = saledatafunc(actualpower);
    %�г�ʵ����������뷢���Ľ�������
    genintersection=gendatafunc(actualpower);
    

    [ clearpriceUC,dealpowerUC ] = clearPriceUC(saleprice,...
        salevolsum,saleintersection,genprice,genvolsum,...
        genintersection,actualpower,kindex,false,true);
    
     %�����г�ʵ������������۵��Ľ�������
    nsaleintersection = saledatafunc(dealpowerUC);
    %�����г�ʵ����������뷢���Ľ�������
    ngenintersection=gendatafunc(dealpowerUC);
    
    %===============��ͼ���±�������==========%
 %plotPidVol( iteratoralgs,salevolsum, saleprice,...
    %salequotationcurvetmp,genvolsum,genprice,...
    %genquotationcurvetmp,actualpower,dealpowerUC);
    %================================%
    
    [ sbenefitUC,~,~,~] = saleBenefitUC...
    (ps1_new,deltavs1_new,ps2_new,deltavs2_new,ps3_new,...
    deltavs3_new, pA1,deltavA1,pA2,deltavA2,pA3,deltavA3,...
    pB1,deltavB1,pB2,deltavB2,pB3,deltavB3,...
    pC1,deltavC1,pC2,deltavC2,pC3,deltavC3,saleprice,...
    genprice,saleintersection,nsaleintersection,genintersection,...
    clearpriceUC,actualpower, dealpowerUC,salequotationcurvetmp,...
    salevolsum,salevolcurve,genvolsum,nsale,msale,s,A,B,C,false,false);
    %-------------------------------------------------------------------------------------%
    
%����ѡ������q
%exp:������޸���
for i = 1:mdeltaps3
    if i ~= selps3
        %������޸���exptmp
        exptmp(i)=sbenefitUC*epsilon/(mdeltaps3-1);
    else
        exptmp(i) = sbenefitUC*(1-epsilon);
    end
    qdeltaps3(i) = (1-phi)*qdeltaps3(i)+exptmp(i);
end

%-------����ѡ�����----------%
for i = 1:mdeltaps3
    pdeltaps3(i)=qdeltaps3(i) /sum(qdeltaps3);
end

sbenefitUCplot = [sbenefitUCplot,sbenefitUC];
%------------���¸���pdeltaps3��ʼ�Ӳ��Լ���deltaps3ѡȡԪ��-----------%
ps3_newtmp=[];
tmp = 1;%ȡtmp��ʱ�̵ı�����Ӱ����һ��ʱ�̵ı���
for i = 1:tmp
    % ȡ��
    % 1 �������ȷֲ������
    ptmp=rand;
    selps3=unidrnd(mdeltaps3);
    % 2 �ж��Ƿ��������
    while(pdeltaps3(selps3) < ptmp)
        ptmp=rand;
        selps3=unidrnd(mdeltaps3);
    end
    % ���
    ps3_newtmp=[ps3_newtmp,deltaps3(selps3)];
end
ps3_new = ps3_newtmp(1);%�����۵繫˾s�ĵ����μ۸�
ps3_newplot=[ps3_newplot,ps3_new];
end

%-------------------�۵繫˾s����ɢ��ͼ----------------------%
% figure();
% [~,msbenefitUCplot] = size(sbenefitUCplot);
% xsbenefitUCplot = 1:1:msbenefitUCplot;
% plot(xsbenefitUCplot,sbenefitUCplot);
% xlabel('�����ִ�');
% ylabel('�۵繫˾s������($)');
% title('�۵繫˾s������仯','FontSize',25);
% xmin=0;%x�����Сֵ
% xmax=iteratortimesalgs;%x������ֵ
% xstep=100;%x��Ĳ���
% ymin=0;%y�����Сֵ
% ymax=60000;%y������ֵ
% ystep=5000;%y��Ĳ���
% axis([xmin xmax ymin ymax]);
% set(gca,'XTick',xmin:xstep:xmax);
% set(gca,'YTick',ymin:ystep:ymax);
%----------------------------------------------------------%
%-------------------�۵繫˾s����ɢ��ͼ----------------------%
figure();
[~,mps3_newplot] = size(ps3_newplot);
xps3_newplot= 1:1:mps3_newplot;
scatter(xps3_newplot,ps3_newplot,1,'r');
xlabel('�����ִ�');
ylabel('�۵繫˾s����($)');
title('�۵繫˾s���۱仯','FontSize',25);
xmin=0;%x�����Сֵ
xmax=iteratortimesalgs;%x������ֵ
xstep=iteratortimesalgs/10;%x��Ĳ���
ymin=0;%y�����Сֵ
ymax=90;%y������ֵ
ystep=5;%y��Ĳ���
axis([xmin xmax ymin ymax]);
set(gca,'XTick',xmin:xstep:xmax);
set(gca,'YTick',ymin:ystep:ymax);
%----------------------------------------------------------%
%==================================%  


%--------�������ɴε���֮��ѡ����������λ��---------%
maxpospdeltaps3 =  pdeltaps3==max(pdeltaps3);
%-----------------------------------------------------------------------------%
%------------------ѡ�����ʱ�̵ļ۸�-------------------%
ps3_new = deltaps3(maxpospdeltaps3);
ps3_newplot = [ps3_newplot,ps3_new];
%--------------------------------------���¼�������------------------------------%
%-------����������������------%
[saleprice,salequotationcurvetmp,salevolsum,...
    salevolcurve,s,A,B,C]=saleData...
    (ps1_new,ps2_new,ps3_new,deltavs1_new,...
    deltavs2_new,deltavs3_new,pA1,pA2,pA3,...
    deltavA1,deltavA2,deltavA3,pB1,pB2,pB3,...
    deltavB1,deltavB2,deltavB3, pC1,pC2,pC3,...
    deltavC1,deltavC2,deltavC3, nsale,msale);

[genprice,genquotationcurvetmp,genvolsum,...
        genvolcurve,ga,gb]=genData...
        (pga1,pga2,pga3,deltavga1,deltavga2,deltavga3,...
        pgb1,pgb2,pgb3,deltavgb1,deltavgb2,deltavgb3,ngen,mgen);

%--------�����۵繫˾������Ҫ�����������Ĳ������¸���---------%

    %�۵繫˾�������ߵķֶκ���
    saledatafunc=dataFunc(salevolsum, saleprice);
    %�����̱������ߵķֶκ���
    gendatafunc=dataFunc(genvolsum, genprice);
    %�г�ʵ������������۵��Ľ�������
    saleintersection = saledatafunc(actualpower);
    %�г�ʵ����������뷢���Ľ�������
    genintersection=gendatafunc(actualpower);

    [ clearpriceUC,dealpowerUC ] = clearPriceUC( saleprice,salevolsum,...
        saleintersection,genprice,genvolsum,genintersection,...
        actualpower,kindex,false,true);
    
     %�����г�ʵ������������۵��Ľ�������
    nsaleintersection = saledatafunc(dealpowerUC);
    %�����г�ʵ����������뷢���Ľ�������
    ngenintersection=gendatafunc(dealpowerUC);
    
    [ sbenefitUC,AbenefitUC,BbenefitUC,CbenefitUC] = saleBenefitUC...
    (ps1_new,deltavs1_new,ps2_new,deltavs2_new,ps3_new,deltavs3_new,...
    pA1,deltavA1,pA2,deltavA2,pA3,deltavA3,...
    pB1,deltavB1,pB2,deltavB2,pB3,deltavB3,...
    pC1,deltavC1,pC2,deltavC2,pC3,deltavC3,...
    saleprice,genprice,saleintersection,nsaleintersection,genintersection,...
    clearpriceUC,actualpower, dealpowerUC,salequotationcurvetmp,...
    salevolsum,salevolcurve,genvolsum,nsale,msale,s,A,B,C,false,false);
    %-------------------------------------------------------------------------------------%
 
% sbenefitUCplot
% ps3_newplot
end

