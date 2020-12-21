%This script allows generating a figure similar to [REF, Fig.9]

%% System parameters
S = 500;      %Number of Monte Carlo runs
kappa = 10;   %LOS factor of the Rician quasi-static fading model (scalar)
N=64;         %Number of EH devices
R = 20;       %Radius of the circular area where the EH devices are deployed

MQ = [8 16 24 32]; %Total number of antennas in the system

%% Main section of the code script
for j = 1:length(MQ)   
    mq = MQ(j);               %For each total number of antennas
    
    for i=1:S                 %For each Monte Carlo run
        [j i]                 %To follow the running progress in the command window
        
        %Random deployment
        d = R*sqrt(rand(1,N));
        a = 2*pi*rand(1,N);
        
        % (x,y) coordinate of each EH device and distance with respect to
        % area center 
        x = d.*cos(a);
        y = d.*sin(a);
        
        %Single multi-antenna PB using full-CSI energy beamforming
        Q = mq;
        E_sPB(i,j) = min(single_PB( Q, N,  x, y, kappa, i, 1 ));
        
        %Multiple single-antenna PBs
        M = mq;
        E_mPBs(i,j) = min(single_antenna_PBs( M, N, x, y, R ));        %Random deployment
        E_mPBsO(i,j) = min(single_antenna_PBs_optimized( M, N, x, y ));%Optimized deployment
        
        %Four multi-antenna PBs
        M = 4;
        Q = mq/M;
        E_4MPBs(i,j) = min(multi_antenna_PBs( M, Q,  N, x, y, kappa, i ));
        
        %Eight multi-antenna PBs
        M = 8;
        Q = mq/M;
        E_8MPBs(i,j) = min(multi_antenna_PBs( M, Q,  N, x, y, kappa, i ));
    end
end

%Average over all the Monte Carlo runs. Results are expressed in dBm
sPB = 10*log10(mean(E_sPB))+30;
mPBs = 10*log10(mean(E_mPBs))+30;
mPBsO = 10*log10(mean(E_mPBsO))+30;
e4MPBs = 10*log10(mean(E_4MPBs))+30;
e8MPBs = 10*log10(mean(E_8MPBs))+30;


%% Figure generation
figure
set(gcf, 'Units', 'centimeters'); 
axesFontSize = 16;
legendFontSize = 16;
afFigurePosition = [2 7 19 12]; 
set(gcf, 'Position', afFigurePosition,'PaperSize',[18 8],'PaperPositionMode','auto'); 

plot(MQ, sPB,'-ok','MarkerSize',6,'LineWidth',2.5)
hold on
plot(MQ, mPBs,'--v','Color', [232 112 6]/255 ,'MarkerSize',7,'LineWidth',2.5)
hold on
plot(MQ, mPBsO,'-^','Color',[232 112 6]/255,'MarkerSize',7,'LineWidth',2.5)
hold on
plot(MQ, e4MPBs,'--x','Color',[0.4660 0.6740 0.1880],'MarkerSize',13,'LineWidth',2.5)
hold on
plot(MQ, e8MPBs,'-+','Color',[0.4660 0.6740 0.1880],'MarkerSize',13,'LineWidth',2.5)
hold on

xlim([1 32])
xticks(MQ)

xlabel('total number of antennas, $M$','Interpreter', 'latex','fontsize',axesFontSize)
ylabel('average worst-case RF energy (dBm)','Interpreter', 'latex','fontsize',axesFontSize)
hl=legend('Single PB (EB)','Single-antenna PBs (DAS)','Single-antenna PBs (oDAS)',...
    '4 PBs (EB+oDAS)','8 PBs (EB+oDAS)');
set(hl,'FontSize',legendFontSize,'interpreter','latex')

set(gca,'FontSize',12)
box on
grid on

%% References:
%[REF]    - O. L. A. López, H. Alves, R. D. Souza, S. Montejo-Sánchez, E. Fernández
%          and M. Latva-aho, "Massive Wireless Energy Transfer: Enabling Sustainable
%          IoT Towards 6G Era," in IEEE Internet of Things Journal.