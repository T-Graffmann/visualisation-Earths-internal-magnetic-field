function DISPLAY(Lat,Long,DATA,CustomColormap,region)
%DISPLAY function that creates a projection of the entire earth's surface
%with costalines displayed for orientation
%   
%   INPUT:
%       Lat:    array containing latitude values
%       Long:   array containing longitude values
%       DATA:   array containing grid of magnetic data
%       coastlon:   array containing longitudal values of coastlines
%       coastlat:   array containing latitudal values of coastlines
%       Zero:   array of zeros with size of phi theta grid pushing
%               intensities into the background
%       titlestring:    string containing title of specific display
%       CustomColormap: string denoting used colormap PlusMinus for
%                       displays with both positive and negative values and
%                       Plus for those with only positive values
%       CLIMmax:    Highest value for this quantity
%       CLIMmin:    lowest value for visualised quantity
% 
% The usage of DATA allows for a wide range of data being visualised through this function
%   
%   see also: worldmap,geoshow


load coastlines;

%   predetermine picturename for saving %
    picturename=extractBefore(string(DATA),".");

%   Determine titlestring   %

if contains(DATA,'Bx_diff')==1
    titlestring='northward difference in %';
elseif contains(DATA,'Bx')==1
    titlestring='Intensity along longitude in [nT]';
elseif contains(DATA,'By_diff')==1
    titlestring='eastward difference in %';
elseif contains(DATA,'By')==1
    titlestring='Intensity along latitude in [nT]';
elseif contains(DATA,'Bz_diff')==1
    titlestring='vertical difference in %';
elseif contains(DATA,'Bz')==1
    titlestring='Vertical intensity in [nT]';
elseif contains(DATA,'Bhor_diff')==1
    titlestring='horizontal difference in %';
elseif contains(DATA,'Bhor')==1
    titlestring='Horizontal intensity in [nT]';
elseif contains(DATA,'Btotal_diff')==1
    titlestring='total field difference in %';
elseif contains(DATA,'Btotal')==1
    titlestring='Total field intensity in [nT]';
elseif contains(DATA,'Ic')==1
    titlestring='Inclination in [°]';
elseif contains(DATA,'Dc')==1
    titlestring='Declination in [°]';
else
    error('Meese not liky dis name!');
end% IF statement

%   load Long and Lat   %
Lat=table2array(readtable(Lat));
Long=table2array(readtable(Long));
%   create zeros array  %
Zero=zeros(size(Long,2),size(Lat,1));  % matrix of zeroes to push displayed intensities into the background

%   load data and generate limits %

DATA=table2array(readtable(DATA));
ClimMin=min(DATA,[],'all');
ClimMax=max(DATA,[],'all');
%   georeferencing data
DATAgeoref=DATA;
%DATAgeoref=[DATA(:,ceil(size(DATA,2)/2):size(DATA,2)) DATA(:,1:floor(size(DATA,2)/2))];

if ClimMin>=0
    limits=[ClimMin ClimMax];
elseif abs(ClimMin)>abs(ClimMax)
    ClimMax=abs(ClimMin);
    limits=[ClimMin ClimMax];
else
    ClimMin=-ClimMax;
    limits=[ClimMin ClimMax];
end% IF statement

%   generate display    %

    figure;
    LoadColorMap=append(CustomColormap,'.mat');
    load(LoadColorMap);
    custom=eval(CustomColormap);
    axesm robinson
    worldmap(region)
    geoshow(Lat,Long,DATAgeoref,'DisplayType','texturemap','CData',DATAgeoref,'ZDATA',Zero)
    colormap(custom)
   % limits=[-20 20];
    clim(limits)
    shading 'flat'
    cb=colorbar('southoutside');
    cb.XLabel.String=titlestring;
    geoshow(coastlat,coastlon,'Color','black')
    
    %   save picture    %
    saveas(gcf,picturename,'epsc');
    saveas(gcf,picturename,'png');

    clear all;
    close all;
end% FUNCTION