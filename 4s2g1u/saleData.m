function [saleprice,salequotationcurvetmp,salevolsum,...
    salevolcurve,s,A,B,C]=saleData...
    (ps1,ps2,ps3,deltavs1,deltavs2,deltavs3,...
    pA1,pA2,pA3,deltavA1,deltavA2,deltavA3,...
    pB1,pB2,pB3,deltavB1,deltavB2,deltavB3,...
    pC1,pC2,pC3,deltavC1,deltavC2,deltavC3,...
    nsale,msale)
%构造4家售电公司报价，容量段与量，利用排队法排好队构造4家售电的报价曲线
%四家售电公司分别用s, A,B,C表示
%每个售电公司只能报三段价格
%每个售电公司的容量上限为600MW
%售电公司的价格上下限为30$/MWh~100$/MWh

%saleprice:排好队后的售电公司的报价集合
%salepricecurve:价格曲线集合
%salequotationcurvetmp:排队后的售电公司各段的字符串表示形式
%salevolSum:排好队后售电公司的容量集合
%nsale:售电公司的个数
%msale:售电公司报价的段数
%s,A,B,C:每个售电公司的字典集合，用来提取中标电量
%最大电量,售电公司价格上下限
global salemaxpower salepriceceiling salepricefloor;
global shuffersale shuffersalenum;
%售电公司的个数与报价段数
%--------------市场规则对售电公司s的约束-----------------------%
s1=[(ps1);(deltavs1)];
s2=[(ps2);(deltavs2)];
s3=[(ps3);(deltavs3)];
%将s返回用来提取中标电量
s=['s1','s2','s3'];
if ~(ps1>=ps2 && ps2>=ps3 &&...
        ps1<=salepriceceiling &&ps1>=salepricefloor&&...
        ps2<=salepriceceiling &&ps2>=salepricefloor&&...
        ps3<=salepriceceiling &&ps3>=salepricefloor)
    error('售电公司s的报价不满足市场要求')
end
if ~(deltavs1+deltavs2+deltavs3<=salemaxpower)
    error('售电公司s的容量申报不满足市场要求');
end


%售电公司A的三段报价与电量
A1=[(pA1);(deltavA1)];
A2=[(pA2);(deltavA2)];
A3=[(pA3);(deltavA3)];
A=['A1','A2','A3'];
%--------------市场规则对售电公司A的约束-----------------------%
if ~(pA1>=pA2 && pA2>=pA3 &&...
        pA1<=salepriceceiling &&pA1>=salepricefloor&&...
        pA2<=salepriceceiling &&pA2>=salepricefloor&&...
        pA3<=salepriceceiling &&pA3>=salepricefloor)
    error('售电公司A的报价不满足市场要求');
end
if ~(deltavA1+deltavA2+deltavA3<=salemaxpower)
    error('售电公司A的容量申报不满足市场要求');
end


%售电公司B的三段报价与电量
B1=[(pB1);(deltavB1)];
B2=[(pB2);(deltavB2)];
B3=[(pB3);(deltavB3)];
B=['B1','B2','B3'];
%--------------市场规则对售电公司B的约束-----------------------%
if ~(pB1>=pB2 && pB2>=pB3 &&...
        pB1<=salepriceceiling &&pB1>=salepricefloor&&...
        pB2<=salepriceceiling &&pB2>=salepricefloor&&...
        pB3<=salepriceceiling &&pB3>=salepricefloor)
    error('售电公司B的报价不满足市场要求')
end
if ~(deltavB1+deltavB2+deltavB3<=salemaxpower)
    error('售电公司B的电量申报不满足市场要求');
end

%售电公司C的三段报价与电量
C1=[(pC1);(deltavC1)];
C2=[(pC2);(deltavC2)];
C3=[(pC3);(deltavC3)];
C=['C1','C2','C3'];
%--------------市场规则对售电公司C的约束-----------------------%
if ~(pC1>=pC2 && pC2>=pC3 &&...
        pC1<=salepriceceiling &&pC1>=salepricefloor&&...
        pC2<=salepriceceiling &&pC2>=salepricefloor&&...
        pC3<=salepriceceiling &&pC3>=salepricefloor)
    error('售电公司C的报价不满足市场要求')
end
if ~(deltavC1+deltavC2+deltavC3<=salemaxpower)
    error('售电公司C的电量申报不满足市场要求');
end


%售电商电价集合
salepricecurve=[s1(1),s2(1),s3(1),A1(1),A2(1),...
    A3(1),B1(1),B2(1),B3(1),C1(1),C2(1),C3(1)];
%售电商电量集合
salevolcurve=[s1(2),s2(2),s3(2),A1(2),A2(2),...
    A3(2),B1(2),B2(2),B3(2),C1(2),C2(2),C3(2)];
%pricecurve
salequotationcurvetmp= { 's1','s2','s3','A1','A2','A3' ,'B1','B2','B3','C1','C2','C3'};
salequotationcurve= {s1,s2 ,s3 ,A1 ,A2 ,A3 ,B1 ,B2 ,B3 ,C1 ,C2 ,C3};
%---------------打乱顺序-------------------%

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

%利用排队法将4个售电公司的报价构造出报价曲线
[salequotationcurvetmp, salequotationcurve,salepricecurve,salevolcurve] =...
    saleQueuingMethod(nsalequotationcurvetmp,nsalequotationcurve,...
    nsalepricecurve,nsalevolcurve,msale,nsale);
%构造salevol与saleprice的曲线
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

