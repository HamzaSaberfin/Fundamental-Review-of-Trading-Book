function [Rates,Spread]= ComputeCurves(TimeSerie,Zrates,spread,vertex,flag,file)

%INPUT:
% TimeSerie=struct containing the dates, delta rates and delta spread of
% the historical serie
%Zrates(:,1)=dates of the rates
%Zrates(:,2)=values of the rates
%spread(:,1)=dates of the spread
%spread(:,2)=values of the spread
%vertex=struct containing the vetices for ir and cs
%flag=="Blue" if i consider the blue serie, "Yellow" if i consider the
%yellow serie
%file=name of the file from which taking the value
%
%
%OUTPUT: 
%Rates= rates for every dates of the time series
%Spread= spreads for every dates of the time series

if flag=="Blue"
    
    %data
    deltaZrates=TimeSerie.DeltaZrates;
    deltaSpread=TimeSerie.DeltaSpread;
  
    %initialize
    deltazrates(1,:)=Zrates(:,1);
    deltaspread(1,:)=spread(:,1);
    Spread=zeros(size(deltaZrates-1,1),size(spread,1));
    Rates=zeros(size(deltaZrates-1,1),size(Zrates,1));
   
    
    for i=2:size(deltaZrates,1)+1
        %interpolate the rates and the spread from the daily market data of
        %the time serie
        deltazrates(i,:)=interp1(vertex.ir,deltaZrates(i-1,:),Zrates(:,1),'spline');
        deltaspread(i,:)=interp1(vertex.cs,deltaSpread(i-1,:),spread(:,1),'spline');
        
        %compute the rates and the spread by subtracting the sum of the
        %daily change 
        Rates(i-1,:)= Zrates(:,2) - sum(deltazrates(2:i,:),1)';
        Spread(i-1,:)= spread(:,2) - sum(deltaspread(2:i,:),1)';
    end

else
   
   %data
   deltaZrates=TimeSerie.DeltaZrates;
   deltaSpread=TimeSerie.DeltaSpread;
   
   bp=0.0001;
   zero_coupon=xlsread(file,2,'B32:K1754')*bp;
   z_spread=xlsread(file,3,'B32:F1754')*bp;
   
   %inizilize
   Zero_coupon=zeros(size(zero_coupon,1),size(Zrates,1));
   Z_spread=zeros(size(z_spread,1),size(spread,1));
   
   %interpolate the rates and the spread from the daily market data
   for i=1:size(zero_coupon,1)
        Zero_coupon(i,:)=interp1(vertex.ir,zero_coupon(i,:),Zrates(:,1),'spline');
        Z_spread(i,:)=interp1(vertex.cs,z_spread(i,:),spread(:,1),'spline');       
   end
   
   %compute the rates and spread  at the beginning of the serie
   Zrates_begin=Zrates(:,2)-sum(Zero_coupon,1)';
   Spread_begin=spread(:,2)-sum(Z_spread,1)';
   
   %inizialize 
   deltazrates(1,:)=Zrates(:,1);
   deltaspread(1,:)=spread(:,1);
   Spread=zeros(size(deltaZrates,1),size(spread,1));
   Rates=zeros(size(deltaZrates,1),size(Zrates,1));
   
    
    for i=2:size(deltaZrates,1)+1
        %interpolate the rates and the spread from the daily market data of
        %the time serie
        deltazrates(i,:)=interp1(vertex.ir,deltaZrates(i-1,:),Zrates(:,1),'spline');
        deltaspread(i,:)=interp1(vertex.cs,deltaSpread(i-1,:),spread(:,1),'spline');
  
        %compute the rates and the spread by subtracting the sum of the
        %daily change 
        Rates(i-1,:)= Zrates_begin(:,1) - sum(deltazrates(2:i,:),1)';
        Spread(i-1,:)= Spread_begin(:,1)' - sum(deltaspread(2:i,:),1);
    end
    
end



end