function E = SA( M, x, y, kappa, seed)
%This function computes the RF energy available at location (x,y) under the 
%CSI-free WET scheme SA in [REF1] and [REF2]

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
                      
Hnlos = sqrt(1/(2*(1+kappa)))*(randn(1,M)+1i*randn(1,M)); % NLOS Rician channel
Hlos = sqrt(kappa/(1+kappa))*exp(-1i*pi*repmat(0:(M-1),N,1)...
    .*sin(repmat(ang',1,M)));  % LOS Rician channel for ULA 
H = Hnlos + Hlos;              % Instantaneous channel realizations

% RF Energy available at each EH under the AA-IS CSI-free WET scheme
E = beta'.*abs(H).^2/M;

%% References:
% [REF1]    - O. L. A. López, et al., "Statistical Analysis of Multiple Antenna
%             Strategies for Wireless Energy Transfer," in IEEE Transactions on 
%             Communications, vol. 67, no. 10, pp. 7245-7262, Oct. 2019.
% [REF2]    - O. L. A. López, et al., "On CSI-free Multi-Antenna Schemes for 
%             Massive RF Wireless Energy Transfer," in IEEE Internet of Things 
%             Journal, doi: 10.1109/JIOT.2020.3003114.