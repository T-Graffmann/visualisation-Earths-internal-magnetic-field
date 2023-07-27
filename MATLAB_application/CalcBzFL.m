function [BzFL]=CalcBzFL(Pnm,CoeffS,CoeffD,Phi,sizTheta,sizPhi,NminL,NmaxL,gpointer,hpointer,A,R)
%CalcBzFL provides the z-component of the crustal contribution to
%the magnetic field
%
%   INPUT:
%       Pnm:    array of Schmidt normalised associated Legendre
%               polynomials. It is given as a 3 dimensional array.
%    CoeffS:    array containining static Gaussian coefficients from the
%               LCS-1 crustal magnetic field model
%     CoeffD:   array containing dynamic time dependent 
%               Gaussian coefficients
%       Phi:    array containing the linspace of longitude phi
%  sizTheta:    size of linspace for colatitude theta
%    sizPhi:    size of Phi
%     NminL:    smallest n within scope of observation
%     NmaxL:    largest n within scope of observation
%  gpointer:    array containing positions of Gaussian coefficients g with
%               their postions correlating to their respective n and m+1
%  hpointer:    array containing positions of Gaussian coefficients h with
%               their postions correlating to their respective n and m
%         A:    Earth's reference radius
%         R:    radius of sphere corresponding to height of observation
%
%  OUTPUT:
%   BzFLnew:    2-D array containing values of y-component of crustal
%               contribution to the magnetic field at all positions of the
%               grid.
%
%   WHAT IT DOES:
%               In a first step this function defines the derivative of the
%               lithospheric contribution potential with respect to r.
%               The parfor loop afterwards calculates the array of the
%               z-component of the magnetic field over the theta-phi grid.

itheta=1:sizTheta;
diffr=@(N,M,PHI,PNM,G,H) (N+1)*(A/R)^(N+2)*(cos(PHI.*M).*G+sin(PHI.*M).*H).*PNM;
Bz=zeros(sizTheta,sizPhi,NmaxL-NminL);

parfor in=NminL:NmaxL
   im=1:in;
   for iphi=1:sizPhi
       if in<21
           %    time-dependent contribution
           Bz(itheta,iphi,in)=diffr(in,0,Phi(iphi),Pnm(1,1.*itheta(:),in),CoeffD(gpointer(1,in)),0)...
         +sum(diffr(in,1.*im(:),Phi(iphi),Pnm(1.+im(:),1.*itheta(:),in),CoeffD(gpointer(1.+im(:),in)),CoeffD(hpointer(1.*im(:),in))),1);
       else
           %    static contributions
       Bz(itheta,iphi,in)=diffr(in,0,Phi(iphi),Pnm(1,1.*itheta(:),in),CoeffS(gpointer(1,in)-440),0)...%     gpointerL-440 and hpointerL-440 account for considered values only from n=21
         +sum(diffr(in,1.*im(:),Phi(iphi),Pnm(1.+im(:),1.*itheta(:),in),CoeffS(gpointer(1.+im(:),in)-440),CoeffS(hpointer(1.*im(:),in)-440)),1);
       end% IF statement differentiating n greater 21 and se. than 20
   end% FOR loop over all phi
end% PARFOR loop over all n
 BzFL=sum(Bz(:,:,:),3);
end% FUNCTION