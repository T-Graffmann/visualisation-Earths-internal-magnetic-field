Nmax=185;
n=1:1:Nmax;
a=6371*10^3;
r=a+0;%   400 metres above reference radius (roughly Freiberg?)
[gpointer,hpointer]=ghPointer(Nmax);

%   load in time-dependent CHAOS coefficients
    loadedTable=readtable('TimeDepCoeffCHAOS.txt', 'ReadVariableNames',false);
    sizLoadedTable=size(loadedTable);
    CHAOS_Coeff=loadedTable(:,:);
    CHAOS_Coeff_TimeDep=table2array(CHAOS_Coeff(:,:));
    CHAOS_Coeff_TimeDep=TimeDependChaosCoeff(CHAOS_Coeff_TimeDep,2020,01,01);
    
%   load in static CHAOS coefficients
    loadedTable1=readtable('LithosGH.txt','ReadVariableNames',false);
    sizLoadedTable1=size(loadedTable1);
    CHAOS_Coeff_Stat=loadedTable1(:,:);
    CHAOS_Coeff_Stat=table2array(CHAOS_Coeff_Stat(:,3));

%   load IGRF coefficients for 2020
    loadedTable2=readtable('IGRF13OC-2.xlsx',ReadVariableNames=false);
    sizLoadedtable2=size(loadedTable2);
    IGRF_Coeff=loadedTable2(:,:);
    IGRF_Coeff=table2array(IGRF_Coeff(:,28));

%   Calculate power spectrum of CHAOS 1:Nmax
    for in=1:20
        img=2:in+1;
        imh=1:in;
        CoeffSum=( CHAOS_Coeff_TimeDep(gpointer(1,in),1)^2+ ...
                 sum(CHAOS_Coeff_TimeDep(gpointer(img(:),in),1).^2 ...
                 + CHAOS_Coeff_TimeDep(hpointer(imh(:),in),1).^2,1) );
        RnCHAOSgen(in)=(in+1)*(r/a)^(2*in+4)*CoeffSum;
    end
    if Nmax>20
        for in=21:Nmax
            img=2:in+1;
            imh=1:in;
            CoeffSum=( CHAOS_Coeff_Stat(gpointer(1,in)-439,1)^2+ ...
                     sum( CHAOS_Coeff_Stat(gpointer(img(:),in)-439,1).^2+ ...
                     CHAOS_Coeff_Stat(hpointer(imh(:),in)-440,1).^2,1) );
            RnCHAOSgen(in)=(in+1)*(r/a)^(2*in+4)*CoeffSum;
        end
    end


 %  Calculate power spectrum LCS-1
    if Nmax>21
        for in=21:Nmax
           img=2:in+1;
           imh=1:in;
           CoeffSum=( CHAOS_Coeff_Stat(gpointer(1,in)-439,1)^2+ ...
                    sum( CHAOS_Coeff_Stat(gpointer(img(:),in)-439,1).^2+ ...
                    CHAOS_Coeff_Stat(hpointer(imh(:),in)-440,1).^2,1) );
           RnLCS(in-20)=(in+1)*(r/a)^(2*in+4)*CoeffSum;
        end
    end


 %  Calculate power spectrum IGRF-13
    if Nmax>13
       Nmax=13;
    end
    for in=1:Nmax
       img=2:in+1;
       imh=1:in;
       CoeffSum=( IGRF_Coeff(gpointer(1,in),1)^2+ ...
                sum( IGRF_Coeff(gpointer(img(:),in),1).^2+ ...
                IGRF_Coeff(hpointer(imh(:),in),1).^2,1) );
       RnIGRF(in)=(in+1)*(r/a)^(2*in+4)*CoeffSum;
    end

 %  anjust to nT
    RnIGRF(:)=(RnIGRF(:).*10^(-6))';
    RnLCS(:)=(RnLCS(:).*10^(-6))';
    RnCHAOSgen(:)=(RnCHAOSgen(:).*10^(-6))';

%   Visualisation
    figure('Name','Power spectrum Rn',NumberTitle='off');
    xlim([0 185]);
    PlotR=semilogy(n(1:185),RnCHAOSgen(1:185), ...
                   n(21:185),RnLCS, ...
                   n(1:13),RnIGRF,'LineWidth',2.5);
%   PlotR2=plot(n(1:185),Rn(1:185)/(10^6),'LineWidth',2.5);
    set(PlotR(2),'LineStyle',':');
    set(PlotR(3),'LineStyle','--');
    set(gca,'FontName','SanSerif','FontSize',24)
    set(gca,'yscale','log');
    xlabel('$n$','Interpreter','latex');
    grid on;
    ylabel('$R(n)$ in nT','Interpreter','latex');
    legend({'Power spectrum for CHAOS-model','Power spectrum for LCS-1 model','Power spectrum for IGRF-13 model'},'Interpreter','latex');
%     print('PowerspectrumLogarithmic.eps','-depsc');
%     print('PowerspectrumLogarithmic.jpg', 'djpeg');

    