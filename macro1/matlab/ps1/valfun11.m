function val=valfun11(k)

global v0 beta alpha kgrid k0 A

    val0 = interp1(kgrid,v0,k); % just choosing one of the point values of the v0 that corresponds to k
    val1 = log(A*k0^alpha-k) + beta*val0;
    
    val = - val1;

end