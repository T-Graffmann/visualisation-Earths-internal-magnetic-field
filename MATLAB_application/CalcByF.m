function [ByF] = CalcByF(Pnm,Coeff,Theta,Phi,sizTheta,sizPhi,Nmin,Nmax,gpointer,hpointer,A,R)
%CalcByF generates the distribution of the y-component of the
%magnetic field
%
%   INPUT:
%       Pnm:    array of Schmidt normalised associated Legendre
%               polynomials. It is given as a 3 dimensional array.
%     Coeff:    array containing Gaussian coefficients
%     Theta:    1-D array of values arising from the linspace of colatitude
%               theta
%       Phi:    1-D array of values arising from the linspace of longitude
%               phi
%  sizTheta:    size of Theta
%    sizPhi:    size of Phi
%      Nmin:    smallest visualised n
%      Nmax:    largest visualised n
%  gpointer:    array containing positions of Gaussian coefficients g with
%               their postions correlating to their respective n and m+1
%  hpointer:    array containing positions of Gaussian coefficients h with
%               their postions correlating to their respective n and m
%         A:    Earth's reference radius
%         R:    radius of sphere corresponding to height of observation
%
%  OUTPUT:
%    ByF:    2-D array containing values of the y-component of the
%               core's contribution to the magnetic field
%
%   WHAT IT DOES:
%           In a first step the derivative with respect to phi is
%           formulated with n,m, associated Legendre polyonmials and
%           coefficients as well as longitude phi being treated as
%           variables that are put into the equation during the actual
%           calculation within the scope of the for-loop.

itheta=1:sizTheta;
diffphi=@(N,M,PHI,PNM,G,H) -(A/R)^(N+1).*(cos(PHI.*M).*H-sin(PHI.*M).*G).*(PNM).*M.*(1./(R*sin(1.*Theta(itheta))));

for in=Nmin:Nmax     
    im=1:in;
    parfor iphi=1:sizPhi
       By(itheta,iphi,in)=A*sum(diffphi(in,1.*im(:),Phi(iphi),Pnm(2:(in+1)...
                          ,1.*itheta(:),in),Coeff(gpointer(1.+im(:),in),1)...
                          ,Coeff(hpointer(1.*im(:),in),1)),1);
   end% PARFOR loop over all phi
end% FOR loop over all n
 ByF=sum(By(:,:,:),3);
end% FUNCTION