function [Variance,Standard_Deviation,Geo_mean]= CalcVarStanDev(DATA)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
DATA=table2array(readtable(DATA));
DATA_size=size(DATA,1)*size(DATA,2);
DATA_sum=sum(sum(DATA,1),2);
DATA_avg=DATA_sum/DATA_size;
DATA_var_dist=(DATA-DATA_avg).^2;
Variance=sum(sum(DATA_var_dist,1),2)/DATA_size;
Standard_Deviation=sqrt(Variance);
Geo_mean=(prod(DATA,'all'))^(1/DATA_size);
end