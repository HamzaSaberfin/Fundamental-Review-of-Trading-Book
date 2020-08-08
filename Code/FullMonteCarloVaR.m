function VaR=FullMonteCarloVaR(TimeSerie,Zrates,vertex,spread,instrument,Portfolio,DeltaT,c)

% INPUT:
% TimeSerie=struct containing the dates, delta rates and delta spread of
% the historical serie
%Zrates(:,1)=dates of the rates
%Zrates(:,2)=values of the rates
%vertex=struct containing the vetices for ir and cs
%spread(:,1)=dates of the spread
%spread(:,2)=values of the spread
%instument=struck containing the maturity,coupon and notional of the
%instruments
%Portfolio=value of the portfolio at today
%DeltaT=time horizon of the Var
%c=confidence level of the Var
%
%
%OUTPUT: 
%VaR= value at risk computed with full MC method
       

%% extract the time serie with time horizon 10 days:

    [nbDays,~]=size(TimeSerie.DeltaZrates);
    delta=DeltaT/nbDays;
    deltaZrates=cumulativesum(TimeSerie.DeltaZrates,DeltaT);
    deltaSpread=cumulativesum(TimeSerie.DeltaSpread,DeltaT);    
    [m,~]=size(deltaZrates);

%% Mean Adjustement
   deltaZrates=deltaZrates-mean(deltaZrates);
   deltaSpread=deltaSpread-mean(deltaSpread);
      
 %% Simulate Risk Factors by MonteCarlo: 
    
    replicated_Zrates=repmat(Zrates(:,2),[1,m+1]);
    replicated_Zrates(:,1)=Zrates(:,1);
    replicated_Zspread=repmat(spread(:,2),[1,m+1]);
    replicated_Zspread(:,1)=spread(:,1);
    
    fict_his_rates=zeros(size(replicated_Zrates));
    fict_his_spread=zeros(size(replicated_Zspread));
    % Find indices of the vertices for both cases IR/Spread
    indice_ir=FindIndex(vertex.ir,Zrates);
    indice_cs=FindIndex(vertex.cs,spread);
    %Compute the fictive historical rates/spread
    replicated_Zrates(indice_ir,2:end)=replicated_Zrates(indice_ir,2:end)+deltaZrates';                              
    replicated_Zspread(indice_cs,2:end)=replicated_Zspread(indice_cs,2:end)+deltaSpread';
    
    fict_his_rates(:,2:end)=interp1(vertex.ir',replicated_Zrates(indice_ir,2:end),replicated_Zrates(:,1));
    fict_his_rates(:,1)=replicated_Zrates(:,1);
    fict_his_spread(:,2:end)=interp1(vertex.cs',replicated_Zspread(indice_cs,2:end),replicated_Zspread(:,1));
    fict_his_spread(:,1)=replicated_Zspread(:,1);

   
   %% Compute Loss
   
   P_2year=Pricer(fict_his_rates,fict_his_spread,instrument.coupon(1),2,delta,instrument.notional(1),"Bond");
   P_3year=Pricer(fict_his_rates,fict_his_spread,instrument.coupon(2),3,delta,instrument.notional(2),"Bond");
   P_5year=Pricer(fict_his_rates,fict_his_spread,instrument.coupon(3),5,delta,instrument.notional(3),"Bond");
   NPV_IRS=Pricer(fict_his_rates,fict_his_spread,instrument.coupon(4),4,delta,instrument.notional(4),"Swap"); 

 %% Compute Loss and make Q-Q plot:

   Portfolio_value=NPV_IRS+P_5year+P_3year+P_2year;
   Loss=Portfolio-Portfolio_value;
   qqplot(Loss)

   %% Compute VaR
   
   losses_ord = sort(Loss,'descend');
   % computing i*
   index = ceil(m*(1-c));
   % VaR and ES
   VaR =losses_ord(index);

   
    
end