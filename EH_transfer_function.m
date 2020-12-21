function harvested_energy = EH_transfer_function(RF_energy,sensitivity,saturation,efficiency)
%EH transfer function given RF energy input and EH hardware parameters [REF]

%% Input parameters:
% RF_energy    -> RF energy available at the input of the EH circuit 
% sensitivity  -> RF sensitivity level of the EH circuit
% saturation   -> RF saturation level of the EH circuit
% efficiency   -> EH conversion efficiency of the EH circuit (scalar between 0 and 1)

%% Output parameters:
% harvested_energy    -> harvested energy

%% Main code
%A linear EH transfer function but including sensitivity and saturation phenomena is used here [REF]
harvested_energy = efficiency*(RF_energy.*(RF_energy>=sensitivity & RF_energy<saturation)+saturation*(RF_energy>saturation));

%Other, more evolved, EH transfer functions can be tested by modifying line 15

%[REF]    - O. L. A. López, et al., "Statistical Analysis of Multiple Antenna
%           Strategies for Wireless Energy Transfer," in IEEE Transactions on 
%           Communications, vol. 67, no. 10, pp. 7245-7262, Oct. 2019.
end

