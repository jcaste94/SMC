% computes the logarithm of the gamma pdf at each of the values in X using 
% the corresponding shape parameters in A and scale parameters in B
function y = lpdfgam(x, a, b)
    
    y = log(gampdf(x,a,b));
    
end