function [phistep,thetastep] = DefLinspaceSteps(stepAmount,Nmax)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%   calculate minimal data point density accord. to sampling theorem
WavNum=sqrt(Nmax*(Nmax+1));
PointDens=1/(1*WavNum);

%   compare stepsizes
if stepAmount>PointDens
    phistep=PointDens;
    thetastep=PointDens;
end
end