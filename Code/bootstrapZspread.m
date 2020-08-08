function Zspread=bootstrapZspread(Discounts,Maturity,yield)

  % Function that gives as an output the bootstrapped curve of z spreads
  % from yields of Corporate bond rated AA and the discount factors
  
% INPUT data are stored as:
%   1. Discounts: table of the bootsrapped curve
%       Column #1: Maturities (year frac)
%       Column #2: Discount factors 
%   2. Maturity: Set of Maturities of the Corporate Bonds 
%   3. Yields  : Set of Yields of the Corporate Bonds 
% 
% OUTPUT data are stored as:
%       Zspread: Table of Zspread 
%       Column #1: Maturities (year frac)
%       Column #2: Zspread 
  
  
  
  Zrates_curve=zeroRates(Discounts);
  %Identify the zero rates that correspond to the same maturities of the bonds
  zrates=interp1(Zrates_curve(:,1),Zrates_curve(:,2),Maturity,'spline');
  % Compute the prices of the Corporate bonds
  Prices=exp(-Maturity.*yield);
  % Calibrate the Zspread
  zspread=-log(Prices)./Maturity -zrates;
  Zspread=[Maturity,zspread];
end


