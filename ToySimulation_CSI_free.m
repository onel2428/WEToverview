%This script allows generating a figure similar to [REF1, Fig.13]
%With the output data here, one can also generate a figure similar to [REF1, Fig.14]

%% System parameters
S = 1e3;      %Number of Monte Carlo runs
M = 4;        %Number of PB antennas
kappa = 10;   %LOS factor of the Rician quasi-static fading model (scalar)
R = 10;       %Radius of the circular area where the EH devices are deployed

%EH circuit parameters
sensitivity = 10.^((-22-30)/10); %-22dBm
saturation = 10.^((-8-30)/10);   %-8dBm
efficiency = 0.35;               %35%

%% Main section of the code script
% (xi,yi) are the coordiantes of the point in the area where the energy is
% measured via simulation

r=1;
for xi = -R:0.2:R    
    c=1;
    %(r,c) if the unitless point coordinates to be stored in a matrix
    for yi = -R:0.2:R        
        %For (xi,yi):
        
        for i=1:S            %For each Monte Carlo run
            
           aa = AA_SS( M, xi, yi, kappa, i);     %RF energy available when using AA-SS schemes [REF2]
           aass_0(i) = EH_transfer_function(aa(1), sensitivity,...
               saturation,efficiency);           %Harvested energy when using AA-SS_minVar scheme [REF2]
           aass_1(i) = EH_transfer_function(aa(2), sensitivity,...
               saturation,efficiency);           %%Harvested energy when using AA-SS_maxE scheme [REF2]
            
           %Harvested energy when using AA-IS scheme [REF2]
           aais(i) = EH_transfer_function(AA_IS( M, xi, yi, kappa, i), sensitivity,saturation,efficiency);
           
           esa = SA( M, xi, yi, kappa, i);        %RF energy available in each time slot when using SA schemes [REF3]
           sa(i) = sum(EH_transfer_function(esa, sensitivity,...
               saturation,efficiency));           %Harvested energy when using SA scheme
            
           %Harvested energy when using APS-EMW scheme [REF4]
           aps(i) = EH_transfer_function(APS_EMW( M, xi, yi, kappa, i), sensitivity,saturation,efficiency);            
        end   
        
        %Average over all the Monte Carlo runs. Results are expressed in dBm
        AASS_0(r,c)=10*log10(mean(aass_0))+30;
        AASS_1(r,c)=10*log10(mean(aass_1))+30;
        AAIS(r,c)=10*log10(mean(aais))+30;
        SAs(r,c)=10*log10(mean(sa))+30;
        APS(r,c)=10*log10(mean(aps))+30;     
        
        c=c+1;
    end
    r=r+1;
end



%% Figures generation
%Fig1
figure
set(gcf, 'Units', 'centimeters'); 
afFigurePosition = [2 7 11 11]; 
set(gcf, 'Position', afFigurePosition,'PaperSize',[19 11],'PaperPositionMode','auto'); 

imagesc(SAs')
colormap(flipud(hot))
set(gca,'YDir','normal')

set(gca,'XTick',0:10:100)
set(gca,'YTick',0:10:100)
set(gca,'XTickLabel',{'0' '2' '4' '6' '8' '10'},'FontSize',10)
set(gca,'YTickLabel',{'0' '2' '4' '6' '8' '10'},'FontSize',10)

%Fig2
figure
set(gcf, 'Units', 'centimeters'); 
afFigurePosition = [2 7 11 11]; 
set(gcf, 'Position', afFigurePosition,'PaperSize',[19 11],'PaperPositionMode','auto'); 

imagesc(APS')
colormap(flipud(hot))
set(gca,'YDir','normal')

set(gca,'XTick',0:10:100)
set(gca,'YTick',0:10:100)
set(gca,'XTickLabel',{'0' '2' '4' '6' '8' '10'},'FontSize',10)
set(gca,'YTickLabel',{'0' '2' '4' '6' '8' '10'},'FontSize',10)

%Fig3
figure
set(gcf, 'Units', 'centimeters'); 
afFigurePosition = [2 7 11 11]; 
set(gcf, 'Position', afFigurePosition,'PaperSize',[19 11],'PaperPositionMode','auto'); 

imagesc(AASS_0')
colormap(flipud(hot))
set(gca,'YDir','normal')

set(gca,'XTick',0:10:100)
set(gca,'YTick',0:10:100)
set(gca,'XTickLabel',{'0' '2' '4' '6' '8' '10'},'FontSize',10)
set(gca,'YTickLabel',{'0' '2' '4' '6' '8' '10'},'FontSize',10)

%Fig4
figure
set(gcf, 'Units', 'centimeters'); 
afFigurePosition = [2 7 12 11]; 
set(gcf, 'Position', afFigurePosition,'PaperSize',[19 11],'PaperPositionMode','auto'); 

imagesc(AASS_1')
colormap(flipud(hot))
set(gca,'YDir','normal')

set(gca,'XTick',0:10:100)
set(gca,'YTick',0:10:100)
set(gca,'XTickLabel',{'0' '2' '4' '6' '8' '10'},'FontSize',10)
set(gca,'YTickLabel',{'0' '2' '4' '6' '8' '10'},'FontSize',10)


%% References:
%[REF1]    - O. L. A. López, H. Alves, R. D. Souza, S. Montejo-Sánchez, E. Fernández
%          and M. Latva-aho, "Massive Wireless Energy Transfer: Enabling Sustainable
%          IoT Towards 6G Era," in IEEE Internet of Things Journal.
%[REF2]    - O. L. A. López, et al., "On CSI-free Multi-Antenna Schemes for 
%          Massive RF Wireless Energy Transfer," in IEEE Internet of Things 
%          Journal, doi: 10.1109/JIOT.2020.3003114.
%[REF3]    - O. L. A. López, et al., "Statistical Analysis of Multiple Antenna
%          Strategies for Wireless Energy Transfer," in IEEE Transactions on 
%          Communications, vol. 67, no. 10, pp. 7245-7262, Oct. 2019.
%[REF4]    - B. Clerckx and J. Kim, "On the Beneficial Roles of Fading and 
%          Transmit Diversity in Wireless Power Transfer With Nonlinear Energy
%          Harvesting," in IEEE Transactions on Wireless Communications, vol. 17,
%          no. 11, pp. 7731-7743, Nov. 2018, doi: 10.1109/TWC.2018.2870377.