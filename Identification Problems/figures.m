% ----------------------------------------------------------------
% Figure file for SMC example
% - This file creates/saves figures based on outputs from main_ss.m
% Updates
% 5/13/2014: scatter plot 
% ----------------------------------------------------------------
% Minchul Shin [mincshin@sas.upenn.edu]
% Last modified: 5/13/2014
%
% Edited: Juan Castellanos Silvan
% Date: 03/03/2020
% ----------------------------------------------------------------
clc; clear all; close all;

% add the toolbox
addpath([pwd, '/toolbox_ss']);

%% General Setting - Specificaitons/Path
modelname = 'HS';                          
priorname = '0';
ident = 'local';    % 'global' or 'local'
specname  = [modelname, '_p', priorname];   % prior 
smcrun    = '1';                            % chain number
propmode  = 1;                              % 1-RWMH, 2-Mixture MH
T0_       = 1;                              % starting point of likelihood evaluation

rstname = [specname, '_mode',num2str(propmode),'_run',smcrun, '_', ident]; 

% path
workpath = pwd;
priopath = workpath; %prior path
savepath = [workpath, '/results_',specname];
chk_dir(savepath);

%% Load results
loadfilename = [specname, '_mode',num2str(propmode),'_run',smcrun,'_', ident,'.mat'];
cd(savepath);
load(loadfilename);
cd(workpath);

%% Figure 2: Waterfall plot
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
%title(['Density Estimates of $\pi_{n}(\theta_{1})$'], 'fontsize', 25, 'interpreter', 'latex')
xlabel(['$\theta_{1}$'], 'fontsize', 20, 'interpreter', 'latex')
ylabel(['$N_{\phi}$'], 'fontsize', 20, 'interpreter', 'latex')

x = 29.7;                  % A4 paper size
y = 21.0;                  % A4 paper size
xMargin = 1;               % left/right margins from page borders
yMargin = 1;               % bottom/top margins from page borders
xSize = x - 2*xMargin;     % figure size on paper (widht & hieght)
ySize = y - 2*yMargin;     % figure size on paper (widht & hieght)

set(gcf, 'Units','centimeters', 'Position',[0 0 xSize ySize]/2)

set(gcf, 'PaperUnits','centimeters')
set(gcf, 'PaperSize',[x y])
set(gcf, 'PaperPosition',[xMargin yMargin xSize ySize])
set(gcf, 'PaperOrientation','portrait')

save = '/Users/Castesil/Documents/EUI/Year II - PENN/Spring 2020/Econometrics IV/PS/PS4/LaTeX/';
filename = strcat('pWaterfall_', ident,'.pdf');
saveas(gcf, strcat(save,filename));

%% Figure 2: Contour plot
% load pre-computed posterior values
cd(savepath);
load(strcat('ctrval_', ident,'.mat'));
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
%title('Contour Plot', 'fontsize', 25);

hold on
% plot scatter 
temppara = squeeze(parasim(end, id, :));
scatter(temppara(:,1), temppara(:,2), 40, 'filled',  'black')
grid on 

set(gcf, 'Units','centimeters', 'Position',[0 0 xSize ySize]/2)

set(gcf, 'PaperUnits','centimeters')
set(gcf, 'PaperSize',[x y])
set(gcf, 'PaperPosition',[xMargin yMargin xSize ySize])
set(gcf, 'PaperOrientation','portrait')

save = '/Users/Castesil/Documents/EUI/Year II - PENN/Spring 2020/Econometrics IV/PS/PS4/LaTeX/';
filename = strcat('pContour_', ident,'.pdf');
saveas(gcf, strcat(save,filename));

%cd(savepath);
%savefilename = ['fig_',rstname, '_contour.png'];
%saveas(fig, savefilename);

cd(workpath)














