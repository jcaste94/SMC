function [A,B,Phi,R,H,S2] = sysmat(para)

% This function computes the matrices of the state space representation.
% Input = para : Vector of Structural Parameters
%         T1 T0: 
% Output= Matrices of state space model. See kalman.m
% ----------------------------------------------------
% Model
% ----------------------------------------------------
%  y_{t} = A + B s_{t} + u
%  s_{t} = Phi s_{t-1} + R*ep
%  var(u) ~ H
%  var(ep) ~ S2
% ----------------------------------------------------

[T1, ~, T0, ~, ~, ~] = model_solution(para);

tau = para(1);
kappa = para(2);
psi1 = para(3);
psi2 = para(4);
rA = para(5);
piA = para(6);
gammaQ = para(7);
rho_R = para(8);
rho_g = para(9);
rho_z = para(10);
sigma_R = para(11);
sigma_g = para(12);
sigma_z = para(13);



eq_y = 1;
eq_pi = 2;
eq_ffr = 3;

% /** number of observation variables **/

ny = 3;

% /** model variable indices **/

y_t   = 1;
pi_t   = 2;
R_t   = 3;
y1_t  = 4;
g_t   = 5;
z_t   = 6;
Ey_t1   = 7;
Epi_t1  = 8;

% /** shock indices **/

z_sh = 1;
g_sh = 2;
R_sh = 3;

%=========================================================================
%                          TRANSITION EQUATION
%  
%           s(t) = Phi*s(t-1) + R*e(t)
%           e(t) ~ iid N(0,Se)
% 
%=========================================================================

nep = size(T0,2);

Phi = T1;

R   = T0;

S2  = zeros(nep,nep);

S2(z_sh,z_sh) = (sigma_z)^2;
S2(g_sh,g_sh) = (sigma_g)^2;
S2(R_sh,R_sh) = (sigma_R)^2;

%=========================================================================
%                          MEASUREMENT EQUATION
%  
%           y(t) = a + b*s(t) + u(t) 
%           u(t) ~ N(0,HH)
% 
%=========================================================================

A         = zeros(ny,1);
A(eq_y,1) = gammaQ;
A(eq_pi,1) = piA;
A(eq_ffr,1) = piA+rA+4*gammaQ;

nstate = size(Phi,2); 

B = zeros(ny,nstate);

B(eq_y,y_t) =  1;
B(eq_y,y1_t) =  -1; 
B(eq_y, z_t) = 1;

B(eq_pi,pi_t) =  4;

B(eq_ffr,R_t) = 4;

%H = zeros(ny,ny);  
% with measurement errors (from dsge1_me.yaml)
H(eq_y, y_t) = (0.20*0.579923)^2;
H(eq_pi, pi_t) = (0.20*1.470832)^2;
H(eq_ffr, R_t) = (0.20*2.237937)^2;

end

