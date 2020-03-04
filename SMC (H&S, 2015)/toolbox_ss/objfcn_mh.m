function [lnpost, lnpY, lnprio, error] = objfcn_mh(para, prior, bounds, YY, modelname, T0_)
% objfcn_mh
%  - evaluates posterior density given parameter bounds
%  - direct translation of professor Schorfheide's gauss code
%  - by Minchul Shin (UPenn)
% updated: 2012-12-03

% recover prior information
pshape   = prior(:,1);
pmean    = prior(:,2);
pstdd    = prior(:,3);
pmask    = prior(:,4);
pfix     = prior(:,5);
pmaskinv = 1- pmask;
pshape   = pshape.*pmaskinv;

% check bounds
parabd_ind1 = para > bounds(:,1); % lower bounds
parabd_ind2 = para < bounds(:,2); % upper bounds
parabd_ind1 = parabd_ind1(logical(pmaskinv));
parabd_ind2 = parabd_ind2(logical(pmaskinv));

% 
modelpara = para;

if and(parabd_ind1 == 1, parabd_ind2 == 1) % in bounds
    

    % evaluation of likelihood
    [loglik, s_up, error] = evalmod_kalman(modelpara, YY, modelname);
	lnpY = sum(loglik(T0_:end,:));
    
    % evaluate the prior distribution
    lnprio = priodens(modelpara, pmean, pstdd, pshape);
    
    % log posterior
    lnpost = (lnpY + lnprio);
    
    
else % if parameter proposal is out of bounds

    lnpost  = -inf;
    lnpY    = -inf;
    lnprio = -inf;
    error   = 10;
	
end






