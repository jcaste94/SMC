%==========================================================================
%                       IDENTIFICATION PROBLEMS
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
modelname = 'HS'; % Herbst and Schorfheide's SS example
ident = 'global';
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
y  = load('data.txt');
YY = y(1:200,:);

%% SMC Setting - setting up a tunning variable, "tune"

% General
tune.npara = 2;      % # of parameters
tune.npart = 1*1024; % # of particles
tune.nphi  = 50;     % # of stage
tune.lam   = 2;      % # bending coeff, lam = 1 means linear cooling schedule

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

