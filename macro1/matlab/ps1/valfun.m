function val=valfun(k)

global v0 beta alpha kmat k0 A

    g = interp1(kmat,v0,k); % just linear 
    val=log(A*k0^alpha-k) + beta*g;
    
    val = - val;

end