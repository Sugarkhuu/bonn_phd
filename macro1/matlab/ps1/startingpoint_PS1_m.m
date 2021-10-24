clear
clc

% Define a grid of capital states
N = 1000; % Number of grid points
klow = 2; % lowest grid point
khigh = 10; % highest grid point
kgrid = linspace(klow,khigh,N)'; % Transpose it to be a column vector

% Output and undepreciated capital at each grid point ("cash at hand")
a = 0.3; % Parameter of Cobb Douglas function
d = 0.1; % Depreciation rate
b = 0.9; % Time discount rate
cah = kgrid.^a + (1 - d) * kgrid;

    % Initial guess for policy function
    pol = cah * 0.5;

for s = 1:1000
    % This is a Nx1 vector for each state and a 1x3 vector with the bounds of the search grid for the optimal solution
    kguess =  [zeros(N,1),zeros(N,1),cah];
    kguess(:,2) = 0.5 * (kguess(:,1) + kguess(:,3) );
    % Take second column as guess
    x = kguess(:,2);


    for t = 1:1000
        % Marginal utility today
        c = cah - x; % consumption
        mu = 1./c;

        % Marginal utility tomorrow
        kp = interp1(kgrid,pol,x,'linear','extrap'); % k(t+2)
        % You fill in here ....
        mup = 1./cp;
        % Marginal return on capital net of depreciation next period
        r = a * x.^(a - 1) - d;

        % Residual on Euler equation
        res = mu - b * (1 + r) .* mup;

        % Update the guess for x until |res| < 1e-6
        % Not this must be the maximum over all res as res is going to be a Nx1
        % vector
        maxres = max(abs(res));
        if(maxres < 1.0e-6)
            break;
        end

        % Now update kguess and x and continue with loop
        % You fill in here ...

    end
    % Update the policy function (x is your solution to the Euler equation, i.e. optimal k(t+1) given k(t))
    polold = pol; % Save old policy function
    pol = x; % Update policy function
    % Check convergence
    maxres = max(abs(pol - polold));
    if(maxres < 1.0e-6)
        break;
    end
end
