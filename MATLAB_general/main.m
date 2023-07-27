function main(Nmin,Nmax,r,phistep,thetastep,Year,Month,DayOfMonth)
%Code_Bachelorthesis_TW Function providing a snapshot of earth's magnetic
%field
%   Parameters for call and their meaning:
%       Nmin:   minimum degree n for spherical harmonics calculation
%       Nmax:   maximum degree n for spherical harmonics calculation
%          r:   height of observation from Earth's center in m 
%               (6371.2e3 for reference radius)                                                                                                         
%    phistep:   number of longitudal grid points 
%  thetastep:   number of latitudal grid points
%       Year:   observed year
%      Month:   month of observation
% DayOfMonth:   day of observation withinn that month
%
%
%   WHAT DOES IT DO?:
%   It creates individual displays showing inclination, declination and the
%   magnetic components intensities (phi-component, theta-component,
%   vert.-component) as well as the horizontal and overall intensity of the
%   magnetic field at selected time and height. The data used is provided
%   by Gaussian coefficients located in tables located in the function's
%   folder 
%   
%   The visualisation is generated via the implementation of the mapping
%   toolbox 
%
%   see also worldmap, geoshow.
%
%   as well as: <https://de.mathworks.com/help/map/index.html?s_tid=CRUX_lftnav Mapping Toolbox>




%closes all preexisting figures

close all;
warning("off");
clc;
delete(gcp('nocreate'));%    deletes pool for parallel computing

parpool("threads");%    pool for calculations adjust to fit local system

%%% CHECK FOR CORRECT INPUT %%%
CheckForFeasibleDate(Year,Month,DayOfMonth);

% determine whether CHAOS or IGRF implemented
[differentiator,loadedTable,loadedTable2]=ChooseCHAOSorIGRF(Nmin,Nmax);


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%% Predetermined Coefficients %%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
   

    %   Choose era, year within era and day within said year of observation
    genIGRF=(Year-1900)/5+1;%  determines current observed era in IGRF including current year
    
    %   Gives info regarding radii
    
    a=6371.2e3;%standardised referencing radius
            
    %   predetermine Coastal latitudes and longitudes
    coastlat=[];
    coastlon=[];

    %%%%%%%%%%%%%%%%%% Define gridspaces %%%%%%%%%%%%%%%%%%%
    
    
    Phi =linspace(0,2*pi,phistep);
    Theta =linspace(pi/100,pi-pi/100,thetastep);%  poles are cut off because of division by 0 at poles
    sizTheta=size(Theta,2);
    sizPhi=size(Phi,2);
    
    
      
    function [BxF,ByF,BzF,Bhor,Btotal,Dc,Ic]=calculations(Nmax,Nmin,genIGRF,Year,Month,DayOfMonth,loadedTable,loadedTable2,differentiator,a,r,Phi,Theta,sizTheta,sizPhi)

   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%% sorting algorithm for g and h %%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    [gpointer,hpointer]=ghPointer(Nmax);

    switch differentiator
        case 0
    %   For IGRF
    sizLoadedTable=size(loadedTable);
    Coeff=loadedTable(:,:);
    Coeff=table2array(Coeff(:,4:genIGRF+4));%   causes problems inside another function (declaration of table outside function)   ATTENTION column 3 contains m
    Coeff=TimeDependCoeff(Coeff,Year,Month,DayOfMonth,sizLoadedTable);%   introduces time-dependency to the coefficients and reduces table to relevant columns
        case 1
    %   For static CHAOS-7 data
    
    CoeffL=loadedTable(:,3);
    CoeffL=table2array(CoeffL);

    sizLoadedTable=size(loadedTable2);
    CHAOS_Coeff=loadedTable2(:,:);
    CHAOS_Coeff=table2array(CHAOS_Coeff(:,3:sizLoadedTable(2)));
    CHAOS_Coeff=TimeDependChaosCoeff(CHAOS_Coeff,Year,Month,DayOfMonth);
        case 2
    %   For time dependent CHAOS-7 data
    
    sizLoadedTable=size(loadedTable);
    CHAOS_Coeff=loadedTable(:,:);
    CHAOS_Coeff=table2array(CHAOS_Coeff(:,3:sizLoadedTable(2)));
    CHAOS_Coeff=TimeDependChaosCoeff(CHAOS_Coeff,Year,Month,DayOfMonth);

        otherwise
    end%    SWITCH
    
    %%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%% calculation of Legendre Polynomials and x,y and z components of magn. field %%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
   
    switch differentiator
        case 0
           Pnm=buildPnm(Nmin,Nmax,Theta,sizTheta);%building all associated Legendre polynomials (attention saved in 1 row array)
           dPnm=derPnmNew(Pnm,Nmin,Nmax);%creating theta derivatives of all Schmidt semi-normalised associated Legendre Polynomials and saving them on a 1D array 

           BxF=CalcBxF(dPnm,Coeff,Theta,Phi,sizTheta,sizPhi,Nmin,Nmax,gpointer,hpointer,a,r);
           ByF=CalcByF(Pnm,Coeff,Theta,Phi,sizTheta,sizPhi,Nmin,Nmax,gpointer,hpointer,a,r);
           BzF=CalcBzF(-Pnm,Coeff,Phi,sizTheta,sizPhi,Nmin,Nmax,gpointer,hpointer,a,r);
            
        case 1
           PnmL=buildPnm(Nmin,Nmax,Theta,sizTheta);%building all associated Legendre polynomials (attention saved in 1 row array)
           dPnmL=derPnmNew(PnmL,Nmin,Nmax);%creating theta derivatives of all Schmidt semi-normalised associated Legendre Polynomials and saving them on a 1D array 
            
           BxF=fetchOutputs(parfeval(@CalcBxFL,1,dPnmL,CoeffL,CHAOS_Coeff,Theta,Phi,sizTheta,sizPhi,Nmin,Nmax,gpointer,hpointer,a,r));
           ByF=fetchOutputs(parfeval(@CalcByFL,1,PnmL,CoeffL,CHAOS_Coeff,Theta,Phi,sizTheta,sizPhi,Nmin,Nmax,gpointer,hpointer,a,r));
           BzF=fetchOutputs(parfeval(@CalcBzFL,1,-PnmL,CoeffL,CHAOS_Coeff,Phi,sizTheta,sizPhi,Nmin,Nmax,gpointer,hpointer,a,r));
       
        case 2
           Pnm=buildPnm(Nmin,Nmax,Theta,sizTheta);
           dPnm=derPnmNew(Pnm,Nmin,Nmax);
 
           BxF=CalcBxF(dPnm,CHAOS_Coeff,Theta,Phi,sizTheta,sizPhi,Nmin,Nmax,gpointer,hpointer,a,r);
           ByF=CalcByF(Pnm,CHAOS_Coeff,Theta,Phi,sizTheta,sizPhi,Nmin,Nmax,gpointer,hpointer,a,r);
           BzF=CalcBzF(-Pnm,CHAOS_Coeff,Phi,sizTheta,sizPhi,Nmin,Nmax,gpointer,hpointer,a,r);
           
    end%    SWITCH

    
             
    %%


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculate horizontal, total Field intensity, Decl. and Incl. %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %   calculate total field intensity
    Btotal=totalF(BxF,ByF,BzF);

    %   calculate horizontal field intensity
    Bhor=Bhorizontal(BxF,ByF);

    %   Calculation for declination (Dc) and inclination (Ic)
    Dc=atan(ByF./sqrt((BxF).^2+(ByF).^2))*180/pi;
    Ic=atan(BzF./sqrt((BxF).^2+(ByF).^2))*180/pi;
    end%    CALCULATIONS FUNCTION
    %   CALL for function function [BxF,ByF,BzF,Bhor,Btotal,Dc,Ic]=calculations(Nmax,Nmin,genIGRF,tygenIGRF,Year,Month,DayOfMonth,tday,loadedTable,loadedTable2,differentiator,a,r,Phi,Theta,sizTheta,sizPhi)
    [BxF,ByF,BzF,Bhor,Btotal,Dc,Ic]=calculations(Nmax,Nmin,genIGRF,Year,Month,DayOfMonth,loadedTable,loadedTable2,differentiator,a,r,Phi,Theta,sizTheta,sizPhi);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%% create displays %%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    


    %   general data for the display
    X=(Phi-pi)*180/pi;
    Y=(Theta-pi/2)*180/pi;

    %   get min and max data for clims in displays (provides the specific limits for each respective colorbar)
    %   [],'all' specifies search for single value over all dimensions of
    %   the array

    DcMax=max(Dc,[],'all'); DcMin=min(Dc,[],'all');
    IcMax=max(Ic,[],'all'); IcMin=min(Ic,[],'all');
    BxMax=max(BxF,[],'all'); BxMin=min(BxF,[],'all');
    ByMax=max(ByF,[],'all'); ByMin=min(ByF,[],'all');
    BzMax=max(BzF,[],'all'); BzMin=min(BzF,[],'all');
    BhMax=max(Bhor,[],'all'); BhMin=min(Bhor,[],'all');
    BtMax=max(Btotal,[],'all'); BtMin=min(Btotal,[],'all');
    
    %create data for geospatial referencing

    %   Lon-Lat raster for world display 
    XLon=repelem(X,length(Y),1);    % Longitude for georeferencing derived from X
    YLat=repelem(-Y.',1,length(X)); % Latitude for georeferencing derived from Y

    Zero=zeros(length(Phi),length(Theta));  % matrix of zeroes to push displayed intensities into the background
    
    load coastlines

    %   DISPLAY: INCLINATION    
    titlestring='Inclination in [°]';
    DISPLAY(YLat,XLon,Ic,coastlon,coastlat,Zero,titlestring,'PlusMinus',IcMax,IcMin)

    %   DISPLAY: DECLINATION
    titlestring='Declination in [°]';
    DISPLAY(YLat,XLon,Dc,coastlon,coastlat,Zero,titlestring,'PlusMinus',DcMax,DcMin)  

    %   DISPLAY: X-COMPONENT FIELD INTENSITY
    titlestring='Intensity along Longitude in [nT]';
    DISPLAY(YLat,XLon,BxF,coastlon,coastlat,Zero,titlestring,'PlusMinus',BxMax,BxMin)  

    %   DISPLAY: Y-COMPONENT FIELD INTENSITY
    titlestring='Intensity along Latitude in [nT]';
    DISPLAY(YLat,XLon,ByF,coastlon,coastlat,Zero,titlestring,'PlusMinus',ByMax,ByMin) 

    %   DISPLAY: Z-COMPONENT FIELD INTENSITY
    titlestring='vertical Intensity in [nT]';
    DISPLAY(YLat,XLon,BzF,coastlon,coastlat,Zero,titlestring,'PlusMinus',BzMax,BzMin)
    
    %   DISPLAY: HORIZONTAL COMPONENT FIELD INTENSITY
    titlestring='horizontal Intensity in [nT]';
    DISPLAY(YLat,XLon,Bhor,coastlon,coastlat,Zero,titlestring,'Plus',BhMax,BhMin)
    
    %   DISPLAY: TOTAL FIELD INTENSITY
    titlestring='total Intensity in [nT]';
    DISPLAY(YLat,XLon,Btotal,coastlon,coastlat,Zero,titlestring,'Plus',BtMax,BtMin)
    end%    MAIN FUNCTION
