function E = single_antenna_PBs_optimized( M, N, x, y )
%This function works as described in [REF, Section III-B]: Several multi-antenna
%PBs are intelligently deployed in a circular area to serve the surrounding EH devices
%The PBs deployment is based on k-means clustering

%% Input parameters:
% M    -> Number of single-antenna PBs
% N    -> Number of EH Devices served by the PB (scalar)
% x, y -> (x,y) coordinates of EH devices' positions with respect to the PB
%         Each x and y can be equal-size vectors 

%% Output parameters:
% E    -> 1xN RF energy available at each EH device (vector)

%% Main code
%Optimizes deployment of PBs using k-means clustering
X = [x' y'];
[~,C] = kmeans(X,M);
% (x,y) coordinate of each PB with respect to area center
xpb = C(:,1)';
ypb = C(:,2)';

%RF Energy provided by each j-th PB to the deployed EH devices
powerCoef = zeros(1,M);
Ej = zeros(M,N);
for j=1:M
    beta = channel_path_loss(x, xpb(j), y, ypb(j));    
    powerCoef(j) = 1/min(beta);         %%PBs with farthest associated devices are assigned more power
    Ej(j,:) = powerCoef(j)*beta;
end
%RF energy available at each EH device (vector)
E = sum(Ej/sum(powerCoef));

%Note that since PBs are single-antenna there was no need to generate 
%instantaneous realizations of the complex channels (under quasi-static 
%Riciand fading)

%% References:
%[REF]    - O. L. A. López, H. Alves, R. D. Souza, S. Montejo-Sánchez, E. Fernández
%          and M. Latva-aho, "Massive Wireless Energy Transfer: Enabling Sustainable
%          IoT Towards 6G Era," in IEEE Internet of Things Journal.
end 