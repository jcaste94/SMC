function y = lpdfig(x,a,b)

    if x <= 0
        error('The pdf is only defined over the support x>0')
    end

    pdfig = (b.^a ./ gamma(a)) .* x.^(-a-1) .* exp(-b./x);
    
    y = log(pdfig);
    
end