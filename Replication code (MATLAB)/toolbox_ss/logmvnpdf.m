function logf = logmvnpdf(x, mu, Sig)
% log of multivariate normal pdf
% x: k by 1
k    = size(x,1);
Siglogdet = log(det(Sig));
% Siginv    = inv(Sig);

logf = -k/2*log(2*pi) -1/2*Siglogdet -1/2*((x-mu)'/Sig)*(x-mu);
