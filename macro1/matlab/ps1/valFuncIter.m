% Iterates value function given by 
% v_0 = ln(Ak_{0}^alpha - k_{1}) + v_{1}
% in given grid of capital: [2,4,6,8,10]

global v0 beta alpha kgrid k0 A 
A = 20;
alpha = 0.3;
beta  = 0.6; 

tol   = 1e-6;
it = 0;
dif = tol + 1000;
maxit = 1e3;
kgrid  = [2,4,6,8,10]';
[N,n] = size(kgrid);

v0 = zeros(N,1);
v1 = v0;
k11 = k0;
kmin = 2;
kmax = 10;


while dif>tol & its < maxit
    for i = 1:N
        k0 = kgrid(i,1);
        k1 = fminbnd(@valfun,kmin,kmax);
        v1(i,1) = -valfun(k1);
        k11(i,1) = k1;
        k1
    end

dif = norm(v1-v0,"inf");

v0 = v1;
it = it + 1;
end

% Show the final value function
disp(v0)

%% Value Function
function val=valfun(k)
% Calculates value function value as v_1 = ln(Ak_{t}^alpha - k_{t+1}) + v_{0}
% Input: 
%       k - k_{t+1}, float scalar
% Output: 
%       val - value of the value function, float scalar 

global v0 beta alpha kgrid k0 A

    val0 = interp1(kgrid,v0,k); % just choosing one of the point values of the v0 that corresponds to k
    val1 = log(A*k0^alpha-k) + beta*val0;
    
    val = - val1;

end
