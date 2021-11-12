% search for all possible values in each k

global kgrid pol A cah d b a k0

clear
clc

% Define a grid of capital states
N = 5; 1000; % Number of grid points
klow = 2; % lowest grid point
khigh = 10; % highest grid point
kgrid = linspace(klow,khigh,N)'; % Transpose it to be a column vector



% Output and undepreciated capital at each grid point ("cash at hand")
A = 20;
a = 0.3; % Parameter of Cobb Douglas function
d = 1; % Depreciation rate
b = 0.6; % Time discount rate
cah = A*kgrid.^a + (1 - d) * kgrid;
k0=0;
    % Initial guess for policy function
    pol = cah * 0.5;
    x2 = zeros(size(pol));

for s = 1:1000
    % This is a Nx1 vector for each state and a 1x3 vector with the bounds of the search grid for the optimal solution
%    kguess =  [zeros(N,1),zeros(N,1),cah];
%    kguess(:,2) = 0.5 * (kguess(:,1) + kguess(:,3) );
%     % Take second column as guess
%     x = kguess(:,2);

    x=pol;

    for t = 1:N
        
        k0 = kgrid(t);
        [val_max, id_max] = max(arrayfun(@(kp) mresid(kp),kgrid')); % max value and its location corresponding to kgrid

%         x1 = fminbnd(@(x) resid(x,caht),0,caht);
        x2(t) = val_max;
        keyboard
%         maxres = max(abs(res))
%         if(maxres < 1.0e-6)
%             break;
%         end

        % Now update kguess and x and continue with loop
        % You fill in here ...
        
%         kguess = ;

    end
    % Update the policy function (x is your solution to the Euler equation, i.e. optimal k(t+1) given k(t))
    polold = pol; % Save old policy function
    pol = x2; % Update policy function
    % Check convergence
    maxres = max(abs(pol - polold));
    if(maxres < 1.0e-6)
        break;
    end

end


%% Policy Function
function res = mresid(kp)


global kgrid pol A cah d b a k0
keyboard       
    % Marginal utility today
    caht = interp1(kgrid,cah,k0,'linear');
%     caht = interp1(kgrid,cah,k0,'linear','extrap'); % k(t+2)
    c = caht - k0; % consumption
    keyboard
    mu = 1/c;

    % Marginal utility tomorrow
%     kp = interp1(kgrid,pol,k,'linear','extrap'); % k(t+2)
    % You fill in here ....
    cp = A*k0^a-kp+(1-d)*k0;
    mup = 1/cp;
    % Marginal return on capital net of depreciation next period
    r = a * k0^(a - 1) - d;
    % Residual on Euler equation
    res = mu - b * (1 + r) * mup;
end

