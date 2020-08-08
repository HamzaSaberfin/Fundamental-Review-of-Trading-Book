function zrates_curve = zeroRates(Discounts)

% INPUT
% (Dates,Discounts): discount curve computed through bootstrap

% OUTPUT:
% zRates: zero-rates curve

%% computing zero-rates

ZRates = -log(Discounts(2:end,2))./Discounts(2:end,1);
ExtrapolZrates=interp1(Discounts(2:end,1),ZRates,[15;20;30],'linear','extrap');
zrates=[ZRates;ExtrapolZrates];
zrates_curve=[[Discounts(2:end,1);15;20;30],zrates];

end