function  g  = calculateGaussianPDF( X11,X12,m1,cov1 )
%Returns Gaussian PDF for given data

x1minu11 = X11 - m1(1,1);
x2minu21 = X12 - m1(1,2);
icov1 = pinv(cov1);
p11 = icov1(1,1).*x1minu11.^2 + icov1(1,2).*x1minu11.*x2minu21 + icov1(2,1).*x1minu11.*x2minu21 + icov1(2,2).*x2minu21.^2;
g = (1/(2*pi*sqrt(det(cov1)))) * exp(-0.5 * (p11));

% s = (x-m);
% p1 = s'*inv(cov)*s;
% g1 = ((1/(2*pi*sqrt(det(cov)))) * exp(-0.5 * (p1)))*(1/3);


end

