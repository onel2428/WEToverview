function [E, W] = CSI_based_EB( M, N, H, beta)
%This function implements the maximum-fairness energy beamforming [REF] 
%(there are some code lines that need to be uncommented for this function be able to work)

%% Input parameters:
% M    -> Number of Tx Antennas in the PB  (scalar)
% N    -> Number of EH Devices served by the PB (scalar)
% H    -> NxM Complex Channel Matrix (matrix)
% beta -> 1xN or Nx1 Power channel gain of each WET channel between PB and device (vector)

%% Output parameters:
% E    -> 1xN RF energy available at each EH device (vector)
% W    -> ?xM Beamforming matrix, where ?<=M, although it may be usually =M (matrix)

%Note that cvx solver is needed to run this function (install cvx if not already
%installed). cvx is called to solve the SDP optimization problem

%Uncomment these two code lines:
%oldFolder=cd('specify directory address for your cvx folder'); 
%cvx_startup

%% Main code
%Create a 3D matrix Hi to store H*H' corresponding to the antenna channels
%for each device i=1:N
for i=1:N
   Hi(:,:,i)= (H(i,:).')*(H(i,:).')';
end

%Create the structure of the SDP formulation according to cvx requirements
%The problem to solve is basically given in [REF, P2 in Eq.(4)]
cvx_begin sdp quiet
    variable Y(M,M) hermitian semidefinite
    variable t
    minimize( - t )   
    for i=1:N           
        beta(i)*real(trace((Hi(:,:,i)*Y)))>=t
    end
    trace(Y)==1;    
cvx_end

%This section is to obtain the beamforming matrix W
r=rank(Y);
[U,S] = eig(Y);
for j=1:r    
    W(j,:)=sqrt(S(j,j))*U(:,j)';
end
W = W./norm(W,'fro');

%This section is to compute the energy available at each devices with such
%EB W
E=zeros(1,N);
for i=1:N
  for j=1:r
       E(i)=E(i)+beta(i)*abs(sum(W(j,:).*H(i,:)))^2;
  end
end

%Uncomment this code line:
%cd(oldFolder)

%% References:
%[REF]    - O. L. A. López, F. A. Monteiro, H. Alves, R. Zhang and M. Latva-aho,
%          "A Low-Complexity Beamforming Design for Multiuser Wireless Energy 
%          Transfer," in IEEE Wireless Communications Letters, 
%          doi: 10.1109/LWC.2020.3020576.

