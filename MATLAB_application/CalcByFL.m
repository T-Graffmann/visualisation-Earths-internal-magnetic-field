function [ByFL]=CalcByFL(Pnm,CoeffS,CoeffD,Theta,Phi,sizTheta,sizPhi,NminL,NmaxL,gpointer,hpointer,A,R)
%CalcByFL calculates the crustal contribution to the y-component of
%Earth's magnetic field.
%   
%   INPUT:
%        Pnm:   array of Schmidt normalised associated Legendre
%               polynomials. It is given as a 3 dimensional array.
%     CoeffS:   array containining static Gaussian coefficients from the
%               LCS-1 crustal magnetic field model
%     CoeffD:   array containing dynamic time dependent 
%               Gaussian coefficients   
%      Theta:   1-D array containing linspace of theta
%        Phi:   1-D array containing linspace of phi
%   sizTheta:   size of Theta
%     sizPhi:   size of Phi
%      NminL:   smallest n within scope of observation
%      NmaxL:   largest n within scope of observation
%   gpointer:   array containing position of Gaussian coefficients for g in
%               CoeffS and CoeffD for their respective n and m
%   hpointer:   array containing position of Gaussian coefficients for g in
%               CoeffS and CoeffD for their respective n and m
%          A:   Earth's reference radius
%          R:   radius of sphere corresponding to height of observation
%
%   OUTPUT:
%    ByFLnew:   2-D array containing values of y-component of crustal
%               contribution to the magnetic field at all positions of the
%               grid.
%
%   WHAT IT DOES:
%               In a first step this function defines the derivative of the
%               lithospheric contribution potential with respect to phi.
%               The parfor loop afterwards calculates the array of the
%               y-component of the magnetic field over the theta-phi grid.

itheta=1:sizTheta;
diffphi=@(N,M,PHI,PNM,G,H) -(A/R)^(N+1).*(cos(PHI.*M).*H-sin(PHI.*M).*G).*(PNM).*M.*(1./(R*sin(1.*Theta(itheta))));
By=zeros(sizTheta,sizPhi,NmaxL-NminL);
 
parfor in=NminL:NmaxL
       im=1:in;
    for iphi=1:sizPhi
       if in<21
           %    time-dependent contributions
          By(itheta,iphi,in)=A*sum(diffphi(in,1.*im(:),Phi(iphi),Pnm(2:(in+1),1.*itheta(:),in)...
          ,CoeffD(gpointer(1.+im(:),in)),CoeffD(hpointer(1.*im(:),in))),1);  
       else
           %    static contributions
          By(itheta,iphi,in)=A*sum(diffphi(in,1.*im(:),Phi(iphi),Pnm(2:(in+1),1.*itheta(:),in)...
          ,CoeffS(gpointer(1.+im(:),in)-440),CoeffS(hpointer(1.*im(:),in)-440)),1);%   gpointerL-440 and hpointerL-440 acount for considered values only from n=21
       end% IF statement differentiate n greater than 21 and se. than 20
   end% FOR loop over all phi
end% PARFOR loop over all n
 ByFL=sum(By(:,:,:),3);
end% FUNCTION