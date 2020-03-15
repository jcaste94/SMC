% ----------------------------------------------------------------
% ss_smc.m
% -Script for SMC algorithm in Herbst and Schorfheide (2015)
% ***If you use this code, please cite Herbst and Schorfheide (2015).
% ----------------------------------------------------------------
% Minchul Shin (Penn), mincshin@sas.upenn.edu
% Last modified: 5/9/2014
%
% Bugs corrected by Mark Bognanni (FRB Cleveland)
% 5/12/2017
% ----------------------------------------------------------------

%% initialization

% ------------------------------------------------------------------------
% Import prior specification / Get bounds
% ------------------------------------------------------------------------
priorfile = ['prior_', specname, '.txt'];
cd(priopath);
prior     = load(priorfile, '-ascii');
cd(workpath);

eval(['[prior, para_names] = psel_',modelname, '(prior);']); % run "psel.m"

pshape   = prior(:,1);
pmean    = prior(:,2);
pstdd    = prior(:,3);
pmask    = prior(:,4);
pfix     = prior(:,5);
pmaskinv = 1- pmask;
pshape   = pshape.*pmaskinv;

% parameter specification: transformation
eval(['trspec = prtr_', modelname, ';']); % run "prtr.m"
trspec(:,1) = trspec(:,1).*pmaskinv;
bounds      = trspec(:,2:3);

% ------------------------------------------------------------------------
% Define a function handle for Posterior evaluation
% ------------------------------------------------------------------------
f = @(x1, x2) objfcn_smc(x1, x2, prior,bounds,YY,modelname,T0_); % x1: para, x2: tempering parameter

% ------------------------------------------------------------------------
% matrices for storing
% ------------------------------------------------------------------------
parasim = zeros(tune.nphi, tune.npart, tune.npara); % parameter draws
wtsim   = zeros(tune.npart, tune.nphi);        % weights
zhat    = zeros(tune.nphi,1);                  % normalization constant
nresamp = 0; % record # of iteration resampled

csim    = zeros(tune.nphi,1); % scale parameter
ESSsim  = zeros(tune.nphi,1); % ESS
acptsim = zeros(tune.nphi,1); % average acceptance rate
rsmpsim = zeros(tune.nphi,1); % 1 if re-sampled

%% SMC algorithm starts here

% ------------------------------------------------------------------------
% Initialization: Draws from the prior
% ------------------------------------------------------------------------
disp('SMC starts ... ');
priorsim       = priordraws(prior, trspec, tune.npart);
parasim(1,:,:) = priorsim; % from prior
wtsim(:, 1)    = 1/tune.npart;    % initial weight is equal weights
zhat(1)        = sum(wtsim(:,1));

% Posterior values at prior draws
loglh  = zeros(tune.npart,1); %log-likelihood
logpost = zeros(tune.npart,1); %log-posterior
for i=1:1:tune.npart
    p0       = priorsim(i,:)';
    [logpost(i), loglh(i)] = f(p0,tune.phi(1)); % likelihood
end

% ------------------------------------------------------------------------
% Recursion: For n=2,...,N_{\phi}
% ------------------------------------------------------------------------
smctime   = tic;
totaltime = 0;

disp('SMC recursion starts ... ');
for i=2:1:tune.nphi

    %-----------------------------------
    % (a) Correction
    %-----------------------------------
    % incremental weights
    incwt = exp((tune.phi(i)-tune.phi(i-1))*loglh);

    % update weights
    wtsim(:, i) = wtsim(:, i-1).*incwt;
    zhat(i)     = sum(wtsim(:, i));

    % normalize weights
    wtsim(:, i) = wtsim(:, i)/zhat(i);

    %-----------------------------------
    % (b) Selection
    %-----------------------------------
    ESS = 1/sum(wtsim(:, i).^2); % Effective sample size
    if (ESS < tune.npart/2)

        [id, m] = multinomial_resampling(wtsim(:,i)'); %multinomial resampling

        parasim(i, :, :) = parasim(i-1, id, :);
        loglh            = loglh(id);
        logpost          = logpost(id);
        wtsim(:, i)      = 1/tune.npart; % resampled weights are equal weights
        nresamp          = nresamp + 1;
        rsmpsim(i)       = 1;
    else
        parasim(i,:,:)   = parasim(i-1,:,:);
    end

    %--------------------------------------------------------
    % (c) Mutuation
    %--------------------------------------------------------
    % Adapting the transition kernel
    tune.c = tune.c*(0.95 + 0.10*exp(16*(tune.acpt-tune.trgt))/(1 + exp(16*(tune.acpt-tune.trgt))));

    % Calculate estimates of mean and variance
    para = squeeze(parasim(i, :, :));
    wght = repmat(wtsim(:, i), 1, tune.npara);

    tune.mu      = sum(para.*wght); % mean
    z            = (para - repmat(tune.mu, tune.npart, 1));
    tune.R       = (z.*wght)'*z;       % covariance
    tune.Rdiag   = diag(diag(tune.R)); % covariance with diag elements
    tune.Rchol   = chol(tune.R, 'lower');
    tune.Rchol2  = sqrt(tune.Rdiag);

    % Particle mutation (Algorithm 2)
    temp_acpt = zeros(tune.npart,1); %initialize accpetance indicator
    for j = 1:tune.npart %iteration over particles

        % Options for proposals
        if propmode == 1
            % Mutation with RWMH
            [ind_para, ind_loglh, ind_post, ind_acpt] = mutation_RWMH(para(j,:)', loglh(j), logpost(j), tune, i, f);
        elseif propmode == 2
            % Mutation with Mixture MH
            [ind_para, ind_loglh, ind_post, ind_acpt] = mutation_MixtureMH(para(j,:)', loglh(j), logpost(j), tune, i, f);
        end

        parasim(i,j,:) = ind_para;
        loglh(j)       = ind_loglh;
        logpost(j)     = ind_post;
        temp_acpt(j,1) = ind_acpt;

    end
    tune.acpt = mean(temp_acpt); % update average acceptance rate

    % store
    csim(i,:)    = tune.c; % scale parameter
    ESSsim(i,:)  = ESS; % ESS
    acptsim(i,:) = tune.acpt; % average acceptance rate

    % print some information
    if mod(i, 1) == 0

        % time calculation
        totaltime = totaltime + toc(smctime);
        avgtime   = totaltime/i;
        remtime   = avgtime*(tune.nphi-i);

        % print
        fprintf('-----------------------------------------------\n')
        fprintf(' Iteration = %10.0f / %10.0f \n', i, tune.nphi);
        fprintf('-----------------------------------------------\n')
        fprintf(' phi  = %5.4f    \n', tune.phi(i));
        fprintf('-----------------------------------------------\n')
        fprintf('  c    = %5.4f\n', tune.c);
        fprintf('  acpt = %5.4f\n', tune.acpt);
        fprintf('  ESS  = %5.1f  (%d total resamples.)\n', ESS, nresamp);
        fprintf('-----------------------------------------------\n')
        fprintf('  time elapsed   = %5.2f\n', totaltime);
        fprintf('  time average   = %5.2f\n', avgtime);
        fprintf('  time remained  = %5.2f\n', remtime);
        fprintf('-----------------------------------------------\n')

        smctime = tic; % re-start clock
    end
end

%% Save result
savefilename = [specname, '_mode',num2str(propmode),'_run',smcrun,'.mat'];
cd(savepath);
save(savefilename, 'parasim', 'wtsim', 'tune', 'csim', 'ESSsim', 'acptsim', 'rsmpsim', 'zhat');
cd(workpath);
