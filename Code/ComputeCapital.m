function K=ComputeCapital(sensitivities,RW,Rho)
%INPUT:
%
%sensitivities=sensitivity of the ir or cs
%RW=risk weight vector
%Rho=correlation matrix
%
%
%OUTPUT:
%K=capital required
      
     WS=sensitivities.*RW;
     K=sqrt(max(WS*Rho*WS',0));
     
    
end 