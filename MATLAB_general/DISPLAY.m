function DISPLAY(Lat,Long,DATA,coastlon,coastlat,Zero,titlestring,CustomColormap,CLIMmax,CLIMmin)
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

    figure;
    LoadColorMap=append(CustomColormap,'.mat');
    load(LoadColorMap);
    custom=eval(CustomColormap);
    axesm robinson
    worldmap('world')
    DATAgeoref=[DATA(:,ceil(size(DATA,2)/2):size(DATA,2)) DATA(:,1:floor(size(DATA,2)/2))];
    geoshow(Lat,Long,DATAgeoref,'DisplayType','texturemap','CData',DATAgeoref,'ZDATA',Zero)
     if CLIMmin>=0
         limits=[CLIMmin CLIMmax];
     elseif abs(CLIMmin)>abs(CLIMmax)
         CLIMmax=abs(CLIMmin);
         limits=[CLIMmin CLIMmax];
     else
         CLIMmin=-CLIMmax;
         limits=[CLIMmin CLIMmax];
     end% IF statement
    colormap(custom)
    limits=[CLIMmin CLIMmax];
    clim(limits)
    shading 'flat'
    cb=colorbar('southoutside');
    cb.XLabel.String=titlestring;
    geoshow(coastlat,coastlon,'Color','black')
end% FUNCTION