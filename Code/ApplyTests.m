function  pvalue=ApplyTests(TimeSerie,LbLags,ArchLags,flag)




% Ljung-Box test for Auto Corroletation 
% Arch test for Volatility clustering
% Dicky Fuller test for unit root (test for stationarity)


if flag=="Rates"
[~,n1]=size(TimeSerie.DeltaZrates);

for i=1:n1
   [~,pLB] = lbqtest(TimeSerie.DeltaZrates(:,i),'Lags',LbLags);
   [~, pARCH] = archtest(TimeSerie.DeltaZrates(:,i),'lags',ArchLags);
   [~, pDF] =adftest(TimeSerie.DeltaZrates(:,i));   
   pvalue.lbqtest(i)=pLB;  
   pvalue.ARCH(i)=pARCH;
   pvalue.DF(i)=pDF;
end

end 

if flag=="Spread"
[~,n2]=size(TimeSerie.DeltaSpread);

for i=1:n2
  [~,pLB] = lbqtest(TimeSerie.DeltaSpread(:,i),'Lags',LbLags);
  [~, pARCH] = archtest(TimeSerie.DeltaSpread(:,i),'lags',ArchLags);
  [~, pDF] =adftest(TimeSerie.DeltaSpread(:,i));
   pvalue.lbqtest(i)=pLB;  
   pvalue.ARCH(i)=pARCH;
   pvalue.DF(i)=pDF;
end

end






end