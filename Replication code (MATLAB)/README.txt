<Readme file for SMC algorithm>
- In this folder, you can find a set of MATLAB codes that replicate 
 Figure 5.2 and Figure 5.3 in Herbst and Schofheide (2016).
- Last modified: 2/24/2016


Please run the following files in order:

1) main_ss.m
   - Tuning parameters for SMC are collected in structure variable called "tune".
   - This file calls a script "ss_smc.m".

2) fig_contour.m
   - pre-compute log posteior values for contour plot 

3) fig_all.m
   - Create/Save figures based on outputs from main_ss.m   

4) Note: You can change prior specification. Please check the following file:
   - prior_HS_p0.txt : prior specification for theta 1 and theta 2


Remarks

1) The code is designed to extend to other applications such as DSGE applications. 
One only needs to change “sysmat” part and associated parameter/prior files. 

2) In the code, all SMC tuning parameters are collected in one “structure” variable for clarity. 
(variable  name is “tune”)

3) This SMC algorithm can be a very nice tool as the time reduction is almost linear 
in cores used. In Matlab, parallelizing this code is very simple. 
One only needs to change one word. (for -> parfor)