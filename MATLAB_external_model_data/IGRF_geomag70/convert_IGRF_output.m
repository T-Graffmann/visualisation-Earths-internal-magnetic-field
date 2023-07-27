function convert_IGRF_output(output)

%  LOAD OUTPUT TABLE   %

output_table=readtable(output,'ReadVariableNames',false);


%   EXTRACT CONTENT    %

%   extract grid data
LonVec_igrf=table2array(output_table(:,5));
LatVec_igrf=table2array(output_table(:,4));

%   extract field data
DcVec_deg=str2double(extractBefore(string(table2array(output_table(:,6))),'d'));
DcVec_min=str2double(extractBefore(string(table2array(output_table(:,7))),'m'));
IcVec_deg=str2double(extractBefore(string(table2array(output_table(:,8))),'d'));
IcVec_min=str2double(extractBefore(string(table2array(output_table(:,9))),'m'));

BhorVec_igrf=table2array(output_table(:,10));
BxVec_igrf=table2array(output_table(:,11));
ByVec_igrf=table2array(output_table(:,12));
BzVec_igrf=table2array(output_table(:,13));
BtotalVec_igrf=table2array(output_table(:,14));


%   TRANSFORM DATA TO ARRAYS    %

%   transform grid
LonArray_igrf=reshape(LonVec_igrf,[360,720]);
LatArray_igrf=reshape(LatVec_igrf,[360,720]);

%   transform DC and IC
DcVec_igrf=DcVec_deg+DcVec_min/60;
IcVec_igrf=IcVec_deg+IcVec_min/60;
DcArray_igrf=reshape(DcVec_igrf,[360,720]);
IcArray_igrf=reshape(IcVec_igrf,[360,720]);

%   transform rest of data
BxArray_igrf=reshape(BxVec_igrf,[360,720]);
ByArray_igrf=reshape(ByVec_igrf,[360,720]);
BzArray_igrf=reshape(BzVec_igrf,[360,720]);
BhorArray_igrf=reshape(BhorVec_igrf,[360,720]);
BtotalArray_igrf=reshape(BtotalVec_igrf,[360,720]);

%   SAFE AS DAT FILES   %
writematrix(LonArray_igrf,'LonIGRF2022.dat');
writematrix(LatArray_igrf,'LatIGRF2022.dat');
writematrix(DcArray_igrf,'DcIGRF2022.dat');
writematrix(IcArray_igrf,'IcIGRF2022.dat');
writematrix(BxArray_igrf,'BxIGRF2022.dat');
writematrix(ByArray_igrf,'ByIGRF2022.dat');
writematrix(BzArray_igrf,'BzIGRF2022.dat');
writematrix(BhorArray_igrf,'BhorIGRF2022.dat');
writematrix(BtotalArray_igrf,'BtotalIGRF2022.dat');

end%    FUNCTION