function GammaCS01 =GammaCS01(zrates,spread,instrument,portfolio,choice)

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
%GammaCS01= value of the Gammacs01 sensitivity

%data
bp=0.0001;
spread_shock_plus=spread;
spread_shock_minus=spread;

if choice~=0
    spread_shock_plus(choice,2)=spread_shock_plus(choice,2)+bp;
    spread_shock_minus(choice,2)=spread_shock_minus(choice,2)-bp;

end

%compute the value of the portfolio shifting up
P_2year=Pricer(zrates,spread_shock_plus,instrument.coupon(1),2,0,instrument.notional(1),"Bond");
P_3year=Pricer(zrates,spread_shock_plus,instrument.coupon(2),3,0,instrument.notional(2),"Bond");
P_5year=Pricer(zrates,spread_shock_plus,instrument.coupon(3),5,0,instrument.notional(3),"Bond");
NPV_IRS=Pricer(zrates,spread_shock_plus,instrument.coupon(4),4,0,instrument.notional(4),"Swap"); 
shifted_portfolio_plus=NPV_IRS+P_5year+P_3year+P_2year;

%compute the value of the portfolio shifting down
P_2year=Pricer(zrates,spread_shock_minus,instrument.coupon(1),2,0,instrument.notional(1),"Bond");
P_3year=Pricer(zrates,spread_shock_minus,instrument.coupon(2),3,0,instrument.notional(2),"Bond");
P_5year=Pricer(zrates,spread_shock_minus,instrument.coupon(3),5,0,instrument.notional(3),"Bond");
NPV_IRS=Pricer(zrates,spread_shock_minus,instrument.coupon(4),4,0,instrument.notional(4),"Swap"); 
shifted_portfolio_minus=NPV_IRS+P_5year+P_3year+P_2year;


%compute the second derivative
GammaCS01=(shifted_portfolio_plus+shifted_portfolio_minus-2*portfolio)/bp^2;

end