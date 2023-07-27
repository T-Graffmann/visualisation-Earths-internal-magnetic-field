function convert_chaos_outputValidation(outputname)
%%% CONVERT CHAOS OUTPUT ROUTINE %%%

%   load file
output=table2array(readtable(outputname));

%   set up variables
LatCHAOS=output(:,3);
LonCHAOS=output(:,4);
LatCHAOS_array=-1.*reshape(LatCHAOS,[720,360])-90;
LonCHAOS_array=reshape(LonCHAOS,[720,360])-180;
B_rCrust=output(:,8);
B_thetaCrust=output(:,9);
B_phiCrust=output(:,10);
B_rCrustCHAOS_array=reshape(B_rCrust,[720,360]);
B_thetaCrustCHAOS_array=reshape(B_thetaCrust,[720,360]);
B_phiCrustCHAOS_array=reshape(B_phiCrust,[720,360]);

%   safe files
writematrix(B_phiCrustCHAOS_array,'By_Crust_CHAOS.dat');
writematrix(B_rCrustCHAOS_array,'Bz_Crust_CHAOS.dat');
writematrix(B_thetaCrustCHAOS_array,'Bx_Crust_CHAOS.dat');
writematrix(LonCHAOS_array,'Long_Crust_CHAOS.dat');
writematrix(LatCHAOS_array,'Lati_Crust_CHAOS.dat');

end
%BtotalCrustCHAOS=totalF(table2array(readtable('BxCrustCHAOS.dat'))',table2array(readtable('ByCrustCHAOS.dat'))',table2array(readtable('BzCrustCHAOS.dat'))');