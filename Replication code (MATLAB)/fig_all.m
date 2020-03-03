% ----------------------------------------------------------------
% Figure file for SMC example
% - This file creates/saves figures based on outputs from main_ss.m
% Updates
% 5/13/2014: scatter plot 
% ----------------------------------------------------------------
% Minchul Shin [mincshin@sas.upenn.edu]
% Last modified: 5/13/2014
% ----------------------------------------------------------------
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

rstname = [specname, '_mode',num2str(propmode),'_run',smcrun]; 

% path
workpath = pwd;
priopath = workpath; %prior path
savepath = [workpath, '/results_',specname];
chk_dir(savepath);

%% Load results
loadfilename = [specname, '_mode',num2str(propmode),'_run',smcrun,'.mat'];
cd(savepath);
load(loadfilename);
cd(workpath);

%% Figure 1: Waterfall plot
fig = figure(1);
setmyfig(fig, [1.7, 1.2, 8, 7], version)

parai = 1; %parameter index

itsel = 1:1:tune.nphi;
nsel  = length(itsel);

bins = 0:0.01:1;
post = zeros(nsel, length(bins));
for i = 1:nsel
    
    phisel  = itsel(i);
    para    = squeeze(parasim(phisel, :, parai));
    [id, m] = multinomial_resampling(wtsim(:, phisel)');
    para    = para(id);
    
    post(i, :) = ksdensity(para, bins);
end

colscale = (0.65:-0.05:0);
colormap(repmat(colscale', 1, 3));

% waterfall(bins, itsel/tune.nphi, post)

phigrid = (1:1:tune.nphi)';
waterfall(bins, phigrid, post)

set(gca, 'linewidth', 1, 'fontsize', 15)
title(['Density Estimates of $\pi_{n}(\theta_{1})$'], 'fontsize', 25, 'interpreter', 'latex')
xlabel(['$\theta_{1}$'], 'fontsize', 20, 'interpreter', 'latex')
ylabel(['$N_{\phi}$'], 'fontsize', 20, 'interpreter', 'latex')

cd(savepath);
savefilename = ['fig_',rstname, '_waterfall.png'];
saveas(fig, savefilename);
cd(workpath);

%% Figure 2: Contour plot
% load pre-computed posterior values
cd(savepath);
load('ctrval.mat');
cd(workpath);

theta1 = contourxval';
theta2 = contourxval';

% plot contour
fig = figure(1);
setmyfig(fig, [1.7, 1.2, 8, 7], version)

level = -355:1:-305;
colormap('summer')
contourf(theta1, theta2, contourfval, level)
set(gca, 'linewidth', 1, 'fontsize', 15)
xlabel('$\theta_1$','interpreter', 'latex', 'fontsize', 20)
ylabel('$\theta_2$','interpreter', 'latex', 'fontsize', 20)
title('Contour Plot', 'fontsize', 25);

hold on
% plot scatter 
temppara = squeeze(parasim(end, id, :));
scatter(temppara(:,1), temppara(:,2), 40, 'filled',  'black')

cd(savepath);
savefilename = ['fig_',rstname, '_contour.png'];
saveas(fig, savefilename);
cd(workpath)

%% Figure 3: ESS

fig = figure(3);
setmyfig(fig, [1.7, 1.2, 11, 6], version)

% Plot ESS
plot(phigrid, ESSsim, 'linewidth', 4)
hold on
% Plot location of resampling is implemented
ylimval = get(gca,'ylim');
xval = phigrid(logical(rsmpsim));
for i=1:size(xval,1)
    plot([xval(i), xval(i)], ylimval, 'k--', 'linewidth', 3)
end
hold off
xlim([2, tune.nphi])

title('Effective Sample Size', 'fontsize', 25);
set(gca, 'linewidth', 2, 'fontsize', 15);
xlabel(['$N_{\phi}$'], 'fontsize', 20, 'interpreter', 'latex')


cd(savepath);
savefilename = ['fig_',rstname, '_ESS.png'];
saveas(fig, savefilename);
cd(workpath);

%% Figure 4: Acceptance rate

fig =figure(4);
setmyfig(fig, [1.7, 1.2, 11, 6], version)
plot(phigrid, acptsim, 'linewidth', 4)
hold on
plot(phigrid, tune.trgt*ones(tune.nphi), 'k--', 'linewidth', 3);
xlim([2, tune.nphi])
ylim([0, 1])

title('Acceptance rate', 'fontsize', 25);
set(gca, 'linewidth', 2, 'fontsize', 15);
xlabel(['$N_{\phi}$'], 'fontsize', 20, 'interpreter', 'latex')

cd(savepath);
savefilename = ['fig_',rstname, '_acpt.png'];
saveas(fig, savefilename);
cd(workpath);

%% Figure 5: Scale parameter for proposal

fig =figure(5);
setmyfig(fig, [1.7, 1.2, 11, 6], version)
plot(phigrid, csim, 'linewidth', 4)
% hold on
% % Plot location of resampling is implemented
% ylimval = get(gca,'ylim');
% xval = phigrid(logical(rsmpsim));
% for i=1:size(xval,1)
%     plot([xval(i), xval(i)], ylimval, 'k--', 'linewidth', 3)
% end
% hold off
xlim([2, tune.nphi])
%ylim([0, 1.5])

title('Scale parameter, c', 'fontsize', 25);
set(gca, 'linewidth', 2, 'fontsize', 15);
xlabel(['$N_{\phi}$'], 'fontsize', 20, 'interpreter', 'latex')

cd(savepath);
savefilename = ['fig_',rstname, '_c.png'];
saveas(fig, savefilename);
cd(workpath);















