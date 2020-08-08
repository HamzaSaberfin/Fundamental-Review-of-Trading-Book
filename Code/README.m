% Final Project
% RM 1
% Pietro, Hamza

close all
clear all
clc


%% data
file='Copie de TS_and_shocks.xlsx';
[Maturity, rates,Yields] = readExcelData(file);

instrument.maturity=[2 ; 3 ; 5 ; 4];
instrument.coupon=[1 ; 1.25 ; 1.75; 1.0095]./100;
instrument.notional=[40 ; 80 ; 160 ; 280].*10^6;


%% bootstrap

Discounts = bootstrap(Maturity, rates);
Zrates=zeroRates(Discounts);
yields=interp1(Maturity.bonds,Yields,Discounts(2:end,1),'spline');
spread=bootstrapZspread(Discounts,Discounts(2:end,1),yields);


%% Market value of the portfolio :

% 2Y,3Y,5Y Bonds Pricing:

P_2year=Pricer(Zrates,spread,instrument.coupon(1),2,0,instrument.notional(1),"Bond");
P_3year=Pricer(Zrates,spread,instrument.coupon(2),3,0,instrument.notional(2),"Bond");
P_5year=Pricer(Zrates,spread,instrument.coupon(3),5,0,instrument.notional(3),"Bond");


% IRS pay fix, receive float:
NPV_IRS=Pricer(Zrates,spread,instrument.coupon(4),4,0,instrument.notional(4),"Swap"); 

% Portfolio Value
portfolio=NPV_IRS+P_5year+P_3year+P_2year;



%% Standarised method framework:

[RW_ir,rho_ir,vertex_ir]=ReadParameters(file,"Rates");
[RW_cs,rho_cs,vertex_cs]=ReadParameters(file,"Spread");
vertex.ir=vertex_ir;
vertex.cs=vertex_cs;

% Compute the sensitivities 

[Sensitivity_ir,~]=ComputeSensitivity(Zrates,spread,instrument,portfolio,vertex.ir,"PV01");
[Sensitivity_cs,~]=ComputeSensitivity(Zrates,spread,instrument,portfolio,vertex.cs,"CS01");

%Compute the capitals
K_ir=ComputeCapital(Sensitivity_ir,RW_ir,rho_ir);
K_cs=ComputeCapital(Sensitivity_cs,RW_cs,rho_cs);

%Compute Undiversified K_sa 
K_sa=K_ir+K_cs;

%% Old Method framework:
%data
c=0.99;
DeltaT=10;
formatdate='dd/mm/yy';
m=3;     
TimeSerie_blue=ReadTimeSerie(file,formatdate,"blue");
TimeSerie_yellow=ReadTimeSerie(file,formatdate,"yellow");

%% Time Serie Analysis:

autocorr(TimeSerie_blue.DeltaZrates(:,1));

% the Jarque-Bera test for normality h=1 we reject the normality hypothesis at level 5%.
% we can't use parametric approach !!

[h,p] = jbtest(TimeSerie_blue.DeltaZrates(:,3));

% Set of p-values for multiple tests on the time series from each vertice:

% Ljung-Box test for Auto Corroletation 
% Arch test for Volatility clustering
% Dicky Fuller test for unit root (test for stationarity)

 ArchLags=1;  % Number of legs for Arch test
 LbLags=3;    % Number of legs for Ljung-Box test
 
 % Blue pail tests
 pvalue_blue_Zrates=ApplyTests(TimeSerie_blue,LbLags,ArchLags,"Rates");
 pvalue_blue_Spread=ApplyTests(TimeSerie_blue,LbLags,ArchLags,"Spread");
 % Yellow pail tests
 pvalue_yellow_Zrates=ApplyTests(TimeSerie_yellow,LbLags,ArchLags,"Rates");
 pvalue_yellow_Spread=ApplyTests(TimeSerie_yellow,LbLags,ArchLags,"Spread");
 
% Clc:
% Stationarity hypothesis is verified 
% autocorrelation exists for the time serie of the zero rates 

%% MonteCarlo:


% VaR
VaR=FullMonteCarloVaR(TimeSerie_blue,Zrates,vertex,spread,instrument,portfolio,DeltaT,c);

% Stressed Var
SVaR=FullMonteCarloVaR(TimeSerie_yellow,Zrates,vertex,spread,instrument,portfolio,DeltaT,c);

%Capital using MC
K_MC=m*(VaR+SVaR);


%% DeltaNormalVar:

% VaR
VaR=DeltaNormalVaR(TimeSerie_blue,Zrates,vertex,spread,instrument,portfolio,DeltaT,c);

% Stressed Var
SVaR=DeltaNormalVaR(TimeSerie_yellow,Zrates,vertex,spread,instrument,portfolio,DeltaT,c);

%Capital using DeltaNormal
K_delta=m*(VaR+SVaR);


%% GammaNormalVar:

% VaR
VaR=GammaNormalVaR(TimeSerie_blue,Zrates,vertex,spread,instrument,portfolio,DeltaT,c);

% Stressed Var
SVaR=GammaNormalVaR(TimeSerie_yellow,Zrates,vertex,spread,instrument,portfolio,DeltaT,c);

%Capital using DeltaNormal
K_Gamma=m*(VaR+SVaR);

%% Historical Simulation

%VaR
Var_HS=HSVAR(TimeSerie_blue,Zrates,spread,vertex,instrument,DeltaT,c,file,"Blue");

%Stressed VaR
SVar_HS=HSVAR(TimeSerie_yellow,Zrates,spread,vertex,instrument,DeltaT,c,file,"Yellow");

%Capital using Historical simulation
K_HS=m*(Var_HS+SVar_HS);

%% Look for deltaT ans c that minimize the difference:
% m=3;
% Days=(1:75);
% Conf=(0.99:-0.001:0.7);
% n1=length(Days);
% n2=length(Conf);
% K_old=zeros([n1 n2]);
% for j=1:n2
% for i=1:n1
%         VaR=FullMonteCarloVaR(TimeSerie_blue,Zrates,vertex,spread,instrument,portfolio,Days(i),Conf(j));
%         SVaR=FullMonteCarloVaR(TimeSerie_yellow,Zrates,vertex,spread,instrument,portfolio,Days(i),Conf(j));
%         K_old(i,j)=m*(VaR+SVaR);
% end 
% end 
% 
% positive_part=max(K_old,0);
% C=abs(positive_part-K_sa);
% [min,ind]=minposition(C); % find the position of the nearest K_old to K_sa



