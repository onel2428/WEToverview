function E = single_PB( Q, N, x, y, kappa, seed, nlos )
%This function works as described in [REF1, Section III-B]: A single
%multi-antenna PB at coordinates (0,0) serves N EH devices in the
%surroundings via maximum-fairness energy beamforming

%% Input parameters:
% Q    -> Number of Tx Antennas in the PB  (scalar)
% N    -> Number of EH Devices served by the PB (scalar)
% x, y -> (x,y) coordinates of EH devices' positions with respect to the PB
%         Each x and y can be equal-size vectors 
% kappa-> LOS factor of the Rician quasi-static fading model (scalar)
% seed -> seed for random number generation (scalar)
% nlos -> =1 if the NLOS component of the channel is taken into account (full CSI available at PB)
%         =0 if the NLOS component is not taken into account (only LOS is considered: average CSI available at PB)

%% Output parameters:
% E    -> 1xN RF energy available at each EH device (vector)


%% Main code
beta = channel_path_loss(x, 0, y, 0); %Power channel gain of each WET channel 
                                      %between PB and device (vector)
ang = atan(x./y);                     %Angular position of the EH devices

rand('seed',seed)            %Setting the seed for random number generation
Hnlos = sqrt(1/(2*(1+kappa)))*(randn(N,Q)+1i*randn(N,Q)); %Instantaneous nlos 
                                                          %channel realizations
Hlos = sqrt(kappa/(1+kappa))*exp(-1i*pi*repmat(0:(Q-1),N,1)...
    .*sin(repmat(ang',1,Q)));      %LOS channel component
H = Hlos + Hnlos;                  %Instantaneous channel realizations

% Energy beamformer and energy values computation
% The energy beamformers are computed according to [REF2]
if nlos == 1           % Full-CSI -based beamforming
    [E,~] = CSI_based_EB(Q, N, H, beta);

elseif nlos == 0       % LOS-CSI (average CSI) -based beamforming
    [~,W] = CSI_based_EB(Q, N, Hlos, beta);
    [r,~]=size(W);
    
    E=zeros(1,N); 
    for ii=1:N
        for jj=1:r
            E(ii)=E(ii)+beta(ii)*abs(sum(W(jj,:).*H(ii,:)))^2;   
        end
    end
end

%%References:
%[REF1]   - O. L. A. López, H. Alves, R. D. Souza, S. Montejo-Sánchez, E. Fernández
%          and M. Latva-aho, "Massive Wireless Energy Transfer: Enabling Sustainable
%          IoT Towards 6G Era," in IEEE Internet of Things Journal.
%[REF2]   - O. L. A. López, F. A. Monteiro, H. Alves, R. Zhang and M. Latva-aho,
%          "A Low-Complexity Beamforming Design for Multiuser Wireless Energy 
%          Transfer," in IEEE Wireless Communications Letters, 
%          doi: 10.1109/LWC.2020.3020576.

end