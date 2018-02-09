function [genprice,genquotationcurvetmp,genvolsum,...
    genvolcurve,ga,gb]=genData(pga1,pga2,pga3,deltavga1,...
    deltavga2,deltavga3, pgb1,pgb2,pgb3,deltavgb1,deltavgb2,...
    deltavgb3,ngen,mgen)
%构造2家发电商的报价，电量段与电量
%利用排队法排好队构造2家发电商的报价曲线
%在供大于求的情况下，2家发电商的发电量之和暂定为3000MWh
%两家发用ga,gb表示
%每个发电商只能报三个价格段
%每个发电商的电量上限均为1500MWh
%发电商的价格上下限为30$/MWh~40$/MWh

%genprice:排好队后的发电商的价格集合
%genquotationcurvetmp:排队后的发电商各段的字符串表示形式
%genvolsum:排好队后发电商的电量集合
%nsale:发电商的个数
%msale:发电商报价的段数

global genmaxpower genpriceceiling genpricefloor;
global shuffergen shuffergennum;

%--------------市场规则对发电商ga的约束-----------------------%
if ~(pga1<=pga2 && pga2<=pga3 &&...
        pga1<=genpriceceiling &&pga1>=genpricefloor&&...
        pga2<=genpriceceiling &&pga2>=genpricefloor&&...
        pga3<=genpriceceiling &&pga3>=genpricefloor)
    error('发电商ga1的报价不满足市场要求')
end
if ~(deltavga1+deltavga2+deltavga3<=genmaxpower)
    error('发电商ga1的容量申报不满足市场要求');
end



%--------------市场规则对发电商gb的约束-----------------------%
if ~(pgb1<=pgb2 && pgb2<=pgb3 &&...
        pgb1<=genpriceceiling &&pgb1>=genpricefloor&&...
        pgb2<=genpriceceiling &&pgb2>=genpricefloor&&...
        pgb3<=genpriceceiling &&pgb3>=genpricefloor)
    error('发电商gb1的报价不满足市场要求')
end
if ~(deltavgb1+deltavgb2+deltavgb3<=genmaxpower)
    error('发电商gb1的容量申报不满足市场要求');
end

%发电厂ga的三段报价和电量
ga1=[(pga1);(deltavga1)];
ga2=[(pga2);(deltavga2)];
ga3=[(pga3);(deltavga3)];
ga=['ga1','ga2','ga3'];
%发电厂gb的三段报价和电量
gb1=[(pgb1);(deltavgb1)];
gb2=[(pgb2);(deltavgb2)];
gb3=[(pgb3);(deltavgb3)];
gb=['gb1','gb2','gb3'];
%发电商电价的集合
genpricecurve=[ga1(1),ga2(1),ga3(1),gb1(1),gb2(1),gb3(1)];
%发电商电量集合
genvolcurve=[ga1(2),ga2(2),ga3(2),gb1(2),gb2(2),gb3(2)];

genquotationcurvetmp={'ga1','ga2','ga3','gb1','gb2','gb3'};
genquotationcurve={ga1,ga2,ga3,gb1,gb2,gb3};


%---------------打乱顺序-------------------%
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

%利用排队法将2个发电商的报价构造出报价曲线
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