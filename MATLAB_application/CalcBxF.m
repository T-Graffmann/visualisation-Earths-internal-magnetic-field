function [BxF] = CalcBxF(dPnm,Coeff,Theta,Phi,sizTheta,sizPhi,Nmin,Nmax,gpointer,hpointer,A,R)
%CalcBxF derives the X-component of the magnetic field by deriving
%with repect to theta
%   INPUT:
%       dPnm:   array of theta derivatives of Schmidt normalised associated
%               Legendre polynomials. It is given as a 3 dimensional array.
%       Coeff:  array containining Gaussian coefficients
%       Theta:  1-D array containing linspace of theta
%       Phi:    1-D array containing linspace of phi
%       sizTheta:   size of Theta
%       sizPhi: size of Phi    
%       Nmin:   smallest n taken into account for visualisation
%       Nmax:   greatest n visualised
%       gpointer:   array containing position of Gaussian coefficients for g
%                   in Coeff for their respective n and m
%       hpointer:   array containing position of Gaussian coefficients for g
%                   in Coeff for their respective n and m
%       A:      Earth's reference radius
%       R:      radius of sphere corresponding to height of observation
%   OUTPUT:
%       BxF:  2-D array corresponding to the grid of theta and phi
%                linspaces containing at each position a value for the
%                x-component of B
%   WHAT IT DOES:
%

itheta=1:sizTheta;
difftheta=@(N,M,PHI,DPNM,G,H) (A/R)^(N+1).*(cos(PHI.*M).*G+sin(PHI.*M).*H).*(DPNM/R);

for in=Nmin:Nmax
   im=1:in;
   parfor iphi=1:sizPhi
          Bx(itheta,iphi,in)=A*(difftheta(in,0,Phi(iphi),dPnm(1,itheta(:),in),Coeff(gpointer(1,in),1),0)...
           +sum(difftheta(in,1.*im(:),Phi(iphi),dPnm(2:(in+1),itheta(:),in),Coeff(gpointer(1.+im(:),in),1),Coeff(hpointer(1.*im(:),in),1)),1));
   end% PARFOR loop for phi
end% FOR loop for degrees n
 BxF=sum(Bx(:,:,:),3);
end% FUNCTION