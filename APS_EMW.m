function E = APS_EMW( M, x, y, kappa, seed)
%RF energy available at location (x,y) under the CSI-free WET scheme APS-EMW in [REF]

%% Input parameters:
% M    -> Number of Tx Antennas in the PB  (scalar)
% x, y -> (x,y) coordinates of EH devices' positions with respect to the PB
%         Each x and y can be equal-size vectors       
% kappa-> LOS factor of the Rician quasi-static fading model (scalar)
% seed -> seed for random number generation (scalar)

%% Output parameters:
% E    -> 1xN RF energy available at each of the N EH devices.

%% Main code
N = length(x);    % number of EH devices. N=length(x)=length(y)
ang = atan(x./y); % angular position of each EH device
beta = channel_path_loss(x, 0, y, 0); % path loss of the channel between the 
                                      % EH devices and the PB (at (0,0))

rand('seed',seed)     % set the seed for random number generation
                      % it allows reproducibility and fair comparisson of
                      % results
                      
Hnlos = sqrt(1/(2*(1+kappa)))*(randn(N,M)+1i*randn(N,M));  % NLOS Rician channel
Hlos = sqrt(kappa/(1+kappa))*exp(-1i*pi*repmat(0:(M-1),N,1)...
    .*sin(repmat(ang',1,M)));  % LOS Rician channel for ULA 
H = Hnlos + Hlos;              % Instantaneous channel realizations

% RF Energy available at each EH under the APS-EMW CSI-free WET scheme
E = abs(sum(repmat(sqrt(beta)'.*randn(N,1),1,M).*H.*exp(1j*rand(N,M)*2*pi),2)).^2/M;

%% References:
%[REF]    - B. Clerckx and J. Kim, "On the Beneficial Roles of Fading and 
%         Transmit Diversity in Wireless Power Transfer With Nonlinear Energy
%         Harvesting," in IEEE Transactions on Wireless Communications, vol. 17,
%         no. 11, pp. 7731-7743, Nov. 2018, doi: 10.1109/TWC.2018.2870377.