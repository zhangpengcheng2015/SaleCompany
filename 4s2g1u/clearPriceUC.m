function [ clearpriceUC,dealpowerUC ] = clearPriceUC( saleprice,salevolsum,...
    saleintersection,genprice,genvolsum,genintersection,actualpower,kindex,...
    plotflag1,plotflag2 )
%clearpriceUC:ͳһ������
%dealpowerUC:�ܳɽ����ٵ���
%salevolsum/genprice:�źöӺ��۵繫˾/�����̵ĵ�������
%saleprice/genprice:�۵繫˾/����౨�ۼ���
%saleintersection/genintersection:ʵ�ʵ������۵��/����౨�۽���������
%actualpower:ʵ�ʵ���
%kindex:kϵ��
%------������ڱ��۽��㣬��ô�����۾��ڽ����λ��--------%

%�۵繫˾�������ߵķֶκ���
saledatafunc=dataFunc(salevolsum, saleprice);
%�����̱������ߵķֶκ���
gendatafunc=dataFunc(genvolsum, genprice);
%�г��ɽ��������۵��Ľ�������

if saleintersection<genintersection
    if plotflag2
        disp('======================');
        disp('���ڲ��ֵ����޷��ɽ�');
        disp('======================');
    end
    %��������µ����б�ĵ��������Ǳ������߽������࣬
    %�Ҵ�ʱ�����۵繫˾����Ҫ�������û���ƫ��ɱ�
    intersectionpos = find (saleintersection == saleprice);%�����λ��
    dealpos = intersectionpos(end);
    while saleintersection<genintersection 
        if  dealpos == 0
            error('����ʧ��');
        end
        if saledatafunc(salevolsum(dealpos))>=...
                gendatafunc((salevolsum(dealpos)))
            break;
        end
        dealpos = dealpos - 1;
    end
    
    %-----------���ղ����г��ĵ���-----------%
    dealpowerUC = salevolsum(dealpos);
    %-----------------------------------------------------%
    
    saledealintersection = saledatafunc(dealpowerUC);
    %�г��ɽ������뷢���Ľ�������
    gendealintersection=gendatafunc(dealpowerUC);
    %��ʱ�ܳɽ����ֵ��г�������
    clearpriceUC = (saledealintersection+gendealintersection)/kindex;%������
else
    dealpowerUC = actualpower;
    clearpriceUC = (saleintersection+genintersection)/kindex;%������
end
if plotflag1
disp(strcat('�߼�ͳһ������: ', num2str(clearpriceUC),'$/MWh'));
end
end

