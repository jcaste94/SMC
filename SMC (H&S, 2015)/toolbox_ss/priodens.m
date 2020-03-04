function lnprior = priodens(para, pmean, pstdd, pshape)
% /* This procedure computes a prior density for
% ** the structural parameters of the DSGE models
% ** pshape: 0 is point mass, both para and pstdd are ignored
% **         1 is BETA(mean,stdd)
% **         2 is GAMMA(mean,stdd)
% **         3 is NORMAL(mean,stdd)
% **         4 is INVGAMMA(s^2,nu)
% **         5 is uniform(a,b)
% */

lnprior = 0;
a = 0;
b = 0;

nprio = size(pshape,1);
prioinfo = [zeros(nprio, 2) pshape];

for i=1:1:nprio
    
    if prioinfo(i,3) == 1         % beta prior
        a = (1-pmean(i))*pmean(i)^2/pstdd(i)^2 - pmean(i);
        b = a*(1/pmean(i) -1);
        lnprior = lnprior + lpdfbeta(para(i), a, b);
    elseif prioinfo(i,3) == 2     % gamma prior
        b = pstdd(i)^2/pmean(i);
        a = pmean(i)/b;
        lnprior = lnprior + lpdfgam(para(i), a, b);
    elseif prioinfo(i,3) == 3     % gaussian prior
        a = pmean(i);
        b = pstdd(i);
        lnprior = lnprior + lpdfnor(para(i), a, b);
    elseif prioinfo(i,3) == 4     % invgamma prior
        a = pmean(i);
        b = pstdd(i);
        lnprior = lnprior + lpdfig(para(i), a, b);
    elseif prioinfo(i,3) == 5     % uniform prior
        a = pmean(i);
        b = pstdd(i);
        lnprior = lnprior + log(1/(b-a));
    end
        
    prioinfo(i,1) = a;
    prioinfo(i,2) = b;
end
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        