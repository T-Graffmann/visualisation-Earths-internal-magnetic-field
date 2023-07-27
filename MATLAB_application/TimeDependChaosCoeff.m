function [Coeffnew]=TimeDependChaosCoeff(Coeff,Year,Month,Day)
%TimeDependChaosCoeff takes the complete array of loaded coefficients for the
%model (starting in 1997), chooses the nearest g and h based on selected
%date.
%
%   Parameters and their meaning:
%   INPUT:  
%           Coeff:  full array of model coefficients regardless of time 
%            Year:  year of observation
%           Month:  month within year of observation
%      DayOfMonth:  day within said month
%   OUTPUT: 
%        Coeffnew:  array of coefficients only containing information
%                   relevant to selected date
% 
%   WHAT IT DOES:
%   With info about date and number of model epochs the function selects
%   the column with data of the CHAOS-7 timeframe containing the date of
%   observation.


%reduce coefficient table to relevant data
CoeffEra(:,:)=Coeff(:,:);%  reduce table of coefficients to column of observed model era
%CoeffEra(:,2)=Coeff(:,:,gen);%  add column containing coefficients of era directly following the observed timeframe


DayNumb=datenum(Year,Month,Day)-datenum(Year,01,01)+1;%   DayNumb gives nth day of the year as between 1 and 365 for normal years and 366 for leap years
MaxDayNumb=datenum(Year,12,31)-datenum(Year,01,01)+1;%  Provides the maximum days for normal and leap year
PartofYear=DayNumb/MaxDayNumb;%     calculates the part of year covered by Days past PartofYear<=1

%   FIND CORRESPONDING DATA     %

%   begin of data package for observed year
ColYear=10*(Year-1997);%     finds the first column of CHAOS-7 data corresponding to observed year starting at 3rd column to account for n an m counter
%   specific coefficients of tenth of year within observed year
ColYear2=ColYear+ceil(PartofYear*9);

%   new coefficients from the tenth of the year where observed day is located

Coeffnew(:,1)=CoeffEra(:,ColYear2);


end% FUNCTION

% 
% %consideration of leapyears
% if mod(Year,4)==0
%     if tDay<=50
%         tDay=tDay/366;% transforms number of days since and including January first into parts of 366 days of a leapyear
%     else
%         tDay=(tDay+1)/366;% transforms number of days since and including January first into parts of 366 days of a leapyear acounting for 29th of February
%     end
% elseif mod(Year,400)==0
%     tDay=tDay/365;% transforms number of days since and including January first into parts of 365 days of the year
% end
% 


% 
% %   number of weeks passed for any given week
% numWeek=floor(tDay/7);
% 
% t=tEra+tyear+tDay;%     calculates time of observation
% 
% Coeffnew(:)=1.*CoeffEra(:,numWeek+1);
% 
% if gen==6
%    differentiator=0;
% else
%    differentiator=1;
% end
% 
% switch differentiator
%     case 0
%         error('CHAOS-7 is not capable of prognosis');
%     case 1
%         Coeffnew(:)=1.*CoeffEra(:,1)+(t-tEra).*(1/5*(CoeffEra(:,2)-CoeffEra(:,1)));
%         Coeffnew=Coeffnew';
%     otherwise
% end
% end
% 

% 
% 
% %calculate time since start time current model era
% tEra=1900+(gen-1)*5;%   year of start of current model era (January 1st)
% 
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

