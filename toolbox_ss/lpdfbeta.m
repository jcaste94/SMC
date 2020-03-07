% computes the log of the beta pdf at each of the values in X using the corresponding
% parameters in A and B
function y = lpdfbeta(x, a, b)
    
    y = log(pdfbeta(x,a,b));

end