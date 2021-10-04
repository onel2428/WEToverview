# WET_overview

This compilation of MatLab scripts is used to generate the results illustrated in [REF1].
The scripts description is as follows.

CSI-free WET schemes:
  - AA_SS.m (AA-SS as given in [REF2])
  - AA_IS.m (AA-IS as given in [REF2])
  - SA.m (SA as given in [REF2] and [REF3])
  - APS_EMW.m (APS-EMW as given in [REF4])

Energy beamforming schemes:
  - CSI_based_EB.m (it can be used to either compute full-CSI or average-CSI -based beamformers as illustrated in [REF5])

Distributed Antenna Deployments and Energy Beamforming:
  - single_PB.m (energy available at the EH devices when using a single multi-antenna PB at the area center. It uses CSI_based_EB.m and works as described in [REF1])
  - single_antenna_PBs.m (energy available at the EH devices when using several single-antenna PBs randomly deployed in the area. It works as described in [REF1])
  - single_antenna_PBs_optimized.m (energy available at the EH devices when using several single-antenna PBs intelligently deployed in the area. It works as described in [REF1])
  - multi_antenna_PBs.m (energy available at the EH devices when using several multi-antenna PBs intelligently deployed in the area. It works as described in [REF1])

Auxiliary functions:
  - channel_path_loss.m (average power channel coeficient -following a log-distance model- as a function of nodes coordinates)
  - EH_transfer_function.m (Linea EH transfer function but considering sensitivity and saturation phenomena as illustrated in [REF3])

Scripts for figures generation:
  - ToySimulation_EB_vs_DAS.m (It allows generating a figure similar to [REF1, Fig.9]: Average worst-case RF energy at the input of the energy harvesters
as a function of the total number of transmit antennas M for different EB, DAS and hybrid DAS & EB deployments)
  - ToySimulation_Average_vs_Full_CSI.m (It allows generating a figure similar to [REF, Fig.12]: Average worst-case RF energy at the input of the energy harvesters as a function of the Rician LOS factor)
  - ToySimulation_CSI_free.m (It allows generating a figure similar to [REF1, Fig.13]:  Heatmap of the average harvested energy in dBm under the
CSI-free WET schemes. With the same output data, one can also generate a figure similar to [REF1, Fig.14])




References:

[REF1] - O. L. A. López, H. Alves, R. D. Souza, S. Montejo-Sánchez, E. Fernández and M. Latva-aho, "Massive Wireless Energy Transfer: Enabling Sustainable   IoT Towards 6G Era," in IEEE Internet of Things Journal.

[REF2] - O. L. A. López, et al., "On CSI-free Multi-Antenna Schemes for Massive RF Wireless Energy Transfer," in IEEE Internet of Things Journal, doi: 10.1109/JIOT.2020.3003114.

[REF3] - O. L. A. López, et al., "Statistical Analysis of Multiple Antenna Strategies for Wireless Energy Transfer," in IEEE Transactions on Communications, vol. 67, no. 10, pp. 7245-7262, Oct. 2019.

[REF4] - B. Clerckx and J. Kim, "On the Beneficial Roles of Fading and Transmit Diversity in Wireless Power Transfer With Nonlinear Energy Harvesting," in IEEE Transactions on Wireless Communications, vol. 17, no. 11, pp. 7731-7743, Nov. 2018, doi: 10.1109/TWC.2018.2870377.

[REF5] - O. L. A. López, F. A. Monteiro, H. Alves, R. Zhang and M. Latva-aho, "A Low-Complexity Beamforming Design for Multiuser Wireless Energy Transfer," in IEEE Wireless Communications Letters, doi: 10.1109/LWC.2020.3020576.
