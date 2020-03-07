% returns the log pdf of the normal distribution with mean mu and standard 
% deviation sigma, evaluated at the values in x.
function y = lpdfnor(x, mu, sigma)
    
    y = log(normpdf(x,mu,sigma));
    
end