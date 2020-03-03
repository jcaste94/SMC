%==========================================================================
%                       IDENTIFICATION PROBLEMS
%                Simulate observationally equivalent data
%
%
% Author: Juan Castellanos Silván
% Date: 3/2/2020
%==========================================================================

function YY = gendata(theta, s0, T, Tsim, bimodal)

% Set up: State-space representation
[A_1,B_1,Phi_1,R_1,H_1,S2_1] = sysmat_HS(theta);

% Bimodality
if bimodal == true
    theta_eq(1) = sqrt(1-theta(1)^2);
    theta_eq(2) = theta(1)*theta(2)/theta_eq(1);
    [A_2,B_2,Phi_2,R_2,H_2,S2_2] = sysmat_HS(theta_eq);
end

% Pre-allocation and initial conditions
y = zeros(Tsim,1);
s = zeros(2,Tsim);
s(:,1) = s0;

% Simulation
for t = 2:Tsim
    
    Phi = Phi_1;
    R = R_1;
    A = A_1;
    B = B_1;
    
    if bimodal
        
        id = round(rand);
        
        if id == 1
            Phi = Phi_2;
            R = R_2;
            A = A_2;
            B = B_2;
        end
        
    end
    
    % Transition equation
    s(:,t) = Phi * s(:,t-1) + R .* randn(2,1);

    % Measurement equation
     y(t+1) = A + B_1 * s(:,t);

end

YY = y(Tsim-T+2:end);

end