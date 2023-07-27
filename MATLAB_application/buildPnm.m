function Pnm = buildPnm(Nmin,Nmax,Theta,sizTheta)
%buildPnm calculates the Schmidt semi-normalised associated Legendre
%polynomials. and returns them as a 3 dimensional array
%   INPUT:
%       Nmin:       smallest n taken into account for visualisation
%       Nmax:       greatest n taken into account for visualisation
%       Theta:      array containing the values of the linspace of theta
%       sizTheta:   size of array Theta
%   OUTPUT:
%       Pnm:        3 dimensional array containing the associated Legendre
%                   polynomials ordered by order m in the first,
%                   colatitude theta in the second and repsective degrees n
%                   in the third dimension
%   WHAT IT DOES:
%

Pnm(:,:,:)=zeros(Nmax+1,sizTheta,Nmax);

for in=Nmin:Nmax

%generates content of Pnm for all thetas for one n
P=zeros(Nmax,sizTheta);
LP=legendre(in,cos(Theta),'sch');
P(1:size(LP,1),1:size(LP,2))=LP(:,:);

%Pnm with first dimension accounting vor rows depending on m, 2nd dim
%accounts for theta and third calls in regard to n

Pnm(1:size(P,1),1:size(P,2),in)=P(:,:);
end% FOR loop
end% FUNCTION