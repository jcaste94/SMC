function logpdf = logpdf_MixtureMH(px,p0,tune,mixsel)
% pdf of Mixture MH
% px: proposal
% p0: previous old


% pdf = tune.alp*exp(logmvnpdf(px, p0, tune.c^2*tune.R)) ...
%     + (1-tune.alp)/2*exp(logmvnpdf(px, p0, tune.c^2*tune.Rdiag)) ...
%     + (1-tune.alp)/2*exp(logmvnpdf(px, tune.mu', tune.c^2*tune.R));
% logpdf = log(pdf);


if mixsel == 1
    logpdf = logmvnpdf(px, p0, tune.c^2*tune.R);
elseif mixsel == 2
    logpdf = logmvnpdf(px, p0, tune.c^2*tune.Rdiag);
elseif mixsel == 3
    logpdf = logmvnpdf(px, tune.mu', tune.c^2*tune.R);
end


