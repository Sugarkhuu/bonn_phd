% Calculate and compare the analytical 
% and numerical solutions of the 
% value function

grid100 = linspace(2,10,100);
grid1000 = linspace(2,10,1000);

% Analytical solutions
an_val100 = iter_val_an(grid100);
an_val1000 = iter_val_an(grid1000);

% Numerical solutions
num_val100 = iter_val(grid100);
num_val1000 = iter_val(grid1000);

% Gap
diff100 = max(abs(num_val100 - an_val100));
diff1000 = max(abs(num_val1000 - an_val1000));


function an_val_arr = iter_val_an(ngrid)
    % analytical calculation of value function for ngrid - grid of capital
    
    alpha = 0.3;
    beta  = 0.6;
    A = 20;
    
    
    f1 = alpha*beta*log(alpha*beta)/(1-alpha*beta);
    f2 = log(1-alpha*beta);
    f3 = log(A) + alpha*beta*log(A)/(1-alpha*beta);
    f4 = 1/(1-beta);
    
    alpha_0 = f4*(f1+f2+f3);
    alpha_1 = alpha/(1-alpha*beta);
    
    kgrid  = ngrid';
    an_val_arr = []
    
    for i = 1:length(kgrid)
        an_val = alpha_0+alpha_1*log(kgrid(i));
        an_val_arr(end+1) = an_val;
    end
    
    an_val_arr = an_val_arr';

end