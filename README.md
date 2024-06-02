In order to better apply to the examination of HD-SEMG decomposition algorithm, based on the sEMG simulation system developed by Li Qiang, we simulated the electrode arrays with 64 channels (8*8) and 128 (16*8) channels, and the interelectrode distance was determined by the system parameters. And using the elliptical muscle to replace original circular and rectangular muscles, and the long and short axes of the ellipse were determined by “Total length of the muscle” and “Total width of the muscle”. Where the simulation of the MUAP waveform and the MU dispensing strategy are based on [1] and [2], respectively. The more details about the simulation system can be found in [3].
The main interface of the simulation system:
 
Fill in the parameters and click the “Calculate” button, the result and graph will be displayed in the window. If you want to display the sEMG of a specific channel or the MUAP waveform of a specific MU, please input the parameters in the corresponding position, e.g., show the 6th MU of channel 30, and press the Enter key. If you need to save the synthesized sEMG and its constituent MUAP and MU pulse train, you can click the “Save Data” button to save them in a specified location on your computer.
Description of simulation parameters:
(1) Maximum Voluntary Contraction Level (MVC): refers to the maximum level of muscle contraction force that a person can produce under maximum voluntary, usually set to 5,10,20,30 (%max). With a constant number of motor unit pools, the higher the level of contraction, the higher the number of activated motor units, the more MUAPTs are included in the generated sEMG, the more complex the signal is, and the more time is spent on computation.
(2) Recruitment Range(RR): the recruitment range of MU, if the RR value is small, it presents a narrow recruitment situation. For example, if it is set to 40, it means that all MUs are involved in the firing when the muscle is at 40% of the maximum incentive; if the RR value is larger, it presents a wide recruitment situation. More details shown in Figure1.
(3) Firing Strategy selection
MU recruitment will form the corresponding firing process. The number of  discharge times of MUs in the unit time is the firing rate. The system provides three firing assumption schemes to calculate the firing rate of each activated MU. They are Frscheme1, Frscheme2, and Frscheme3(More details shown in [4]) ,they are described below:
	Frscheme1	Frscheme2	Frscheme3
Narrow recruit-ment	 	 	 
Wide Recruit-ment	 	 	 
Fig1 show the three distribution schemes under narrow recruitment (RR=40, for example) and wide recruitment (RR=70, for example), respectively. It can be selected according to the demand.

This repository intends to service as supplementary materials for our review. Detailed information to be added.

Refrences:
[1]	R. Merletti, L. Lo Conte, E. Avignone, and P. Guglielminotti, “Modeling of surface myoelectric signals. I. Model implementation,” IEEE Transactions on Biomedical Engineering, vol. 46, no. 7, pp. 810–820, Jul. 1999, doi: 10.1109/10.771190.
[2]	A. J. Fuglevand, D. A. Winter, and A. E. Patla, “Models of recruitment and rate coding organization in motor-unit pools,” Journal of Neurophysiology, vol. 70, no. 6, pp. 2470–2488, Dec. 1993, doi: 10.1152/jn.1993.70.6.2470.
[3]	Li, Q. (2008). Study on the detection of motor unit action potentials in surface electromyography [Doctoral dissertation, University of Science and Technology of China, Hefei, Anhui, China].
[4]	P. Zhou and W. Z. Rymer, “Factors Governing the Form of the Relation Between Muscle Force and the EMG: A Simulation Study,” Journal of Neurophysiology, vol. 92, no. 5, pp. 2878–2886, Nov. 2004, doi: 10.1152/jn.00367.2004.



