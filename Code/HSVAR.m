function Var=HSVAR(TimeSerie,Zrates,spread,vertex,instrument,DeltaT,c,file,flag)

% INPUT:
% TimeSerie=struct containing the dates, delta rates and delta spread of
% the historical serie
%Zrates(:,1)=dates of the rates
%Zrates(:,2)=values of the rates
%spread(:,1)=dates of the spread
%spread(:,2)=values of the spread
%vertex=struct containing the vetices for ir and cs
%instument=struck containing the maturity,coupon and notional of the
%instruments
%DeltaT=time horizon of the Var
%c=confidence level of the Var
%file=name of the file from which taking the value
%flag=="Blue" if i consider the blue serie, "Yellow" if i consider the
%yellow serie
%
%
%OUTPUT: 
%VaR= value at risk computed with the historical simulation


deltaZrates=TimeSerie.DeltaZrates;
[m,~]=size(deltaZrates);

%compute from the excel file the value of the rates and the spread at each
%day
[deltazrates,deltaspread]= ComputeCurves(TimeSerie,Zrates,spread,vertex,flag,file);
    
deltazrates=[Zrates(:,1)';deltazrates];
deltaspread=[spread(:,1)';deltaspread];
%% compute the price for each day 

P_2year=Pricer(deltazrates',deltaspread',instrument.coupon(1),2,0,instrument.notional(1),"Bond");
P_3year=Pricer(deltazrates',deltaspread',instrument.coupon(2),3,0,instrument.notional(2),"Bond");
P_5year=Pricer(deltazrates',deltaspread',instrument.coupon(3),5,0,instrument.notional(3),"Bond");
NPV_IRS=Pricer(deltazrates',deltaspread',instrument.coupon(4),4,0,instrument.notional(4),"Swap"); 

portfolio=P_2year+P_3year+P_5year+NPV_IRS;

s=1:length(portfolio)-DeltaT;

%compute the loss at each day

loss=portfolio(s)-portfolio(s+DeltaT);


losses_ord = sort(loss,'descend');

index = ceil(m*(1-c));

%compute the VaR
Var =losses_ord(index);


end