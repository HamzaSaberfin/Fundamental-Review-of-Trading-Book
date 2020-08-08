function TimeSerie=ReadTimeSerie(file,formatdate,flag)


%Function reads the data in blue pale and in yellow pale:
% Input: xls file, format date e.g('dd/mm/yy'),flag=:{blue,yellow}
% Output: Struct object holding: Dates,DeltaZrates(change in Zero rates),DeltaSpread (change in
% spread)

bp=0.0001;      
if flag=="blue"
    
   [~,dates]=xlsread(file,2,'A32:A293');
   TimeSerie.Dates=datenum(dates,formatdate);
   TimeSerie.DeltaZrates=xlsread(file,2,'B32:K293')*bp;
   TimeSerie.DeltaSpread=xlsread(file,3,'B32:F293')*bp;

end

if flag=="yellow"
    
   [~,dates]=xlsread(file,2,'A1755:A2015');
   TimeSerie.Dates=datenum(dates,formatdate);
   TimeSerie.DeltaZrates=xlsread(file,2,'B1755:K2015')*bp;
   TimeSerie.DeltaSpread=xlsread(file,3,'B1755:F2015')*bp; 
      
end

end 