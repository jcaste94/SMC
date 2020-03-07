function [x0, P0] = initialize_kf(nx,Phi,R,S2,param)
% initialization of KF

%% using dlyap - require system control toolbox
% nx = size(Phi,1);
% x0 = zeros(nx,1);
% P0 = dlyap(Phi,R*S2*R');
% vecP1 = vec(P0);

%% without dlyap - brute force calculation
nx    = size(Phi,1);
x0    = zeros(nx,1);
vecP0 = (eye(nx^2)-kron(Phi,Phi))\vec(R*S2*R');
P0    = reshape(vecP0,nx,nx);

% compare with dlyap
% if sum(vecP1-vecP0) > 1e-10
%     sum(vecP1-vecP0)
%     pause
% end

%% For nonstationary ss
%precover; % recover parameter (need param)

% second state is nonstationary
%x0 = [0; PI0];
%P0 = [sige^2/(1-rho), 0; 0, 0];

end

% ---------------------------------------------------------
% Other function used in this function
function vecx = vec(x)

    % vectorize
    vecx = x(:);

end
