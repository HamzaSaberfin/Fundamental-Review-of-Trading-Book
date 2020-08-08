function [Delta,Gamma]=ComputeSensitivity(Zrates,spread,instrument,portfolio,vertex,flag)

%INPUT:
%
%Zrates(:,1)=dates of the rates
%Zrates(:,2)=values of the rates
%spread(:,1)=dates of the spread
%spread(:,2)=values of the spread
%instrument=struct containing maturity,coupon and notional of the
%instrument
%portfolio=value of the porfolio at today
%vertex=containing the vertices of the ir or cs
%flag=cs01 if i want to compute the cs01
%flag=pv01 if i want to compute the pv01
%
%
%OUTPUT:
%
%Delta=sensitivity of first order
%Gamma=sensitivity of second order

%inizializate
Delta=zeros(size(vertex));
Gamma=zeros(size(vertex));

if flag=="CS01"
    
    indice_cs=FindIndex(vertex,spread);
    for i=1:length(indice_cs)
    Delta(i)=CS01(Zrates,spread,instrument,portfolio,indice_cs(i));
    Gamma(i)=GammaCS01(Zrates,spread,instrument,portfolio,indice_cs(i));
    end
    
end

 if flag=="PV01"
   
   indice_ir=FindIndex(vertex,Zrates);
   for i=1:length(indice_ir)
     Delta(i)=PV01(Zrates,spread,instrument,portfolio,indice_ir(i));
     Gamma(i)=GammaPV01(Zrates,spread,instrument,portfolio,indice_ir(i));
   end  
   
 end
 


end 