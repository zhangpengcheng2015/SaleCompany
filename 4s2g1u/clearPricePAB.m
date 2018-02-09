function [uniclearpricePAB,powersumPAB] = clearPricePAB...
    (dealpowerUC, saledatafunc, gendatafunc,plotflag)
%高低匹配
%uniclearpricePAB:高低匹配电价集合
%powersumPAB:不同电价下的中标电量
%dealpowerUC:实际参与市场的电量

global kindex;

gendatafuncPAB = gendatafunc(1:dealpowerUC);

saledatafuncPAB = saledatafunc(1:dealpowerUC);

clearpricePAB = ((saledatafuncPAB+gendatafuncPAB)/kindex);

uniclearpricePAB = unique_unsorted(clearpricePAB);
[~,nuniclearpricePAB] = size(uniclearpricePAB);
power = zeros(1,nuniclearpricePAB);
for i = 1:nuniclearpricePAB
    power(i) = length(find(clearpricePAB == uniclearpricePAB(i)));
end
powersumPAB = [0];
for i = 1:nuniclearpricePAB
    powersumPAB=[powersumPAB, sum(power(1:i))];
end
for i = 1:nuniclearpricePAB
    h(i)=line([powersumPAB(i),powersumPAB(i+1)],...
        [uniclearpricePAB(i),uniclearpricePAB(i)]);
    set(h(i),'linestyle','-','marker','s','linewidth',2,'color','g');
    text((powersumPAB(i)+powersumPAB(i+1))/2,...
        uniclearpricePAB(i),num2str(uniclearpricePAB(i)),...
        'FontSize',16,'color','r');
end
if plotflag
disp('高低匹配出清电价为: ')
for i = 1:nuniclearpricePAB
    disp(strcat(num2str(uniclearpricePAB(i)),'$/MWh'));
end
end
end



