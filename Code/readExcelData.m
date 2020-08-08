function [Maturity, rates,Yields] = readExcelData(filename)



%Reads data from excel
%  It reads bid/ask prices and maturities
%  All input rates are in % units
%
% INPUTS:
%  filename: excel file name where data are stored
%  formatData: data format in Excel
% 
% OUTPUTS:
%  Maturity: struct with  deposMaturity, swapMaturity,
%  rates: struct with deposRates, swapRates
%  Yields: vector of  corporate bond Yields
%% Dates from Excel



%Maturities relative to depos
Maturity.depos = xlsread(filename, 1, 'A17:A18');

%Maturities relative to swaps
Maturity.swaps= xlsread(filename, 1, 'A3:A12');

%Maturities Corporate bonds
Maturity.bonds= xlsread(filename, 1, 'E3:E10');



%% Rates from Excel (Bids & Asks)

%Depos
rates.depos = xlsread(filename, 1,'B17:C18');

%Swaps
rates.swaps  = xlsread(filename, 1,'B3:C12');


%% Yields from Excel 

%Yields
Yields= xlsread(filename, 1, 'F3:F10');


end % readExcelData