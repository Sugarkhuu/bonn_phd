% Iterates value function given by 
% v_0 = ln(Ak_{0}^alpha - k_{1}) + v_{1}
% in given grid of capital: [2,4,6,8,10]
% Input: 
%       None
% Output: 
%       None
%
% Example:
%       valFuncIter()


global A beta alpha kgrid k0 v0

% fixed parameters
A     = 20;
alpha = 0.3;
beta  = 0.6; 
kgrid = [2,4,6,8,10]'; % capital grid

% loop parameters
stop  = 1e-6;
it    = 0;
maxit = 1e3;
N     = length(kgrid);

% Initialize
v0  = zeros(N,1);
k0  = zeros(N,1);
k1  = k0;
v1  = v0;
dif   = stop+1e3; % arbitrarily large at first to start while loop

while dif > stop
    for i = 1:N
        k0 = kgrid(i,1);
        [val_max, id_max] = max(arrayfun(@(k) valfun(k),kgrid)); % max value and its location corresponding to kgrid
        v1(i) = val_max;
        k1(i) = kgrid(id_max)
    end

dif = max(abs(v1-v0));
v0 = v1;
it = it + 1

end

% Show the final value function
disp(v0)

%% Value Function
function val=valfun(k)
% Calculates value function value as v_0 = ln(Ak_{t}^alpha - k_{t+1}) + v_{1}
% Input: 
%       k - k_{t+1}, float scalar
% Output: 
%       val - value of the value function, float scalar 

global v0 beta alpha kgrid k0 A

    val1 = interp1(kgrid,v0,k); % one of v0 corresponding to k
    val0 = log(A*k0^alpha-k) + beta*val1;
    val  = val0;

end


