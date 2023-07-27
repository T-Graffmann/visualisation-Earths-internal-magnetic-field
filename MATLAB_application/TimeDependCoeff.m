function [Coeffnew]=TimeDependCoeff(Coeff,Year,Month,DayOfMonth,sizLoadedTable)
%TimeDependCoeff takes the complete array of loaded coefficients for the
%model, chooses the relevant portion based on selected time, and calculates g(t) and h(t) 
%
%   Parameters and their meaning:
%   INPUT:  
%           Coeff:  full array of model coefficients regardless of time 
%            Year:  year of observation
%           Month:  month within year of observation
%      DayOfMonth:  day within said month
%  sizLoadedTable:  number of last column of loaded array
%   OUTPUT: 
%        Coeffnew:  array of coefficients only containing information
%                   relevant to selected date
% 
%   WHAT IT DOES:
%   With info about date and number of model epochs the function selects
%   the column with data of the IGRF epoch containing the date of
%   observation. sizLoadedTable is important to decide, whether the epoch
%   of observation is the current epoch as in this case the new time
%   dependent coefficients are calculated differently.
% 
% 


%generate model era from given date
gen=floor((Year-1900)/5)+1;
%reduce coefficient table to relevant columns
CoeffEra(:,1)=Coeff(:,gen);%  reduce table of coefficients to column of observed model era
CoeffEra(:,2)=Coeff(:,gen+1);%  add column containing coefficients of era directly following the observed timeframe

%calculate base year of IGRF model era
EraYear=1900+5*(gen-1);
%Calculate time in current year + part of year
t=Year+(datenum(Year,Month,DayOfMonth)-datenum(Year,1,1))/(datenum(Year,12,31)-datenum(Year,01,01));
%Calculate new coefficients
if gen==sizLoadedTable(1,2)-4
   differentiator=0;
else
   differentiator=1;
end% IF-STATEMENT

switch differentiator
    case 0
        Coeffnew(:)=1.*CoeffEra(:,1)+(t-EraYear).*CoeffEra(:,2);
        Coeffnew=Coeffnew';
    case 1
        Coeffnew(:)=1.*CoeffEra(:,1)+(t-EraYear).*(1/5*(CoeffEra(:,2)-CoeffEra(:,1)));
        Coeffnew=Coeffnew';
    otherwise
end% SWITCH
end% FUNCTION


% %calculate time since start time current model era
% tEra=1900+(gen-1)*5;%   year of start of current model era (January 1st)


% %consideration of leapyears
% if mod(tEra+tyear,4)==0
%     if tDay<=50
%         tDay=tDay/366;% transforms number of days since and including January first into parts of 366 days of a leapyear
%     else
%         tDay=(tDay+1)/366;% transforms number of days since and including January first into parts of 366 days of a leapyear acounting for 29th of February
%     end
% elseif mod(tEra+tyear,400)==0
%     tDay=tDay/365;% transforms number of days since and including January first into parts of 365 days of the year
% else
%     for passedyears=0:tyear
%         if mod(tEra+passedyears,4)==0
%            if tDay<=50
%               tDay=tDay/366;% transforms number of days since and including January first into parts of 366 days of a leapyear
%            else
%               tDay=(tDay+1)/366;% transforms number of days since and including January first into parts of 366 days of a leapyear acounting for 29th of February
%            end
%         elseif mod(tEra+passedyears,400)==0
%               tDay=tDay/365;
%         elseif mod(tEra+passedyears,4)~=0
%               tDay=tDay/365;
%         end
% %         passedyears=passedyears+1;
%     end
% end
% t=tEra+tyear+tDay;%     calculates time of observation

