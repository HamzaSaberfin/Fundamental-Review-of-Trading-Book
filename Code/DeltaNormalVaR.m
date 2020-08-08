function VaR=DeltaNormalVaR(TimeSerie,Zrates,vertex,spread,instrument,portfolio,DeltaT,c)

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
%porfolio=value of the portfolio at today
%DeltaT=time horizon of the Var
%c=confidence level of the Var
%
%
%OUTPUT: 
%VaR= value at risk computed with the delta normal method


%% extract the time serie with time horizon 10 days interpolated at the missing changes:
    [nbDays,~]=size(TimeSerie.DeltaZrates);
    delta=DeltaT/nbDays;
    interpolated_Zrates=interp1(vertex.ir',TimeSerie.DeltaZrates',Zrates(:,1));
    interpolated_Zspread=interp1(vertex.cs',TimeSerie.DeltaSpread',spread(:,1));
    interpolated_Zspread(1,:)=interp1(vertex.cs',TimeSerie.DeltaSpread',0.25,'linear','extrap');
    deltaZrates=cumulativesum(interpolated_Zrates',DeltaT);
    deltaSpread=cumulativesum(interpolated_Zspread',DeltaT);
    [N,~]=size(deltaZrates);
%% Time sensitivity

   bp=0.0001;
   P_2year=Pricer(Zrates,spread,instrument.coupon(1),2,bp,instrument.notional(1),"Bond");
   P_3year=Pricer(Zrates,spread,instrument.coupon(2),3,bp,instrument.notional(2),"Bond");
   P_5year=Pricer(Zrates,spread,instrument.coupon(3),5,bp,instrument.notional(3),"Bond");
   NPV_IRS=Pricer(Zrates,spread,instrument.coupon(4),4,bp,instrument.notional(4),"Swap"); 
   portfolio_shifted=NPV_IRS+P_5year+P_3year+P_2year;
   DF_t=(portfolio_shifted-portfolio)/bp;
   
%% Sensitivities with respect to CS01,PV01

   [delta_ir,~]=ComputeSensitivity(Zrates,spread,instrument,portfolio,Zrates(:,1)',"PV01");
   [delta_cs,~]=ComputeSensitivity(Zrates,spread,instrument,portfolio,spread(:,1)',"CS01");
  
%% Compute Loss and make Q-Q plot:

   Loss=-DF_t*delta-delta_ir*deltaZrates'-delta_cs*deltaSpread';
   qqplot(Loss)
 
 %% Compute VaR
 
   losses_ord = sort(Loss,'descend'); 
   
   % computing index of N*(1-c) th value:
   
   index = ceil(N*(1-c));
   
   % VaR:
   
   VaR = losses_ord(index);
   
end