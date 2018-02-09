function [ clearpriceUC,dealpowerUC ] = clearPriceUC( saleprice,salevolsum,...
    saleintersection,genprice,genvolsum,genintersection,actualpower,kindex,...
    plotflag1,plotflag2 )
%clearpriceUC:统一出清电价
%dealpowerUC:能成交多少电量
%salevolsum/genprice:排好队后售电公司/发电商的电量集合
%saleprice/genprice:售电公司/发电侧报价集合
%saleintersection/genintersection:实际电量与售电侧/发电侧报价交点纵坐标
%actualpower:实际电量
%kindex:k系数
%------如果存在报价交点，那么出清电价就在交点的位置--------%

%售电公司报价曲线的分段函数
saledatafunc=dataFunc(salevolsum, saleprice);
%发电商报价曲线的分段函数
gendatafunc=dataFunc(genvolsum, genprice);
%市场成交电量与售电侧的交点坐标

if saleintersection<genintersection
    if plotflag2
        disp('======================');
        disp('存在部分电量无法成交');
        disp('======================');
    end
    %这种情况下的能中标的电量仅仅是报价曲线交点的左侧，
    %且此时部分售电公司存在要补偿给用户的偏差成本
    intersectionpos = find (saleintersection == saleprice);%交点的位置
    dealpos = intersectionpos(end);
    while saleintersection<genintersection 
        if  dealpos == 0
            error('交易失败');
        end
        if saledatafunc(salevolsum(dealpos))>=...
                gendatafunc((salevolsum(dealpos)))
            break;
        end
        dealpos = dealpos - 1;
    end
    
    %-----------最终参与市场的电量-----------%
    dealpowerUC = salevolsum(dealpos);
    %-----------------------------------------------------%
    
    saledealintersection = saledatafunc(dealpowerUC);
    %市场成交电量与发电侧的交点坐标
    gendealintersection=gendatafunc(dealpowerUC);
    %此时能成交部分的市场出清电价
    clearpriceUC = (saledealintersection+gendealintersection)/kindex;%出清电价
else
    dealpowerUC = actualpower;
    clearpriceUC = (saleintersection+genintersection)/kindex;%出清电价
end
if plotflag1
disp(strcat('边际统一出清电价: ', num2str(clearpriceUC),'$/MWh'));
end
end

