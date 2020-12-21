function E = AA_SS( M, x, y, kappa, seed)
%RF energy available at location (x,y) under the CSI-free WET schemes AA-SS_minVar 
%and AA-SS_maxE analyzed in [REF]

%% Input parameters:
% M    -> Number of Tx Antennas in the PB  (scalar)
% x, y -> (x,y) coordinates of EH devices' positions with respect to the PB
%         Each x and y can be equal-size vectors       
% kappa-> LOS factor of the Rician quasi-static fading model (scalar)
% seed -> seed for random number generation (scalar)

%% Output parameters:
% E    -> [2xN] RF energy available at each of the N EH devices. First row 
%         corresponds to AA-SS_minVar scheme, while second row to AA-SS_maxE     

%% Main code
N = length(x);    % number of EH devices. N=length(x)=length(y)
ang = atan(x./y); % angular position of each EH device
beta = channel_path_loss(x, 0, y, 0); % path loss of the channel between the 
                                      % EH devices and the PB (at (0,0))

rand('seed',seed)     % set the seed for random number generation
                      % it allows reproducibility and fair comparisson of
                      % results

Hnlos = sqrt(1/(2*(1+kappa)))*(randn(N,M)+1i*randn(N,M)); % NLOS Rician channel

% LOS Rician channel for ULA without any preventive phase shift
Hlos_AA_SS_minVar = sqrt(kappa/(1+kappa))*exp(-1i*pi*repmat(0:(M-1),N,1).*sin(repmat(ang',1,M)));

% LOS Rician channel for ULA with a preventive phase shift of [0 pi 0 pi 0 ....]
phase = pi*mod(0:M-1,2);
Phase = repmat(phase,N,1);
Hlos_AA_SS_maxE = sqrt(kappa/(1+kappa))*exp(1i*(-pi*repmat(0:(M-1),N,1).*sin(repmat(ang',1,M))+Phase));    

% Instantaneous channel realizations
H_AA_SS_minVar = Hnlos + Hlos_AA_SS_minVar;
H_AA_SS_maxE = Hnlos + Hlos_AA_SS_maxE;

% RF Energy available at each EH under the AA-SS_minVar and AA-SS_maxE schemes
% (first and second row vectors, respectively)
E = [abs(sum(sqrt(repmat(beta',1,M)).*H_AA_SS_minVar,2)').^2; abs(sum(sqrt(repmat(beta',1,M)).*H_AA_SS_maxE,2)').^2]/M;

%% References:
% [REF]    - O. L. A. López, et al., "On CSI-free Multi-Antenna Schemes for 
%          Massive RF Wireless Energy Transfer," in IEEE Internet of Things 
%          Journal, doi: 10.1109/JIOT.2020.3003114.
