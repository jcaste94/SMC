function param = prtr_HS
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
theta1  = [1 , 1e-20  , 0.9999999 , 1];	
theta2  = [1 , 1e-20  , 0.9999999 , 1];	
% /********************************************************************
% **      Parameter selection according to model
% ********************************************************************/
param = [ ...
theta1  ;...
theta2 ;...
 ];
% 
% [para,pnames] = psel(paratemp,msel);
