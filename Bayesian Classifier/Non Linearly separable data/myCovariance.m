function [ c ] = myCovariance( x )
% Return Covariance Matrix for a given input.

[d n] = size(x);
m = zeros(d,1);
c = zeros(d);

m = sum(x,2)/n;

   for j = 1:n
     
     c = c + (x(:,j) - m)*(x(:,j) - m)';   
       
   end
    
c = c./(n);

end

