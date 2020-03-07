function param = prtr_SSNK
%  sets parameter transformation type and arguments
% /********************************************************************
% **   Each row has the following specification:
% **
% **    tr~a~b~c
% **
% **    tr parameter transformation type
% **        0: no transformation needed
% **        1: [a,b] -> [-1,1] -> [-inf,inf] by (1/c)*c*z/sqrt(1-c*z^2)
% **        2: [0,inf] -> [-inf,inf] by b + (1/c)*ln(para[i]-a);
% **    a  transformation argument a (usually lower bound)
% **    b  transformation argument b (usually upper bound)
% **    c  transformation argument c
% ********************************************************************/
tau = [0 , 1e-20, 1e20 , 1];
kappa = [0 , 1e-20 , 1 , 1];
psi1 = [0 , 1e-20, 1e20 , 1];
psi2 = [0 , 1e-20, 1e20 , 1];
rA = [0 , 1e-20, 1e20 , 1];
piA = [0 , 1e-20, 1e20 , 1];
gammaQ = [0 , -1e20, 1e20 , 1];
rho_R = [0 , 1e-20 , 0.9999999 , 1];
rho_g = [0 , 1e-20 , 0.9999999 , 1];
rho_z = [0 , 1e-20 , 0.9999999 , 1];
sigma_R = [0 , 1e-20, 1e20 , 1];
sigma_g = [0 , 1e-20, 1e20 , 1];
sigma_z = [0 , 1e-20, 1e20 , 1];

% /********************************************************************
% **      Parameter selection according to model
% ********************************************************************/
param = [ ...
tau ; kappa ; psi1 ; psi2 ; rA ; piA ; gammaQ ; rho_R ; rho_g ; ...
rho_z ; sigma_R ; sigma_g ; sigma_z ...
 ];
% 
% [para,pnames] = psel(paratemp,msel);
