function Koeff = loadCoeffTable(Tablename)

%loadCoeff loads table of coefficients provided by the IGRF versions. It is
%given the name provided in the central life script in order to account for
% different names under which tables are safed. 

Koeff=readtable(Tablename);
end