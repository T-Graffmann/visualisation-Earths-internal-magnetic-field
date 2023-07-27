function [gpointer,hpointer] = ghPointer(Nmax)
% ghPointer creates 2 arrays of numbers giving the position of g and h in
% a squential list corresponding to their n an order m
% 
%   Parameters and their meaning:
%   INPUT:
%           Nmax:   maximum of chosen range of degrees n
%   OUTPUT:
%       gpointer:   array containing all sequentail positions for g until
%                   g of Nmax and corresponding Mmax
%       hpointer:   array containing all sequential positions for h until h
%                   of Nmax and corresponding Mmax
%   WHAT IT DOES:
%   It creates arrays for g and h where the degree n is given by the row
%   and order m is given by the column where the coefficient is located.
%   For g m=0 is realised by treating the column position as m+1

gpointer=zeros(Nmax,Nmax);
hpointer=zeros(Nmax,Nmax);

for in=1:Nmax
    im=1:in;
    inc=0:(in-1);

    gpointer(1,in)=sum(1.+inc)+sum(1.*inc);
    gpointer(im+1,in)=sum(1.+inc)+sum(1.*inc)+1.*im+(1.*im-1);
    
    hpointer(im,in)=sum(1.+inc)+sum(1.*inc)+1.*im+(1.*im-1)+1;
end%    FOR loop
end%    FUNCTION