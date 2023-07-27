function CheckForFeasibleDate(Year,Month,DayOfMonth)
%CheckForFeasibleDate tests whether the chosen date is within the timeframe
%covered by either IGRF or CHAOS and whether chosen months and days
%actually exist.
%
%   INPUT:
%       Year:   Year of observation (i.e.: 1900,1920,...)
%      Month:   Month of observation given as number 01 to 12
% DayOfMonth:   Day of observation (i.e. 01,04,...,31)
%
%   WHAT IT DOES:
%               It takes user input and tests whether the year is within
%               the combined time-frame of the CHAOS-7 and IGRF13 models.
%               Additionally the function checks whether the provided date
%               actually exists.

if Year>=1900 && Year<=2025%        checks whether year within largest implemented range
    if Year<=1997 && Year>2022 && Nmax>13%  checks whether year covered by CHAOS-7
        error('this year is not covered by CHAOS-7 implementation');
    else
    end% IF statement year between 1997 and 2022
else
    error('This year is not processable'); 
end% IF statement year between 1900 and 2025

%   check whether day within month feasible 
if DayOfMonth<1
    error('such a date is non-conforming to given rules');
elseif DayOfMonth>31
    error('There is no month with more than 31 days');
else
end% IF statement day between 1st and 31st
if mod(Month,2)==0
    if Month==2
        if DayOfMonth>29
            error('Febuary does not have that many days');
        elseif DayOfMonth>28 && mod(Year,4)~=0 && mod(Year,400)==0
            error('Febuary has only 28 days this year');
        end% IF statement check for date existent in Febuary
    else
        if Month<7 && DayOfMonth>30
            error('even-numbered months prior to July have up to 30 days');
        end% IF state check 31st not chosen for even months until June
    end% IF statement Febuary and even months until June
elseif mod(Month,2)~=0
    if Month>7 && DayOfMonth>30
        error('Beginning with August uneven-numbered months have 30 days');
    else
    end% IF statement months beyond July
end% IF statement even months
end% FUNCTION