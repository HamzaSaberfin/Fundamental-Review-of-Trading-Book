function [Shocks,Rho,Vertices]=ReadParameters(file,flag)
    
%INPUT:
%file=name of the spreadsheet file
%flag==Spread if i want the data of the spread
%flag==Rates if i want the data of the rates


bp=0.0001;

% function that store parameters

   if flag=="Spread"
      Vertices=xlsread(file,5,'C2:G2');
      Shocks=xlsread(file,5,'C3:G3')*bp;
      Rho=xlsread(file,5,'C7:G11');
    end
    
    if flag=="Rates"
        Vertices=xlsread(file,4,'C2:L2');
        Shocks=xlsread(file,4,'C3:L3')*bp;
        Rho=xlsread(file,4,'C7:L16');
    end
    
end