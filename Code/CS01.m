function cs01 =CS01(zrates,spread,instrument,portfolio,choice)

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
%cs01= value of the deltacs01 sensitivity

%data
bp=0.0001;
spread_shock=spread;

if choice~=0
    spread_shock(choice,2)=spread_shock(choice,2)+bp;
end


%price of the bonds
P_2year=Pricer(zrates,spread_shock,instrument.coupon(1),2,0,instrument.notional(1),"Bond");
P_3year=Pricer(zrates,spread_shock,instrument.coupon(2),3,0,instrument.notional(2),"Bond");
P_5year=Pricer(zrates,spread_shock,instrument.coupon(3),5,0,instrument.notional(3),"Bond");


%IRS pay fix, receive float
NPV_IRS=Pricer(zrates,spread_shock,instrument.coupon(4),4,0,instrument.notional(4),"Swap"); 

shifted_portfolio=NPV_IRS+P_5year+P_3year+P_2year;

cs01=(shifted_portfolio-portfolio)/bp;

end