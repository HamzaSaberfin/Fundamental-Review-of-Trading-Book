%% Plots 

%% Plot 3-D smoothed Curve:
m=3;
Days=(1:75);
Conf=(0.999:-0.004:0.7);
n=length(Days);
K_old=zeros([n 1]);
for i=1:n
        [VaR,~]=FullMonteCarloVaR(TimeSerie_blue,Zrates,vertex,spread,instrument,portfolio,Days(i),Conf(i));
        [SVaR,~]=FullMonteCarloVaR(TimeSerie_yellow,Zrates,vertex,spread,instrument,portfolio,Days(i),Conf(i));
        K_old(i)=m*(VaR+SVaR);
end 


  
% Plot a smoothed 3-D surface curve 

x=Conf';
y=Days';
z=K_old;
surffit = fit([x,y],z,'Lowess', 'Normalize', 'on' );
plot(surffit,[x,y],z,'Style','predfunc');
xlabel('Confidence level');
ylabel('Time horizon');
zlabel('Capital Internal model');


%% why we can not use a scaling factor ?:
%% The plot shows a noisy relation ship between the days and rapport of capitals
Days=(1:100);
n=length(Days);
K_old=zeros([n 1]);
for i=1:n
        [VaR,~]=FullMonteCarloVaR(TimeSerie_blue,Zrates,vertex,spread,instrument,portfolio,Days(i),0.99);
        [SVaR,~]=FullMonteCarloVaR(TimeSerie_yellow,Zrates,vertex,spread,instrument,portfolio,Days(i),0.99);
        K_old(i)=m*(VaR+SVaR);
end 

rapport=K_old/K_old(1);
plot(Days,rapport,'o');
%% Comment: no linear relationship between Var and h, since there existe correlation 
% Smoothing Data
[curve, goodness, output] = fit(Days',rapport,'smoothingspline');
plot(curve,Days',rapport);
xlabel('time horizon');
ylabel('K_{old}/K_{old 1 day}');

