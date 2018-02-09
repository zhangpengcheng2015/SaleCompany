function [saleprice,salequotationcurvetmp,salevolsum,...
    salevolcurve,s,A,B,C]=saleData...
    (ps1,ps2,ps3,deltavs1,deltavs2,deltavs3,...
    pA1,pA2,pA3,deltavA1,deltavA2,deltavA3,...
    pB1,pB2,pB3,deltavB1,deltavB2,deltavB3,...
    pC1,pC2,pC3,deltavC1,deltavC2,deltavC3,...
    nsale,msale)
%����4���۵繫˾���ۣ������������������Ŷӷ��źöӹ���4���۵�ı�������
%�ļ��۵繫˾�ֱ���s, A,B,C��ʾ
%ÿ���۵繫˾ֻ�ܱ����μ۸�
%ÿ���۵繫˾����������Ϊ600MW
%�۵繫˾�ļ۸�������Ϊ30$/MWh~100$/MWh

%saleprice:�źöӺ���۵繫˾�ı��ۼ���
%salepricecurve:�۸����߼���
%salequotationcurvetmp:�ŶӺ���۵繫˾���ε��ַ�����ʾ��ʽ
%salevolSum:�źöӺ��۵繫˾����������
%nsale:�۵繫˾�ĸ���
%msale:�۵繫˾���۵Ķ���
%s,A,B,C:ÿ���۵繫˾���ֵ伯�ϣ�������ȡ�б����
%������,�۵繫˾�۸�������
global salemaxpower salepriceceiling salepricefloor;
global shuffersale shuffersalenum;
%�۵繫˾�ĸ����뱨�۶���
%--------------�г�������۵繫˾s��Լ��-----------------------%
s1=[(ps1);(deltavs1)];
s2=[(ps2);(deltavs2)];
s3=[(ps3);(deltavs3)];
%��s����������ȡ�б����
s=['s1','s2','s3'];
if ~(ps1>=ps2 && ps2>=ps3 &&...
        ps1<=salepriceceiling &&ps1>=salepricefloor&&...
        ps2<=salepriceceiling &&ps2>=salepricefloor&&...
        ps3<=salepriceceiling &&ps3>=salepricefloor)
    error('�۵繫˾s�ı��۲������г�Ҫ��')
end
if ~(deltavs1+deltavs2+deltavs3<=salemaxpower)
    error('�۵繫˾s�������걨�������г�Ҫ��');
end


%�۵繫˾A�����α��������
A1=[(pA1);(deltavA1)];
A2=[(pA2);(deltavA2)];
A3=[(pA3);(deltavA3)];
A=['A1','A2','A3'];
%--------------�г�������۵繫˾A��Լ��-----------------------%
if ~(pA1>=pA2 && pA2>=pA3 &&...
        pA1<=salepriceceiling &&pA1>=salepricefloor&&...
        pA2<=salepriceceiling &&pA2>=salepricefloor&&...
        pA3<=salepriceceiling &&pA3>=salepricefloor)
    error('�۵繫˾A�ı��۲������г�Ҫ��');
end
if ~(deltavA1+deltavA2+deltavA3<=salemaxpower)
    error('�۵繫˾A�������걨�������г�Ҫ��');
end


%�۵繫˾B�����α��������
B1=[(pB1);(deltavB1)];
B2=[(pB2);(deltavB2)];
B3=[(pB3);(deltavB3)];
B=['B1','B2','B3'];
%--------------�г�������۵繫˾B��Լ��-----------------------%
if ~(pB1>=pB2 && pB2>=pB3 &&...
        pB1<=salepriceceiling &&pB1>=salepricefloor&&...
        pB2<=salepriceceiling &&pB2>=salepricefloor&&...
        pB3<=salepriceceiling &&pB3>=salepricefloor)
    error('�۵繫˾B�ı��۲������г�Ҫ��')
end
if ~(deltavB1+deltavB2+deltavB3<=salemaxpower)
    error('�۵繫˾B�ĵ����걨�������г�Ҫ��');
end

%�۵繫˾C�����α��������
C1=[(pC1);(deltavC1)];
C2=[(pC2);(deltavC2)];
C3=[(pC3);(deltavC3)];
C=['C1','C2','C3'];
%--------------�г�������۵繫˾C��Լ��-----------------------%
if ~(pC1>=pC2 && pC2>=pC3 &&...
        pC1<=salepriceceiling &&pC1>=salepricefloor&&...
        pC2<=salepriceceiling &&pC2>=salepricefloor&&...
        pC3<=salepriceceiling &&pC3>=salepricefloor)
    error('�۵繫˾C�ı��۲������г�Ҫ��')
end
if ~(deltavC1+deltavC2+deltavC3<=salemaxpower)
    error('�۵繫˾C�ĵ����걨�������г�Ҫ��');
end


%�۵��̵�ۼ���
salepricecurve=[s1(1),s2(1),s3(1),A1(1),A2(1),...
    A3(1),B1(1),B2(1),B3(1),C1(1),C2(1),C3(1)];
%�۵��̵�������
salevolcurve=[s1(2),s2(2),s3(2),A1(2),A2(2),...
    A3(2),B1(2),B2(2),B3(2),C1(2),C2(2),C3(2)];
%pricecurve
salequotationcurvetmp= { 's1','s2','s3','A1','A2','A3' ,'B1','B2','B3','C1','C2','C3'};
salequotationcurve= {s1,s2 ,s3 ,A1 ,A2 ,A3 ,B1 ,B2 ,B3 ,C1 ,C2 ,C3};
%---------------����˳��-------------------%

[~,nsalevolcurve] = size(salevolcurve);
if shuffersale 
    shuffersalenum=randperm(nsalevolcurve);
    shuffersale = false;
end
for i=1:nsalevolcurve
    nsalepricecurve(shuffersalenum(i))=salepricecurve(i);
    nsalevolcurve(shuffersalenum(i))=salevolcurve(i);
    nsalequotationcurvetmp(shuffersalenum(i)) = ...
        salequotationcurvetmp(i);
    nsalequotationcurve(shuffersalenum(i)) = ...
        salequotationcurve(i);
end

%�����Ŷӷ���4���۵繫˾�ı��۹������������
[salequotationcurvetmp, salequotationcurve,salepricecurve,salevolcurve] =...
    saleQueuingMethod(nsalequotationcurvetmp,nsalequotationcurve,...
    nsalepricecurve,nsalevolcurve,msale,nsale);
%����salevol��saleprice������
saleprice = [];
salevol=[];
for i = 1:msale*nsale
    saleprice = [saleprice,salequotationcurve{i}(1)];
    salevol = [salevol,salequotationcurve{i}(2)];
end
salevolsum=[0];
for i = 1:msale*nsale
    salevolsum=[salevolsum, sum(salevol(1:i))];
end
end

