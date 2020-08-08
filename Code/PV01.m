function pv01 =PV01(zrates,spread,instrument,portfolio,choice)

% INPUT:
% zrates(:,1)=dates of the rates curve
% zrates(:,2)=value of the rates
% spread(:,1)=dates of the spread curve
% spread(:,2)=value of the spread
% instrument.maturity=maturities of the instruments
% instrument.coupon=coupon of the instruments
% instrument.notional= notional of the instruments
% portfolio=value of the portfolio at today
% choice=numeber corresponding to the vertex i want to shift, if 0 i don't
% do the shift
% 
% the first 3 instruments are corporate bond while the last one is a IRS
%
%OUTPUT:
%pv01= value of the deltapv01 sensitivity

%data
bp=0.0001;
rates_shock=zrates;

if choice~=0
    rates_shock(choice,2)=rates_shock(choice,2)+bp;
end


%compute the bonds
P_2year=Pricer(rates_shock,spread,instrument.coupon(1),2,0,instrument.notional(1),"Bond");
P_3year=Pricer(rates_shock,spread,instrument.coupon(2),3,0,instrument.notional(2),"Bond");
P_5year=Pricer(rates_shock,spread,instrument.coupon(3),5,0,instrument.notional(3),"Bond");


%IRS pay fix, receive float
NPV_IRS=Pricer(rates_shock,spread,instrument.coupon(4),4,0,instrument.notional(4),"Swap"); 

%new portfolio
shifted_portfolio=NPV_IRS+P_5year+P_3year+P_2year;

%compute the first derivative
pv01=(shifted_portfolio-portfolio)/bp;


end