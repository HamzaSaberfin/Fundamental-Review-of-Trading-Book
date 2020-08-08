function Price=Pricer(Zrates,spread,coupon,maturity,t0,national,flag)

%INPUT:
%Zrates:   matrix of Zero rates 
       % #column1: dates 
       % #column2: zero rates
%Spreads:  Vector of spreads
%coupon:  coupons of the instrument
%maturity: maturity of the instrument
%t0: delta of the first time
%national: notional of the instrument
%flag=Bond if we are considering a bond
%flag=Swap if we are considering a swap
 

if flag=="Bond"
    t=(1:maturity)'-t0;
    indices=find(Zrates(:,1)<=maturity & Zrates(:,1)>=floor(t0)+1);
    CF=national*[repmat(coupon,length(indices)-1,1)',1+coupon];
    discounts=exp(-(spread(indices,2:end)+Zrates(indices,2:end)).*t);
    Price=CF*discounts;
end 


if flag=="Swap"
    t=(1:maturity)'-t0;
    indices=find(Zrates(:,1)<=maturity & Zrates(:,1)>=floor(t0)+1);
    discounts=exp(-Zrates(indices,2:end).*t); 
    NPV_fixed=national*coupon*sum(discounts);
    NPV_float=national*(1-discounts(end,:));
    Price=NPV_float-NPV_fixed;
end 


end