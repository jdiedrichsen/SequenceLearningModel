% simulations with the deaults of the function 
[IPIs, Exam] =    slm_diagModel();



% simulation with the 'boxcar' function
 [IPIs, Exam] =    slm_diagModel('DecayFunc' , 'boxcar' , 'numSimulations' , 100,...
     'Aintegrate' , 0.98 , 'theta_stim' , 0.01 , 'DecayParam' , [2:10]);
 
load('IPIs_horizon.mat')
% separate the full horizons only
% A = getrow( IPIs , IPIs.Horizon == max(IPIs.Horizon));
A = getrow( IPIs , IPIs.Horizon == 10);
slm_diagModelViz(IPIs , 'MT_RT_vs_theta')
slm_diagModelViz(IPIs , 'MT_RT_vs_Aintegrate')
slm_diagModelViz(IPIs , 'MT_RT_vs_Horizon_constantAiTs', 'Aintegrate_select' , 0.9950)
slm_diagModelViz(IPIs , 'MT_RT_vs_Horizon')
slm_diagModelViz(A , 'IPIs_vs_theta')
slm_diagModelViz(A, 'IPIs_vs_Aintegrate')
