%This script allows generating a figure similar to [REF, Fig.12]

%% System parameters
S = 1e3;      %Number of Monte Carlo runs
Q = 8;        %Number of PB antennas
N = 16;       %Number of EH devices
R = 20;       %Radius of the circular area where the EH devices are deployed 

Kappa_dB = -10:5:30;         %LOS factor (in dB) of the Rician fading
Kappa = 10.^(Kappa_dB./10);

%% Main section of the code script
for j = 1:length(Kappa)    
    kappa = Kappa(j);             %For each LOS factor
   
    %Random deployment
    d = R*sqrt(rand(1,N));
    a = 2*pi*rand(1,N);

    % (x,y) coordinate of each EH device and distance with respect to
    % area center 
    x = d.*cos(a);
    y = d.*sin(a);    
        
    for i=1:S      %For each Monte Carlo run      
        [j i]      %To follow the running progress in the command window
        
        FullCSI(i,j) = min(single_PB( Q, N, x, y, kappa, i, 1 ));  %full-CSI -based beamforming        
        AveCSI(i,j) = min(single_PB( Q, N, x, y, kappa, i, 0 ));   %LOS-CSI (average CSI) -based beamforming
    end
end

%Average over all the Monte Carlo runs. Results are expressed in dBm
fCSI = 10*log10(mean(FullCSI))+30;
aCSI = 10*log10(mean(AveCSI))+30;


%% Figure generation
figure
set(gcf, 'Units', 'centimeters'); 
axesFontSize = 16;
legendFontSize = 16;
afFigurePosition = [2 7 19 12]; 
set(gcf, 'Position', afFigurePosition,'PaperSize',[18 8],'PaperPositionMode','auto'); 

plot(Kappa_dB, fCSI,'-ok','MarkerSize',6,'LineWidth',2.5)
hold on
plot(Kappa_dB, aCSI,'-sk','MarkerSize',6,'LineWidth',2.5)
hold on


xlabel('$\kappa$ (dB)','Interpreter', 'latex','fontsize',axesFontSize)
ylabel('average worst-case RF energy (dBm)','Interpreter', 'latex','fontsize',axesFontSize)
hl=legend('full CSI EB','LOS-based CSI');
set(hl,'FontSize',legendFontSize,'interpreter','latex')

set(gca,'FontSize',12)
box on
grid on

%% References:
%[REF]    - O. L. A. López, H. Alves, R. D. Souza, S. Montejo-Sánchez, E. Fernández
%          and M. Latva-aho, "Massive Wireless Energy Transfer: Enabling Sustainable
%          IoT Towards 6G Era," in IEEE Internet of Things Journal.
