function [differentiator,loadedTable,loadedTable2] = ChooseCHAOSorIGRF(Nmin,Nmax)
%ChooseCHAOSorIGRF decides which model to visualise based on input range of n
%
%   Parameters and their meaning:
%   INPUT:
%       Nmin:   minimum of range for degrees n
%       Nmax:   maximum of range for degrees n
%   OUTPUT:
% differentiator:   value 1,2 or 3 for switching between code for
%                   calculation of the magnetic field (see: Code_Bachelorthesis_TW.m)
% loadedTable:  table containing coefficients depending on decision outcome
%
%   WHAT IT DOES:
%   Via multiple layers of if statements the decision is made to select the
%   table of coefficients corresponding to the applied model and explored
%   field contributor. It also returns error messages for inputs not
%   processable.

if Nmax<=20%    check if static or time dependent
    if Nmax<=13%    core field according to IGRF
        loadedTable=readtable('IGRF13OC-2.xlsx','ReadVariableNames',false);% loads in table containing IGRF data
        loadedTable2=0;
        differentiator=0;
    else%           core field according to CHAOS
        loadedTable=readtable('CHAOScoeff2.txt','ReadVariableNames',false);
        loadedTable2=0;
        differentiator=2; 
    end% IF statement checking Nmax in [13,20]
elseif Nmin>=17 && Nmax>20%     crustal field from CHAOS-7 time-independent no need to check for correct year
        differentiator=1;
        loadedTable=readtable('LithosGH2.dat','ReadVariableNames',false);%   loads in table containing g and h for lithospheric field
        loadedTable2=readtable('CHAOScoeff2.txt','ReadVariableNames',false);
end% IF statement checking Nmax in [1,n>20] and Nmin ge. than 17
end% FUNCTION