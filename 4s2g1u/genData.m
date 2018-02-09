function [genprice,genquotationcurvetmp,genvolsum,...
    genvolcurve,ga,gb]=genData(pga1,pga2,pga3,deltavga1,...
    deltavga2,deltavga3, pgb1,pgb2,pgb3,deltavgb1,deltavgb2,...
    deltavgb3,ngen,mgen)
%����2�ҷ����̵ı��ۣ������������
%�����Ŷӷ��źöӹ���2�ҷ����̵ı�������
%�ڹ������������£�2�ҷ����̵ķ�����֮���ݶ�Ϊ3000MWh
%���ҷ���ga,gb��ʾ
%ÿ��������ֻ�ܱ������۸��
%ÿ�������̵ĵ������޾�Ϊ1500MWh
%�����̵ļ۸�������Ϊ30$/MWh~40$/MWh

%genprice:�źöӺ�ķ����̵ļ۸񼯺�
%genquotationcurvetmp:�ŶӺ�ķ����̸��ε��ַ�����ʾ��ʽ
%genvolsum:�źöӺ󷢵��̵ĵ�������
%nsale:�����̵ĸ���
%msale:�����̱��۵Ķ���

global genmaxpower genpriceceiling genpricefloor;
global shuffergen shuffergennum;

%--------------�г�����Է�����ga��Լ��-----------------------%
if ~(pga1<=pga2 && pga2<=pga3 &&...
        pga1<=genpriceceiling &&pga1>=genpricefloor&&...
        pga2<=genpriceceiling &&pga2>=genpricefloor&&...
        pga3<=genpriceceiling &&pga3>=genpricefloor)
    error('������ga1�ı��۲������г�Ҫ��')
end
if ~(deltavga1+deltavga2+deltavga3<=genmaxpower)
    error('������ga1�������걨�������г�Ҫ��');
end



%--------------�г�����Է�����gb��Լ��-----------------------%
if ~(pgb1<=pgb2 && pgb2<=pgb3 &&...
        pgb1<=genpriceceiling &&pgb1>=genpricefloor&&...
        pgb2<=genpriceceiling &&pgb2>=genpricefloor&&...
        pgb3<=genpriceceiling &&pgb3>=genpricefloor)
    error('������gb1�ı��۲������г�Ҫ��')
end
if ~(deltavgb1+deltavgb2+deltavgb3<=genmaxpower)
    error('������gb1�������걨�������г�Ҫ��');
end

%���糧ga�����α��ۺ͵���
ga1=[(pga1);(deltavga1)];
ga2=[(pga2);(deltavga2)];
ga3=[(pga3);(deltavga3)];
ga=['ga1','ga2','ga3'];
%���糧gb�����α��ۺ͵���
gb1=[(pgb1);(deltavgb1)];
gb2=[(pgb2);(deltavgb2)];
gb3=[(pgb3);(deltavgb3)];
gb=['gb1','gb2','gb3'];
%�����̵�۵ļ���
genpricecurve=[ga1(1),ga2(1),ga3(1),gb1(1),gb2(1),gb3(1)];
%�����̵�������
genvolcurve=[ga1(2),ga2(2),ga3(2),gb1(2),gb2(2),gb3(2)];

genquotationcurvetmp={'ga1','ga2','ga3','gb1','gb2','gb3'};
genquotationcurve={ga1,ga2,ga3,gb1,gb2,gb3};


%---------------����˳��-------------------%
[~,ngenvolcurve] = size(genvolcurve);
if shuffergen
    shuffergennum=randperm(ngenvolcurve);
    shuffergen = false;
end

for i=1:ngenvolcurve
    ngenpricecurve(shuffergennum(i))=genpricecurve(i);
    ngenvolcurve(shuffergennum(i))=genvolcurve(i);
    ngenquotationcurvetmp(shuffergennum(i)) = ...
        genquotationcurvetmp(i);
    ngenquotationcurve(shuffergennum(i)) = ...
        genquotationcurve(i);

end
%-----------------------------------------------------------%

%�����Ŷӷ���2�������̵ı��۹������������
[genquotationcurvetmp,genquotationcurve,...
    genpricecurve,genvolcurve] = genQueuingMethod...
    ( ngenquotationcurvetmp,ngenquotationcurve,ngenpricecurve,...
    ngenvolcurve,mgen,ngen);
%genquotationcurvetmp

genprice = [];
genvol=[];
for i = 1:mgen*ngen
    genprice = [genprice,genquotationcurve{i}(1)];
    genvol = [genvol,genquotationcurve{i}(2)];
end
genvolsum=[0];
for i = 1:mgen*ngen
    genvolsum=[genvolsum, sum(genvol(1:i))];
end
end