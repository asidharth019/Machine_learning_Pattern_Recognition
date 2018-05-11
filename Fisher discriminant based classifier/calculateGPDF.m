function [ g ] = calculateGPDF( x,m,cov )
%Returns Gaussian PDF for given data

denom = sqrt(((2*pi).^(size(x,1)))*det(cov));
expt = (x-m)'*pinv(cov)*(x-m);
if denom > 0
    g = (1/(denom))*exp(-0.5*expt);
else
    g = 0;
end

end

