function X_delta=cumulativesum(X_1,delta)
    
    % Function that compute the risk factor of delta-period from
    % Daily change of rates
    % INPUT:
    % Daily change of rates
    % Time step delta
    % OTPUT:
    % delta period change of rates
    
    [n,~]=size(X_1);
    X_delta=[];
    i=1;
    if delta==1
       X_delta=X_1;
    else   
        while i+delta-1<=n
        X_delta=[X_delta;sum(X_1(i:i+delta-1,:))];
        i=i+delta;
        end    
    end  
    
end 