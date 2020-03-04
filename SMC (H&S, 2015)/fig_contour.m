% contour of posterior
% - generates/saves likelihood contour
clc; clear all; close all;

% add the toolbox
addpath([pwd, '/toolbox_ss']);

%% General Setting - Specificaitons/Path
modelname = 'HS'; % Herbst and Schorfheide
priorname = '0';
specname  = [modelname, '_p', priorname]; % prior 
smcrun    = '1'; % chain number
propmode  = 2;   % 1-RWMH, 2-Mixture MH
T0_       = 1;   % starting point of likelihood evaluation

% path
workpath = pwd;
priopath = workpath; %prior path
savepath = [workpath, '/results_',specname];
chk_dir(savepath);

%% load data
y  = load('data.txt');
YY = y(1:200,:);

%% Import prior specification / Get bounds
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


%% Get contour: posterior function
f = @(x1, x2) objfcn_smc(x1, x2, prior,bounds,YY,modelname,T0_); % x1: para, x2: tempering parameter

nx = 50;
theta1 = linspace(0.01,0.99,nx);
theta2 = linspace(0.01,0.99,nx);

logpost = zeros(nx,nx); %theta2 by theta1
loglh   = zeros(nx,nx); %theta2 by theta1
for i=1:1:nx %theta 2
    for j=1:1:nx %theta 1
        
    p0       = [theta1(j); theta2(i)];
    [logpost(i,j), loglh(i,j)] = f(p0,1); % posterior, tunining =1
    
    end
end

% level = -325:1:-305;
% colormap('summer')
% contourf(theta1, theta2, logpost, level)
% xlabel('\theta_1')
% ylabel('\theta_2')

%% save result
contourfval = logpost;
contourxval = theta1;

savefilename = ['ctrval.mat'];
cd(savepath);
save(savefilename, 'contourfval', 'contourxval');
cd(workpath);



