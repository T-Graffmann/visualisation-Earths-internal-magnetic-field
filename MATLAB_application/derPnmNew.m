function dPnm = derPnmNew(Pnm,Nmin,Nmax)
%function to create the derivative of the associated Legendre polynomials
%the derivation is achieved through application of recursive formulas
%taken from the Matlab code for the CHAOS-5 model
%
%   INPUT:  
%        Pnm:   array of Schmidt normalised associated Legendre
%               polynomials. It is given as a 3 dimensional array.
%       Nmin:    smallest visualised n
%       Nmax:    larges visualised n
%  OUTPUT:
%       dPnm:   array of theta derivatives of Schmidt normalised associated
%               Legendre polynomials. It is generated as a 3 dimensional
%               array.
%
%   WHAT IT DOES:

dpzz=0;%derivative of Pnm for n and m equal 0

dpoo=@(theta)cos(theta);%derivative of Pnm for n and m both equal 1

dpnn=@(theta,P1,P2,n,m) sqrt(1-1/(2*n))*(sin(theta)*P1+cos(theta)*P2);%with P1=dpnn(n-1,n-1) P2=pnn(n-1,n-1) 

dpnm=@(theta,P1,P2,P3,n,m) (2*n-1)/sqrt(n^2-m^2)*(cos(theta)*P1-sin(theta)*P2)...
    -sqrt(((n-1)^2-m^2)/(n^2-m^2))*P3;%with P1=dpnm(n-1,m) P2=Pnm(n-1,m) and P3=dpnm(n-2,m) 

for in=Nmin:Nmax
     dPnm(in+1,:,in)=(sqrt(in/2).*Pnm(in,:,in));%for m=n
     dPnm(1,:,in)=-sqrt(in*(in+1)/2).*Pnm(2,:,in);%for m=0 (org. -sqrt(in*(in+1)/2.) weird)
     
     if in>1
        dPnm(2,:,in)=(sqrt(2*(in+1)*in).*Pnm(1,:,in)-sqrt((in+2)*(in-1)).*Pnm(3,:,in))/2;
     end% IF statement for m=1 and n>1
     for im=2:in-1
         dPnm(im+1,:,in)=(sqrt((in+im)*(in-im+1)).*Pnm(im,:,in)-sqrt((in+im+1)*(in-im)).*Pnm(im+2,:,in))/2;%m=2...n-1
     end% FOR loop for m in [2,n-1]
     if in==1
        dPnm(2,:,in)=sqrt(2)*dPnm(2,:,in);
     end% IF statement for m=1 and n=1
end% FOR loop over all n
end% FUNCTION