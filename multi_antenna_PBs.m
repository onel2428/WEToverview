function E = multi_antenna_PBs( M, Q,  N, x, y, kappa, seed )
%This function works as described in [REF, Section III-B]: Several
%multi-antenna PB are intelligently deployed to serve N EH devices in the
%surroundings via maximum-fairness energy beamforming based on local CSI
%The PBs deployment is based on k-means clustering

%% Input parameters:
% M    -> Number of PBs
% Q    -> Number of antennas per PB
% N    -> Number of EH Devices in the area served by the PBs (scalar)
% kappa-> LOS factor of the Rician quasi-static fading model (scalar)
% seed -> seed for random number generation (scalar)

%% Output parameters:
% E    -> 1xN RF energy available at each EH device (vector)

%% Main code
%Optimizes deployment of PBs using k-means clustering
X = [x' y'];
[idx,C] = kmeans(X,M);

% (x,y) coordinate of each PB with respect to area center
xpb = C(:,1)';
ypb = C(:,2)';

rand('seed',seed)           %Setting the seed for random number generation
Hnlos = sqrt(1/(2*(1+kappa)))*(randn(N,M*Q)+1i*randn(N,M*Q)); %Instantaneous nlos
                                                              %channel realizations

%This code section computes the RF energy provided by each PB to each EH
%device
powerCoef = zeros(1,M);
E = zeros(1,N);
inM = 1;
for j=1:M         %For each PB
    beta = channel_path_loss(x, xpb(j), y, ypb(j));  %Power channel gain of the WET channel 
                                                     %between the j-th PB and each EH device (vector) 
    
    powerCoef(j) = 1/min(beta(idx==j)); %%PBs with farthest associated devices are assigned more power
    
    ang = 2*pi*rand + atan((xpb(j)- x)./(ypb(j)- y));  %ang of each device with respect
                                                       %the ULA of the j-th PB
    
    %LOS (geometric) channel realizations
    Hlos = sqrt(kappa/(1+kappa))*exp(-1i*pi*repmat(0:(M*Q-1),N,1).*sin(repmat(ang',1,M*Q)));    
    
    %Instantanoues channel realizations
    H = Hlos + Hnlos;
    
    INM = inM + Q - 1;
    %Energy beamforming computation based on full CSI
    [~, W] = CSI_based_EB( Q, sum(idx==j), H(idx==j,inM:INM), beta(idx==j));    
    
  
    [r,~] = size(W);        % r is the number of EB vectors
    %This code section computes the RF energy provided by the j-th PB to 
    %each of the deployed EH devices
    for ri=1:r        
        for devI=1:N        % devI is th device index     
            E(devI)=E(devI)+powerCoef(j)*beta(devI)*abs(sum(W(ri,:).*H(devI,Q*(idx(devI)-1)+1 : Q *idx(devI))))^2;
        end
    end
    inM = INM+1;
end

%RF energy available at each EH device (vector)
E=E/sum(powerCoef);


%% References:
%[REF]    - O. L. A. López, H. Alves, R. D. Souza, S. Montejo-Sánchez, E. Fernández
%          and M. Latva-aho, "Massive Wireless Energy Transfer: Enabling Sustainable
%          IoT Towards 6G Era," in IEEE Internet of Things Journal.


end

