
alpha = 0.3;
beta  = 0.6;
A = 20;


f1 = alpha*beta*log(alpha*beta)/(1-alpha*beta);
f2 = log(1-alpha*beta);
f3 = log(A) + alpha*beta*log(A)/(1-alpha*beta);
f4 = 1/(1-beta);

alpha_0 = f4*(f1+f2+f3);
alpha_1 = alpha/(1-alpha*beta);

kgrid  = [2,4,6,8,10]';

for i = 1:length(kgrid)
    disp(alpha_0+alpha_1*log(kgrid(i)))
end



% for i = 1:N
%     con(i,1) = kmat(i,1)^(alpha) - k11(i,1) + (1-delta)*kmat(i,1);
%     polfun(i,1) = kmat(i,1)^(alpha) - k11(i,1) + (1-delta)*kmat(i,1);
% end