function [BxFL]=CalcBxFL(dPnm,CoeffS,CoeffD,Theta,Phi,sizTheta,sizPhi,NminL,NmaxL,gpointer,hpointer,A,R)
%CalcBxFL calculates the crustal contribution to the x-component of
%Earth's magnetic field.
%   
%   INPUT:
%       dPnm:   array of theta derivatives of Schmidt normalised associated
%               Legendre polynomials. It is given as a 3 dimensional array.
%     CoeffS:   array containining static Gaussian coefficients from the
%               LCS-1 crustal magnetic field model
%     CoeffD:   array fcontaining dynamic time dependent 
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
%    BxFLnew:   2-D array containing values of x-component of crustal
%               contribution to the magnetic field at all positions of the
%               grid.
%
%   WHAT IT DOES:
%               After initial formulation of the derivative with respect to
%               theta as an anonynmous function a parallel for-loop

itheta=1:sizTheta;
difftheta=@(N,M,PHI,DPNM,G,H) (A/R)^(N+1).*(cos(PHI.*M).*G+sin(PHI.*M).*H).*(DPNM/R);%
Bx=zeros(sizTheta,sizPhi,NmaxL-NminL);

parfor in=NminL:NmaxL
   im=1:in;
   for iphi=1:sizPhi
       if in<21
           %    time-dependent contributions
           Bx(itheta,iphi,in)=A*(difftheta(in,0,Phi(iphi),dPnm(1,itheta(:),in),CoeffD(gpointer(1,in)),0)...
                              +sum(difftheta(in,1.*im(:),Phi(iphi),dPnm(2:(in+1),itheta(:),in),CoeffD(gpointer(1.+im(:),in)),CoeffD(hpointer(1.*im(:),in))),1));
       else
           %    static contributions
            Bx(itheta,iphi,in)=A*(difftheta(in,0,Phi(iphi),dPnm(1,itheta(:),in),CoeffS(gpointer(1,in)-440),0)...%     gpointerL-440 provides correction for considered values only after n=21
            +sum(difftheta(in,1.*im(:),Phi(iphi),dPnm(2:(in+1),itheta(:),in),CoeffS(gpointer(1.+im(:),in)-440),CoeffS(hpointer(1.*im(:),in)-440)),1));%   hpointerL-440 provides correction for considered values only after n=21
       end% IF statement differentiate n g. than 21 and se. than 20
   end% FOR loop over all phi
end% PARFOR loop over all n
 BxFL=sum(Bx(:,:,:),3);
end% FUNCTION


