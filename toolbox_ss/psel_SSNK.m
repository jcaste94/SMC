function [parasel, paranames] = psel_SSNK(para)
%  originally this function is to pick up parameters according to the 
%  model specification (we don't use here)

paranames = {'\tau','\kappa','\psi_1','\psi_2','r^{(A)}',...
                   '\pi^{(A)}','\gamma^{(Q)}',...
                   '\rho_{r}','\rho_{g}', '\rho_{z}', ...
                   '\sigma_{r}','\sigma_{g}', '\sigma_{z}'};
             
parasel = para;
