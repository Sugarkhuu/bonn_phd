global v0 beta delta alpha kmat k0 s
plott=0;
alpha = 0.33;
beta = 0.95;
delta = 0.1; 
s = 2;

tol = 0.01;
maxits = 1000;
dif = tol+1000;
its = 0;
kgrid = 99;

kstar = (alpha/(1/beta - (1-delta)))^(1/(1-alpha)); % steady state k
cstar = kstar^(alpha) - delta*kstar;
istar = delta*kstar;
ystar = kstar^(alpha);

kmin = 0.25*kstar;
kmax = 1.75*kstar;
grid = (kmax-kmin)/kgrid;
kmat = kmin:grid:kmax;
kmat = kmat';
[N,n] = size(kmat);

polfun = zeros(kgrid+1,3);

v0 = zeros(N,1);
dif = 10;
its = 0;

while dif>tol & its < maxits
    for i = 1:N
        k0 = kmat(i,1);
        k1 = fminbnd(@valfun,kmin,kmax);
        v1(i,1) = -valfun(k1);
        k11(i,1) = k1;
    end

dif = norm(v1-v0);

v0 = v1;
its = its+1
end

for i = 1:N
    con(i,1) = kmat(i,1)^(alpha) - k11(i,1) + (1-delta)*kmat(i,1);
    polfun(i,1) = kmat(i,1)^(alpha) - k11(i,1) + (1-delta)*kmat(i,1);
end



