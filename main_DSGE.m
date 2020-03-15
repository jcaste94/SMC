%==========================================================================
%                           POSTERIOR INFERENCE
%                    Sequential Monte Carlo Algorithms
%               (Stylized state space model in the textbook)
%
%
% Author: Juan Castellanos Silván
% Date: 3/2/2020
% 
% Original code by Minchul Shin 
% SMC algorthm in Herbst and Schofheide (2015)
%==========================================================================

clear all
close all
clc

% add the toolbox
addpath([pwd, '/toolbox_ss']);

%% General Setting - Specificaitons/Path
modelname = 'SSNK'; % Small Scale New Keynesian DSGE in H&S(2015)
priorname = '0';
specname  = [modelname, '_p', priorname]; % prior 
smcrun    = '1'; % chain number
propmode  = 1;   % 1-RWMH, 2-Mixture MH
T0_       = 1;   % starting point of likelihood evaluation

% path
workpath = pwd;
priopath = workpath; % prior path
savepath = [workpath, '/results_',specname];
chk_dir(savepath);

%% load data
YY  = load('us.txt');

%% SMC Setting - setting up a tunning variable, "tune"

% General
tune.npara = 13;      % # of parameters
tune.npart = 1*1024; % # of particles
tune.nphi  = 50;     % # of stage
tune.lam   = 1;      % # bending coeff, lam = 1 means linear cooling schedule

% Create the tempering schedule
tune.phi = (1:1:tune.nphi)';
tune.phi = ((tune.phi-1)/(tune.nphi-1)).^tune.lam;

% tuning for MH algorithms
tune.c    = 0.5;                    % initial scale cov
tune.R    = 0.1*eye(tune.npara);    % initial cov
tune.acpt = 0.5;                    % initial acpt rate
tune.trgt = 0.25;                   % target acpt rate
tune.alp  = 0.9;                    % Mixture weight for mixture proposal

% run script
ss_smc; %this file will save parasim, wtsim, tune, others

%% Final report

%------------------------------------------------------------
% report summary statistics
%------------------------------------------------------------
para = squeeze(parasim(end, :, :));
wght = repmat(wtsim(:, end), 1, 13);

mu  = sum(para.*wght);
sig = sum((para - repmat(mu, tune.npart, 1)).^2 .*wght);
sig = (sqrt(sig));

fprintf('Finished SMC algorithm.\n')
fprintf('para     mean     std\n')
fprintf('----     ----     ----\n')
fprintf('tau      %4.2f    %4.3f\n', mu(1), sig(1))
fprintf('kappa    %4.2f    %4.3f\n', mu(2), sig(2))
fprintf('psi1     %4.2f    %4.3f\n', mu(3), sig(3))
fprintf('psi2     %4.2f    %4.3f\n', mu(4), sig(4))
fprintf('rA       %4.2f    %4.3f\n', mu(5), sig(5))
fprintf('piA      %4.2f    %4.3f\n', mu(6), sig(6))
fprintf('gammaQ   %4.2f    %4.3f\n', mu(7), sig(7))
fprintf('rho_R    %4.2f    %4.3f\n', mu(8), sig(8))
fprintf('rho_g    %4.2f    %4.3f\n', mu(9), sig(9))
fprintf('rho_z    %4.2f    %4.3f\n', mu(10), sig(10))
fprintf('sigma_R  %4.2f    %4.3f\n', mu(11), sig(11))
fprintf('sigma_g  %4.2f    %4.3f\n', mu(12), sig(12))
fprintf('sigma_z  %4.2f    %4.3f\n', mu(13), sig(13))


    % ----------------------
    % Export table to LaTeX
    % ----------------------
    parameters = {'$\tau$';'$\kappa$'; '$\psi_{1}$';'$\psi_{2}$';'$r^{(A)}$';...
        '$\pi^{(A)}$';'$\gamma^{(Q)}$';'$\rho_{r}$';'$\rho_{g}$'; '$\rho_{z}$';...
        '$\sigma_{r}$'; '$\sigma_{g}$'; '$\sigma_{z}$'};

    T = table(mu', sig');
    T.Properties.RowNames = parameters;
    T.Properties.VariableNames{'Var1'} = '\textbf{Mean}';
    T.Properties.VariableNames{'Var2'} = '\textbf{Std}';

    path = '/Users/Castesil/Documents/EUI/Year II - PENN/Spring 2020/Econometrics IV/PS/PS4/LaTeX/';
    filename = strcat('tSummaryStatistics_',modelname,'.tex');
    table2latex(T, strcat(path,filename));


