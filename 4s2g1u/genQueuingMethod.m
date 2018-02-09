function  [quotationcurvetmp, quotationcurve,pricecurve,volcurve] = ...
    queuingMethod(quotationcurvetmp,quotationcurve,pricecurve,volcurve,m,n)
for i = 1:n*m-1
    for j =i+1:n*m
        if pricecurve(i)>pricecurve(j)
            tmp1 = quotationcurvetmp(i);
            quotationcurvetmp(i)=quotationcurvetmp(j);
            quotationcurvetmp(j) = tmp1;
            tmp2 = quotationcurve(i);
            quotationcurve(i)=quotationcurve(j);
            quotationcurve(j) = tmp2;
            tmp3=pricecurve(i);
            pricecurve(i)=pricecurve(j);
            pricecurve(j)=tmp3;
            tmp4=volcurve(i);
            volcurve(i)=volcurve(j);
            volcurve(j)=tmp4;
        end
    end
end

