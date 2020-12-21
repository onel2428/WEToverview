function E = single_antenna_PBs( M, N, x, y, R )
%This function works as described in [REF, Section III-B]: Several multi-antenna
%PBs are randomly deployed in a circular area to serve the surrounding EH devices

%% Input parameters:
% M    -> Number of single-antenna PBs
% N    -> Number of EH Devices served by the PB (scalar)
% x, y -> (x,y) coordinates of EH devices' positions with respect to the PB
%         Each x and y can be equal-size vectors 
% R    -> Radius of the circular area served by the PBs

%% Output parameters:
% E    -> 1xN RF energy available at each EH device (vector)

%% Main code
%Random deployment of PBs
apb = 2*pi*rand(1,M);
dpb = R*sqrt(rand(1,M));
% (x,y) coordinate of each PB with respect to area center
xpb = dpb.*cos(apb);
ypb = dpb.*sin(apb);

%RF Energy provided by each j-th PB to the deployed EH devices
ej = zeros(M,N);
for j=1:M
    beta = channel_path_loss(x, xpb(j), y, ypb(j));
    ej(j,:) = (1/M)*beta; 
end

%RF energy available at each EH device (vector)
E = sum(ej);

%Note that since PBs are single-antenna there was no need to generate 
%instantaneous realizations of the complex channels (under quasi-static 
%Riciand fading)

%% References:
%[REF]   - O. L. A. López, H. Alves, R. D. Souza, S. Montejo-Sánchez, E. Fernández
%         and M. Latva-aho, "Massive Wireless Energy Transfer: Enabling Sustainable
%         IoT Towards 6G Era," in IEEE Internet of Things Journal.

end

