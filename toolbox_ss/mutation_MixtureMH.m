function [ind_para, ind_loglh, ind_post, ind_acpt] = mutation_MixtureMH(p0, l0, post0, tune, i, f)
% Mixture proposal for mutation step
% - See Herbst and Schorfheide(2014)
% Date: 5/8/2014
% Minchul Shin (Penn)

% INPUT
% tune
% p0 = para(j,:)';
% l0 = loglh(j);
% post0 = logpost(j);

% OUTPUT
% ind_para
% ind_loglh
% ind_post
% ind_acpt

% Mixture proposal
alpind = rand;
if alpind<tune.alp
    % random walk
    px     = p0 + tune.c*tune.Rchol*randn(tune.npara,1);
    mixsel = 1;
elseif alpind<tune.alp + (1-tune.alp/2)
    % random walk with diagonal cov
    px = p0 + tune.c*tune.Rchol2*randn(tune.npara,1);
    mixsel = 2;
else
    % independent proposal 
    px = tune.mu + tune.c*tune.Rchol*randn(tune.npara,1);
    mixsel = 3;
end

% Proposal densities
qx = logpdf_MixtureMH(px,p0,tune,mixsel);
q0 = logpdf_MixtureMH(p0,px,tune,mixsel);

% Posterior at proposed value
[postx, lx] = f(px, tune.phi(i));

% Previous posterior needs to be updated (due to tempering)
post0 = post0+(tune.phi(i)-tune.phi(i-1))*l0;

% Accept/Reject
alp = exp((postx-qx) - (post0-q0)); % this is RW, so q is canceled out
if rand < alp % accept
    ind_para   = px;
    ind_loglh  = lx;
    ind_post   = postx;
    ind_acpt   = 1;
else
    ind_para   = p0;
    ind_loglh  = l0;
    ind_post   = post0;
    ind_acpt   = 0;
end

% % outside of function
% parasim(i,j,:) = ind_para;
% loglh(j)       = ind_loglh;
% temp_acpt(j,1) = ind_acpt;
