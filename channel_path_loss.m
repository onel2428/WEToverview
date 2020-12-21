function beta = channel_path_loss(x1, x2, y1, y2)
%Channel path-loss between device at position (x1,y1) and another device at position (x2,y2)

%% Input parameters:
% (x1,y1) -> coordinates of the first node
% (x2,y2) -> coordinates of the second node

%% Output parameters:
% beta    -> path-loss between the two nodes at (x1,y1) and (x2,y2)

%% The path loss is comupted using the log-distance model
% Setting path-loss exponent and attenuation at reference distance of 1m
exponent = 2.7;         %path loss exponent
attenuation1m = 1e-3;   %average power attenuation at 1m
% Path loss computation
beta = min(attenuation1m*sqrt((x1 - x2).^2 + (y1 - y2).^2).^-exponent, 1);

end

