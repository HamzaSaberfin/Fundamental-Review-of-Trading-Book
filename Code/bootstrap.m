function Discounts = bootstrap(Maturity, Rates)

% INPUT
% Maturity: struct with  deposMaturity, swapMaturity
% rates: struct with deposRates, swapRates

% OUTPUT
% Discounts(:,1)=delta of the discounts curve
% Discounts(:,2)=value of the discounts

%% inizialize
maturity = zeros(13,1);
discounts = zeros(13,1);


discounts(1) = 1;

%% depos
N = 2; % number of depos before the first future

mid_depo_rates=mean(Rates.depos,2);
maturity(2:N+1,:)=Maturity.depos;

for i = 2:N+1
    discounts(i) = 1/(1+maturity(i)*mid_depo_rates(i-1));
end
%% swaps

mid_swap_rates=mean(Rates.swaps,2);
% maturity
maturity(N+2:end,:)=Maturity.swaps;
% compute B(t0,t1)
discounts(N+2) = 1/(1+Maturity.swaps(1)*mid_swap_rates(1));
% annualy fixed coupons
delta=1;                           
for i = 2:length(Rates.swaps)
    discounts(i+N+1) = (1-delta*mid_swap_rates(i)*sum((discounts(N+2:N+i))))/(1+delta*mid_swap_rates(i));
end

Discounts=[maturity,discounts];

end