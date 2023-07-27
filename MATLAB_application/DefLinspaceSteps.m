function [MaxStepAmount,NmaxGENmin] = DefLinspaceSteps(Nmin,Nmax)
%DefLinSpaceSteps defines the maximum amounts of steps providing data
%depending on Nmax. Also includes the test for Nmax>=Nmin
% 
%  INPUT:
%   Nmax: maximum degree n for spherical harmonic expansion
%   Nmin: minimum degree n for spherical harmonics considered in the
%         visualisation
%  OUTPUT:
%   MaxStepAmount: Maximum amount of steps defining the linspaces of theta and phi
%                  beyond which a denser grids do not yield additional
%                  visualised data
%   NmaxGENmin:    Boolean value returning 1 for cases in which further
%                  computation is feasible. It relays the information
%                  whether the highest considered n is greater or equal the
%                  lowest.
%   WHAT IT DOES:
%          Based on Nmax this function in a first step calculates wave
%          number WavNum for the highest term of the spherical harmonic
%          expansion from that the point density PointDens is calculated
%          according to the sampling theorem although as the maximum degree
%          of theta is limited to 180° the term is adapted from 1/2k to 1/k
%          Its inverse gives the highest sensible amount of theta steps, 
%          called MaxStepAmount. To account for steps being defined as
%          natural numbers, ceil(MaxStepAmount) returns the actual used
%          amount of steps in the grid.
%          Additionally this function also generates a boolean, testing
%          whether user input is actually feasible.

%   calculate minimal data point density accord. to sampling theorem
WavNum=sqrt(Nmax*(Nmax+1));
PointDens=(pi)/WavNum;
MaxStepAmount=pi/PointDens;
MaxStepAmount=ceil(MaxStepAmount);

%   Determine whether Nmax is greater than or equal Nmin
NmaxGENmin=true(Nmax>=Nmin);

end% FUNCTION