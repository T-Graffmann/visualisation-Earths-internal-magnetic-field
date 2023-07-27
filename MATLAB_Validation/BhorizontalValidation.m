function Bhor = BhorizontalValidation(Bx,By)
%Bhorizontal calculates the horizontal intensity of the magnetic field as
%the length of the hypothenuse of the x- and y-components.
%
%   INPUT:
%       Bx: magnetic field component from the theta-derivative of the
%           potential
%       By: magnetic field component form the phi-derivative of the
%           potential
%   OUTPUT:
%       Bhor: horizontal magnetic field component
%
Bhor=sqrt(Bx.^2+By.^2);

end