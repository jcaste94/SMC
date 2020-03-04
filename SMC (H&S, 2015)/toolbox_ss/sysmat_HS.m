function [A,B,Phi,R,H,S2] = sysmat_HS(param)
% FUNCTION TO TURN PARAMETER VECTOR INTO SYSTEM MATRICES
% Model in Herbst and Schorfheide (2014)
% DATE: 2014/05/08
% Minchul Shin (Penn)
% ----------------------------------------------------
% Model
% ----------------------------------------------------
%  y_{t} = A + B s_{t} + u
%  s_{t} = Phi s_{t-1} + R*ep
%  var(u) ~ H
%  var(ep) ~ S2
% ----------------------------------------------------

% Recover Parameters
theta1 = param(1);
theta2 = param(2);

% Reduced form parameters
phi1 = theta1^2;
phi2 = (1-theta1^2);
phi3 = phi2 -theta1*theta2;

% System matrices
A   = [0];
B   = [1, 1];
Phi = [phi1, 0; phi3, phi2];
R   = [1;0];
H   = [0].^2;
S2  = ([1]).^2;
