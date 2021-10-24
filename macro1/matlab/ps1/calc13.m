% Path for capital for the first 20 period starting at k0 = 2

period = 20;

%% Analytical 

A     = 20;
alpha = 0.3;
beta  = 0.6; 
alpha_1 = alpha/(1-alpha*beta);

k0   = 2;
k_an = k0; % first period capital is k0


for i=1:(period-1)
    k1 = alpha_1*beta*A*(k0^alpha)/(1+alpha_1*beta);
    k_an(end+1) = k1;
    k0 = k1;
end


%% Numerical

grid100 = linspace(2,10,100);
[num_val100 k_val_100]= iter_val(grid100);


k0_grid = grid100;
k_num = k0_grid(1); % first period capital is k0

idx = 1; % first period capital is at 2 and index 1
i = 1; % loop
period = 20;



while i < period
    k1 = k_val_100(idx); % corresponding capital for k0
    k_num(end+1) = k1;
    idx = find(k1 == k0_grid); % where k1 is located as k0 for the next period
    i = i+1;
end




[k_an' k_num']
