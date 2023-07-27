function [totalField] = totalFValidation(Bx,By,Bz)
%totalF calculates the total magnetic field from its x-, y- and z-components
%   INPUT:
%       Bx: magnetic field component from the theta-derivative of the
%           potential
%       By: magnetic field component form the phi-derivative of the
%           potential
%       Bz: magnetic field component from the r-derivative of the potential
%
%   OUTPUT:
%       totalField: field arising from the pythagoras of the components

totalField=sqrt(Bx.^2+By.^2+Bz.^2);
end% FUNCTION