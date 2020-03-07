function [loglik, s_up, error] = evalmod_kalman(para, YY, modelname)
% THIS FUNCTION EVALUATES LIKELIHOOD VIA KALMAN FILTER
% 2012/12/3

% error
error = 0;

% SYSTEM MATRICES

% A, B, Phi, R, H, S2
eval(['[A,B,Phi,R,H,S2] = sysmat_', modelname, '(para);']);

% INITIALIZATION
[x0, P0] = initialize_kf('',Phi,R,S2,para);

% KALMAN FILTER
[s_up, P_up, loglik] = kalman_filter_ini(x0,P0,A,B,Phi,R,H,S2,YY);

% ERROR CONTROL
if any(~isreal(loglik))
    error = 20;
    loglik =  -inf;
    s_up = [];
end
end %end of the function